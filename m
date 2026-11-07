Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062949;
	b=yr8dBdomHPwADf4d5Zk5oAzh9Nn7W4aHh/pKhAgQwGk0uJOv834ICQtL033FINXqMt6I
	 Tal1TsjWH2yo/GG5Gm3qQYGu7yTYDubPynyRVCxvEzGHhbANjbGBPKWPhIIfKTdpBMbA3
	 uryNQG8W41ic0h+DpR9p3KFoG6Vml8lIiAAaJoNxJI/7GB6SEvBsrEsABvqDmQufPxPou
	 Btq+KqKVyZOgb8HHBB5MCccIB3LZuQdL4W+bvPTFtjqvsLhGCadp0kLibqpB8W2QVfFC7
	 L4ouBq8w1ctfNN1KBeY4ymqgs22JdrdJdwrgmX77dS4GTrZlbl9ojbnEttO+UmjD94w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YtTuwUb+/sDynteX75p2Ke4DrP0zZSG/Y7aiFM9pykY=;
	b=Zeyathz59kbLlMGLa5OHEzv47AIUV/Khhvo965vFMXqGTXRB7E2LfejpUX5YEIPgj33d
	 WT1ns71rQ3x2Uw7o9CWNTv5SrLrespKu7Zu1V9CWgCJlNSD4JHXbQciHTscLz0pDDDihF
	 l4XPOlJGWRnZtVAMd2DOP4FX3Ikk/8Yx0InqRisBJAbI3FVaepOzTGcObdhf+vrUBS1LR
	 oWb+wo4cDIEE1+GPr7p0itY0Fgn3HPgpghFtgGM9WxE6WChWhEsiXERJKU94P3qnM0jZR
	 dSTlvxt/Im2ZA9oTGi/V2pgJC8d+30DG6RMXiMf7isHaS08d0PxsayPgEL80nfn8viw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/4N56+q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F25E606A32C;
	Sat,  7 Nov 2026 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/4N56+q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18DC1F0089F;
	Sat,  7 Nov 2026 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062948;
	bh=YtTuwUb+/sDynteX75p2Ke4DrP0zZSG/Y7aiFM9pykY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/4N56+qvdzAnEvkh+sq6bZu2A9TUAwCIOpSiFj9CCU5wQDJuft3+Yt8+BJKiRXE8
	 REf5llqDeoEq6ypWRbe/O4BmSg55iRDRVpiK6xIf3MXfhDOYB0TlB9l3twlY+6Saj/
	 ba9K6qPtWRPjdCFJuRQzRpV1bnevAbKK8sCMVJWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/869] media: adv7180: Initialize mutex before ancillary clients
Date: Sat,  7 Nov 2026 08:48:16 -0500
Message-ID: <20261107134859.202325053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5cbc973df684d..6223911e324ae 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1425,6 +1425,7 @@ static int adv7180_probe(struct i2c_client *client)
 	if (state == NULL)
 		return -ENOMEM;
 
+	mutex_init(&state->mutex);
 	state->client = client;
 	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = i2c_get_match_data(client);
@@ -1466,7 +1467,6 @@ static int adv7180_probe(struct i2c_client *client)
 	}
 
 	state->irq = client->irq;
-	mutex_init(&state->mutex);
 	state->curr_norm = V4L2_STD_NTSC;
 
 	state->input = 0;
-- 
2.53.0



