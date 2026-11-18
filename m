Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037271;
	b=j+frW51tj1Sh2/HknFNsMpRcu4RV7LXKPrH2Fj/5teGIfVVup06lBalbXPIS+oEqz+xe
	 cMmIltFdSU8KGRPeVZul7YQBlTjbx0xCMNGcrr6tLE1TJTp/McavpAkmkWltoX3O6Vnqf
	 IEhV4Ewjxkkr0LpIAq7qsh+wGaiqO6VaW8kAF2u+Iu7ixoRmV6wmuOEDUs4PeFkzv60tT
	 Y0SsbdBcv3NZNpjTSIh31PR6WvJqBqoTzcpoB1nmy23HBg/JWa5Jgwmtg8szvQJ8TBxx8
	 GGJbbEcAzuxoBjiesgMijMmmYW83oA3CweCILfk+4wKuiqiz5l/dKcXklpYHXx8LqnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FTZWOoEJssGODQDp0Ff+ICsCG7NN3KyQcZXK4fnXCyY=;
	b=n1Ok91ixUY4wt3jOLMWcmaOsM/zZ60n0iDAgefA+yAp0pl7rWrPdTzMlSrm00V+W2kop
	 Fj6nYnSsm0CZv6cUt7b3p4b9JlzhVHJV+Kc2q5wDSHMjzmVz7g5N1sbJamVhpFVX/YaPy
	 3s0CxJQ0Sxsq0xPT0gBKJZaxe43uCRaMo8Qj6pu91PJ4TbWt16AhGHQ2DQNDQ52KrRp5E
	 ywZ5s7LlVL5rXy1/cOJmjdbzbxMPdc2Mpfz8bM3t/2FecFQIn9dlwzJbMKSBpBSaDB1ao
	 4gA0OMC0l3gT7SraHCgri/GXnYdDlUXkAUw9G7vXM00ns95ZjgJqgeF/ztzYv9BSR6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KX9aivaH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473A8606A31C;
	Wed, 18 Nov 2026 21:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KX9aivaH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7991F000C4;
	Wed, 18 Nov 2026 21:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037270;
	bh=FTZWOoEJssGODQDp0Ff+ICsCG7NN3KyQcZXK4fnXCyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KX9aivaHJkeFNX2ZoLp0fMh01lywKY6KOz2DvCOwa1Oxo/0k8kZzKId11ehqZUJxJ
	 TiKlN/8zP21KD+tOB4UuTLA8hpA5ORaR6y7SfHVCoCI7FMouZlN07XVgGJEe5VUp3b
	 wBm5l0i+KwJ47dyBY35s5YHbEOw534YNXJgrL6bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1350/3318] ACPI: CPPC: Accept requests to retain immutable autonomous selection
Date: Wed, 18 Nov 2026 15:32:52 +0100
Message-ID: <20261118150400.908135797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 4bcc60d326c5acaa28c5913259decb22a33a83a1 upstream.

ACPI permits Autonomous Selection Enable to be Integer 1 when the platform
always selects performance autonomously. cppc_get_auto_sel() returns that
value, but cppc_set_auto_sel() rejects the Integer even when asked to keep
autonomous selection enabled. AMD shared-memory initialization consequently
fails in active or guided mode after successfully reading the capability.

Accept a request to keep this immutable field enabled without issuing a
register access. Expose the immutable encoding to callers, separately from
the current value of a writable register.

Before an AMD shared-memory transition to passive mode, reject immutable
autonomous selection on any present CPU. Otherwise a guided-to-passive
transition ignores the failed disable and reports the wrong mode, while
active-to-passive unregisters the working driver before passive policy
initialization fails. Check under the driver mode lock before invoking
either transition, including known offline CPUs.

Serialize this capability query with descriptor publication and removal.
ACPI processor removal drops the descriptor before taking the CPU hotplug
write lock, so the caller's cpus_read_lock() alone cannot protect the
lookup. Unpublish under the same mutex before releasing a descriptor,
including when adding its kobject fails.

The cppc-cpufreq auto_select attribute can also request one while
autonomous selection is already enabled. If the subsequent bounds update
fails, its rollback requests zero and clears the cached mode regardless
of the previous state. For an immutable field the disable request fails,
leaving the cached mode wrong. Save and restore the previous mode instead.
This also avoids disabling an already-enabled writable control on that
error path.

Fixes: c984f5d5d45b ("ACPI: CPPC: Add auto select register read/write support")
Fixes: ea3db45ae476 ("cpufreq: cppc: Update MIN_PERF/MAX_PERF in target callbacks")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-19-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c     | 48 ++++++++++++++++++++++++++++++++++--
 drivers/cpufreq/amd-pstate.c | 23 ++++++++++++++---
 include/acpi/cppc_acpi.h     |  6 +++++
 3 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 53d68220f72c8..c4184619c76c9 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/iopoll.h>
 #include <linux/ktime.h>
+#include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/wait.h>
 #include <linux/topology.h>
@@ -94,6 +95,16 @@ static DEFINE_PER_CPU(int, cpu_pcc_subspace_idx);
  */
 static DEFINE_PER_CPU(struct cpc_desc *, cpc_desc_ptr);
 
+/* Protect immutable capability queries against descriptor removal. */
+static DEFINE_MUTEX(cpc_desc_lock);
+
+static void cpc_set_desc(unsigned int cpu, struct cpc_desc *desc)
+{
+	mutex_lock(&cpc_desc_lock);
+	per_cpu(cpc_desc_ptr, cpu) = desc;
+	mutex_unlock(&cpc_desc_lock);
+}
+
 /* pcc mapped address + header size + offset within PCC subspace */
 #define GET_PCC_VADDR(offs, pcc_ss_id) (pcc_data[pcc_ss_id]->pcc_comm_addr + \
 						0x8 + (offs))
@@ -896,12 +907,12 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	}
 
 	/* Plug PSD data into this CPU's CPC descriptor. */
-	per_cpu(cpc_desc_ptr, pr->id) = cpc_ptr;
+	cpc_set_desc(pr->id, cpc_ptr);
 
 	ret = kobject_init_and_add(&cpc_ptr->kobj, &cppc_ktype, &cpu_dev->kobj,
 			"acpi_cppc");
 	if (ret) {
-		per_cpu(cpc_desc_ptr, pr->id) = NULL;
+		cpc_set_desc(pr->id, NULL);
 		kobject_put(&cpc_ptr->kobj);
 		goto out_free;
 	}
@@ -955,6 +966,8 @@ void acpi_cppc_processor_exit(struct acpi_processor *pr)
 	if (!cpc_ptr)
 		return;
 
+	cpc_set_desc(pr->id, NULL);
+
 	/* Free all the mapped sys mem areas for this CPU */
 	for (i = 2; i < cpc_ptr->num_entries; i++) {
 		addr = cpc_ptr->cpc_regs[i-2].sys_mem_vaddr;
@@ -1589,6 +1602,32 @@ int cppc_get_auto_sel_caps(int cpunum, struct cppc_perf_caps *perf_caps)
 }
 EXPORT_SYMBOL_GPL(cppc_get_auto_sel_caps);
 
+/**
+ * cppc_auto_sel_is_immutable - Check for always-enabled autonomous selection.
+ * @cpu: CPU whose _CPC descriptor to check.
+ *
+ * Context: Process context.
+ * Return: true for Integer 1, false for a register or an absent descriptor.
+ */
+bool cppc_auto_sel_is_immutable(int cpu)
+{
+	struct cpc_desc *cpc_desc;
+	struct cpc_register_resource *reg;
+	bool immutable = false;
+
+	mutex_lock(&cpc_desc_lock);
+	cpc_desc = per_cpu(cpc_desc_ptr, cpu);
+	if (cpc_desc) {
+		reg = &cpc_desc->cpc_regs[AUTO_SEL_ENABLE];
+		immutable = reg->type == ACPI_TYPE_INTEGER &&
+			    reg->cpc_entry.int_value == 1;
+	}
+	mutex_unlock(&cpc_desc_lock);
+
+	return immutable;
+}
+EXPORT_SYMBOL_GPL(cppc_auto_sel_is_immutable);
+
 /**
  * cppc_set_auto_sel - Write autonomous selection register.
  * @cpu    : CPU to which to write register.
@@ -1609,6 +1648,11 @@ int cppc_set_auto_sel(int cpu, bool enable)
 
 	auto_sel_reg = &cpc_desc->cpc_regs[AUTO_SEL_ENABLE];
 
+	/* Integer 1 describes autonomous selection that is always enabled. */
+	if (auto_sel_reg->type == ACPI_TYPE_INTEGER &&
+	    auto_sel_reg->cpc_entry.int_value == 1)
+		return enable ? 0 : -EOPNOTSUPP;
+
 	if (CPC_IN_PCC(auto_sel_reg)) {
 		if (pcc_ss_id < 0) {
 			pr_debug("Invalid pcc_ss_id\n");
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 664bd617a2d67..d16e626155a2d 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1157,7 +1157,7 @@ static ssize_t amd_pstate_show_status(char *buf)
 
 static int amd_pstate_update_status(const char *buf, size_t size)
 {
-	int mode_idx;
+	int cpu, mode_idx, ret = 0;
 
 	if (size > strlen("passive") || size < strlen("active"))
 		return -EINVAL;
@@ -1167,10 +1167,25 @@ static int amd_pstate_update_status(const char *buf, size_t size)
 	if (mode_idx < 0 || mode_idx >= AMD_PSTATE_MAX)
 		return -EINVAL;
 
-	if (mode_state_machine[cppc_state][mode_idx])
-		return mode_state_machine[cppc_state][mode_idx](mode_idx);
+	if (!mode_state_machine[cppc_state][mode_idx])
+		return 0;
 
-	return 0;
+	if (mode_idx == AMD_PSTATE_PASSIVE &&
+	    !cpu_feature_enabled(X86_FEATURE_CPPC)) {
+		cpus_read_lock();
+		/* Check offline CPUs too, before changing or removing the driver. */
+		for_each_present_cpu(cpu) {
+			if (cppc_auto_sel_is_immutable(cpu)) {
+				ret = -EOPNOTSUPP;
+				break;
+			}
+		}
+		cpus_read_unlock();
+		if (ret)
+			return ret;
+	}
+
+	return mode_state_machine[cppc_state][mode_idx](mode_idx);
 }
 
 static ssize_t status_show(struct device *dev,
diff --git a/include/acpi/cppc_acpi.h b/include/acpi/cppc_acpi.h
index a451ca4c207bb..26f50cb250c20 100644
--- a/include/acpi/cppc_acpi.h
+++ b/include/acpi/cppc_acpi.h
@@ -160,6 +160,7 @@ extern int cpc_write_ffh(int cpunum, struct cpc_reg *reg, u64 val);
 extern int cppc_get_epp_perf(int cpunum, u64 *epp_perf);
 extern int cppc_set_epp_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls, bool enable);
 extern int cppc_get_auto_sel_caps(int cpunum, struct cppc_perf_caps *perf_caps);
+bool cppc_auto_sel_is_immutable(int cpu);
 extern int cppc_set_auto_sel(int cpu, bool enable);
 #else /* !CONFIG_ACPI_CPPC_LIB */
 static inline int cppc_get_desired_perf(int cpunum, u64 *desired_perf)
@@ -226,6 +227,11 @@ static inline int cppc_get_epp_perf(int cpunum, u64 *epp_perf)
 {
 	return -ENOTSUPP;
 }
+static inline bool cppc_auto_sel_is_immutable(int cpu)
+{
+	return false;
+}
+
 static inline int cppc_set_auto_sel(int cpu, bool enable)
 {
 	return -ENOTSUPP;
-- 
2.53.0



