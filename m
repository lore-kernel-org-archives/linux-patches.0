Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051216;
	b=Zr8ZS3V+0sqyUUwIBOSvb4yh2wvCTyL3fiyEb5hJ3P4sQavyZQ58LXNsdeuWsoyLnHs0
	 /sF5vE98uWzc0CMEpENkSyQnftCwzpEzMccumcp40Nsy4PhG0j7ykkdY5FANVt78Ntx58
	 hCflQmOE3ia/2Nzewz6wDQw3XI3/DRHmvA7L1f/oCPUo+9DqqY7r/ekbcygMCx1lH+cl6
	 TmOGsG/7LHpX1sQtCiuZD7UOdr0uq+4lL6EazeHnl2dCisuEo9YsTgdUSYw9FYExH+xc/
	 qz59rntLXukW5lb7FLOBpqNDFpAMI6sumxpPC2GQCrdRn5+ytc9YAKLtAwoOe4o+u+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NFbh3FwhR4/xyI7EyK7jbgZbbSYmp6l0/8RJzLDwdag=;
	b=OpcBVuonGNxOOtjYSpWtuYNbflUJE/Go9fwH5DuZUlJAFAI4UOizjJgSOm24ot3qGmTD
	 mo4yBQB4yY0+tb5G4YXKSHNBHJLCr3FP2R/La1kwQkqpdgPkDtK1Kub8v/8BToSGkNKy7
	 X/focyxFPJ2j66Tef3VUK3DnxSTuoeERN8/7HtkUqKJREznCQS+0yzi+bxzcJnpRxavb/
	 2pY26TOKJSPkzUqpjQ8iqLz4a+3Czpo6dWCxvEgYu0gX0DF8yrM/TSeJ4auRRVxd36RbV
	 4eS4nP8gmWIJzv0z5zAZl6Lnu3Yjbgss6w/lefI6r/0EEMqwQpxmFI210PO9rLiJXhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZJnRSYu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238CA606A320;
	Thu, 19 Nov 2026 01:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dZJnRSYu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A29A1F000C4;
	Thu, 19 Nov 2026 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051216;
	bh=NFbh3FwhR4/xyI7EyK7jbgZbbSYmp6l0/8RJzLDwdag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZJnRSYuqtzwNKWeYvBKWIOrZoyOU6hFQEe9J4LCIpE7UAy+r1q/tl04YcI2rH4+p
	 0Y6Wqs00vZFV6AxeRm1yCy7PDRKH2pFo26FT5ydiGkhAm2sRX2YNmQ2KAG7IZsOwGb
	 dxF8WMgRCvqUb1hmvNFx0ttY5dVwWkaBooYTyhio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0089/2214] media: cec/core: drop cec_post_state_event call
Date: Wed, 18 Nov 2026 15:29:25 +0100
Message-ID: <20261118150013.539790683@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 2ff4b91e82bd76e1a6e1ff22bfc9aeda08e12a61 ]

No need to call cec_post_state_event() if the next call
is to cec_adap_unconfigure() since that will also call
cec_post_state_event().

This fixes the case when, when the physical address is
invalidated, you get two CEC_EVENT_STATE_CHANGE events:
one with a non-zero log_addr_mask and one with a zero
log_addr_mask.

You just want to see the event with phys_addr set to
f.f.f.f and log_addr_mask set to 0.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 19367fdf3d431..365714c343572 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1636,7 +1636,6 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		cec_phys_addr_exp(phys_addr));
 	if (becomes_invalid || !is_invalid) {
 		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
-		cec_post_state_event(adap);
 		cec_adap_unconfigure(adap);
 		if (becomes_invalid) {
 			cec_adap_enable(adap);
-- 
2.53.0



