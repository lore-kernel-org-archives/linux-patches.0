Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015311;
	b=2EBKrlwuWoJ+0cv5GFC9TQ0/gxxvZvtapqTmjwvPC4+ZE4ravuu1RwBTM1RVPvl6CkJt
	 UP/rkN38i3PZ5JhuCeRHk32BozzpHV7o9PEqBNjC0lhJDZgvh4NxL64Je2sM6ml90pWzN
	 oM3KDRQCnv6da/N2Juyf16P6kDMu4uT3GZVvhGMomLAAHSXe9vdgIHRl9iKO/+gbRva+9
	 JcD/UbVl2kphMRlDKUhlrO8L8AjYGXX/FHxpeWXqIhlzxiaMcKBZptoc7upBeslIQT577
	 vHL7ukf8BnneE7KKrM7ddABYOJu0r9kfHXXsybLWvjLJhYaSrbG6awDUjn5nNrhNppA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wv7nSTjJ51Nd2Ec5RgU4hnrJnmGUwuMzIGy5rMKtSkw=;
	b=iDRSFS/92RssNFcwWno0HnD83ZOfDMLk4V1vh2Df1jGGQTozOzCHmCs7/QBeE+uZks63
	 6VHX/i3o6TuUjo8kcbwq/fKIwOrN2W0VSxn3SMgeD9h2jLtOZ2UDsRZKDY/TgBVs99/6a
	 x812AB2jd+pbWlK23MjfpLMfHBZpPpgrJZd+IajbxTbouM5WweBiZe0Yhea+J6VJR6QFd
	 /p8I8s8deGP0xJQYYNG797AiMt3xkK4ds1iu9gxlD7vhHMd2CObl0MJ4EfM7GtoP5Qvjn
	 Itptuf8b9uwNtPhwy7BDp3dsjr7z8+xlj60Ny1w2MAip4rLdCofSVXIkzQrvo6OoqwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nk7vkrzk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD2D60A260A;
	Wed, 18 Nov 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nk7vkrzk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9121F000C5;
	Wed, 18 Nov 2026 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015311;
	bh=Wv7nSTjJ51Nd2Ec5RgU4hnrJnmGUwuMzIGy5rMKtSkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nk7vkrzk+dcLjv5hfT5Cl4yXKW3N1YSPbi6y4Cne8NUBKb6ETzSTtc/UdEBDhtxIa
	 z7KPtHe29wdlcGfSpRi7yobXdxk6B0bL8ffV2meINWHeq57s+CZCLVs0nZfA8M59gk
	 UzvQvukKvcol/i2Tr1H+fHYfYD7iWGM04afoapVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0129/2651] cxl/mce: Avoid alias page retirement for corrected errors
Date: Wed, 18 Nov 2026 15:22:49 +0100
Message-ID: <20261118150252.502845822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>

[ Upstream commit 04a7b330c8b60dfff200d9a32dd6615f97b59d07 ]

cxl_handle_mce() offlines the aliased page of an Extended Linear Cache
(ELC) region for any MCE with a usable address in the region. This
includes corrected errors, needlessly reducing usable memory.

Skip ELC alias retirement when mce_is_correctable() identifies the
reported error as corrected. Uncorrected errors with a usable address
in the ELC region continue to retire the aliased page as before.

mce_usable_address() already implements the per-vendor checks that
determine whether the reported address is usable, so no separate
memory-error classification is needed.

On AMD, a corrected legacy bank 4 DRAM ECC error (XEC 8) reports a
usable address and retired the aliased page before this change.
Tested under QEMU with Intel Skylake-Server and AMD EPYC-Milan models.

Fixes: 516e5bd0b6bf ("cxl: Add mce notifier to emit aliased address for extended linear cache")
Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260824134957.11085-1-shaikhkamal2012@gmail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mce.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/mce.c b/drivers/cxl/core/mce.c
index 65fed913b2217..3ac6802e750d2 100644
--- a/drivers/cxl/core/mce.c
+++ b/drivers/cxl/core/mce.c
@@ -18,7 +18,13 @@ static int cxl_handle_mce(struct notifier_block *nb, unsigned long val,
 	u64 spa, spa_alias;
 	unsigned long pfn;
 
-	if (!mce || !mce_usable_address(mce))
+	if (!mce)
+		return NOTIFY_DONE;
+
+	if (mce_is_correctable(mce))
+		return NOTIFY_DONE;
+
+	if (!mce_usable_address(mce))
 		return NOTIFY_DONE;
 
 	spa = mce->addr & MCI_ADDR_PHYSADDR;
-- 
2.53.0



