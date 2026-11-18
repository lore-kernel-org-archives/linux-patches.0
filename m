Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058560;
	b=0TG9QZALf+gnYAe+s9L4uPE3F1ID+WmaSVAS/V6JRLPbSxzd0aqq8VmT59WwMgTerOBC
	 wFrHyCorqn+H2iQN8Sr6fraZPMJhMlSojIsJ7BahzryKjCcRAl0XdstGKpGdAZTLqtSGs
	 Dd4GPNG8kBZ9siLhwwjB29eUPlT9oqlgg8ljOpAs9zp35lCVGPqjRWl3MfDMyh5yCAncC
	 xKKYWr1QHc7EtlVfZb3A/60zCF0Y8WDT5Rm2PRl2FDTJwsJuScXbEM9nFrYzIb1IW/B7f
	 Eyr6pDZlivUSt2uX/8juKoWOpI6V7BImMtzIRrS/DDsnMShY1lJQUWkXbm0/fVqu5hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O7IqFOHStSnOP9dlAKZtgIkNHgzGQmKfN3i7+thZIKg=;
	b=RH0FYKe16wkFJnAeUORQYTrqsEmngNBcls9KV13avGpenDLQshDRo4SH7A4UC0hTKsJ7
	 PWmG71Pk6MKzuEl7prLwxDXrODMlpcaaJq0i3nCqxHpujk5Mo9uLvEGV6ycNbjLTV4xOb
	 ZUZegaH84vwqKC+YVwu+VHU89f2aZCqNDqvjVLZn9kBeT5LeFTXaNLwdFkXRpmVSM7GvC
	 SfPDx8EBOV9VHCz7D+3okiNCT7ctM1mMo30ILhafah+xZPEYzTfCLbafSu1K51xns4PPB
	 cYfm444UYHi7YcboqoxHpOZUylQfDn3VR+Xg44TScKeTI42l3QSdmBth/kta+rq1Nlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPcgKJgH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DB1606A320;
	Thu, 19 Nov 2026 03:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPcgKJgH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D0F1F000C5;
	Thu, 19 Nov 2026 03:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058559;
	bh=O7IqFOHStSnOP9dlAKZtgIkNHgzGQmKfN3i7+thZIKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPcgKJgHPXkA4/OLU3jAYrKu2k2ZR8da395PbJ0S/yGu7EmbrXW5JDsspWxKgLGSa
	 MdCNkeIlY4WB5eiAupWNJCv1jiZPsqz5Kxp0Ee76nRtV3JCp3lycw5IcEU58qMOSlG
	 TuCfsCneFa/9L5wxiRiTGl0vCNe2qS5T25KYJO9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0527/1848] mfd: tps65217: Check return value when masking interrupt sources
Date: Wed, 18 Nov 2026 15:42:45 +0100
Message-ID: <20261118145936.937780983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit 66ed12c1e5a986bee1dc63f9bd9c7f068138a69a ]

tps65217_irq_init() ignores the error returned by
tps65217_set_bits() when masking all interrupt sources. A failed
register write leaves the driver's software mask out of sync with the
hardware and may result in spurious interrupts.

Check the return value and propagate the error to the caller.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Link: https://patch.msgid.link/20261002113624.178588-3-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 40265478639ae..ca81623a74389 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -164,8 +164,12 @@ static int tps65217_irq_init(struct tps65217 *tps, int irq)
 
 	/* Mask all interrupt sources */
 	tps->irq_mask = TPS65217_INT_MASK;
-	tps65217_set_bits(tps, TPS65217_REG_INT, TPS65217_INT_MASK,
-			  TPS65217_INT_MASK, TPS65217_PROTECT_NONE);
+	ret = tps65217_set_bits(tps, TPS65217_REG_INT, TPS65217_INT_MASK,
+				TPS65217_INT_MASK, TPS65217_PROTECT_NONE);
+	if (ret) {
+		dev_err(tps->dev, "Failed to mask interrupt sources: %d\n", ret);
+		return ret;
+	}
 
 	tps->irq_domain = irq_domain_add_linear(tps->dev->of_node,
 		TPS65217_NUM_IRQ, &tps65217_irq_domain_ops, tps);
-- 
2.53.0



