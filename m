Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022766;
	b=1oyIiEBugIbKC14QVWnS/h150bVc9wVbM5OOttH07C2zhlAxED+0QImWbVr255S18Vzh
	 J6kh9Lv/Y7d1O9iLru2EOsI5pWivlrYU0lbkQHa0gofo/ATrO1KqJoVgx2OmsTvJl2Sqf
	 nXuWBqGrFCxi6WUFO5wW55u4edPABylSyOWSGsyA1fjkIMTcIIpTAtVd1mPQ8iRHKFMzk
	 tb6xgspMd0yz1FNv2M694DAIqDHtVCk6ZhfE+kb5d4tGeLdibIIa2puuMUyzq9cbxO/37
	 kONDuBttnp6fTLV0dmxgFhR97UVT6ulVGaiGEMd6XtRx5ssGwqqjkdnUQx1fmzKVLFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=m794vSrpMUR12pB/aaDmFQ1LWtfltwI/hAIu7pZ7vSs=;
	b=mCpM5S6Izo+IdnOqTHtXIpF7NEQ05ouWmu1sXFg/uW1V7Z5Xs9N6/LoMZMEfnJV6ZIMJ
	 KjdOD0mXmEyi/GZbQJL1bgoZRWMdJrUq60CoOMl9hSY5xLtMzirr+1marnzMXZTahVTVV
	 5fN6y0Q051KFlnOoEkzT1XAoRq5seO8n3oZCu9tJER1ejFdsm4NCXoL5RThdOhtCdAxFP
	 0DTIVCR94CqECOobWIlrSkjn3nVafhXdDU5foFC38wXMCLqiakee2mJK7szxdHoaRhles
	 Uj8t2fdCrTwaAXqUpe4ArO/pzutTLnQ5OkXWTb4OqGLMivXIW4n2UQZSmQVKTbwaxew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDhJqzW1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392E5606DAA8;
	Wed, 18 Nov 2026 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDhJqzW1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4F21F000C4;
	Wed, 18 Nov 2026 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022766;
	bh=m794vSrpMUR12pB/aaDmFQ1LWtfltwI/hAIu7pZ7vSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDhJqzW1xGvIoO0PBc34t9564qLio7d635sKhqmR2bLNhtBj1f8LfIhS0NV67Yl6e
	 +/UqVUdpnu6IMc9aFq2agbjqNaoXg7Rnr+jH2tyKw+Ng8XfVCW9X6bLPdyGZlqAPc9
	 MAo0TSikgMK5/OCfquGk/i/tW96V6C/t4Seb1NrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claude <noreply@anthropic.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0129/2151] drm/panfrost: Prevent division by 0
Date: Wed, 18 Nov 2026 15:31:04 +0100
Message-ID: <20261118150126.491265473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit fd4227f03546c323b5b21568f727233e9792d298 ]

When updating and debug-printing devfreq stats, in the very unlikely
off-chance that total device time is less than 100 ns, division by 0
would happen. Fix the divisor when relevant and rearrange operands.

Reported-by: Claude <noreply@anthropic.com>
Closes: https://gitlab.freedesktop.org/panfrost/linux/-/work_items/88
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260820-b4-panfrost-fixes-v1-2-1b2c2376f4bc@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 5d0dce10336ba..9ab4fb3deb145 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -76,7 +76,7 @@ static int panfrost_devfreq_get_dev_status(struct device *dev,
 
 	dev_dbg(pfdev->dev, "busy %lu total %lu %lu %% freq %lu MHz\n",
 		status->busy_time, status->total_time,
-		status->busy_time / (status->total_time / 100),
+		status->busy_time * 100 / MAX(status->total_time, 1),
 		status->current_frequency / 1000 / 1000);
 
 	return 0;
-- 
2.53.0



