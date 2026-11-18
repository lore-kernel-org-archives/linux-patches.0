Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051336;
	b=FDvLr6OI3PcousjAS46XqdRV0hRyoXs9Kr3HXly5Os8EkKd1qWtT4KlixDJR9F3G1Vk+
	 ddiG4w63AfehSizSsUN+mYvLXwAE33aoehN1V8OUDmhtp61mdb8CKZj0IqgMv1mbn5cVc
	 N3wK8qtIn2pMkPqCMf/HHYwaswwjy1GfhcEJ1FVMgCQkL0rq/MJv7O0Jq2SNpnNwDKjGv
	 saL/sQSplh89dr1fNuURrE9bic6DSW4s8b3l/YVLWrIVf2wOCNcKmLS8ViFtU9YkO2joP
	 j4jwzHn4oj1v0NMWy3HePOtYtyupKUH6FxY+Wk4YeteIGS88EHCqGz8K2B50k5fPqag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vg+oOVztT2/Dq+3H7vK2cGX/EiNktxMwE41ous3KxOQ=;
	b=wSHLtGZhRSD/F/M7wRsRbw00CkbfCuamidGlKMWMn/LPsTnr2krREmBNKC6O/RkacToI
	 o18rbjTSasSGpGTD6aehG/wWmbIHRHYPWEOY8EGb3fhyZ1zroN0yxNpnCF1y99fAJDKHC
	 ZOXs5zQKrBFhGRdVD2O+r9jjY3133JgGyOxTMB7IEXnTiFKs81s5G2PWZmiPJM/U4Jgza
	 R/DrpNhQxr8hz5JkfstG+zwniOjVVA95O2X/qyRnqVJbW5ew4I20LhR/3aoLvfu6Z6wKg
	 d4YEsJZOwjd8CUy4kA2TVWMauvfeL4y4NJNMxGtxYdWf2IT2clzejNkwm64W4BFe9HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+LNbSwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3EB606A31C;
	Thu, 19 Nov 2026 01:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+LNbSwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC471F000C4;
	Thu, 19 Nov 2026 01:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051336;
	bh=vg+oOVztT2/Dq+3H7vK2cGX/EiNktxMwE41ous3KxOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+LNbSwagkMMLjYBJbqjj38vN0+Zar+6EIUTVQjQGQxquLdCXvmZU3rtWmh4brcQb
	 XAESn34nJRaeSn4L9tqbO6/SozCA/xVF0xa5aBnB5weRYwkEtt85wZFFgv2jwMWoH9
	 E7uz/QvgxrmR+DxMpc/VVm8cg0GrP4GwQs97iwUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0131/2214] soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:30:07 +0100
Message-ID: <20261118150015.458419708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 01479280fa5d4691013bcd64fdfd935117b69769 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Message-ID: <20260704121851.63805-1-pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ixp4xx/ixp4xx-qmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ixp4xx/ixp4xx-qmgr.c b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
index 9154c7029b055..88814e2cb44b4 100644
--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -455,6 +455,7 @@ static const struct of_device_id ixp4xx_qmgr_of_match[] = {
         },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ixp4xx_qmgr_of_match);
 
 static struct platform_driver ixp4xx_qmgr_driver = {
 	.driver = {
-- 
2.53.0



