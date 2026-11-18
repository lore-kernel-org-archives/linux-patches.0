Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043130;
	b=hdhNlf4DVBOyCubTma9bI1uiyZb4QnW2UXQOMNhK8IuYzb6A6K6f0RB6t7pN+FmiwNIU
	 tJcuFcEgP2X9vabZfxc6L/Qbxnkl7HPgwizsSQ5u+375N19b2d/ZWWBPt8vOh0NMRoCB+
	 R34K/qUEvaJR54NCtFOlBvhQDtsSTA0G+PSzTq5voEFUhWnE7F1b1a5un248sc2HXdrcj
	 ij9rM7z5fiLODOs4O2eo8IYJUGgq8YDMD1sQ1q10YXcV9+TuhZKMJKMarcforUkdw71Pr
	 +Mj9f6J1iWcx/F6hxosJ3IGYrQ8swQbBQk2Rk5DVhaAdfrPbwv1mgdRT0jQxyGwNnEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/grV9ShKIAPoKNeRkM/8E9uim9Li5EsC/gROFkTSdY8=;
	b=tmVvC/QH3osF5uqX+sNxXTCwuw7ZJ9rZxJWnS5bgilKmnC3DxGl+Vo1x09udNPGS1vb2
	 DTDRJJYeAzrvOW2unhRlkZABaZW0TAU8ZfJse3hhPePNboUKVHKF0T4wqsClNt88dLgtT
	 Cc3fZ2urmr/us5viHx/yIE60lvZbASacUOss8XDC2V3R2+NcESh0D/P4A4md01ScB/P1c
	 R+xh7tmsRFEPC5ZQfCTSuog7GFkAiZkiUn4rGoc19PYk62kOzkTHSkUG0ogiV9ka+EffA
	 RkQCdw9qlOin8FKqDMuMUiPDDvckAe1uDYRmloiC84Xc3wQaNoKe1Vrry58AHrjxDZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMHO5uES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB31606A320;
	Wed, 18 Nov 2026 23:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMHO5uES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06EB1F000C4;
	Wed, 18 Nov 2026 23:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043130;
	bh=/grV9ShKIAPoKNeRkM/8E9uim9Li5EsC/gROFkTSdY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMHO5uESz5DqBsp8BmckpmDRZi+A0iTFNQ+e1GCKokON6SyyM22MzrwHSEBENULQV
	 N4uWkFEYF+JrYWftDGy7zyN0wfg2CzW/kpv60VVkHKJ8ZwdGvpMrt1183qgoCAzGC2
	 KuDmH6hyhkIBjAaEHq1FSmnfJYp0TRa1GdrBqTQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0099/2857] media: cec/core: drop cec_post_state_event call
Date: Wed, 18 Nov 2026 15:18:53 +0100
Message-ID: <20261118150204.824556692@linuxfoundation.org>
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
index f9483268c84a1..dbaa2b8e5f2c6 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1655,7 +1655,6 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		cec_phys_addr_exp(phys_addr));
 	if (becomes_invalid || !is_invalid) {
 		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
-		cec_post_state_event(adap);
 		cec_adap_unconfigure(adap);
 		if (becomes_invalid) {
 			cec_adap_enable(adap);
-- 
2.53.0



