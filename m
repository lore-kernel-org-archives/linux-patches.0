Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2577F39A7FD;
	Tue, 21 Jul 2026 18:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658223; cv=none; b=ptzwek40nVw0VIuZ57Jzbt+jXs0mP3ol19K2O6QRdNt5wKb6wuonoPKbSlGOhfM6QgsBI7eq5Tkn7zXGTxdu+R8HU74/ZEeCJwq9/sHIg5szKlUpVTQ0SBH/5LtRtdq1fXovkwfUJDex4utlW06EbZbrIHw5VUGlZggSu4Zionc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658223; c=relaxed/simple;
	bh=5gO3Y3iR0h8Rivr3EwlchG+1/IF4IuRIbav7wJdw7gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keKQhijLrgFlTUhC4m5ZeuV/SgIZT8+uBLezpjtgeBBXgNkCbIjnknXL8Jnm70qGsUhP3jL8YI6k9+SLTnYy7VOFCDvO5BAqkMhLt2++ym8VDjKGUo5K9r+t96o0XoyjvBQivd609ZSCMGXznGXC9zbxvEgcLjiEwaj8fTO2fko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baqvzW4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baqvzW4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4D91F000E9;
	Tue, 21 Jul 2026 18:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658222;
	bh=pStv94FekJXDxOcMn+0uyydDtOYMlpzvRqErLOV65X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=baqvzW4FDldKq6Pv21GBfhQ4FKew/PWVG4kJ+RKLX1IECVZAyZLZiXbT1GCQf048u
	 O2Q7ElzP7XgvB5dhTQu2rl9Kr1kq/1aG9g7ARC9urS8MsRq7lv/61vNBMmIzkkYqX4
	 3rNbq/wTevfPv8A51SIXTl/ZGv06q8/vNekZoDQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1060/1611] accel/amdxdna: Use unsigned long for nr_pages in amdxdna_hmm_register()
Date: Tue, 21 Jul 2026 17:19:36 +0200
Message-ID: <20260721152539.248848961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 18aaebdf43366954345a6721ed2bff3ac3c9fa61 ]

nr_pages is declared as u32 in amdxdna_hmm_register(), which may not be
large enough to represent the number of pages for large mappings.

Use unsigned long for nr_pages to avoid potential overflow.

Fixes: ac49797c1815 ("accel/amdxdna: Add GEM buffer object management")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260616061532.3533469-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index a1c9cc4a2b9d88..084b22b774193f 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -196,7 +196,7 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	unsigned long len = vma->vm_end - vma->vm_start;
 	unsigned long addr = vma->vm_start;
 	struct amdxdna_umap *mapp;
-	u32 nr_pages;
+	unsigned long nr_pages;
 	int ret;
 
 	if (!xdna->dev_info->ops->hmm_invalidate)
-- 
2.53.0



