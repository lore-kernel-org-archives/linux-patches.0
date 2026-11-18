Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058273;
	b=OV1CsAO88FOABx+XCUz4L51gBekOU+sUdthsGhKTk8iMvHkEsbOeHx75GhsXegjKv972
	 jDzkm2235a0QwfdiTBY6VH+HHJe7yU8dU3VH4EcnSOaoNodEGPNjREql46W8Aj5Rh6rzV
	 40OraOhT0b+eNlIid/IIDGCTxioS093XzhiyNaKBA466Z3R8r+O9iMyeppX/Ua46KN7yD
	 FHcluea2PXO5ubUV0YGxXx9lpVk18SzukUczFArG0KNoCG1ez3cDGUgrGyCVONB4YjdNg
	 HYaOQIuoDHtNCIKVq8g3RYb9pIxcK67Kyd2fQtucS0b6kZH+0KYp2c1j/cC2pyI+qXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xlMplhthbb/3AEPPY+FziDhhQB4nqaMqwj9FfF4L0Cs=;
	b=qPJpbklFeN1cUkPWa55iEUVj7EmjyVQQ5zXs4YfUCAZVLsVGSjLHfukHogKdlmc7I/y0
	 JjQJtrk85u3F6XAcV0aF9IvQMWkFiJcp2naiScQgSy35k6p6JqPdsZXiZLPKropPWD6uD
	 86JBq7+a1I/qoRR7pL+aBZFhzAYaqKvnmyr+O8y16iJrNBeYbSoPpq55DGxwxpTSGYnle
	 q+5OC4gpoqtS5TtQnrUAbeN8Hr+hZC16yk3SmbOvCHuyzqUVk8jVPrRh/jNP4tnIg8mcE
	 bk9hLLckSpOXG0lKt1zuzjXU0A4iZTjOTxN6qhzKNUto69Ytw8D4H7o+DH6n0J+p7cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qB6P1EcB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF62606A320;
	Thu, 19 Nov 2026 03:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qB6P1EcB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BC81F000C5;
	Thu, 19 Nov 2026 03:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058273;
	bh=xlMplhthbb/3AEPPY+FziDhhQB4nqaMqwj9FfF4L0Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qB6P1EcBPMzR0hQO4AdmD5t9wdo2++Nk9qHUT6KQ7eMR+gMFBiOSQUgooJ3hfi0Pv
	 stgvnXpktDaCD9CoUksFhd6XRCSgF388gdYbIpA5Lw1SWQ1Ucd/RlIfug5np3gHgIC
	 BHqnkQMj7L/WGKpOT7E3I1EtcqrhploEARCitXGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0426/1848] media: adv7180: Initialize mutex before ancillary clients
Date: Wed, 18 Nov 2026 15:41:04 +0100
Message-ID: <20261118145931.972903698@linuxfoundation.org>
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
index 2d689357f156c..65d1073e173e9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1333,6 +1333,7 @@ static int adv7180_probe(struct i2c_client *client,
 	if (state == NULL)
 		return -ENOMEM;
 
+	mutex_init(&state->mutex);
 	state->client = client;
 	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
@@ -1362,7 +1363,6 @@ static int adv7180_probe(struct i2c_client *client,
 	}
 
 	state->irq = client->irq;
-	mutex_init(&state->mutex);
 	state->curr_norm = V4L2_STD_NTSC;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
-- 
2.53.0



