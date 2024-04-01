Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4513F8F4;
	Mon,  1 Apr 2024 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988333; cv=none; b=gv5TTjXnktCimchytWR4AAaYsFZ9wOM7MYB+/cDWpcWly3hVwYaMAYx/F8+TP5wiLpXUGXJO1NmOqiGTKPr1ObNRH/nZFd+djRTwh1FTbp5zcRqhbl5qFgTVKw0DZ2aEnCKA1S7ZAMyF8B2sHvrq4zo+hIODm+RI99GDlFCS0c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988333; c=relaxed/simple;
	bh=9KX1w5199xJTlxbLK2EV4SqNJp/q2Kv1jDKaa6OUNM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yck5RE+vWte4N5dk4liCfF7PpN9AAB7Rj9rh7CQzBEo4zqzxrQ8blgHNXDQzdO3SJ6xr5Rvzdp2m7Yg0Hyz88G5X9oqT81ROgL7TzXRc/OXf5CcH34tkucd/t7I1ENULqI3xmgsl1DaA7si0RY6eZ+Yp9jzs1ZdalqE8KTilrOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbBTUv7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbBTUv7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD88C433F1;
	Mon,  1 Apr 2024 16:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988333;
	bh=9KX1w5199xJTlxbLK2EV4SqNJp/q2Kv1jDKaa6OUNM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbBTUv7bo0y8U3+vQT2EYD4EC51Ibxjd5t6K78bLEdaGSatN1OasuD1DDeQ9yK+lK
	 rWcrK3MzZy58YmzfehL2s2OJcrkbQxYQpzje/LhSdzC+v+DBQXjQNJupTTzapLlh0x
	 /vZvbTYgWrnQ4EGoOdjJSwYdp045g1nE+w+/J5dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 153/432] platform/x86/intel/tpmi: Change vsec offset to u64
Date: Mon,  1 Apr 2024 17:42:20 +0200
Message-ID: <20240401152557.707174113@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 311abcac894a6..c2f6e20b45bc0 100644
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
 
@@ -389,7 +389,7 @@ static int tpmi_pfs_dbg_show(struct seq_file *s, void *unused)
 			read_blocked = feature_state.read_blocked ? 'Y' : 'N';
 			write_blocked = feature_state.write_blocked ? 'Y' : 'N';
 		}
-		seq_printf(s, "0x%02x\t\t0x%02x\t\t0x%04x\t\t0x%04x\t\t0x%02x\t\t0x%08x\t%c\t%c\t\t%c\t\t%c\n",
+		seq_printf(s, "0x%02x\t\t0x%02x\t\t0x%04x\t\t0x%04x\t\t0x%02x\t\t0x%016llx\t%c\t%c\t\t%c\t\t%c\n",
 			   pfs->pfs_header.tpmi_id, pfs->pfs_header.num_entries,
 			   pfs->pfs_header.entry_size, pfs->pfs_header.cap_offset,
 			   pfs->pfs_header.attribute, pfs->vsec_offset, locked, disabled,
@@ -408,7 +408,8 @@ static int tpmi_mem_dump_show(struct seq_file *s, void *unused)
 	struct intel_tpmi_pm_feature *pfs = s->private;
 	int count, ret = 0;
 	void __iomem *mem;
-	u32 off, size;
+	u32 size;
+	u64 off;
 	u8 *buffer;
 
 	size = TPMI_GET_SINGLE_ENTRY_SIZE(pfs);
@@ -424,7 +425,7 @@ static int tpmi_mem_dump_show(struct seq_file *s, void *unused)
 	mutex_lock(&tpmi_dev_lock);
 
 	for (count = 0; count < pfs->pfs_header.num_entries; ++count) {
-		seq_printf(s, "TPMI Instance:%d offset:0x%x\n", count, off);
+		seq_printf(s, "TPMI Instance:%d offset:0x%llx\n", count, off);
 
 		mem = ioremap(off, size);
 		if (!mem) {
-- 
2.43.0



