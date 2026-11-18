Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022898;
	b=sT+xwQA9fewB4SalDrYwtPgbQelcrAXdYA/SaRgMwGPr/CmSCiUgoq9eehsc5p+qilRR
	 msldNm4pW5hVp4PiZ5q5AUIf8nh6zKdtT3OGCIhMflswyNk/KJFjAlYaUotpaDjTrQz+d
	 0iPvEytubHZPM6ARJ9GzIZe6I3uujGpN4o9EVqljDVnIilvcrL8VdLUC7FHWGK0278wjs
	 TfjCiSVY3OhVWYNxni9p82DXk5azR+BEB75oe9ozq3odN2vtkCp8sS1Ktzwz/8F/TtggB
	 8fEKQcB3S9R8vY7uxhgZxnV29/R+EhZka9ECmOedTwS01F0dRiIAa9q8Er8me2CbXaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JFAp0DUrxIj/ieKDZibFwSq+NUv3BWmiD7Vlb0sxELM=;
	b=FPWJ3FqRVl9Zg0N798LrQPSzFnZlzNFa9GCGXZ1Ep0zG02MO9UZk1RC8RQ27T1+ugLsV
	 ZMBTUsXpd7ioa2lPVj+K8eguuTIl+Ob5PVRjlZSKnkPIRuChwhUjF7sl7UyebTo9gG4Ps
	 tHo713JFmuiA97rg5r0ueYh59V0HslazAf5AArL7pfAzROfbt7GQ1xSGPYjtfQsqGZL2b
	 E140i/N5ziah8N7MuTEnlDNVVe2hqdpTiEhFCE2YDBu8zWfcsExWOPb4Gi7c9v0nDo/GF
	 5fpd0ZXmTHa9Z8ZFqfwPIqPOMkwf+u3EZdISqbaP/pf/Ki+x7DNo0/VfoDan4aJuo5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RoKyyuM1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ED6606DA93;
	Wed, 18 Nov 2026 17:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RoKyyuM1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C165D1F0092B;
	Wed, 18 Nov 2026 17:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022898;
	bh=JFAp0DUrxIj/ieKDZibFwSq+NUv3BWmiD7Vlb0sxELM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoKyyuM1eKNFLpqvzGHo/F63wC9H9j9eHyCZtpWD964PwiakFY/LNBGU+1cAbcT5M
	 rWkoqY9IAdUjC6P72zR2Ol8vUmNu3hLECX/3N+0soKqOGcQiPbP86B5K+PSLZthPZZ
	 6VJT6oR1lnPiypqwQMLBclgooxXxbvuCBFEyO0l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0175/2151] cxl/mce: Avoid alias page retirement for corrected errors
Date: Wed, 18 Nov 2026 15:31:50 +0100
Message-ID: <20261118150128.109582741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



