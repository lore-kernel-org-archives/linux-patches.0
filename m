Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052300;
	b=jZ5NVgl/UlJmuvAF0Ogw6GXMYSAfhDpQVgeF7oDW1HYX4pz3baMjBrv5gjwIWH73utRo
	 IKx7rJXvBI/1E0r4ym96A8hTiolDtlNI1TOK0lKHpxF+qaFrA6BfKTvj/B7Ys1jjdwmY0
	 cWYFJChKiYCQn/ntLDzS71YOYyaR9iwOoiJduzrxqMXz7gwhNNAOP/A29ksRZcwCmgDGx
	 Y5fffkEpdfpHoQJAP96sAz4a7zi2uHSZBvfXGPtA8z8FeXIdr+raJo11W5ncNvfUoXp6d
	 qANG7401cDnFn3gSrQZG2ugjZJYQJC5ONhF0L2GhkDxFIw6vpK8M/tOfuHMsLOhQHkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGaGiB7I3Ey3vaH/P/6N9vffN8PkGIkz7ymakX1cBeI=;
	b=e9WQa2sNE+O04oorUmgaGHWoMz0TPIZbPe69RZP9mJ4tUEOlVbV37+EyhI6DR9VYkncQ
	 z5shClISbn4bPjHOcnG+bz3ho/gXxgf9+fWoY1hnnTFUtYfGrnenhcQkCQkTxWcq/FrCg
	 WHxxr/zAa6KyITF4fwC+rQREe1tLcLpX5RKbCGylOdeWhbX8KKQG25TQV8I1E0kdR1HBj
	 V/aXWbJLv8BipaAw8/S/s76CzLlIRBvYvDfugxKWmXSQy/eKJ8zpJGfzGqvorcFwSItpI
	 +u+prYu8pNTkce7OXnrFvm3U9La23T3zm+gvk0tLMvX1E7wtfylJXOYb9o1rqcYnFJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o/6S4e4e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F0B606A320;
	Thu, 19 Nov 2026 01:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o/6S4e4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0C31F000C4;
	Thu, 19 Nov 2026 01:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052300;
	bh=CGaGiB7I3Ey3vaH/P/6N9vffN8PkGIkz7ymakX1cBeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/6S4e4eloXbXmpjqhlVSdTWji+HCr+ia7mvLPWZ7ieVETiKn9ZA05ADzket1zBfX
	 FhhjlFiWgeDGIiudxnEMcVHx6XYvYm7JpxxFghXhqTKqNnEg0WSuRpzuiZXyixEGbe
	 NgCEoP0taa05Q/jHhYctq1SIquoJF6tzhHLqnrjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0512/2214] media: meson-ir-tx: Prevent divide by zero in meson_irtx_prepare_pulse()
Date: Wed, 18 Nov 2026 15:36:28 +0100
Message-ID: <20261118150031.597270353@linuxfoundation.org>
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
index b8a270854e9fb..498692ef2e803 100644
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



