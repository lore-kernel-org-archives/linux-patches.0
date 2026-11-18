Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029900;
	b=g54U9QnwGx9o7BEOK9qhOUCNJ+65TLZC1Pm3ysifC7FwivQ+uiV1dQTtNBfV2ccSmvQj
	 J0HaWlq+q3cu68gEA5g4PeS5FJx34T2XWJz9C0uFD0g5m7o0xdjgswv8zwUot3ndIYbaC
	 lLP1TeyAZNFITsTc+s9cSgPDJMxWE1jiV8O/z+xMgwtV+pZUDbn8Uwu8h3kPH2CX8g4sY
	 iX9oSefxEwtKphRkJLXw/l8aTBUx/i0k4HNdoiG2SILnvp8U4aof9yzFhZ1GFL9lAyqe/
	 mbW2NEosm5DtkxZ/pvPzawA+DgW9IqfWgolhPrrbWX8P7EcQd0DqcnSvGf04Jvb9OBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LW4FkyO68aKFRb9cXJRR8xGPkldBZyhttZ3lTiVl7LQ=;
	b=K+cC3+bOVGo1ateKSo1rUwwIs16fJfflJa/UzHlKIR/IwVvbLsPyF2V3GPH0Ill+j1sR
	 wAg3oqZfVhlwgQPVmyGutbCs9a29SwYFSHU9iaqlxXm8PxBKWohDdA8k2thtJLNSRQxH7
	 +x18CUjYkX4Z1+PZFcIB9Se8i0C4XPLVScJ42KyVJHRs7yFGaaBD8sgsfVG2KWbXSz4wS
	 YYeSeBTqaIN+p7HA4iQu8nyzf8WpydNvHrEmoadmmYI+zDRz/8aeYROdNvwxiAN8UtJ1O
	 VnxNapXKpFn3WeunBDWe4iCat+LviInsjennluB/rI078L6r/b/fFspGs5YkVOMr0fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M53ow9GK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3FA606A332;
	Wed, 18 Nov 2026 19:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M53ow9GK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5F01F000C4;
	Wed, 18 Nov 2026 19:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029900;
	bh=LW4FkyO68aKFRb9cXJRR8xGPkldBZyhttZ3lTiVl7LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M53ow9GKHIjCMkcIFAphCSVavWMX//JzwpIyk8u8di5DEzXZaOh5+oDprLUGAGZpj
	 owl8P1jGimp+gnYPSQduSt9xIzxYihH6bX9OCw+Lb+rLN3np4v9R/RjD3q2/FXPusl
	 bsZqmF7Na254SzTYXwMgL3S0jSO8nqqOVyz/ILf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0472/1756] clk: starfive: jh7110: reject oscillator lookup errors
Date: Wed, 18 Nov 2026 15:43:19 +0100
Message-ID: <20261118150027.668231726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit 54d0b6903921d121fa750546f2b38cc3f5c7e64f ]

Clock lookup may fail while allocating a consumer reference. Return
a notifier error rather than passing ERR_PTR as the new clock parent.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 538d5477b252 ("clk: starfive: jh7110-sys: Add notifier for PLL0 clock")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7110-sys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/starfive/clk-starfive-jh7110-sys.c b/drivers/clk/starfive/clk-starfive-jh7110-sys.c
index 17325f17696f6..f8bff03db80d3 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-sys.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-sys.c
@@ -401,6 +401,9 @@ static int jh7110_pll0_clk_notifier_cb(struct notifier_block *nb,
 	if (action == PRE_RATE_CHANGE) {
 		struct clk *osc = clk_get(priv->dev, "osc");
 
+		if (IS_ERR(osc))
+			return notifier_from_errno(PTR_ERR(osc));
+
 		priv->original_clk = clk_get_parent(cpu_root);
 		ret = clk_set_parent(cpu_root, osc);
 		clk_put(osc);
-- 
2.53.0



