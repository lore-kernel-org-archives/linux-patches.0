Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2023DDDB1;
	Thu, 13 Jun 2024 11:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278787; cv=none; b=Wz66vjB/Yr8ghRuI2Zqlvn9+IhmOm9CxsjghPD02judBBGvVCYWLJ94UVOiIsYPIDD8HZfchFtdmXRU4yRIkC/y1bePOqzrE0v7G9Clx7LY/GM5LGlhkfwUtvBpEZc5UPpXavDk7PfORRAwiSzXoFLOKM7smFVsuF3QdCAJfVU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278787; c=relaxed/simple;
	bh=s96z+16uZU3m6oyRitQGYzhF+VuQffsbP1k2wO5x+Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF/oolTcszgG+t+tiis2V34VTBWAue2BHb0XxoQegh1VgZ2jiK3VlNPocvsJLPhpHx/UUURKDLVSuujPPIT7Riz9Zk2DGp0uIBhXSHl1WdOb5iFU+OK/JGTeehSmMrOeT7o2oPoofqQCNKozYel0ZmMN0WqIBiZ6S1pDFbYZIiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgXZ06/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgXZ06/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C651C2BBFC;
	Thu, 13 Jun 2024 11:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278787;
	bh=s96z+16uZU3m6oyRitQGYzhF+VuQffsbP1k2wO5x+Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgXZ06/MaNFJHSLH1rBmLu9P0G9MO8jdbYnjJ+f2uP0E11ATBg2A0/mtCNNogLZNe
	 /cJZeU6/Ta8ZeITZzLqthmFEyzLrsDsRdeDWdXqOZIb/+YWqPQ/30zcQrtfGJqvm+r
	 HOSua1fwpYBoPgsxvzI6H4HlwwZur8cA/gnJm8c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/213] powerpc/fsl-soc: hide unused const variable
Date: Thu, 13 Jun 2024 13:31:57 +0200
Message-ID: <20240613113230.669604851@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 44aedb6b9f556..4c1fd9d93e584 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -578,10 +578,12 @@ static const struct fsl_msi_feature ipic_msi_feature = {
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



