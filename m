Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7301AC43F;
	Thu,  6 Jun 2024 14:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683326; cv=none; b=AMDmxgIZCJG2dtJRjz+gMqbQiHANS8urVi4lqfCVrMSCAetKuMASLNTEcs6pYNnRMqLPd/eV1/S9jMYv0AEjlR1S1sSIHMyCokogdumMLiwDCfUFQQVjGyamW+UCRX9gmn9IrF/JxbuAH1af0rH8Tgli8L6c2KjjU0D16RCyCc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683326; c=relaxed/simple;
	bh=nJ2ed6txgg92F2FITvX5Wj6mihdLLLd4xw6n3hvg9Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2n31DG0FLbZUvHuf+IV/1k3J49ofeA8nv37ssE+MxKNMt8XppSIMfgEJAEMFkcmNB9VDx1SvWQm76l+lQ5XVY5xdibmv/sk5onzAIbISCgxJyVFMxhazDc+Iv2XQmP4tkJxB7r9gkOADZMuvpO5VVLExGG6BJuLN/yk+B+fnzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rg9K84jE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rg9K84jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3904FC2BD10;
	Thu,  6 Jun 2024 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683326;
	bh=nJ2ed6txgg92F2FITvX5Wj6mihdLLLd4xw6n3hvg9Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rg9K84jEP9vOYmeyZ55wzanx9G0NKE4dqcmkDHqy0hhA77oKqQQR3qD1a3vUocHlV
	 sCLdgusgF/3577eTayLrxkaEcY3s70gcafSEFVBSxAn7PUMGSH4P1avNcyb/2UElL0
	 VIol+gIJV9aC08pw+A4Th8l2dAM2Asiik0P96cfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/473] powerpc/fsl-soc: hide unused const variable
Date: Thu,  6 Jun 2024 16:02:14 +0200
Message-ID: <20240606131706.704105665@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 73c2d70706c0a..e50445c2656ac 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -567,10 +567,12 @@ static const struct fsl_msi_feature ipic_msi_feature = {
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



