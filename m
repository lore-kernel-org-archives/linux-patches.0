Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DBD34214A;
	Tue, 16 Dec 2025 11:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884153; cv=none; b=Km9DzRi0lAPIXyrCnqDgYzuIFC+PWOuIB7Zv9MzdCBa0bIN7I4Ns6I51mGVwojx8N72pYO4DrzSDFRFKtCnuKQ5enqu67R+PkeQL5QzNA3xuC4+863KuuM23l+qrDNvMarITDseRWRR77BLEQW5iNkT451Ysr7OBHyRmK+39wj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884153; c=relaxed/simple;
	bh=bftyF8E5axRhUWGo5zLdz8g2khOjmYluUSaHcQO9QTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bui4Sm12Rk0loxGnMKkwRKz7wZ9LnSY8K/b5KRfIyC/czkZjEovzIqrc+mvj7GpyD6jMDM1bjjAmh48oqghifCcjwHWkyybnx8S9eXhLuirOK3wIZbs0lnNtb0QR7wZ7npKVGj6+mM7ZWDGmFLqIW78WWFtWHVUtC4IgziSBjl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXW9RrSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXW9RrSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6A6C4CEF1;
	Tue, 16 Dec 2025 11:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884153;
	bh=bftyF8E5axRhUWGo5zLdz8g2khOjmYluUSaHcQO9QTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXW9RrSE8R2pUHlkM9jt9ICuyBr2B98u5elgMTWdCSI7lEoFnaKOB9vyYLEOVc3xC
	 3UMHqvmwZNBJ9X39iONbOqy+gFGJndfMcN+8JYAoInsmr/9d24TRGzhOX6Eu6bwkJX
	 x4nmAP+b95J6N52JmmOCa58BNtZVk2NSfOXGYuGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/354] drm/imagination: Fix reference to devm_platform_get_and_ioremap_resource()
Date: Tue, 16 Dec 2025 12:11:07 +0100
Message-ID: <20251216111324.543915701@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f1aa93005d0d6fb3293ca9c3eb08d1d1557117bf ]

The call to devm_platform_ioremap_resource() was replaced by a call to
devm_platform_get_and_ioremap_resource(), but the comment referring to
the function's possible returned error codes was not updated.

Fixes: 927f3e0253c11276 ("drm/imagination: Implement MIPS firmware processor and MMU support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/2266514318480d17f52c7e5e67578dae6827914e.1761745586.git.geert+renesas@glider.be
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_device.c b/drivers/gpu/drm/imagination/pvr_device.c
index 1704c0268589b..6bccbde4945ba 100644
--- a/drivers/gpu/drm/imagination/pvr_device.c
+++ b/drivers/gpu/drm/imagination/pvr_device.c
@@ -46,7 +46,7 @@
  *
  * Return:
  *  * 0 on success, or
- *  * Any error returned by devm_platform_ioremap_resource().
+ *  * Any error returned by devm_platform_get_and_ioremap_resource().
  */
 static int
 pvr_device_reg_init(struct pvr_device *pvr_dev)
-- 
2.51.0



