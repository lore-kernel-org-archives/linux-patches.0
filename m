Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033803;
	b=QoILQ6DFCCvnXh13SnweLKKWmH1ZpD9gTgmaD0+FZ24M9yVnx61nR2iQOVauq4lLChFd
	 cFkYgKOOF4EmP6ApatH1XGvlPo+YXDnApTg5DSdcEBB4zEX4pRC3n5axri6V6ovFBugnv
	 xHZds3ashE730coszJYS8E55slDLmxBGhoj7uxDKhMyHoEAoK4PNiu67nYAFOl4B/qGEC
	 0tquqf0K3vp8WwmMdKCfyrGizat/JJRAETKyyp19uOPdyHUEfMGUQkN/9VgBRHlkl6zHf
	 Jt9sldNBtiyPvXN1KmmvgKNGX+GHYU3XRlCtzAGEWl32/abc8Sx0xyRzOiGgpBvAGrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PQMr2oYpCuIzBA7fD/VFpNz0IIVzefrmOss6sGPceqQ=;
	b=JJ71HO2z4TJM+0TRlH0zzDrto/iwQ8pWSGT97OWEiqKHUxsIEnK3+/WyKKk9C7EbRT3k
	 E4W6UaNftQztCAJAyjfFjVlPT2fsB9dWFidVAzILBCDUDqra/+T4wKYX+08skTjIg9jo/
	 pi2jo8gn0mx78yNABqc0Kzb90XyH4JOQaWA9f937FmzYT2e79OruZExCVpeMPTXDfoxqY
	 qoND4ZLllKLCYIYc1D9QqnO3lEilh0gsHuM4+7uEYIp6w5a31y9PdcbaC75x0kQFKiyWW
	 HG1NdXEVbmDCGo40YeJUiD+BVxxsmBZslAon3disgLndwb9N5XNm+2+VtVNa2W2QcTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVdyg5BR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB31606A320;
	Wed, 18 Nov 2026 20:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVdyg5BR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D93D1F000C4;
	Wed, 18 Nov 2026 20:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033803;
	bh=PQMr2oYpCuIzBA7fD/VFpNz0IIVzefrmOss6sGPceqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVdyg5BRsLGXEO9Eek6qP/JcOnYcZtFFVTCozWkvQLdhlZz49C7drdj1+vmlSnQIb
	 OIi4cIqrBVuaXddRl/ObDFAiLyB2KZ3+cRjJib4SR62MoXoJG9LWO4FudzQXDQQYbi
	 cI2PCvrMq6SZXFeT1/SWZxqBK+iGLWugxxUF/IUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0117/3318] media: cec/core: drop cec_post_state_event call
Date: Wed, 18 Nov 2026 15:12:19 +0100
Message-ID: <20261118150317.819840608@linuxfoundation.org>
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
index c7be3c812b8d4..6bd1dbf0e24af 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1658,7 +1658,6 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		cec_phys_addr_exp(phys_addr));
 	if (becomes_invalid || !is_invalid) {
 		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
-		cec_post_state_event(adap);
 		cec_adap_unconfigure(adap);
 		if (becomes_invalid) {
 			cec_adap_enable(adap);
-- 
2.53.0



