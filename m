Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BB831D374;
	Sat, 25 Oct 2025 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409699; cv=none; b=DDUDm3plONMGPKybXDOY3ueJkTcCjYlBihVRLHJ8HKWabfLSVooNiy5BrAr/4660Xv1a7nCI5AFD8rdae3FCClIuHtoB+ZfHKRAZGpBWiJWJBiSdyX28sA2RQl09fAMqACYb3ZM3HaFr5VbwFn87AyokkpGad8vUK1CdiBb2Jzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409699; c=relaxed/simple;
	bh=qMWLDHS2xACDEWl+ZGTXI/I25ilu1OHVgMQ7gxdd47s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEtl5uD6PuF7smH0iflqQr4xUmt7T/clXcpCXqCX68skZPtJfuEcH2FzrrVSUPEmY1lINH7sHoLhv+/mV4mQt1WY0TZEAZGSBcV8dO2KFXntbWuwtCwCpFODEX4BRiiRnA1yrK8JAVoOos8rW+WyHFH8ZwT2u9RC/uVwbYl0ppY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rICQLr+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rICQLr+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B2C4CEF5;
	Sat, 25 Oct 2025 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409699;
	bh=qMWLDHS2xACDEWl+ZGTXI/I25ilu1OHVgMQ7gxdd47s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rICQLr+PfsS5JRG9nKMmuUZUKuEXsUTIxM4Bupyq9fRVKhkEPPKiFpw1ohwmikwNz
	 AAucq4M5KiM78R4/E+KC6hYbQ3vl3xi0tpxqR5LqIPtkRXL8kE+0b/sLgeZE45Kk7K
	 IIvLeUtdOTCR5IkHd/yW7yrRBG4OWdyQAfdV0Y8yP3l/cQv3xPpd7XQuCNLHTVaxuM
	 EoR2H2H48jZypj68a+vy5PUXb5BtUfIwym96Gnjq6sw+kyUVfbhx17QomID8DLeL/X
	 levAJAGT3UvV60DBKXC3ebBnMXUKslaQsJL98xfApT/v1zGqbXmFhZAHP6fwKOCbda
	 SgAG3uRWwjjmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fan Gong <gongfan1@huawei.com>,
	Zhu Yikai <zhuyikai1@h-partners.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] hinic3: Fix missing napi->dev in netif_queue_set_napi
Date: Sat, 25 Oct 2025 12:00:56 -0400
Message-ID: <20251025160905.3857885-425-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fan Gong <gongfan1@huawei.com>

[ Upstream commit 4404f6af810829588a51968959c6b85574109c13 ]

As netif_queue_set_napi checks napi->dev, if it doesn't have it and
it will warn_on and return. So we should use netif_napi_add before
netif_queue_set_napi because netif_napi_add has "napi->dev = dev".

Co-developed-by: Zhu Yikai <zhuyikai1@h-partners.com>
Signed-off-by: Zhu Yikai <zhuyikai1@h-partners.com>
Signed-off-by: Fan Gong <gongfan1@huawei.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/a17a5a087350eaf2e081dcd879779ca2c69b0908.1757653621.git.zhuyikai1@h-partners.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – The patch fixes a real bug that every hinic3 user will hit, and it
does so with a minimal, obviously-correct change.

- `drivers/net/ethernet/huawei/hinic3/hinic3_irq.c:45-50` now calls
  `netif_napi_add()` before `netif_queue_set_napi()`. Before this change
  the calls were reversed, so the queue registration happened while
  `napi->dev` was still NULL.
- `net/core/dev.c:7159-7166` shows `netif_queue_set_napi()` emits
  `WARN_ON_ONCE(napi && !napi->dev)` and returns early. That warning
  fires on every queue bring-up in current kernels because
  `qp_add_napi()` tried to attach the queue first, and the association
  silently failed.
- Because the helper bails out, the driver leaves
  `rxq->napi`/`txq->napi` unset, meaning busy-polling, queue
  diagnostics, and any code using `netif_queue_get_napi()` lose the
  mapping, on top of the user-visible WARN splat. `netif_napi_add()` is
  precisely where `napi->dev` becomes valid (`net/core/dev.c:7440`), so
  executing it first is required.
- The fix is a one-line reordering with no side effects or dependencies,
  so the regression risk is negligible while the benefit is immediate.

Given the always-on warning and missing queue-to-NAPI wiring, this is a
good and safe candidate for stable backporting.

 drivers/net/ethernet/huawei/hinic3/hinic3_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c b/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
index 8b92eed25edfe..aba1a1d579c50 100644
--- a/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
+++ b/drivers/net/ethernet/huawei/hinic3/hinic3_irq.c
@@ -42,11 +42,11 @@ void qp_add_napi(struct hinic3_irq_cfg *irq_cfg)
 {
 	struct hinic3_nic_dev *nic_dev = netdev_priv(irq_cfg->netdev);
 
+	netif_napi_add(nic_dev->netdev, &irq_cfg->napi, hinic3_poll);
 	netif_queue_set_napi(irq_cfg->netdev, irq_cfg->irq_id,
 			     NETDEV_QUEUE_TYPE_RX, &irq_cfg->napi);
 	netif_queue_set_napi(irq_cfg->netdev, irq_cfg->irq_id,
 			     NETDEV_QUEUE_TYPE_TX, &irq_cfg->napi);
-	netif_napi_add(nic_dev->netdev, &irq_cfg->napi, hinic3_poll);
 	napi_enable(&irq_cfg->napi);
 }
 
-- 
2.51.0

