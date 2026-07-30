Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE613A5433;
	Thu, 30 Jul 2026 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421467; cv=none; b=W/IhZNFSbOWca9R6su4MNQT+37Dp8MpvIq05VzJTfibllOgDRyXJite531vtyFgi6iT2lWUnp2CJ6iRHSsBOvDEjZv2bOD2QnqFZPUTjvxh8BAP++fpz3QnWe/FVRWSs6yhyZZArh8Ny2lB9nF2t2of2eMSgwJmSdTHp3v8CeAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421467; c=relaxed/simple;
	bh=o1yGgOyncAQLq6kWmX/Kmc8SR97epDayahVPEgAgDzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPHRBChA+JUQ5n6ancIGPhFnXCdhkmAlg+Jt6UKe6P3Ue89/xTU2bCg2WjH/lNVsDTfL+BuO8O1JMhm4pG1X+kf+8RClgGAZOM3rUqRaUUOcJRb0Wif8KCXuL8NerS20RkEO0unpUnY0LxjbxnzV9fmFxCKguBiXDFCSdNnKQXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlZr8vnX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlZr8vnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371881F00A3D;
	Thu, 30 Jul 2026 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421465;
	bh=iTJKBtZ3q5wKoG+8JgppRzlX2/Te4xHQQHNiraWUbVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlZr8vnXCxhIEYdyQ3SZYaPeHvvIkeLMbkk+oqXs1xg9ME+VAhuoUdo5snIR3wQRD
	 W0ivFAjhytqYNflesjQmLSBVdOqwoG7Ml/afoNBQWLJJLoGZOaUlSA2SBXiML8dF1j
	 yrrTDaIvOYTHiNDBHMk+H6Nodhl61ZU5hPsUqy9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 112/744] powerpc/85xx: Add fsl,ifc to common device ids
Date: Thu, 30 Jul 2026 16:06:25 +0200
Message-ID: <20260730141446.660277734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 25957f7c3dac3265332d766b71233e3622f17e14 ]

Add fsl,ifc to mpc85xx_common_ids so that of_platform_bus_probe
creates a platform device for the IFC node even without 'simple-bus'
in its compatible property. On P1010 and similar platforms the IFC
node is a direct child of the root, so it must be explicitly matched
to be populated.

Fixes: 0bf51cc9e9e5 ("powerpc: dts: mpc85xx: remove "simple-bus" compatible from ifc node")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260604043309.91280-1-rosenp@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/85xx/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/85xx/common.c b/arch/powerpc/platforms/85xx/common.c
index 757811155587db..c11deb2f50ed45 100644
--- a/arch/powerpc/platforms/85xx/common.c
+++ b/arch/powerpc/platforms/85xx/common.c
@@ -42,6 +42,8 @@ static const struct of_device_id mpc85xx_common_ids[] __initconst = {
 	{ .compatible = "fsl,qoriq-pcie-v2.3", },
 	{ .compatible = "fsl,qoriq-pcie-v2.2", },
 	{ .compatible = "fsl,fman", },
+	/* IFC NAND and NOR controllers */
+	{ .compatible = "fsl,ifc", },
 	{},
 };
 
-- 
2.53.0



