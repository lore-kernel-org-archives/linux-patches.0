Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EC643DA2C;
	Tue, 16 Jun 2026 15:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623094; cv=none; b=bNS1zwPILWIXyG55ah78BFF7jXfyNjrc4cYTDIAJdCWUXWde8v+mZw0gK0zD/rrdpgaGEg0KXcygtRbbotjEdSI2Lbr6iOZ5FvXtsiPMwW8nUVhrL9I7id0oP3Q6BV3QkwDO71cAl1D8yq+TRNKUuK5IqM3xD9BPDAvnbAKylZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623094; c=relaxed/simple;
	bh=3r73Ck+nh2Jxo9qF+SUdq01/VOroRtE2ftZtzHfhKBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3L9EStV75fti3enY7fb7yUijoIN1B7ao+hGuE5Zd2I4V8m8HgpnUhueq7RyWE61Pj1LfBcVGtpVdy1pMKHrL73luZ7CgbysesKDvmQ1IALnC6sJmW5/n3yXA26+qwjQTYIOhpVHyyBW45gFEkSb0DeYMAtCxfajZgSogs0jRq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmRpmCBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmRpmCBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092DE1F00A3A;
	Tue, 16 Jun 2026 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623093;
	bh=EAmEtb7vUW7XQe5j82os3ncEl09iCwjRkkwvGbgkL6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SmRpmCBjQ1kEFkXTkUjvpbRXGdMu206BDx2vzpN3YCNUWzgGXoTUKY4Cak5gwMWYS
	 FzOjIeDJgrD5tJ1unyf2XvWRK4zrtONWgNFFvz/Rpnlgbx569tEEGNa9xx87K6Q26H
	 Pvc9NT2znygCsKlCzcimIAWMZckOmrVaeIr9zwZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babu Moger <babu.moger@amd.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 087/378] x86/resctrl: Only check Intel systems for SNC
Date: Tue, 16 Jun 2026 20:25:18 +0530
Message-ID: <20260616145114.829858459@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 6f6947b2387e94e405f80d472f8a189bfbf2bd6c ]

topology_num_nodes_per_package() reports values greater than one on certain
AMD systems resulting in resctrl's Intel model specific SNC detection
printing the confusing message:

   "CoD enabled system? Resctrl not supported"

Add a check for Intel systems before looking at the topology.

[ reinette: Add Closes tag, fix tag typos, rework changelog ]

Fixes: 59674fc9d0bf ("x86/resctrl: Fix SNC detection")
Reported-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Babu Moger <babu.moger@amd.com>
Link: https://patch.msgid.link/9849330f45ac86344cc5ac54df2d313906d70bc4.1780634584.git.reinette.chatre@intel.com
Closes: https://lore.kernel.org/lkml/37ac0376-43a3-4283-a3d5-4d57b3bec578@amd.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 9bd87bae498342..59215fef3924c8 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -377,7 +377,12 @@ static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
 
 static __init int snc_get_config(void)
 {
-	int ret = topology_num_nodes_per_package();
+	int ret;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 1;
+
+	ret = topology_num_nodes_per_package();
 
 	if (ret > 1 && !x86_match_cpu(snc_cpu_ids)) {
 		pr_warn("CoD enabled system? Resctrl not supported\n");
-- 
2.53.0



