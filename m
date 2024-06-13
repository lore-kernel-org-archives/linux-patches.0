Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D507E136E00;
	Thu, 13 Jun 2024 12:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281089; cv=none; b=p5M6DviFwLZI5hN4YTklENy5Nojt7lFdAmkimdCp6ADwHrMqmPlbgLo0dmpsoB/yPouqmqOmLk8HXBoisorXbn37LNdf096gawdcTdu/qW31FrA47N9uGKJVUsjRmqLBVGvv4d8l6/8pFrx5AMMqnhDzqobIyx9dDatV8H9DwrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281089; c=relaxed/simple;
	bh=Anh1kAiTiiNqfL4xcXM3eayzFnLOY3LBqnLz3vLOHqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/WgpohshVjMYAJ49PXb5h8juGM/aEkgSz/5sG4QbVSaJg1Sf5o85NaXBOS91paCjY7B0miOMmeajEAJpdzrmD12WzBDNjpZS22TLk19lrtkTT4Kkh/4M7ZDQZTiN6GVmTTLrjy/C4i1xj/bBMazIUOJe2bwdKAY7XSl09iA3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrG6ZnbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrG6ZnbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BECBC2BBFC;
	Thu, 13 Jun 2024 12:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281089;
	bh=Anh1kAiTiiNqfL4xcXM3eayzFnLOY3LBqnLz3vLOHqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrG6ZnbUdcrSefhCSfpq/0UUxyb6EpVDxVLD2Q3cC9zkRPdCP0GAUgy7xQ3i/xZ0f
	 7d4Vko77a2Klu2CIvuNEKdEGwd3qeuRrveSBgRPRTlY4TiyTvko44D4CWFoZY2Zc6B
	 rQ73r80XR7Ji+0jxL0AlNw/ZZZCge1wEqlJLfeS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/317] powerpc/fsl-soc: hide unused const variable
Date: Thu, 13 Jun 2024 13:31:55 +0200
Message-ID: <20240613113251.302679348@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 01acaf3aa75e1641442cc23d8fe0a7bb4226efb1 ]

vmpic_msi_feature is only used conditionally, which triggers a rare
-Werror=unused-const-variable= warning with gcc:

arch/powerpc/sysdev/fsl_msi.c:567:37: error: 'vmpic_msi_feature' defined but not used [-Werror=unused-const-variable=]
  567 | static const struct fsl_msi_feature vmpic_msi_feature =

Hide this one in the same #ifdef as the reference so we can turn on
the warning by default.

Fixes: 305bcf26128e ("powerpc/fsl-soc: use CONFIG_EPAPR_PARAVIRT for hcalls")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240403080702.3509288-2-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/fsl_msi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index d276c5e964458..77aa7a13ab1db 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -573,10 +573,12 @@ static const struct fsl_msi_feature ipic_msi_feature = {
 	.msiir_offset = 0x38,
 };
 
+#ifdef CONFIG_EPAPR_PARAVIRT
 static const struct fsl_msi_feature vmpic_msi_feature = {
 	.fsl_pic_ip = FSL_PIC_IP_VMPIC,
 	.msiir_offset = 0,
 };
+#endif
 
 static const struct of_device_id fsl_of_msi_ids[] = {
 	{
-- 
2.43.0



