Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064105;
	b=YLN97t4IXVd/uQMKbwlTnsf1JrFrDYbpIoopy/QKAiYkGJTRp1rUG5f80ZoQkqWRChgZ
	 WvISQw5tL9lhR91GBGBW10ItP+/+g+XzGFO3Y8hOOVQz4r9DgXadoEP5a94cVhF77+SDM
	 ZvVESUywGcg9zYaUx2YoiKXhj4Zur4N+5s0yui6rTYqJ5zaM5gytQt64ryS9lhNDnh3gx
	 MH4/oxnrm5jQf5EV7eH/TPaU2mqQt76+wPmGXEfNsbPdfF8OpBTdNxHd84YLhFfNkbjB+
	 fSeTQl1R4cxREZanHz8kWQugr9sN7+z3ovOmHbK3i7gkSgEmtxbFZRX0l8fCWrM+0rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EIVO644+SZKTyJlTh8I+QVaJRRi5QVHnDglVJdPe1n0=;
	b=Os+QZwYa9lHcRvt1OZwEGKCwLJYLl/z7/Ki2uu/e6uBymIhOPNRDJc1BSwz1hVO/Lar0
	 eo1VGK/pgzDkO094pGi2eh/JtfFeqGu6fpX0UdNZPZZnqg6qh2gUouEK5ZTP0XNHO2xsr
	 yZdyV0X8s/1CdxR11aIuHBOAqheAXO8zp81qntF6gHMwy0Q4Q1QT4U0S3fyPNTJTKUf1l
	 TP8WdXqW0K6awL3fu6CMadwk9GqM1s6bPFuWMUopUoMNjF7ePfngjkMwoAyeZci3M7w2I
	 FdELu0wJdqr8UThMCYs7NGo4xTQjtLGb33HOdjvBXKtWE33QUDagyaHJT904gqx/O4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/J8/0ry";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147BB606B882;
	Sat,  7 Nov 2026 15:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/J8/0ry
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66E61F008A1;
	Sat,  7 Nov 2026 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064104;
	bh=EIVO644+SZKTyJlTh8I+QVaJRRi5QVHnDglVJdPe1n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/J8/0ry4bzAXCYBWDHq5hV569VR5j7fE+/NSv2sAGmtXOJTkxHjiCvYyPeKApbHk
	 aZCD53lwvK2F64+mnsXUUGmqBYcQQfxlChX+imAXyUQumWbZ4AnHWOf3gJTcloXBse
	 0OHXNlPD2r8wnWzdHTxoxkmsJawiKLFSIXs9JV9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0265/1257] media: adv7180: Initialize mutex before ancillary clients
Date: Sat,  7 Nov 2026 08:42:41 -0500
Message-ID: <20261107134946.817011287@linuxfoundation.org>
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
index a1c7f68225b45..8c2cf3f539781 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1454,6 +1454,7 @@ static int adv7180_probe(struct i2c_client *client)
 	if (state == NULL)
 		return -ENOMEM;
 
+	mutex_init(&state->mutex);
 	state->client = client;
 	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = i2c_get_match_data(client);
@@ -1497,7 +1498,6 @@ static int adv7180_probe(struct i2c_client *client)
 	}
 
 	state->irq = client->irq;
-	mutex_init(&state->mutex);
 	state->curr_norm = V4L2_STD_NTSC;
 
 	state->input = 0;
-- 
2.53.0



