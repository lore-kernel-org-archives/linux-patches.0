Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045116;
	b=TFqg6TmGQ0G0/PgSOGRWuEUMcO+jdj2xFKLEi4iJv4wufxF0nQ5W8sTAPBt3TmH1MAlg
	 tr2jawYxsWDdcN+OhP3R/cQ1uwz+4uVvAdP9fxow04/VsLm3mHa6T/nPv8PPUt2vitwBt
	 eEd4qvqnqgXy3ez1lRrXigyU5/ZHLI5XiGyJOxHLeYCBUzHDe5ZrXxVzZdfyHcHJCvCY9
	 TNBpxdqT/Ahl+ZtvlZVKxboKxS5Vo71rJBHtZEgCkpak96r7HPaD8OnZuP9P4ohPZOt0o
	 RAkbUmV0X5XysSZxQHI4YipoWfih7vUI+iuShMBdrHWZ+hMVra069eeDhjFG8b98pjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bcm5OnYjFD8HsrZWQnUo2x83d6uiFAIfDeWzZN0bUTo=;
	b=QUXAA/O9n8lr/wagTa7Pm7YEwr7aCGQqUK3S7mMVCVjePjYgE+25wllzUa9M1YFU86kF
	 3QatkeqLhoUmT56M14vTKVOh6sllLtycF4FSziutAPm5ppuVWa+QYlU4b9xm5+/iATCuw
	 7s6zj331DKkATNKGQmqs7h0iK5ejm/XJSAfDegrqRCwJU2GnGotYLJAp5VH0zz1DwkBX3
	 +AkJcLZkFV8e749pWNPDvKmv9uPRjqX4TL9Aeg8qpbAQBlcOqyhSClRXQsFl5/znDWJBQ
	 8DZtzaD2bJstgFNymQ3aKNNPCVrRdSWBlRRYXZBBiwd+/YZ0/AXugIxRJlp9QQCXjoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgUe7f8o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D870606A32F;
	Wed, 18 Nov 2026 23:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgUe7f8o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E823B1F000C4;
	Wed, 18 Nov 2026 23:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045116;
	bh=Bcm5OnYjFD8HsrZWQnUo2x83d6uiFAIfDeWzZN0bUTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgUe7f8odrfXvTxdbrvifHr9FIAhgwEPAPr3PsvMgHXiQFVlgUW0zzQbWDRf3ZBoT
	 wCvlv1RJR+dLFG1qfY7e8zrZh53aijAwp+pVGnQyRm1TvQiqKV13uyf9GZSkMVBVLU
	 ja3bMrjboo9k7lq7Fvb0UrPgbckg/O9BVl1hV6A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0809/2857] media: adv7180: Initialize mutex before ancillary clients
Date: Wed, 18 Nov 2026 15:30:43 +0100
Message-ID: <20261118150230.697603935@linuxfoundation.org>
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
index b34e1a7bd2c45..bc545ccb61bbf 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1416,6 +1416,7 @@ static int adv7180_probe(struct i2c_client *client,
 	if (state == NULL)
 		return -ENOMEM;
 
+	mutex_init(&state->mutex);
 	state->client = client;
 	state->field = V4L2_FIELD_ALTERNATE;
 	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
@@ -1456,7 +1457,6 @@ static int adv7180_probe(struct i2c_client *client,
 	}
 
 	state->irq = client->irq;
-	mutex_init(&state->mutex);
 	state->curr_norm = V4L2_STD_NTSC;
 	if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
 		state->powered = true;
-- 
2.53.0



