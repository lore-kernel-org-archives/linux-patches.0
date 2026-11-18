Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035995;
	b=BpUdpp0vdzkr0X16TcnN3RLLUEpkQSUz9Rdegh3om3TiTiDMi1Ov05rTN3J4SYWs6wf9
	 0edrx+vB6c5l6/xGnTGwEebszAaTFDVp9nZtMNFEPSVtFA7k7wz3bwC8ZdNxLR/LQe5kr
	 wgQaUFZGVhIoU7f8uBMxRuQi0BKhEbGxTlr51OFSABxJjDDHUSTg9OVomv9Loa+brYwBK
	 VHV60Zo+xr6Aoq10bFa8ONvoFv+zAQefQdUJTyPEox/hYy1fpsKX/AbFPrFke32ZOmApT
	 6vFe+zPF+PnaDirLEehW03oiAG0gl71CzWs+xRM+DXBMwVt4f9oA9mTWhuVaGjozFMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iX+XP0+qRTirewX64+3s/NdnxmgedRmOA0ACFXgib6k=;
	b=FzGtbs9akq1MOiXXh03PykiUWHpYiD39Vc7d1DS5qj0CXBM8etdvXNy5uglXgAx5amsD
	 ++Z7oLO32pUAF8mVwZ/3V3DDFGALHRgzpSM+efmjO7lqqgavgGKoiSs05hWHK+meTxZ2L
	 W3QX27Jo4C06Z3YPejGqE4/Gyp1mAylw6DKbnevIMM32Y8D61kL/NEITOM9HozOyj1KBr
	 rN4BJ/+tRDX4u+qDZQu+aNGzk+Tm/Wh5k5Qg5d1us+4vnypxlQBm7swGLTfrCzs+sOIM5
	 Nn1OlD5v6wq8SyVqX9owAAolRsFrEo76wpnNORirpXdqBqI/Y4q0OTZo8WHjq+U912g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Mjby70p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662E0606A32F;
	Wed, 18 Nov 2026 21:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Mjby70p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EAA1F000C4;
	Wed, 18 Nov 2026 21:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035995;
	bh=iX+XP0+qRTirewX64+3s/NdnxmgedRmOA0ACFXgib6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Mjby70pK56PVnOq18PDqkBhpZsLqcwIl3utQeP6f8TOnG2gbJGEmKe7e+RhCa1i8
	 FjISVr3uu4aMu7DS906qoa8U8ApSLunNncKy0JxRhXwhUE2DD/aL4zBhnxLCBmIxJ5
	 8S6xY8e0nIaMmWCg5yEdMcfOqeAmOafnDS4R+8GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0901/3318] media: meson-ir-tx: Prevent divide by zero in meson_irtx_prepare_pulse()
Date: Wed, 18 Nov 2026 15:25:23 +0100
Message-ID: <20261118150346.514670523@linuxfoundation.org>
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
index e15c6835aaa47..437d2f119262b 100644
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



