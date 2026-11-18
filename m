Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051196;
	b=dWfb9277/3MSbxTsw9np92pX72BSrzEg5huR3mXtsM15MvluyYbMyH7v7w9ej4eH/yNO
	 wIF1ggbCsHPrKbeU92RfUr61zTSM0I8nckQKISqZT5CAhwZq1JGIEq6BhiZ6akK5GO1Ui
	 2RvsycFISOzYSYC5oZEXa1Mhc91ONv4EyxZdu1oLj4qAdtk5F71z7c5YtKk2JcYUXQMvj
	 RKM2AkpmmZD/OxFQbsvPWtnymKkcx9/GRcGDj/gXr6fBu9hK636mecdCOmEgN0RFaONI4
	 Q1VkTqgSVrlG75SdY3la3e0Jq8cxJd0yfVMOHcBV6/zVlFiLiH6j/DHBna4C+XlQ8Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gK3nbZ5OisRRofI2yePtktERIYhlt3VF0yFNM/wdmok=;
	b=REB1Pf/ghAnMa8VjkaD7JZ/LC5tFIomOImES1+TqRxT+U9DY/rgnN6YXw84pPGXbcxn3
	 /MZL//PMYKit+ueOo/dYn+BAUhHdkojjWHZVTYbMVuKogAHr7JUP8O2uyB+PDF2AqglX3
	 RYpLCoLAc5Askt/JZnEvsSL6JUGzZOuo44bUzL2iyq/W+p9wK+3bqzrio9RqfXUxEKA71
	 XxMU6eKvX25lNkweywR8+J9CLLif+6G95zTDoYE6wyctOD1gDZlQd0AQI//ty0tH7ACbb
	 73xerlUmx3vv75l5OJW4lxRKSVZfXNNDoUZkvAt+Aofg2lh0UCwZMbFUB6zyGDc3pnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1Nksf3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0BD606A31C;
	Thu, 19 Nov 2026 01:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1Nksf3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C691F000C4;
	Thu, 19 Nov 2026 01:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051196;
	bh=gK3nbZ5OisRRofI2yePtktERIYhlt3VF0yFNM/wdmok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1Nksf3MLK4k6TPjS73txJwmqU6FjuA06CHCYEHoLNqvYu4oDB4K1ZR2z83FTuef7
	 n5gCSSx3VwdFh1bOaaSpfRQ0Eqp5fktOhOHy1prkXmHKhPIEqG85MD+zh9690KSWQP
	 Il9OVhMn8htARWHLJ2oUE8LsOqzGm3Vv5h2UfyxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0086/2214] gpu: host1x: Wait for timeout worker completion on channel free
Date: Wed, 18 Nov 2026 15:29:22 +0100
Message-ID: <20261118150013.431622414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e49cd5b8f7354..83be9959fc061 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -309,7 +309,7 @@ static int cdma_timeout_init(struct host1x_cdma *cdma)
 static void cdma_timeout_destroy(struct host1x_cdma *cdma)
 {
 	if (cdma->timeout.initialized)
-		cancel_delayed_work(&cdma->timeout.wq);
+		cancel_delayed_work_sync(&cdma->timeout.wq);
 
 	cdma->timeout.initialized = false;
 }
-- 
2.53.0



