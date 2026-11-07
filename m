Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062066;
	b=DSdrPRZF+k3uPLL2CglmfKHrL8QmdPmOIgAtCvbAxzS8bWCPBMHBBHBiQPBW6VCG7iEu
	 T+JbwbJItadeWV80hvW17IgFsKKLu4rWj32udceYOAo73fOULjCX8K5TzOsLpy2OVSMTk
	 t4R1rom5olanMLvHLCEFeDHvDwlUkvohzJ6nycptG7be96sPORbIYzQ4/sM4GMp7KLp2h
	 Xs4OJYH0W/UWC+0Sh1HXILgchqMayZRXFXDYPy/B2y9HdgveOC/aib5Uu+BNipU4sqYkf
	 oeuMKFGyTAHtpTZuaF2KA3orjF6Z+3nJlrt62+QkZpM2Auqyw+vDJ3HmbOWQmfUYk+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NXaGbSF2TcnLFfYlIpHtY2kxO61i9Qk00xFwS1abQVU=;
	b=ISUFmYgb49/HSvQ7S8FJBVPS6nif6RZgrja1wxnWeVRaGhbOtzRahD6ilTAveUaaUEDU
	 bi8yusY+geJU5XqLgPPBYIuAAwKBiRzDjMtVeswAgBYokcyArhQaQqFoo3lZ/ZTGkbsL/
	 y/DGl66hZcZx8fBibwaKfPEqzbjJclWhRJpFyBICnUcQRublKvJWwFBwqzHlayhU5qqq+
	 +NonBMDvUTZZqbo9qc4ojprakpA1j3J5jifG07yXDb+7Xy2VbZfj90wsJmOdlq5Z55J1a
	 E+wiQtCuvUsNUxD20Y9ARDDZ35g/uQ+rxD1lEh941i7yleUn8HeDdlv/xwzOEkGHChw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tp2fK+sA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DBA606A335;
	Sat,  7 Nov 2026 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tp2fK+sA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4682E1F008A1;
	Sat,  7 Nov 2026 14:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062066;
	bh=NXaGbSF2TcnLFfYlIpHtY2kxO61i9Qk00xFwS1abQVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tp2fK+sAM/Q/4e9v8Bjk2+oPUdU69kTGkBZUtNNjG7YYtKnts81VXnEalgVidRlPC
	 aUqA+3Hr1HtoMAzjQNf6vJa9Nb8e5a3umgl45pXlsw16h+FXC2DhKWGrh+dpuM5804
	 Bmfom7emHVaVsTycq7/kaoKIidBLyJK7T9IYZweg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1046/1536] media: adv7180: Initialize mutex before ancillary clients
Date: Sat,  7 Nov 2026 08:51:02 -0500
Message-ID: <20261107135027.055117305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 9d46d17a65e86010b1f5604e5cf61ce1e197f77a ]

The VPP ancillary-client error path unregisters the CSI client before
destroying state->mutex. For I2P variants, the failure can occur before
mutex_init(), so cleanup destroys an uninitialized mutex.

Initialize the mutex immediately after allocating the driver state, before
creating any ancillary clients. This keeps every cleanup path matched with
a completed mutex initialization.

A QEMU x86_64 test using an i2c-stub bus instantiated an ADV7280 client
at address 0x21 and occupied its VPP ancillary address 0x42. This forced
i2c_new_ancillary_device() to return -EBUSY. An instrumentation oracle
observed an uninitialized mutex on the buggy kernel and an initialized
mutex on the fixed kernel. The failure was deliberately injected to
exercise the error path; no natural crash was observed.

Fixes: 851a54effbd8 ("[media] adv7180: Add I2P support")
Cc: stable@vger.kernel.org
Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7180.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 36e0f7a8c6d57..58fe359cd1abe 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1427,6 +1427,7 @@ static int adv7180_probe(struct i2c_client *client)
 	if (state == NULL)
 		return -ENOMEM;
 
+	mutex_init(&state->mutex);
 	state->client = client;
 	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = i2c_get_match_data(client);
@@ -1467,7 +1468,6 @@ static int adv7180_probe(struct i2c_client *client)
 	}
 
 	state->irq = client->irq;
-	mutex_init(&state->mutex);
 	state->curr_norm = V4L2_STD_NTSC;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
-- 
2.53.0



