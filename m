Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048367;
	b=LcIqOPhifRxC6mFU3XOWBtloKi+zz4pTjGjF/QLzyByqdgRNNnEProF1aWPD9X+5md7T
	 e+Fj8s/AoikQ9aIxR0Q8+j1UKJ6UrBQF69Z9Yr2d7Jt5Iu/lub3swOe6yGSAaj4rEXa3m
	 5BgW9oHhEpkTg2gU3/Tq84o1k6WFXu2MWLLHS+0OhBF47AkpXbrmFMquZfDmyzlXRQuYp
	 xV5KCQyzMyyxbu/5Rs8fBwhIB8v2c0CcJoMR9i1eaMbKkLT1EIdtyhrgwN5zQepeOsDqn
	 4+AyVRj/gjfJGAac+XLCIyk7jr6xzo8yOCpaxNTHhroldO42koQbn4ZCwC3VFv2Bhlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NGqqdcMHf9KDBzQ/VoqpYl5lzhcR1xSOhc3T7euuiAM=;
	b=QrS+qz5vxkdoJAiKmD7ftxj2zVVQmvbLB4gmeOx2gPm5Um3nq6ntB/1Y+eduqlp38Pux
	 KzfIYnlzcQzhKlg2x3vrjQfQECljU7iDe/ShI251SJo4EIkzdmK8g1YdKBlTZuHNcyiW7
	 jLTQ7+z08V6DuqtQ7ZTvqMc2VyLoCbI2M1WtTBm09NhI4LUYj/QMdsElH5w6+Y9zjluli
	 JQ3krkGqDjZqMTRAMKaww5yGXEe/HAJZUbFXovMIiThCxLLWNmy/adqkuP44b4WwWJnL9
	 /FPYGrqnglnJ2WIWEd/NjIBojy2qnAjZuYaqp7Lj44XHamt2sxgCA6gVE1A0RxuewPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPctnIYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E8D606A320;
	Thu, 19 Nov 2026 00:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPctnIYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5671F000C4;
	Thu, 19 Nov 2026 00:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048367;
	bh=NGqqdcMHf9KDBzQ/VoqpYl5lzhcR1xSOhc3T7euuiAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPctnIYsaqYZwbaCcWki6Uf6yvaw3ZWWT95T3dPPIL6PvX1ElFUbPSdjZx8rJV26B
	 4a15DHr+V8xUC2ulY8U2yCYj5tnocmOQ7IbRL71PirnzcCmHZuByKreHZRI+vfC08m
	 nRWO8Zvhcy3Z0W850pWAyzoy3i3bYyzTWa8xI0ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1969/2857] interconnect: exynos: Remove the PM QoS request on unbind
Date: Wed, 18 Nov 2026 15:50:03 +0100
Message-ID: <20261118150312.297152701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 601a54f00723b0b653d76caf26a2a78482d95f00 ]

The Exynos interconnect provider adds a minimum-frequency PM QoS request
to its parent devfreq device. The request is embedded in the provider's
device-managed private data.

The probe error path removes the request, but the remove callback does
not. Unbinding the provider while the parent device remains registered
therefore frees the private data with the request still on the parent's
QoS list. The child's device cleanup does not remove requests registered
against its parent.

Remove the request after deregistering the provider, before the private
data is released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260911031750.8182-1-mhun512@gmail.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/samsung/exynos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index ebf09bbf725bd..25d6317af3d05 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,6 +98,7 @@ static int exynos_generic_icc_remove(struct platform_device *pdev)
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
 
 	icc_provider_deregister(&priv->provider);
+	dev_pm_qos_remove_request(&priv->qos_req);
 	icc_nodes_remove(&priv->provider);
 
 	return 0;
-- 
2.53.0



