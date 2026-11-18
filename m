Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057284;
	b=siFjlFSOgBVHxxuZQ7Ug15Z75qQZMh1XAxJREY2jxEi5kyIlKwEG/ruhC3tpipc4y6C3
	 O5ZIZEzYY6kU5yH6iIWUnHpk1DxQTH2te4w82/WVCsg9rU4uFKiYDIQXzUBd5bu/0+p8/
	 kgqtepCXMehA7FisCqQNWll7O0ktdPbkmCMfN98uYPd+NK3uzN1xhtvrCBaOTMDj5O4A3
	 hCWjJnBQoK3Z7S2pIRdTGGJODAa6+Jshb6CBLGeM8Bg4jV/GatJJyoTAiZTL/Sy9jtBuU
	 fKzU7VcDav1DB++h/Ktv95k9Ic6+2TDibabgjtHPbq3xwf7UK/4kZtDMUXXdVUjtSbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rqSEBGZnIGEZl5VALhmmx/v0Tl238TR05wzv8U9VjKc=;
	b=VS9y7v/2cA2iHXIRP1GgDIMuFEAk4EFkGRqSUGtPcvgDOCMs/+IdD0JwMnpp5rKp/jJt
	 rWCnvtxnRzYmbyoWDlsrXXjxb7M12WH0ZMHQVy/xSBjXm37w25OVeGOh8liGW+ppUjpy9
	 RCooU/FY2k05SSaevRAfS8pPsAppcmEAT41Fm4aV2OsdMa8KrO8SeUmR2GYF5tnPV+dvr
	 95Yu/RBFy2lT72QSXkMzNVPgpEA3kdsbvn8t+mpI4Xr14NZZccN6sh9BUUEcsiD0LXxCy
	 QByvjtuHEKaMzpDoGYWzENYUMtM+WDHoNYJjlh5w2l/yKCzMWWJruoJZAwhwrS0gY1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJZYkqpD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932FF60A383A;
	Thu, 19 Nov 2026 03:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJZYkqpD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63ED1F000C9;
	Thu, 19 Nov 2026 03:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057284;
	bh=rqSEBGZnIGEZl5VALhmmx/v0Tl238TR05wzv8U9VjKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJZYkqpD+3d0lWHYX9RNVcwuKxRiz+epTSBtJNRwFwa8Op3alCNTL4IaduKg2sZGD
	 d7uu9krs+KUddn99GYKNmJdi0MTzm8n1VCa3V4cAg1KCR3Ma9MflruUS2xL2TCvrnW
	 FaOhDOhNybQZcCmaOWQbcz7t8NzxYGVrGyBiz/U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0076/1848] media: cec/core: drop cec_post_state_event call
Date: Wed, 18 Nov 2026 15:35:14 +0100
Message-ID: <20261118145914.325561779@linuxfoundation.org>
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
index 4baf377e22a03..a47513e99d4e2 100644
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



