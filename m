Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1554F30CB;
	Tue, 13 Oct 2026 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895586; cv=none; b=kkBHpOjjTWPwbJrCNDQspszaRYDTw7WZSUduUBIg8Xv6Yepdq6q24h62t8wEsBiZ+fvDR7L1hL7ekfX2YJJCealgvCYeD8Iva9dcfjFJj0TpX11jgw2xovy2XvJZT+c8U8j08sBg6c+7AgLCU5P8Wk2tshUGZp2Zjbjg5vTLeYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895586; c=relaxed/simple;
	bh=U9f2fcMG/zh0zhCnfZU/KNexNFz1E2IZ4Mt1i8T95Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EB58Q1iKBwCg2rE8QgSg/cOOmb68AnfC30Hl3jNuhhSm9N9jw8JXp+VUwGWTv8S/1aSwDJn9lhI8jKWMmLmvcL8UF7V4Zyf1XnzBnWPmRVocHukmHz1T+YnNAQz7Mf+UWmSV3UC5x2/smpdCoVsitPr0IRvcOYI5R3vgwQHJPOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQ/85/Eu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQ/85/Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDE41F000FF;
	Tue, 13 Oct 2026 12:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895585;
	bh=NejMHe3bC0ihIoaHPOY99DNDdiT7rLw76yOScuH4G3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQ/85/EuEWJAcKCnKAjNdNmdpuB64ExlTd27/Mxl+Z3F2ZVYDrrOk8/jgrekyDxk4
	 QNlryBc3xSvBET65U0tEquWZCJ5D3gtPOIWrx70+ZhGxBdivMtDxl8nc41TtQ+lkh5
	 sgFyxTuVXTXkVffbzjBHUHyqD0cAyONBz3RprXf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	Ingo Molnar <mingo@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/497] perf: Remove unnecessary parameter of security check
Date: Tue, 13 Oct 2026 13:37:27 +0200
Message-ID: <20261013112914.540355672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Luo Gengkun <luogengkun@huaweicloud.com>

[ Upstream commit 9ec84f79c5a7a65cd69b5b705a203759665160cd ]

It seems that the attr parameter was never been used in security
checks since it was first introduced by:

commit da97e18458fb ("perf_event: Add support for LSM and SELinux checks")

so remove it.

Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Stable-dep-of: 357e8a77a501 ("perf: Require kernel access for text poke events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/bts.c     |  2 +-
 arch/x86/events/intel/core.c    |  2 +-
 arch/x86/events/intel/p4.c      |  2 +-
 drivers/perf/arm_spe_pmu.c      |  4 ++--
 include/linux/lsm_hook_defs.h   |  2 +-
 include/linux/perf_event.h      | 10 +++++-----
 include/linux/security.h        |  5 ++---
 kernel/events/core.c            | 14 +++++++-------
 kernel/trace/trace_event_perf.c |  4 ++--
 security/security.c             |  5 ++---
 security/selinux/hooks.c        |  2 +-
 11 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index 8f78b0c900ef4..485a09d61adf9 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -559,7 +559,7 @@ static int bts_event_init(struct perf_event *event)
 	 * to the user in a zero-copy fashion.
 	 */
 	if (event->attr.exclude_kernel) {
-		ret = perf_allow_kernel(&event->attr);
+		ret = perf_allow_kernel();
 		if (ret)
 			return ret;
 	}
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 64d52911be3d3..2efb414959e1f 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4256,7 +4256,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (x86_pmu.version < 3)
 		return -EINVAL;
 
-	ret = perf_allow_cpu(&event->attr);
+	ret = perf_allow_cpu();
 	if (ret)
 		return ret;
 
diff --git a/arch/x86/events/intel/p4.c b/arch/x86/events/intel/p4.c
index 844bc4fc4724d..78d78b8a15300 100644
--- a/arch/x86/events/intel/p4.c
+++ b/arch/x86/events/intel/p4.c
@@ -776,7 +776,7 @@ static int p4_validate_raw_event(struct perf_event *event)
 	 * the user needs special permissions to be able to use it
 	 */
 	if (p4_ht_active() && p4_event_bind_map[v].shared) {
-		v = perf_allow_cpu(&event->attr);
+		v = perf_allow_cpu();
 		if (v)
 			return v;
 	}
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 5902ca3f057a1..007043a4a3602 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -50,7 +50,7 @@ static_assert((PERF_EVENT_FLAG_ARCH & SPE_PMU_HW_FLAGS_CX) == SPE_PMU_HW_FLAGS_C
 
 static void set_spe_event_has_cx(struct perf_event *event)
 {
-	if (IS_ENABLED(CONFIG_PID_IN_CONTEXTIDR) && !perf_allow_kernel(&event->attr))
+	if (IS_ENABLED(CONFIG_PID_IN_CONTEXTIDR) && !perf_allow_kernel())
 		event->hw.flags |= SPE_PMU_HW_FLAGS_CX;
 }
 
@@ -752,7 +752,7 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
 	set_spe_event_has_cx(event);
 	reg = arm_spe_event_to_pmscr(event);
 	if (reg & (PMSCR_EL1_PA | PMSCR_EL1_PCT))
-		return perf_allow_kernel(&event->attr);
+		return perf_allow_kernel();
 
 	return 0;
 }
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index addb34abffa18..a858b40e9104d 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -445,7 +445,7 @@ LSM_HOOK(int, 0, bpf_token_capable, const struct bpf_token *token, int cap)
 LSM_HOOK(int, 0, locked_down, enum lockdown_reason what)
 
 #ifdef CONFIG_PERF_EVENTS
-LSM_HOOK(int, 0, perf_event_open, struct perf_event_attr *attr, int type)
+LSM_HOOK(int, 0, perf_event_open, int type)
 LSM_HOOK(int, 0, perf_event_alloc, struct perf_event *event)
 LSM_HOOK(int, 0, perf_event_read, struct perf_event *event)
 LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3eaf73af41cdb..08e02dd5651a7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1670,22 +1670,22 @@ static inline int perf_is_paranoid(void)
 	return sysctl_perf_event_paranoid > -1;
 }
 
-int perf_allow_kernel(struct perf_event_attr *attr);
+int perf_allow_kernel(void);
 
-static inline int perf_allow_cpu(struct perf_event_attr *attr)
+static inline int perf_allow_cpu(void)
 {
 	if (sysctl_perf_event_paranoid > 0 && !perfmon_capable())
 		return -EACCES;
 
-	return security_perf_event_open(attr, PERF_SECURITY_CPU);
+	return security_perf_event_open(PERF_SECURITY_CPU);
 }
 
-static inline int perf_allow_tracepoint(struct perf_event_attr *attr)
+static inline int perf_allow_tracepoint(void)
 {
 	if (sysctl_perf_event_paranoid > -1 && !perfmon_capable())
 		return -EPERM;
 
-	return security_perf_event_open(attr, PERF_SECURITY_TRACEPOINT);
+	return security_perf_event_open(PERF_SECURITY_TRACEPOINT);
 }
 
 extern void perf_event_init(void);
diff --git a/include/linux/security.h b/include/linux/security.h
index e4300f2ff11b5..df4eda25c15bf 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2270,14 +2270,13 @@ struct perf_event_attr;
 struct perf_event;
 
 #ifdef CONFIG_SECURITY
-extern int security_perf_event_open(struct perf_event_attr *attr, int type);
+extern int security_perf_event_open(int type);
 extern int security_perf_event_alloc(struct perf_event *event);
 extern void security_perf_event_free(struct perf_event *event);
 extern int security_perf_event_read(struct perf_event *event);
 extern int security_perf_event_write(struct perf_event *event);
 #else
-static inline int security_perf_event_open(struct perf_event_attr *attr,
-					   int type)
+static inline int security_perf_event_open(int type)
 {
 	return 0;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bcd870658b295..ddabdc16e3880 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4924,7 +4924,7 @@ find_get_context(struct task_struct *task, struct perf_event *event)
 
 	if (!task) {
 		/* Must be root to operate on a CPU event: */
-		err = perf_allow_cpu(&event->attr);
+		err = perf_allow_cpu();
 		if (err)
 			return ERR_PTR(err);
 
@@ -12631,7 +12631,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 		}
 		/* privileged levels capture (kernel, hv): check permissions */
 		if (mask & PERF_SAMPLE_BRANCH_PERM_PLM) {
-			ret = perf_allow_kernel(attr);
+			ret = perf_allow_kernel();
 			if (ret)
 				return ret;
 		}
@@ -12889,12 +12889,12 @@ SYSCALL_DEFINE5(perf_event_open,
 		return err;
 
 	/* Do we allow access to perf_event_open(2) ? */
-	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
+	err = security_perf_event_open(PERF_SECURITY_OPEN);
 	if (err)
 		return err;
 
 	if (!attr.exclude_kernel) {
-		err = perf_allow_kernel(&attr);
+		err = perf_allow_kernel();
 		if (err)
 			return err;
 	}
@@ -12914,7 +12914,7 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	/* Only privileged users can get physical addresses */
 	if ((attr.sample_type & PERF_SAMPLE_PHYS_ADDR)) {
-		err = perf_allow_kernel(&attr);
+		err = perf_allow_kernel();
 		if (err)
 			return err;
 	}
@@ -13708,12 +13708,12 @@ const struct perf_event_attr *perf_event_attrs(struct perf_event *event)
 	return &event->attr;
 }
 
-int perf_allow_kernel(struct perf_event_attr *attr)
+int perf_allow_kernel(void)
 {
 	if (sysctl_perf_event_paranoid > 1 && !perfmon_capable())
 		return -EACCES;
 
-	return security_perf_event_open(attr, PERF_SECURITY_KERNEL);
+	return security_perf_event_open(PERF_SECURITY_KERNEL);
 }
 EXPORT_SYMBOL_GPL(perf_allow_kernel);
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index bc01ba2069434..5b272856e5ab1 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -49,7 +49,7 @@ static int perf_trace_event_perm(struct trace_event_call *tp_event,
 
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event)) {
-		ret = perf_allow_tracepoint(&p_event->attr);
+		ret = perf_allow_tracepoint();
 		if (ret)
 			return ret;
 
@@ -86,7 +86,7 @@ static int perf_trace_event_perm(struct trace_event_call *tp_event,
 	 * ...otherwise raw tracepoint data can be a severe data leak,
 	 * only allow root to have these.
 	 */
-	ret = perf_allow_tracepoint(&p_event->attr);
+	ret = perf_allow_tracepoint();
 	if (ret)
 		return ret;
 
diff --git a/security/security.c b/security/security.c
index de57d6e2b3a49..b31fd25f4e5e3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -5954,16 +5954,15 @@ EXPORT_SYMBOL(security_bdev_setintegrity);
 #ifdef CONFIG_PERF_EVENTS
 /**
  * security_perf_event_open() - Check if a perf event open is allowed
- * @attr: perf event attribute
  * @type: type of event
  *
  * Check whether the @type of perf_event_open syscall is allowed.
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_perf_event_open(struct perf_event_attr *attr, int type)
+int security_perf_event_open(int type)
 {
-	return call_int_hook(perf_event_open, attr, type);
+	return call_int_hook(perf_event_open, type);
 }
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3543c4fddb059..a04a3e78936df 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7226,7 +7226,7 @@ struct lsm_blob_sizes selinux_blob_sizes __ro_after_init = {
 };
 
 #ifdef CONFIG_PERF_EVENTS
-static int selinux_perf_event_open(struct perf_event_attr *attr, int type)
+static int selinux_perf_event_open(int type)
 {
 	u32 requested, sid = current_sid();
 
-- 
2.53.0



