Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ED130C143;
	Thu, 30 Jul 2026 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423650; cv=none; b=JxE6IzEyEojGxpU0Xx1mWGk9mo+fFYDXQdYZMjuunJeq3WhGZTp2yceFjLC5BnuHP0juBVgx9l9l6haATTEithhAsuVEBfEvn5wyLMExkqqqJKCKAZyt1lq9vqQKLaJDiLZiOeHypkXoTcr0ZWg5XYstuVkFghk5c2SpNQavbOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423650; c=relaxed/simple;
	bh=uY3OnLJApc9W2Ah2YaUn6SE9kI+Tk2t3lpr1Hp0HJlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKp+uzNxp2HMexUK1UjGJGdMkTKA8ZkA0Beu0n/6FUmxLpYAbjkx8Z+vdN6hnSgp00osFMRSz/vYD88z5xwAHlhRtfaCa4vvDWAXU8hWY4Y2U76mGDvGma3bOLgXxq/ao0I9qJeohn8i/cIILDjlBBwXjOteI5qVjZB1mkyQj8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nN2NiFLQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nN2NiFLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FC01F000E9;
	Thu, 30 Jul 2026 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423649;
	bh=nXnR6aWXmYb1XHYr63+dDfYOK9YsmZoXnEcCYTHGD7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nN2NiFLQ1wJhiWqweoFlmt6a1o+mCIMXHQYLo4PFWgQdxAqNdM/Vn1YZMWITnLK5J
	 OoiaPvQIR458SfOHynpzjek4k2NAqc6eAW2AMr1iClwMhCLY/w60Tnii9LZttPEP5C
	 FWcc3eM4cabCEskcLcwmiabWvVD6NUACI7qZXOfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/675] powerpc/85xx: Add fsl,ifc to common device ids
Date: Thu, 30 Jul 2026 16:07:26 +0200
Message-ID: <20260730141447.609801786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



