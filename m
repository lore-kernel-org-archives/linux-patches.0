Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41574429CC6;
	Sat, 12 Sep 2026 12:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217909; cv=none; b=CFk9kQxmAvgz794UeOoNKEDgmxElv8kCg9x6fq11SQG+vdxXOD3T5YVhRcDQuIPcY6I+nrJZIRaWOymya5yb3O8on2QTSBel+lgyaZkcxsjHEwK6WwDTOMVaJd1TMwx7Vvswwb9UFM2rlqJebSA5SOsoNpBB2ARIYqPZLVmjKaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217909; c=relaxed/simple;
	bh=b0CflfSk/qCMsx5GRuFZ9g9H085G2w35YtKm3f7qBQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4FM20masFrRR3l/yXqsfguKfBGzPTy6qaZdN5AbzzkRr/aphpsV1EZ/md8gUmAGipXsSB9/gbNkKYfLaFWufnGlOhkNt2/wl5m+8cGq0DvtnDp45Kc2hu//BRziDNtbxL05XUJmCWxAomMtmJGjuZlQp2o8RKc4TLufG9RIcQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4YMKl/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4YMKl/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78761F000FF;
	Sat, 12 Sep 2026 12:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217908;
	bh=4fcCjPLdhfsizqejuSqaEgd4nAtzaysPA7qASNMGqBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4YMKl/LSwH7Yh7myDekWKn90RJIpUbbRLoLg8/e/8ImPh6ifmQWwXh5oX6iJdIiN
	 sPeW0M6igY5Nq8FGzojsGE3bUa8nFcr3iJ+JUbx8RWLfb2Hd9tObMY9gZFFDtdPzs3
	 xOGi3b52nB/wTW33gOekKc/0oyAfOWxu9PoECaJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1019/1376] perf python: Add support for struct perf_counts_values to return counter data
Date: Sat, 12 Sep 2026 08:57:25 +0200
Message-ID: <20260912065630.274709481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautam Menghani <gautam@linux.ibm.com>

[ Upstream commit 3b4991dcb49e1d99129ead644858cf7f77b8fb6b ]

Add support for the perf_counts_values struct to enable the python
bindings to read and return the counter data.

Committer notes:

Use T_ULONG instead of Py_T_ULONG, as all the other PyMemberDef arrays,
fixing the build with older python3 versions.

Use { .name = NULL, } to finish the new PyMemberDef
pyrf_counts_values_members array, again as the other arrays to please
some clang versions, ditto for PyGetSetDef.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250519195148.1708988-5-irogers@google.com
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 612aca22a978 ("perf python: Check counts_values size in set_values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 92 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index cce6f7b87673b..17e393bcc7b94 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -636,6 +636,92 @@ static int pyrf_thread_map__setup_types(void)
 	return PyType_Ready(&pyrf_thread_map__type);
 }
 
+struct pyrf_counts_values {
+	PyObject_HEAD
+
+	struct perf_counts_values values;
+};
+
+static const char pyrf_counts_values__doc[] = PyDoc_STR("perf counts values object.");
+
+static void pyrf_counts_values__delete(struct pyrf_counts_values *pcounts_values)
+{
+	Py_TYPE(pcounts_values)->tp_free((PyObject *)pcounts_values);
+}
+
+#define counts_values_member_def(member, ptype, help) \
+	{ #member, ptype, \
+	  offsetof(struct pyrf_counts_values, values.member), \
+	  0, help }
+
+static PyMemberDef pyrf_counts_values_members[] = {
+	counts_values_member_def(val, T_ULONG, "Value of event"),
+	counts_values_member_def(ena, T_ULONG, "Time for which enabled"),
+	counts_values_member_def(run, T_ULONG, "Time for which running"),
+	counts_values_member_def(id, T_ULONG, "Unique ID for an event"),
+	counts_values_member_def(lost, T_ULONG, "Num of lost samples"),
+	{ .name = NULL, },
+};
+
+static PyObject *pyrf_counts_values_get_values(struct pyrf_counts_values *self, void *closure)
+{
+	PyObject *vals = PyList_New(5);
+
+	if (!vals)
+		return NULL;
+	for (int i = 0; i < 5; i++)
+		PyList_SetItem(vals, i, PyLong_FromLong(self->values.values[i]));
+
+	return vals;
+}
+
+static int pyrf_counts_values_set_values(struct pyrf_counts_values *self, PyObject *list,
+					 void *closure)
+{
+	Py_ssize_t size;
+	PyObject *item = NULL;
+
+	if (!PyList_Check(list)) {
+		PyErr_SetString(PyExc_TypeError, "Value assigned must be a list");
+		return -1;
+	}
+
+	size = PyList_Size(list);
+	for (Py_ssize_t i = 0; i < size; i++) {
+		item = PyList_GetItem(list, i);
+		if (!PyLong_Check(item)) {
+			PyErr_SetString(PyExc_TypeError, "List members should be numbers");
+			return -1;
+		}
+		self->values.values[i] = PyLong_AsLong(item);
+	}
+
+	return 0;
+}
+
+static PyGetSetDef pyrf_counts_values_getset[] = {
+	{"values", (getter)pyrf_counts_values_get_values, (setter)pyrf_counts_values_set_values,
+		"Name field", NULL},
+	{ .name = NULL, },
+};
+
+static PyTypeObject pyrf_counts_values__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.counts_values",
+	.tp_basicsize	= sizeof(struct pyrf_counts_values),
+	.tp_dealloc	= (destructor)pyrf_counts_values__delete,
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_counts_values__doc,
+	.tp_members	= pyrf_counts_values_members,
+	.tp_getset	= pyrf_counts_values_getset,
+};
+
+static int pyrf_counts_values__setup_types(void)
+{
+	pyrf_counts_values__type.tp_new = PyType_GenericNew;
+	return PyType_Ready(&pyrf_counts_values__type);
+}
+
 struct pyrf_evsel {
 	PyObject_HEAD
 
@@ -1245,7 +1331,8 @@ PyMODINIT_FUNC PyInit_perf(void)
 	    pyrf_evlist__setup_types() < 0 ||
 	    pyrf_evsel__setup_types() < 0 ||
 	    pyrf_thread_map__setup_types() < 0 ||
-	    pyrf_cpu_map__setup_types() < 0)
+	    pyrf_cpu_map__setup_types() < 0 ||
+	    pyrf_counts_values__setup_types() < 0)
 		return module;
 
 	/* The page_size is placed in util object. */
@@ -1290,6 +1377,9 @@ PyMODINIT_FUNC PyInit_perf(void)
 	Py_INCREF(&pyrf_cpu_map__type);
 	PyModule_AddObject(module, "cpu_map", (PyObject*)&pyrf_cpu_map__type);
 
+	Py_INCREF(&pyrf_counts_values__type);
+	PyModule_AddObject(module, "counts_values", (PyObject *)&pyrf_counts_values__type);
+
 	dict = PyModule_GetDict(module);
 	if (dict == NULL)
 		goto error;
-- 
2.53.0



