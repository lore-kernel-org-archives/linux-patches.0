Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC8417552;
	Mon,  1 Apr 2024 15:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987006; cv=none; b=EN8asVxc9VAeDStw/Azz422DeUHh2ELP1ckcaO/rC75AwLItnfLUcuXjJO+9bXYqmIZrxvAAgr/vzvDHPfn3e0YASvUsVxi4JRdHVMNDOcE5NqvGP+BTh/vkoaLHfWWtlReZUNEvUbl7733JquWhqgjDn7KD1MeyVMmjv0o7b+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987006; c=relaxed/simple;
	bh=b8I4VbltfYNP4vP5auHHaPyXWewmRbPDINFrXqTNtGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMh1tatMyuawarVJG4TIfwY/26AXJVT/OxMpABvLt1ZqC5IuGfkJ3nVvWJXFCSqQiTwlKZWzb0qYPzIDeRuXGeffsQQXotWcB2GyyLposamPOCJZovCKbYV9CJyIKVK6G2bu4Lxi6/8qey8qCR62h7SfO4b/ytihutf/8PmmCIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dU9jXnJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dU9jXnJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02D2C433F1;
	Mon,  1 Apr 2024 15:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987006;
	bh=b8I4VbltfYNP4vP5auHHaPyXWewmRbPDINFrXqTNtGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dU9jXnJJhPcJwKjE23C4o0mXP9UFVvy19oQVRdv6BmhdC7BgNOuWaVs1sy1uOuuVN
	 LmG8M7ljpenv6UBptnQIvOwIS3O1voXIMM/+XzObZ2+bszeZkPe5pLcVna6sagp8rx
	 advtBMi8retyJKl0vo75lgwz9xDxAvi2Cz8IAAvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 154/399] platform/x86/intel/tpmi: Change vsec offset to u64
Date: Mon,  1 Apr 2024 17:42:00 +0200
Message-ID: <20240401152553.784805430@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index e73cdea67fff8..910df7c654f48 100644
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
 
@@ -376,7 +376,7 @@ static int tpmi_pfs_dbg_show(struct seq_file *s, void *unused)
 			read_blocked = feature_state.read_blocked ? 'Y' : 'N';
 			write_blocked = feature_state.write_blocked ? 'Y' : 'N';
 		}
-		seq_printf(s, "0x%02x\t\t0x%02x\t\t0x%04x\t\t0x%04x\t\t0x%02x\t\t0x%08x\t%c\t%c\t\t%c\t\t%c\n",
+		seq_printf(s, "0x%02x\t\t0x%02x\t\t0x%04x\t\t0x%04x\t\t0x%02x\t\t0x%016llx\t%c\t%c\t\t%c\t\t%c\n",
 			   pfs->pfs_header.tpmi_id, pfs->pfs_header.num_entries,
 			   pfs->pfs_header.entry_size, pfs->pfs_header.cap_offset,
 			   pfs->pfs_header.attribute, pfs->vsec_offset, locked, disabled,
@@ -395,7 +395,8 @@ static int tpmi_mem_dump_show(struct seq_file *s, void *unused)
 	struct intel_tpmi_pm_feature *pfs = s->private;
 	int count, ret = 0;
 	void __iomem *mem;
-	u32 off, size;
+	u32 size;
+	u64 off;
 	u8 *buffer;
 
 	size = TPMI_GET_SINGLE_ENTRY_SIZE(pfs);
@@ -411,7 +412,7 @@ static int tpmi_mem_dump_show(struct seq_file *s, void *unused)
 	mutex_lock(&tpmi_dev_lock);
 
 	for (count = 0; count < pfs->pfs_header.num_entries; ++count) {
-		seq_printf(s, "TPMI Instance:%d offset:0x%x\n", count, off);
+		seq_printf(s, "TPMI Instance:%d offset:0x%llx\n", count, off);
 
 		mem = ioremap(off, size);
 		if (!mem) {
-- 
2.43.0



