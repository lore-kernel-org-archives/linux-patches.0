Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445CE446BFB;
	Thu, 30 Jul 2026 15:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425650; cv=none; b=DZy9HSXBdnjeDJAMr/j9ihReuaVjsQObhupvFc6q5brn0loqgtdnMJlRhu5NJgAlWe9sOSg1Wv3sz0G3vcHxexrN8sWgZkE91+lT92ehvxEL0dLloQcSAJsqIsfW4dnBlNA/bdWg9kyLgN8y7Z2Ct77e7kIdnXFl/+Vd+nn8FJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425650; c=relaxed/simple;
	bh=jIU8ytf7B9LkwTObQzgTFNMsGSIEmKAkSx83ECQV7TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw+LmHGn506g1jBMr/tcw/RMi4I0WnVJiDfe1DF5orBwYrwq5Oc8g5hy44KSHUqv63LbEwNdWwe7aQBLOcValbMHpNzuEi0vEsyW+rNY8ZofqWlFY6rHklCIHVTgsXm1Ra/lDowMbrykMHScFtc6fQlOTsynDOK+67BSYnRR3/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKzY00jb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKzY00jb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA0A1F000E9;
	Thu, 30 Jul 2026 15:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425649;
	bh=H95rq1wihht18aJCEkL6LgSXvp+YAzAYiGWCe4CscV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKzY00jbc2PW4s+WdL50icwANfmsqCUtXNPxTBJIEIRkujXpCLwx+o2U/7OhHRYiC
	 Ra7h2WW944r7VpmN8Luo0LFwaMlfHOpP8lYj5KAWoiXUUC/1rDhg2VhM9+z6zErZZr
	 tzrRbnlLq/ZSUkbgrM9DwiI/RAW7wJiMIJAImcdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/602] powerpc/85xx: Add fsl,ifc to common device ids
Date: Thu, 30 Jul 2026 16:08:10 +0200
Message-ID: <20260730141438.053601560@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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



