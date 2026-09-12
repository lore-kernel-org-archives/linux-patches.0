Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECFA4BEE3C;
	Sat, 12 Sep 2026 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231240; cv=none; b=CnRHc1761L3rqxtn/SJUuNskou3ujy55M5LmXg/WQSVdQHjgSezDoekDUNhSoPo2udVnDbxaXpTjTK7ZatqrJ2MTIjMRqc9TnKPjfASzD2kXmuyqF1Cl7VZzlsr6BRTkjzyt1qrNv53zK8oucbklG2KfCe4nstmFmnnumAN2X7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231240; c=relaxed/simple;
	bh=1uKIFsKjs7EtmcXWpt/q0KYUg79RVCSSawEla0iTyIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZ474wdmVryJIzc9bzrMCjy56WoiYa3n5mHXe/63ModVH2vCm82FmHfAMegvHzGKXAxNh09VAQIaaLx31pnWVy1Vk8V6WTaj1eQmQiPcOWSNaDKpzL9w5zeRGyMOTVu0PYdX/eTU+rP6FmaoLU8NyjL7tG6jRA1105jVqelIVA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dydyx+2Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dydyx+2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96BD1F000FF;
	Sat, 12 Sep 2026 16:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231238;
	bh=KyeQ//9/PYzqoOdE9s1+FnrA0bY8YFjl+5XHtXU3OuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dydyx+2ZcTBk8lX5sjjUFkNbc9EfWs7+m2yiNTg9k09+wg3JYls2gaIPDmpPS/wlK
	 F9L5KRVvaNkvcerSWwwxO3sbYHdaWFRWZT7ZwQAINmxvZS2BNQ4cg6qsao4Idz3HpL
	 X9Dl3AkZePC54G2CbygN6Ynqstgq8oGX2HDVR2cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Eric Curtin <ecurtin@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0957/1191] nvme-apple: return directly instead of else
Date: Sat, 12 Sep 2026 09:01:25 +0200
Message-ID: <20260912065609.716711801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kulkarni <kch@nvidia.com>

[ Upstream commit 2ce525d40aa61c87884b100995e59ba68b4ea059 ]

There is no need for the else when direct return is used at the end of
the function.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Eric Curtin <ecurtin@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 8ce883fd068b ("nvme-apple: Drop the PRP null check chicken bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 07b00f4a0e3f2..994cf755de093 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -234,8 +234,8 @@ static unsigned int apple_nvme_queue_depth(struct apple_nvme_queue *q)
 {
 	if (q->is_adminq)
 		return APPLE_NVME_AQ_DEPTH;
-	else
-		return APPLE_ANS_MAX_QUEUE_DEPTH;
+
+	return APPLE_ANS_MAX_QUEUE_DEPTH;
 }
 
 static void apple_nvme_rtkit_crashed(void *cookie)
-- 
2.53.0



