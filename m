Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11D13BBC3;
	Mon,  1 Apr 2024 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989724; cv=none; b=jBlHCql8a48AEYbHb5MzTUepHVeGuyxsKRkks+cwSEU0Glo3wiA8MJ9dLgcqhJa0TRpfXIL68bk0YGMDdZLFGvJiEiQPBX1xhRufpzhMop7vXRRuA4OB5ODpHOH8ZWv8aK/NANXg2eBdqk9MVrs64o00ViV2rF8LXfSOIa4HrJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989724; c=relaxed/simple;
	bh=91OHCzBiQaGGAW9k3aP68cY8l4Rl4yX4GIeNLZAsZg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r4/fikdyKtQLk8likvZ9zCAuwzZHimSiqS35vhmoDPd9yTA47V6DW7yyvO794nfhdtN81sKcxWKZdvUQuxYoVVeWBdzdusml8sRFnkuqDrUe2Uo+BMJ9DgIH2pv5E1kW95vo5kzeAdOqgR9nQmVrRQ6jmQRp7OhV5c4rF5MMDD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmmA3T9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmmA3T9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A631C433F1;
	Mon,  1 Apr 2024 16:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989723;
	bh=91OHCzBiQaGGAW9k3aP68cY8l4Rl4yX4GIeNLZAsZg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmmA3T9bIasHnzU+8AQqkVK03kr+5x9PihupZuXm80hHTfjCwtmzEO/MiLK0z26wd
	 aqw+wxa4RdaZIbrRJ65XVU4VNF+8uiYVpvYXT7nNmt5aEqZQg93gPmQyxbsrXy9sVq
	 kR/VkOd2rahq7cZsTMdjUvXN6kqU7T7bYqCj+T30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/396] platform/x86/intel/tpmi: Change vsec offset to u64
Date: Mon,  1 Apr 2024 17:43:03 +0200
Message-ID: <20240401152551.910803114@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 57221a07ff37ff356f9265acd228bc3c8744c8fc ]

The vsec offset can be 64 bit long depending on the PFS start. So change
type to u64. Also use 64 bit formatting for seq_printf.

Fixes: 47731fd2865f ("platform/x86/intel: Intel TPMI enumeration driver")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org # v6.3+
Link: https://lore.kernel.org/r/20240305194644.2077867-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/tpmi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/tpmi.c b/drivers/platform/x86/intel/tpmi.c
index 0a95736d97e4d..6676eae144f31 100644
--- a/drivers/platform/x86/intel/tpmi.c
+++ b/drivers/platform/x86/intel/tpmi.c
@@ -96,7 +96,7 @@ struct intel_tpmi_pfs_entry {
  */
 struct intel_tpmi_pm_feature {
 	struct intel_tpmi_pfs_entry pfs_header;
-	unsigned int vsec_offset;
+	u64 vsec_offset;
 	struct intel_vsec_device *vsec_dev;
 };
 
@@ -359,7 +359,7 @@ static int tpmi_pfs_dbg_show(struct seq_file *s, void *unused)
 			disabled = disabled ? 'Y' : 'N';
 			locked = locked ? 'Y' : 'N';
 		}
-		seq_printf(s, "0x%02x\t\t0x%02x\t\t0x%04x\t\t0x%04x\t\t0x%02x\t\t0x%08x\t%c\t%c\n",
+		seq_printf(s, "0x%02x\t\t0x%02x\t\t0x%04x\t\t0x%04x\t\t0x%02x\t\t0x%016llx\t%c\t%c\n",
 			   pfs->pfs_header.tpmi_id, pfs->pfs_header.num_entries,
 			   pfs->pfs_header.entry_size, pfs->pfs_header.cap_offset,
 			   pfs->pfs_header.attribute, pfs->vsec_offset, locked, disabled);
@@ -377,7 +377,8 @@ static int tpmi_mem_dump_show(struct seq_file *s, void *unused)
 	struct intel_tpmi_pm_feature *pfs = s->private;
 	int count, ret = 0;
 	void __iomem *mem;
-	u32 off, size;
+	u32 size;
+	u64 off;
 	u8 *buffer;
 
 	size = TPMI_GET_SINGLE_ENTRY_SIZE(pfs);
@@ -393,7 +394,7 @@ static int tpmi_mem_dump_show(struct seq_file *s, void *unused)
 	mutex_lock(&tpmi_dev_lock);
 
 	for (count = 0; count < pfs->pfs_header.num_entries; ++count) {
-		seq_printf(s, "TPMI Instance:%d offset:0x%x\n", count, off);
+		seq_printf(s, "TPMI Instance:%d offset:0x%llx\n", count, off);
 
 		mem = ioremap(off, size);
 		if (!mem) {
-- 
2.43.0



