Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B3C82C76;
	Thu, 13 Jun 2024 12:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282006; cv=none; b=XBXPk5ObAuoFWyRUOEZDLoFBI3lNoz3Jqf/e/3nO+XTxtiqxMP7vJx9eD9ouSmo7q9PgTSBjpd4wiMxcYOEqAVD+xkdqjCHNS2HibjzRXD+RpVUpLvnx26Rr1d+tYJdMpjcglv5hEA8Wo4NFOdTNtPLJa6Jclekobciabsv4Fv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282006; c=relaxed/simple;
	bh=gKT7FhuhUkwvdgX2mSrMRFRorseXzguE5CTCp73TnVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDXO5tO/WO/Ze1bwd/BxG6HfmNQ7/2OgRA4PF5QXNK0TRSnXQoIiuniS/8BHHJYxESlIt4yDC42DTErupUP5Lex4EKfPfIAgZF+vzcbxGjMzdGfYllu5sNEDbhgfqwzzPn56bzxqIR+32bHPVtwRnKYrlmJqVZhPKkb1Xp8nGeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uhv1wjJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uhv1wjJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009A0C2BBFC;
	Thu, 13 Jun 2024 12:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282006;
	bh=gKT7FhuhUkwvdgX2mSrMRFRorseXzguE5CTCp73TnVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uhv1wjJIFpXhwR8C6D3xuP4DshNjvCtTqWR/y7mQ3iztNi8kKV4M8Uvyr15i2d/vq
	 jFKkUm5dR+TzX8KS7xdEHUV2AYIeSjw+8QqsX4o7MZD5K2yz8DMf2jB88R6OYL2SuW
	 pP8AFGfZzu2zxmP19y/sYP3pzmB3tV8hD1QHSqL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/402] powerpc/fsl-soc: hide unused const variable
Date: Thu, 13 Jun 2024 13:31:28 +0200
Message-ID: <20240613113307.249587721@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c55ccec0a1690..d9d3668293707 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -569,10 +569,12 @@ static const struct fsl_msi_feature ipic_msi_feature = {
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



