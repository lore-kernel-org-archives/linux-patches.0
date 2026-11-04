Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829505;
	b=Nodnf0w4Kjf5WfVwuWd6WJIkydzKQHkmexPLrLw6z9FfhH/5v4RNkeIiNr0KFB/f3XAo
	 Hww5dKlU5JeYYD4vrECHnoqqLEdcr9prvJgxPb8eGANqnBtT2m7FrFaGTj1TMMLefk/nm
	 CXoEcIuJ3/aacY2WWEpwGun+HLURQtEVZApaVRDzXyOUeyy0wwUd9NKnq2HoFx//fXbSm
	 eBXNR+DzCByFySvtYnowDyC69KhM2c3LRK4WSkr10ecF4EOOvEwTj3LZirBf0RLavkhh4
	 DjxeWhCQxmoHKxa1qr2YRrsRziw5WDQhWo+u1exYAwmlSxAo5VuZgVcc5aBUCoGCxrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829505;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WvC98MWJ6svWqvpCKYWbb1Q2fSV//nZQGh+5YLEeMT4=;
	b=k3GX15PgPCxtebrOM60L20fae3JB2elgXQY21Q40eb1LXjFsuLv81RUz0XTlxtCQ2SzE
	 Pe4IqmXhcDqhDvBe5Q7bPdolGxko03SJCovk1TLM7GjAQKVLGc9tmMhb3G5F9CcR0nt3v
	 uPttyfj7LptH0NudzXB5cUFUQXH14vP3Xy0DK9lG6r2s5azpA1vd6d3i2uCSnxH8ObPd8
	 JuNbhD9RmaspwCAvEGL3qX8S9XmRaXd0+kbGyqNFg+fTXSkEEmXQaJWrXBYjQ1z3itJom
	 uMUeUNL5o8GYePHugClT9e4yrCAmrWWNiVKs4sWzWMM57eqk9JI29qVt6HIDOpNYUWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VwWUIeg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2090606A849;
	Wed,  4 Nov 2026 21:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VwWUIeg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE291F000C1;
	Wed,  4 Nov 2026 21:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829504;
	bh=WvC98MWJ6svWqvpCKYWbb1Q2fSV//nZQGh+5YLEeMT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VwWUIeg3YRHDYBxiSqggWIPeCvma0xpMoKND6pNCncB+xV4BAR0tsI4Exiu6qGw6o
	 4yEiB4nRfoIDELQD++VLDdTQkL/I3H5bmH6BGaENrSSiOYwlvirc/INm6OibSU9m++
	 1q2jKvu0GDduxxli1Xp1X3WBEuGdKvKzGpG7qRzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0166/1005] gpu: host1x: Wait for timeout worker completion on channel free
Date: Wed,  4 Nov 2026 15:58:19 -0500
Message-ID: <20261104211048.414784729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3f3f0018eee0d..ab714d221120c 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -355,7 +355,7 @@ static int cdma_timeout_init(struct host1x_cdma *cdma)
 static void cdma_timeout_destroy(struct host1x_cdma *cdma)
 {
 	if (cdma->timeout.initialized)
-		cancel_delayed_work(&cdma->timeout.wq);
+		cancel_delayed_work_sync(&cdma->timeout.wq);
 
 	cdma->timeout.initialized = false;
 }
-- 
2.53.0



