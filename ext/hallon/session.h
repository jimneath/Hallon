#ifndef SESSION_H_N4NAEFIZ
#define SESSION_H_N4NAEFIZ

typedef struct
{
  /* session pointer & object */
  sp_session** session_ptr;
  VALUE        session_obj;

  /* event mutex and condition signal */
  pthread_mutex_t event_mutex;
  pthread_cond_t  event_cond;
  hn_event_t* event;
  
  /* startup condition */
  pthread_mutex_t startup_mutex;
  pthread_cond_t  startup_cond;
} hn_session_data_t;

/*
  Macros
*/
#define DATA_OF(obj) Data_Fetch_Struct(obj, hn_session_data_t)

#endif /* end of include guard: SESSION_H_N4NAEFIZ */