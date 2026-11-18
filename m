Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052475;
	b=LibPiFx3B+XBQKLbb+hLw2J3seCkB1RxszrBkYjH8qH6YRhx4x3IDpm2HUQkgWKeljig
	 bEj4abUzunSm+15X9zEkZWB/ttoCWIHadyM7as64Lyt08u7IZuD/3p6d33IXmHTVArmCh
	 6NVN9heyVTJzWtEF39mxbQUYm9uFFTmYPVtGUobPy8y0ymZsjdwJPCH3u+C0+yuczjjtH
	 3PnV/PRsihIvIfCm133/QuaDCvpBN3UXK2ONKF3/Trqu8oavuc3UWZhozwy10njqPI6Rk
	 pq2uwk7CDA/ZcLgB6ERCPg7UCEC1RnXNsBv1ZwtqhXqvvVxJfSzVSL1C44aGO3fFpUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rZ1P/f14Xn870DGHBgFcOqt+Q8G3YTh+DT+WlGmvvKI=;
	b=yxtCcH5BsdvonBvqI/GQy06juEH/3KbvHwNiUanoQebGX/y/3kaE17rxZLsjwCNlxY3L
	 sc+GreBei19GCW/pjVOu/h5uRK+/E3u6PYogudB2reTfIp0pTNyjs0CjMdXS8ztmexSE2
	 rPaFmf9GExbuPnSaOqyGP+hCaanX7hMI77aWIJHeTppZu2mtIaPAV677XXIYDiZueYGeF
	 UGRCBHn6k2rKQoHHLbIdESFYyxT7j1n80t3Qi8mccsFuQX4FwJ2ijubeskChs7LLws93n
	 2p9dG1YseL4/2ML5nUIT7LmiqNmcLavdzedBB3ZsJl5br41Sc6e3GhoYx8zIhikVdpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msBCXu1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCE5606A320;
	Thu, 19 Nov 2026 01:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msBCXu1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0BA1F000C4;
	Thu, 19 Nov 2026 01:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052474;
	bh=rZ1P/f14Xn870DGHBgFcOqt+Q8G3YTh+DT+WlGmvvKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msBCXu1bR/hoF4MBkPuvHhNFZCMKLbtSg8bGYZeOiwFY32SL7DpYPUDnDx2x250Ip
	 wqj00+w7i1zpyJo6l3kImVMsfyK/sGBt1Zq9USPL78ZhGQ/D6OPuSYphHGVY+va69Y
	 gJ6F/9gQaNRFJ+uhm0/QV6kLbvP/cC44SHBHL9GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0527/2214] media: adv7180: Initialize mutex before ancillary clients
Date: Wed, 18 Nov 2026 15:36:43 +0100
Message-ID: <20261118150032.153794967@linuxfoundation.org>
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
index 930ab969cc742..8d02f71ee1998 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1367,6 +1367,7 @@ static int adv7180_probe(struct i2c_client *client,
 	if (state == NULL)
 		return -ENOMEM;
 
+	mutex_init(&state->mutex);
 	state->client = client;
 	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
@@ -1407,7 +1408,6 @@ static int adv7180_probe(struct i2c_client *client,
 	}
 
 	state->irq = client->irq;
-	mutex_init(&state->mutex);
 	state->curr_norm = V4L2_STD_NTSC;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
-- 
2.53.0



