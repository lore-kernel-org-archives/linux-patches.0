Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E49919066D;
	Tue, 10 Sep 2024 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962983; cv=none; b=eieZpF13ILMN8p7vN8d8uq5HBlwo8s4XN8MuuST3f/eyIC20dAo1Yxeevz19ohJjfofYSZ1Mxa2Q1HDaHksYiCRz4KIBh/mUERpFrE2NwAtFCBGit5yH9WxkXTRc+8ngYS3P7p/re0+SosMJSroBrc8xqdt0E/MlFXbJTync0tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962983; c=relaxed/simple;
	bh=rM3UsZyV8fySNnhhMDT3+QpsyFB4rmmivwvM9FggxAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zydk+y/HuHgLBQFVMjI+N73u9bcURDVBklejE9CJMdJ+gVRhfpqwtsqX/n010KGLg9voZksTEo18L92FVC+2F5HP8SNhXVGs31YfTLR5+g2+AITYMZmsuRtOYdBTkDGzY0d0998JVX5+Vfs5iFSLj6Fato0UVIuTqefnAQcLWRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X79sejM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X79sejM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9455C4CECF;
	Tue, 10 Sep 2024 10:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962983;
	bh=rM3UsZyV8fySNnhhMDT3+QpsyFB4rmmivwvM9FggxAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X79sejM6J9EaQv/zNJX96Hy1akBLP/KD+LNcsgWEg4GoTqzn3g3D/p5UHkieDv+wO
	 fLXWAKeU799PuCI09x6SdHF0kdicCSJtLfSDfr9dxcMDkV2pqD47rG/vg75m9XMaAm
	 zzpmjX2x3BXfhvzDfq4TdnGiYkpkvpFhf9xd5Ie0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/192] devres: Initialize an uninitialized struct member
Date: Tue, 10 Sep 2024 11:31:59 +0200
Message-ID: <20240910092601.924426361@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
index f9add2ecdc55..35d1e2864696 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -564,6 +564,7 @@ void * devres_open_group(struct device *dev, void *id, gfp_t gfp)
 	grp->id = grp;
 	if (id)
 		grp->id = id;
+	grp->color = 0;
 
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	add_dr(dev, &grp->node[0]);
-- 
2.43.0



