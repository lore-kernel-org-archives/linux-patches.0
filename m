Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ED714F12C;
	Tue, 10 Sep 2024 09:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961852; cv=none; b=QSBgI7tf2HZNMDDzOnUp6jy0OuiqtBEwPlDprSfHk+5nCrvF0B+k9pgXjj5fRnhlfBsvm1ffahptp/tkQ1/lez1T/YZX9kMv+N6ovl4ofmp/6pRY7h6Ko6Pxp5udF9Ovpcom7gLhjsRMl7DfIladTJ11ttQpuqqKrtfxCNb1bH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961852; c=relaxed/simple;
	bh=Mmg3PwR3C6VjHzuRMhvPc9JTIf6JAwtriXAGpNNUNAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCUL/sNJIMRAZnqOQGhcVQqXHg81J2f0eK6R3eCSFnQu3x53Vx2uM+/alLzlrZurkIKiFrPqpL7HjeMkYWOB7iy/Zo8ftzLQK9uHBenkbHaUrPfo8cAOCrAejrj4ESzE/MSVHuMh6JhnCvi5eOLk14i0EY7DfS2gliX+0GpUMNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAnn+HUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAnn+HUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B48C4CEC3;
	Tue, 10 Sep 2024 09:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961852;
	bh=Mmg3PwR3C6VjHzuRMhvPc9JTIf6JAwtriXAGpNNUNAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAnn+HUit5bAO4EfVQpotxOVdD6ponIQWiLH0x3w5MRdlhHk7Dq4jhQQLpEju1i4j
	 PVPLFCH/LKAQTl6qtOGtQczevKnnNIx1tegyCdGtE9ryZZyzTEC24pg8uG6erc84pJ
	 1wG28pyMNNgwuAgNDN/l4Zq89l516gttZNX55Mt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 210/375] devres: Initialize an uninitialized struct member
Date: Tue, 10 Sep 2024 11:30:07 +0200
Message-ID: <20240910092629.568303134@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 56a20ad349b5c51909cf8810f7c79b288864ad33 ]

Initialize an uninitialized struct member for driver API
devres_open_group().

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-4-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 8d709dbd4e0c..e9b0d94aeabd 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -567,6 +567,7 @@ void * devres_open_group(struct device *dev, void *id, gfp_t gfp)
 	grp->id = grp;
 	if (id)
 		grp->id = id;
+	grp->color = 0;
 
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	add_dr(dev, &grp->node[0]);
-- 
2.43.0



