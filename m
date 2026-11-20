Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199983;
	b=GzM/Ki7oh4A+SFnA2dLY/8YtorG2E09qOaB/sTUBcKCUqapmH3dAa7mTxauow+9lx8RQ
	 HU03Z2rAIMcXV2iKW39YrsO14RYalkXcl/xgeF6KwwisClKfJ8OyVcjen3Yvb5gewyXHs
	 3fOk6A4Fx32eEHVXoiUDHQBReKuxISzIKDacfbhiOC9R2rZ3GGGauPySIm62zWWHY2Dmo
	 92IaOaIgBNVsYq+0tUTR5HFtBP98CnTaZPbe5KOsT8PWBkO2tK3nOnlFnNUVNDv5tonpz
	 CEH+eg4kmvNAZ0U3MUOVafwvpJl/CMuFYvEm3haOFIdil6MNJ6A2RoMQI8ax7ldjWIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199983;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lux1QnDe26RBrxt6XHdu4/sdgdMUB8ZuvQNESEmL/9E=;
	b=UtLUuGkMDFem2D3akHnPLLLnhTtkJgNoFo3/6X0vcMwj7W3v2jnfh0PktxryHtSKV8GK
	 wwoRducqy+1IRvIUdOYvWD+fpvjeOCZnoDxZVl1BBo+TYbZofo45mHUaA8pMN6bzDIloO
	 QrclkuLi6o75CKZdd1fpbWQhrkNfrw3BKCSvuloBx6ELf/S5Kuz+ltFC2HBtqoJkVDLkP
	 HovupZy4fUtH7iwsxXOASEoKq7tGz5nJ+jLsVpViBn3XIVRv0nC8BhL4zJasB0Qei5mqn
	 Cwwpck6nm7s+eW614nKiEX3OGQwJK8tIKq5b/TsI60Z+LvCbNr7dckQqULJsVfTDH3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L0xUFEZD;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B3E60A261B
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 18:39:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9B3E60A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L0xUFEZD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795199982; x=1826735982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gxx6eNi8ibUkgPJe3lE7LZkGi1dnXyn6J8jv49fC89M=;
  b=L0xUFEZDEeYVKvgvHc8OL+dEQ1/NP2rg0seoMI9HmJGBRbtLUqvHaIB8
   yuDYIDT8DFamRg+vKbV33tjjciKxovWpDJtsVcJaatShiTbq+CI+p0LeH
   WNI6xhXOCV7bUGNjMAHhrX1d5G3/AdKxo7nux3IIhzcnQ20CS6wTPvrY0
   FQZrm5ydTGZl8epIkkSwGBDBUDh4Zsur3IUt2Nw+YweBQ0Mgtf3ag1Bd8
   WE4J7BnPBC22s/k+jTCYLG/c6BtLTOqHc77d5BCHx6Yt2hElWezk7X8Ml
   /A3/mbd8KA7a1myRrCmDEkByeI+n896+7z6M//joD+W1fjGzXg0XdDDyW
   A==;
X-CSE-ConnectionGUID: sH4QnKjtSP+T5DGj46sC8A==
X-CSE-MsgGUID: 07JnZKcrQniNNl/CCWPrkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3931846"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3931846"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:40 -0800
X-CSE-ConnectionGUID: PXy/A7cZQa2ZgNBSIucFlQ==
X-CSE-MsgGUID: RujFk1/vTdWmbdc2AQZ3tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12590719"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:40 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	tony.luck@intel.com,
	ben.horgan@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH 2/3] arm,x86/resctrl: Assert tasklist_lock is held when setting CLOSID and RMID
Date: Fri, 20 Nov 2026 10:39:31 -0800
Message-ID: <164d1c3a9f8b281cd038f2e80badb1d94ba3d3c8.1795197419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795197419.git.reinette.chatre@intel.com>
References: <cover.1795197419.git.reinette.chatre@intel.com>
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

resctrl_arch_set_closid_rmid() assigns a task's CLOSID and RMID. All of
its callers hold tasklist_lock for read, which is what lets
resctrl_copy_process() read both values as intended.

Each architecture declares resctrl_arch_set_closid_rmid() itself, so
there is no shared declaration in which to record that requirement.
Record it in the implementations instead.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/include/asm/resctrl.h | 4 ++++
 drivers/resctrl/mpam_resctrl.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 199ca9af0089..48bf22fb6b47 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -5,9 +5,11 @@
 #ifdef CONFIG_X86_CPU_RESCTRL
 
 #include <linux/jump_label.h>
+#include <linux/lockdep.h>
 #include <linux/percpu.h>
 #include <linux/resctrl_types.h>
 #include <linux/sched.h>
+#include <linux/sched/task.h>
 
 #include <asm/msr.h>
 
@@ -149,6 +151,8 @@ static inline void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid,
 static inline void resctrl_arch_set_closid_rmid(struct task_struct *tsk,
 						u32 closid, u32 rmid)
 {
+	lockdep_assert_held(&tasklist_lock);
+
 	WRITE_ONCE(tsk->closid, closid);
 	WRITE_ONCE(tsk->rmid, rmid);
 }
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 7aea58fca85b..4e6ffe273863 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -332,6 +332,8 @@ void resctrl_arch_sync_cpu_closid_rmid(void *info)
 
 void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid)
 {
+	lockdep_assert_held(&tasklist_lock);
+
 	WARN_ON_ONCE(closid > U16_MAX);
 	WARN_ON_ONCE(rmid > U8_MAX);
 
-- 
2.56.0

