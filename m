Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210820;
	b=kOehuRvOi3cuiVy1uhJAoBtzNpHxOsMrRuVCJ05m0iHDOwKiLQAVSOMnK4wgJkPJ0mSw
	 1MkQmyIFW3uXI7fom4nCP4MO/F9fkOpOisJ+LSmjeNzzOiEY2JkbFEcfTb8rNsCgxewdg
	 aFhE5Qde5Xzjz+yr9tbH5pzP+IZLGGbzlpHHObjT6gKsE2FCKkOWSWWm5YxkQscy5pCvt
	 Vcg8HvBvAkyFoXhoFoO+WHY5EgTjY8MwuVsYXD4c0c/6vAOchysBwa6z/C5eG1G1RDtfw
	 s4U6WTyjJzWretOCh9DeOZgCm0HAfwGYlaqCRq0nMyZyNDbIo9V7nghT6aGd7JsYY5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R8J9/goWCY/sjVQgYK4uUphKIDqVi8BY3R8vh7bGKMo=;
	b=tnAXnYfisn2oCzVcVa/xbvRJgcLBK6FgyNKTvn6mlXE7A82Y/TDfublzRHdtSf0zitix
	 XE9eJYUd98DHwRVlWsDeyUAfkVeGLYQUK90g4Xjrcw2XTGHTDdsrDaYMWcmzkl2dH2WAk
	 Qv+CCktpCOO+zl++ICCPjiOZfXbKptaatpbGJYrGd+dCpFlj9N/5kbvudoOnKbWhiJLS5
	 1kdQvvvlpWiJQUIjcWrSDe1l9xY8LGI2Ef3+miXjo++IUFOu6zqXjmhM3HS5gQDf27yxf
	 apj3r/rHCi//xZwwkweNIlzeWf+payuy0OJjIaLXTx2s1GbiS0NYQlnBkKUzOd7m9SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1w+v6pU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D2606A31E;
	Wed, 28 Oct 2026 18:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1w+v6pU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0191F031E0;
	Wed, 28 Oct 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210820;
	bh=R8J9/goWCY/sjVQgYK4uUphKIDqVi8BY3R8vh7bGKMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1w+v6pUiDyllyS+QBVZa4DoTqS/pcf4Zf9HValFyl+jp36KS4WRSHtAGMtr9QCNX
	 0up2gphFLFQUNS7Vbdi3mbEOdtfWHQqtr8nXD9lm2O98aMfsEnaAsM+/e0VilG7ykF
	 2839UKGK5Bn2RvwgmASCQ/dayiGZGnuaKvv/+tCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/571] mtd: core: Drop duplicate NULL checks around nvmem_unregister()
Date: Wed, 28 Oct 2026 17:55:06 +0100
Message-ID: <20261028170011.790359712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit bcf4ef28b0839a55bfae75b2bf4794c1d7244e61 ]

Since nvmem_unregister() checks for NULL, no need to repeat in
the caller. Drop duplicate NULL checks.

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220220151527.17216-13-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 12b31d1acd20 ("mtd: core: call _get_device() with the master MTD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index cd49719ca3410..74e449db33ac3 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -745,8 +745,7 @@ int del_mtd_device(struct mtd_info *mtd)
 		debugfs_remove_recursive(mtd->dbg.dfs_dir);
 
 		/* Try to remove the NVMEM provider */
-		if (mtd->nvmem)
-			nvmem_unregister(mtd->nvmem);
+		nvmem_unregister(mtd->nvmem);
 
 		device_unregister(&mtd->dev);
 
@@ -927,8 +926,7 @@ static int mtd_otp_nvmem_add(struct mtd_info *mtd)
 	return 0;
 
 err:
-	if (mtd->otp_user_nvmem)
-		nvmem_unregister(mtd->otp_user_nvmem);
+	nvmem_unregister(mtd->otp_user_nvmem);
 	return err;
 }
 
@@ -1039,11 +1037,8 @@ int mtd_device_unregister(struct mtd_info *master)
 		memset(&master->reboot_notifier, 0, sizeof(master->reboot_notifier));
 	}
 
-	if (master->otp_user_nvmem)
-		nvmem_unregister(master->otp_user_nvmem);
-
-	if (master->otp_factory_nvmem)
-		nvmem_unregister(master->otp_factory_nvmem);
+	nvmem_unregister(master->otp_user_nvmem);
+	nvmem_unregister(master->otp_factory_nvmem);
 
 	err = del_mtd_partitions(master);
 	if (err)
-- 
2.53.0



