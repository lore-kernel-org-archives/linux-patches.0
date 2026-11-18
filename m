Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045069;
	b=KZ/sy8AojDWG2o5DxRSneK6reyNe7cCYpemMDeTj0vUjJwePO/wz6CPeHRSZw97V7Gvy
	 tXxeaHsZ2WmWY5D1CUplukAnMkIYmMksEXfBx4oYJsXuN2ShokYz6H/DHXU5GPm0/lXiu
	 JTTbBiDZTLsZ4fDbos4YKW1Nt4sMj3Q8Ks0EkUwAHoXLpXPaLCSU1xzFpyyony0Iefnn+
	 w7cBlS2Zcs9epAJ9DkR+Mb/wtwCgWeOdV37VzaNQiu9rA77EHga585PZ9RmpIIbQ3YwDt
	 pQamnl4blxtPF3Fsu/q9qUjeEY+A+LBYjqBO5ohs1EHAts4A8dO9Hx8wWZNSrtxe/Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0b0emIR40Sn4X+myvFJBEv+rp5zgSD3f6n5NXnjuUyA=;
	b=HjF88Ahc68HHN1hw+Nd7wbXCEFAHTda/QjZuZkA5eXLRMklkEN3RRRMKRIP04UhQiuqm
	 JMylGMxAvJPz9PPLRMZWEQnrHyk8vQD3fM9FFY4P7uwRGGRPZN7MJSWEGwharHd3O+phK
	 QeJ96Jdez70+R2WBAKPGANd80B879GHg/wAuXbr//CSg1wwYrgYQ2tGAL36tGMlWaPL9s
	 06ZYl7Ysb6okuq2GBmrIDuG8IktA7YmV0GD6iw6LxAnYDyXpgIuwW53sA+B3QZxcma2UK
	 j2fjeac7OvrXQmmhii405r/nixWKi+UEEz/0ESNZvquIFqNLXbS7d0SVjv5aqXZ1N6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ev+5qg1m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0502606A325;
	Wed, 18 Nov 2026 23:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ev+5qg1m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5511F000C4;
	Wed, 18 Nov 2026 23:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045068;
	bh=0b0emIR40Sn4X+myvFJBEv+rp5zgSD3f6n5NXnjuUyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ev+5qg1mx2lTk1Jzk9aWMUAnwZJMCgK3PpgOrt1Dfk1PcIZlLkRMgXqmprKKLANiE
	 7/jvTPWsZgCTPoyXlX41JpJ5g6gsi+wHF1sKW7sbDV3LhFPlHpzhKO2lvN5ogwLkSl
	 vd3uzKxpjiMBILluekZCVqcRCwAVSm5/tQSw8TV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0793/2857] media: meson-ir-tx: Prevent divide by zero in meson_irtx_prepare_pulse()
Date: Wed, 18 Nov 2026 15:30:27 +0100
Message-ID: <20261118150230.120831523@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 05d9c515cf13056875abbf73adb4a19dd7ba32eb ]

If an excesively high carrier is set, meson_irtx_prepare_pulse() will
cause a divide by zero if tb_us is 0. Prevent such a carrier from being
set.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index ff89956562f7d..278604024ef51 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -219,6 +219,9 @@ static int meson_irtx_set_carrier(struct rc_dev *rc, u32 carrier)
 	if (carrier == 0)
 		return -EINVAL;
 
+	if (!DIV_ROUND_CLOSEST(USEC_PER_SEC, carrier))
+		return -EINVAL;
+
 	ir->carrier = carrier;
 	meson_irtx_set_mod(ir);
 
-- 
2.53.0



