Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EAD3DD51A;
	Sat, 12 Sep 2026 15:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225231; cv=none; b=ZXyrzEYdJl53jP5D64DjjAIQ1eyhayL47LOehixj9FXGg2Y1E4NS9ppb1Ts455pMqoXjJDijuvbL+KFQUL9UnSQ3qeyWMnSmR8sZheWDG3bAcVhV3nDRdaSuPtbr6n1T5Wta0YNL4qpCpCSN3IkdYpuIwLEYOnBKA5yrGitvzw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225231; c=relaxed/simple;
	bh=7At1m+EfLurQ6vUMLHKcFzZ0ItnvdS/h84/uB3DB85M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+Eso9NkBDSDTELjVOV3gF9evSKbqreSDDHOAUrUJzWFZjPJJJadWwMi32fhcZ8Mdd5pH7s0+vjUoE3XQPBS/PKF3k4gTTNtuBEVeWWK4UXHOZzyffsYD1UI6NkepVpFLWMGqeW0xTGIxGRB1Uj400ep8jbQLPO2NXzFQJaLi24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQSVxx21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQSVxx21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF231F000FF;
	Sat, 12 Sep 2026 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225228;
	bh=vmw4w2GAnQDyYGMFDjCn8nVR4usXLNuCPDIVCTjUTMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQSVxx21qMBgT2UyRO9Hlfgz7L6lAjR6bUPvSGqLCprkajbCgKxu9B/VXHHGOBr8N
	 DqPF0B1Fh38HrzlxFFesHMExnVoPp1l6y4kmiuoQwEOVJ4psYHhvZSkBkGhBfPusnC
	 JDyPBcWrKP7hn0ZxlKa7I1s246LbNj9cQN6Cpscg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1155/1424] nvme: introduce change ptpl and iekey definition
Date: Sat, 12 Sep 2026 08:59:47 +0200
Message-ID: <20260912065633.163889615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 7d2f9f870f26798699585f96fa7a2a2cab38dc02 ]

This is for the next tuning pr code more readble patch, make
linux/nvme.h's changes separately.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5bb96cc21883 ("nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index b1e818a6d2bac..09cd06f20da61 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -2092,4 +2092,13 @@ enum nvme_pr_release_action {
 	NVME_PR_RELEASE_ACT_CLEAR		= 1,
 };
 
+enum nvme_pr_change_ptpl {
+	NVME_PR_CPTPL_NO_CHANGE			= 0,
+	NVME_PR_CPTPL_RESV			= 1 << 30,
+	NVME_PR_CPTPL_CLEARED			= 2 << 30,
+	NVME_PR_CPTPL_PERSIST			= 3 << 30,
+};
+
+#define NVME_PR_IGNORE_KEY (1 << 3)
+
 #endif /* _LINUX_NVME_H */
-- 
2.53.0



