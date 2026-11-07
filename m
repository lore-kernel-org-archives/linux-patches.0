Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064058;
	b=yr0mcg0wCbw75vOxZ6yij228oQxhrBga7UPn4l/p2fJNyVF31fbO29MymyozJ2CxBXhX
	 mgpw8Fl6jCA5TMUn/hulwu8swtKWCXHAuFJMQN/062FLRXCm1VUI8z4nOtEkfYZydvAh5
	 O0uoR6YgAjxuxjIaaZaI4yLvcB7Iy7kJu6nMOxtAL3EE24DJSqpsS2ODy+pkKOJ+c3hUK
	 LJ26ajm5m1xWkAUvAnnDrPiY9u3qYGyr5wrttpPGF9GCNP/vLqlPxR5Lu0N4dCDTnzLyO
	 /e0+oqeE7llcv7NULY3+Z1IkmbawR2n95gCGzIWkEg6hvjtzc3Tis0VXYqB2HSFbAnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y2wz6MVmY7EwDAkcOOLGW1Ntb0k+tU0c2jIvnfQ20rM=;
	b=SsxzNldLHAvG6+4lVNzQj+ma+WN7k8/wpydyQzZxrq5Vw4LlEs0ewKuEcuwdBN9A9LPi
	 o9XoVqxEjvumoEayb7/bXZ89wEfJEA+185QuYZndY0TE1BkgZUsQRMDRohoo6hOYAwqzY
	 I9Y04d/CtaoIfCCd3tY02nKrG/HRHI6BfTGIsY9xVKr978T0wM7SdnMqSn/l7iPFn90E3
	 Fm9bgHzC97UnUqmGOMfaHPughj+6vqPNJtNPw3p6w8/cqMaHn17B4eOvgqoruGWpGUa+U
	 xMvkS0BRlIk0jfxR2VDQMP9w1IHQ55lUGaB+geUYB0cogVQu9oLiZyu/6Vac6oreMlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5UOYzJk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8EA606A9D4;
	Sat,  7 Nov 2026 15:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5UOYzJk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6D21F008A1;
	Sat,  7 Nov 2026 15:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064057;
	bh=y2wz6MVmY7EwDAkcOOLGW1Ntb0k+tU0c2jIvnfQ20rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5UOYzJkkqr0ZlHpTKwSRuzLoPcnAG1Xsv5OYcjLHB+FH73l8tMsrqrWj7xKFGRbi
	 Pies8SUEVEEUXoQYyEI0ha7mmopnpa5tpOdiNZIMtWRKfk4fbl00/vpWHva92dg7lt
	 KO7A4lnybS5sza+4K+XPpnP+liBkWtH+rpeLUWiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0228/1257] media: ir_toy: Validate the maximum tx carrier
Date: Sat,  7 Nov 2026 08:42:04 -0500
Message-ID: <20261107134945.823748524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 27303392aa87b61692faadec8b00e0ca66bf98dd ]

Reject any carrier the hardware cannot generate. This also fixes
a divide by zero if a carrier of U32_MAX/16 is set.

Fixes: 8bff1386d62d ("media: ir_toy: allow tx carrier to be set")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index ee645882dd5a6..0819cd5cfa98b 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -373,7 +373,7 @@ static int irtoy_tx_carrier(struct rc_dev *rc, uint32_t carrier)
 	u8 buf[3];
 	int err;
 
-	if (carrier < 11800)
+	if (carrier < 11800 || carrier > 3000000)
 		return -EINVAL;
 
 	buf[0] = 0x06;
-- 
2.53.0



