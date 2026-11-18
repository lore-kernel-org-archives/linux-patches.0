Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033862;
	b=crK1GZu91fGCxePgNlBoAPfTToQTr9EPtvNTgN2TyVDG9LjSncyi82GOfoUko/BGvYXX
	 CcLIBf0dLj2Yf0JV4cdg3F6ZwT4jdQfUiotbQRNpAJaJvJnJQDPw9Y1I3Nh0pokUVIpp/
	 r6fQUedZ6RJ2xloackbuCzMbD4GdByL065lic2icDwb+tt+tp3ikA8MjOBdIhDdeKB6g/
	 CeYoZi9MQ1bhpRJ2bMDbnACrBjUOWsefS5pdQ9fG7SvEvPNYl9LC21FapUVjJMrRJ82c5
	 TROUE+a7m9uju0qkPH4wYI/BHqa/iS2MNj4gnoJeFR4/mD3dVlVVA/BbSfnrgx2oZkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yMsMCsZwqMPJb7lbANQEo5uZyA1A+gMhm0h+wjnT5Lw=;
	b=DDDFUiZJlHCg1F2A7Gum6058Fb/6CaYju6Ug52kyKGod4beRwbauK1/3qDjMn5wB9ajW
	 KgoCC5m+kEYcqtS5E4PMSwXaLZfmNl2Hc7PHLEWDqEFUfAngqU4aNWeH78nvGOnZ1Y2+i
	 glr8h9752ZMjh5tFLbV3PpAF4b2T9bcKkkyvYtcGGj0JBaqiuK+OBfEwp/sdVm9X1tEj4
	 bz2LIOQZqjN5yLykk+i0qdC+DIpU49oT7xdb+c5Nk6JXXW1J6xtL1gOrKBYzfYHPz5NWc
	 v7ZHJIyrGilCh6k3sBWnnoqzjdE8jpqHg+IyRPCs3yqyGK9NSmBMOOJj1uIvEYtcoWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hnk116fR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427EF606A339;
	Wed, 18 Nov 2026 20:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hnk116fR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DB91F000C5;
	Wed, 18 Nov 2026 20:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033861;
	bh=yMsMCsZwqMPJb7lbANQEo5uZyA1A+gMhm0h+wjnT5Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hnk116fRc5tvHnuczd7CSeBATm+9tFwy2PKTp7KwW0DW9vEhYq97hjJj53JV8gMCt
	 VxJXYs3IcNrmtzmIPE2NCg7q/gV/1gbcgK+A0qsU7DUFsH3vDfjDUJBeBWAOQ6LP0L
	 3tNIUR8rD1fC1PL4zYDXNzubc/b8/3LzPG5ts5So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0114/3318] gpu: host1x: Wait for timeout worker completion on channel free
Date: Wed, 18 Nov 2026 15:12:16 +0100
Message-ID: <20261118150317.717204790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 7a39b9856acccc8e9b05845ca2bf62494fcd3dfa ]

cdma_timeout_destroy() used cancel_delayed_work() to cancel pending
timeout work when destroying the CDMA. Usually this is fine, but
there is a narrow race condition where the timeout handler has started
execution but has not taken cdma->lock; the channel is freed causing
cdma_stop to take cdma->lock and flush the channel; host1x_cdma_deinit
then proceeds with deinitializing cdma while the handler is waiting to
take cdma->lock.

Therefore change cdma_timeout_destroy to use cancel_delayed_work_sync
instead to ensure any pending timeout work completes before proceeding.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260609-b4-host1x-small-fixes-a-v1-1-7c1131c0b3ad@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/cdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
index 1b65a10b9dfcf..9607330000f24 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -343,7 +343,7 @@ static int cdma_timeout_init(struct host1x_cdma *cdma)
 static void cdma_timeout_destroy(struct host1x_cdma *cdma)
 {
 	if (cdma->timeout.initialized)
-		cancel_delayed_work(&cdma->timeout.wq);
+		cancel_delayed_work_sync(&cdma->timeout.wq);
 
 	cdma->timeout.initialized = false;
 }
-- 
2.53.0



