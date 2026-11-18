Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036198;
	b=p+Vbn22taLZ4cyOmu2eaFr87b6D3KSUFVIlAMHVGWyAfo2r4A3nO5xJi4uKapuPsnSN3
	 G57HtMVvYdrTl+bZ3FngsADEZab3yUWrff70Ew7pDwSyhT6XO9pyeNZFb33/Ad7qrx3iY
	 Q411ZXfFQuFm6ayrEjGRl47m/+Qc2PZS2p7cRkZ21Zqy1jcH1VsSoOd81iWP6ZfmyhMtp
	 cPYIa6tjPqtKiYwMdZd1JBH7BvaFf6nSwYLZgKc7n+pzV7rCJN0yiaYGpwRQ1qY+pmf9K
	 mWdXg8Ws53otVwpsobJEKqD3ifROb4lkK+JOkA4oFBVrAbSM3ob+QOtInT6MbvJhy+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m7uQmt9Dru7ivbWBvw+gruRwdRDZpk0rvZkb+r2OYc4=;
	b=bWVLulqhxaeAf0FJc1AEgwEJEOok0IA+qIqqVkVvL4hLLRxjW49JcOyDfRpAHq9Mlwka
	 jP00XvPUFUQhQjYres/5BE8mZA5XMz0gFYk+8+xv+BZT7BZBguIOx9b21PpE71OKMsLnK
	 3wQwTVtvJiwd8hSgLDhiBTZft2Ywhh6ESku5ZY1r7UXSY75t/yBO9kB8M86Mf4cco4UBD
	 w+4bLcbhRButbec1VzYt4x/mRd/OiEvkGMz9f0b7cKP7G95rOGixh5GFnUtE6Bi8eCdcW
	 Ks25OEOUH9Petxj/bKeqjaqC4ADDEs1X/1RG4hn1dMp2P2s1V1xHtLrhO4aG45WwUbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YU7lKJi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D773160A2617;
	Wed, 18 Nov 2026 21:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YU7lKJi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370EB1F000C8;
	Wed, 18 Nov 2026 21:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036198;
	bh=m7uQmt9Dru7ivbWBvw+gruRwdRDZpk0rvZkb+r2OYc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YU7lKJiPu+xj6TSgiUn2fHCtK9ipfnbWq1O3BWf0Yhv2GOvCGUAr06DaYk6kosgy
	 +HKclDIZVdGiPWMdXjU0smXFVuOU89pBD94iXNf9EPC+dKWrlEVsxbRxAvNQxlPPTY
	 Shqu6wqHDUaQu2zQFndYCfK1n5iO0M3BCbXxSSFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0921/3318] media: adv7180: Initialize mutex before ancillary clients
Date: Wed, 18 Nov 2026 15:25:43 +0100
Message-ID: <20261118150347.161178238@linuxfoundation.org>
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
index 4778ae653ca9d..58bdb42205c2d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1416,6 +1416,7 @@ static int adv7180_probe(struct i2c_client *client)
 	if (state == NULL)
 		return -ENOMEM;
 
+	mutex_init(&state->mutex);
 	state->client = client;
 	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
@@ -1456,7 +1457,6 @@ static int adv7180_probe(struct i2c_client *client)
 	}
 
 	state->irq = client->irq;
-	mutex_init(&state->mutex);
 	state->curr_norm = V4L2_STD_NTSC;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
-- 
2.53.0



