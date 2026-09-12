Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509AD363C6F;
	Sat, 12 Sep 2026 16:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230235; cv=none; b=mSLVIoLl+tbq+KHUYlFj4JCWn4+wS8YPVnESyo74BjZ03gsFeORLw3y86TWyLlxHQ/E5NVAh/ZtUoSZCy2ds2Rtl7i+uTLcaePTJp7TaQDScpx9CIQ+FVWrH+sZ/CF0Zo9J2OiHeq6XuICIszNj/pSAt8XLGk5RbjpUFMaOndnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230235; c=relaxed/simple;
	bh=Vdg1+9/K57hx1LrpQltt8fpM4G4sfU+QZ9gPT4TJUIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjcBzGfTysYJmBaJbCPE/Pmk8vacWD70QygYf0kK1egt4Z9oNZ99dXX5A3OorenKhkTIYiQyRrAEIe1SpuxdXDakYXZn1FOfGtV2HjCvWwSZeknBftmi17paxBd72K5T9y7k4xDC9U8Ur1r/RgvAnq66nrBNzKV+TOxwXZpC6Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+D+5+8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+D+5+8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BAD1F000FF;
	Sat, 12 Sep 2026 16:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230234;
	bh=rJEnyEBrcJMhOkWohDT5CKbr+G2/FjSfW13JkoFlVco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+D+5+8IfTWtLLA8YAviKvptUIBtALeOfutevxVhsn3R4qEI6tPh7JnMlapkm8ob7
	 Qp03aqEO1v9HlzZsROUkQZwA7NvOY702ofwOGQIkcb8mjTVhiANUYBqPOZ4Ru8Xq/a
	 ijgCyjMim1ZsNCp3weba5LlGsgrTqJAxT9v9w3C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0753/1191] tracing/osnoise: Add osnoise/options file
Date: Sat, 12 Sep 2026 08:58:01 +0200
Message-ID: <20260912065605.193293899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit b179d48b6aab21f3999f5006685ea4254c0618a9 ]

Add the tracing/osnoise/options file to control
osnoise/timerlat tracer features. It is a single
file to contain multiple features, similar to
the sched/features file.

Reading the file displays a list of options. Writing
the OPTION_NAME enables it, writing NO_OPTION_NAME disables
it.

The DEAFULTS is a particular option that resets the options
to the default ones.

It uses a bitmask to keep track of the status of the option. When
needed, we can add a list of static keys, but for now
it does not justify the memory increase.

Link: https://lkml.kernel.org/r/f8d34aefdb225d2603fcb4c02a120832a0cd3339.1668692096.git.bristot@kernel.org

Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 27d73e81195b ("rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 170 +++++++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 3b3f31ca45831..6e82b61fc0d2f 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -48,6 +48,19 @@
 #define DEFAULT_TIMERLAT_PERIOD	1000			/* 1ms */
 #define DEFAULT_TIMERLAT_PRIO	95			/* FIFO 95 */
 
+/*
+ * osnoise/options entries.
+ */
+enum osnoise_options_index {
+	OSN_DEFAULTS = 0,
+	OSN_MAX
+};
+
+static const char * const osnoise_options_str[OSN_MAX] = { "DEFAULTS" };
+
+#define OSN_DEFAULT_OPTIONS	0
+unsigned long osnoise_options	= OSN_DEFAULT_OPTIONS;
+
 /*
  * trace_array of the enabled osnoise/timerlat instances.
  */
@@ -1866,6 +1879,150 @@ static void osnoise_init_hotplug_support(void)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
+/*
+ * seq file functions for the osnoise/options file.
+ */
+static void *s_options_start(struct seq_file *s, loff_t *pos)
+{
+	int option = *pos;
+
+	mutex_lock(&interface_lock);
+
+	if (option >= OSN_MAX)
+		return NULL;
+
+	return pos;
+}
+
+static void *s_options_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	int option = ++(*pos);
+
+	if (option >= OSN_MAX)
+		return NULL;
+
+	return pos;
+}
+
+static int s_options_show(struct seq_file *s, void *v)
+{
+	loff_t *pos = v;
+	int option = *pos;
+
+	if (option == OSN_DEFAULTS) {
+		if (osnoise_options == OSN_DEFAULT_OPTIONS)
+			seq_printf(s, "%s", osnoise_options_str[option]);
+		else
+			seq_printf(s, "NO_%s", osnoise_options_str[option]);
+		goto out;
+	}
+
+	if (test_bit(option, &osnoise_options))
+		seq_printf(s, "%s", osnoise_options_str[option]);
+	else
+		seq_printf(s, "NO_%s", osnoise_options_str[option]);
+
+out:
+	if (option != OSN_MAX)
+		seq_puts(s, " ");
+
+	return 0;
+}
+
+static void s_options_stop(struct seq_file *s, void *v)
+{
+	seq_puts(s, "\n");
+	mutex_unlock(&interface_lock);
+}
+
+static const struct seq_operations osnoise_options_seq_ops = {
+	.start		= s_options_start,
+	.next		= s_options_next,
+	.show		= s_options_show,
+	.stop		= s_options_stop
+};
+
+static int osnoise_options_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &osnoise_options_seq_ops);
+};
+
+/**
+ * osnoise_options_write - Write function for "options" entry
+ * @filp: The active open file structure
+ * @ubuf: The user buffer that contains the value to write
+ * @cnt: The maximum number of bytes to write to "file"
+ * @ppos: The current position in @file
+ *
+ * Writing the option name sets the option, writing the "NO_"
+ * prefix in front of the option name disables it.
+ *
+ * Writing "DEFAULTS" resets the option values to the default ones.
+ */
+static ssize_t osnoise_options_write(struct file *filp, const char __user *ubuf,
+				     size_t cnt, loff_t *ppos)
+{
+	int running, option, enable, retval;
+	char buf[256], *option_str;
+
+	if (cnt >= 256)
+		return -EINVAL;
+
+	if (copy_from_user(buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	if (strncmp(buf, "NO_", 3)) {
+		option_str = strstrip(buf);
+		enable = true;
+	} else {
+		option_str = strstrip(&buf[3]);
+		enable = false;
+	}
+
+	option = match_string(osnoise_options_str, OSN_MAX, option_str);
+	if (option < 0)
+		return -EINVAL;
+
+	/*
+	 * trace_types_lock is taken to avoid concurrency on start/stop.
+	 */
+	mutex_lock(&trace_types_lock);
+	running = osnoise_has_registered_instances();
+	if (running)
+		stop_per_cpu_kthreads();
+
+	mutex_lock(&interface_lock);
+	/*
+	 * avoid CPU hotplug operations that might read options.
+	 */
+	cpus_read_lock();
+
+	retval = cnt;
+
+	if (enable) {
+		if (option == OSN_DEFAULTS)
+			osnoise_options = OSN_DEFAULT_OPTIONS;
+		else
+			set_bit(option, &osnoise_options);
+	} else {
+		if (option == OSN_DEFAULTS)
+			retval = -EINVAL;
+		else
+			clear_bit(option, &osnoise_options);
+	}
+
+	cpus_read_unlock();
+	mutex_unlock(&interface_lock);
+
+	if (running)
+		start_per_cpu_kthreads();
+	mutex_unlock(&trace_types_lock);
+
+	return retval;
+}
+
 /*
  * osnoise_cpus_read - Read function for reading the "cpus" file
  * @filp: The active open file structure
@@ -2048,6 +2205,14 @@ static const struct file_operations cpus_fops = {
 	.llseek		= generic_file_llseek,
 };
 
+static const struct file_operations osnoise_options_fops = {
+	.open		= osnoise_options_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+	.write		= osnoise_options_write
+};
+
 #ifdef CONFIG_TIMERLAT_TRACER
 #ifdef CONFIG_STACKTRACE
 static int init_timerlat_stack_tracefs(struct dentry *top_dir)
@@ -2134,6 +2299,11 @@ static int init_tracefs(void)
 	if (!tmp)
 		goto err;
 
+	tmp = trace_create_file("options", TRACE_MODE_WRITE, top_dir, NULL,
+				&osnoise_options_fops);
+	if (!tmp)
+		goto err;
+
 	ret = init_timerlat_tracefs(top_dir);
 	if (ret)
 		goto err;
-- 
2.53.0



