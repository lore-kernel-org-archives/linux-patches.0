Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061595;
	b=bKlGIEPv4qvcaYWc6ALDinjOPRciPyIT7lllTshu8/XfjRKmtt9ockuHeIQqUdP+XqYu
	 OKiOPb6PutOKo1RyZ8Rq2s4MYoMYaQG5vq81i5Ds6rMN8IY7/sIyu1szGR3y21ydODFuG
	 ckZJWii605eJWy0zqhpEfM48/ZVqG0yFHjM1S2dtNWOqazDuCa2C8TAvOz1h+z0tTa0xe
	 5JsdDmsajdNdrhf9DELNTZqFbaoZerY4rJEAmlkHR9BKbsqc7ZuwBhvNrSzFgSw68EimC
	 MTz1/WBEkpTrBTwN1y1CLBXX9fMClMHbvoSr+gyxgGgU9GM17+jTGNj72q+otvKtHRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hg3vaou/jBBcyFE661MkIz3mWVU9L+oD+MVtL4pMcSc=;
	b=QKMy/aQBWQJiKxDFLIbWDS6s1oq/nmbhJKqq0pJ8mw+uNyhCtikk1Arnx/gL7o2YiaJ3
	 ut+1KQayWPoY9t+W60KHpe6yw5Aw7ca0CJb7g04dBPsS5XINVnADhwxSbqkh+29mobf/s
	 kmhNwS/4vtYdfemo8x5wTJwDlFZSPLyk7axX0+u2QbUFKwjwHwJ+7OwhHg8SgaHemUuAj
	 FIREig9AT7JBLJFf6B7Nk3ZyqEA8FCLo8AeapNwQpLdmkuekqyiLJ7wEa+u/B+b5KU6dr
	 Z8PsOgsNyi8nzNEw1wBMcf+CM4EZqfhRSP3SGiX6ZUbCkXBiZBFVlsF1PgkLwHOjpXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ucc+hOCo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8F4606A32E;
	Sat,  7 Nov 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ucc+hOCo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6941F0089F;
	Sat,  7 Nov 2026 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061595;
	bh=hg3vaou/jBBcyFE661MkIz3mWVU9L+oD+MVtL4pMcSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ucc+hOCoBpMMTRPpvSKkwgVJt0l1DBxoEcBcOkin7qd+FZqw/SrBy9uSPwp7B/q0C
	 1QiVFVzcvjUlTKLdiTelsldfC6GYhIEbBepC3yYS5YXd+TPBfZucOKN9euylbqV9H2
	 zTWGHHF9AqwxtByrookDCh6Z6gFDRemYwsJhEuOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0661/1536] media: rc: Ensure that rc_unregister_device() does not free input device
Date: Sat,  7 Nov 2026 08:44:37 -0500
Message-ID: <20261107135016.081531400@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

commit 61c7ca95d2483c77dfdde1b007cbe846f145dec4 upstream.

During or after rc_unregister_device(), IR may still be reported which
results in a input event being reported. This could result in a null
pointer deref in rc_keydown() or a use-after-free of the input device if
the pointer was read before it is set to NULL.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1742,7 +1742,7 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
-	input_free_device(dev->input_dev);
+	input_put_device(dev->input_dev);
 
 	put_device(&dev->dev);
 
@@ -1854,6 +1854,8 @@ static int rc_setup_rx_device(struct rc_
 	if (rc)
 		return rc;
 
+	input_get_device(dev->input_dev);
+
 	/*
 	 * Default delay of 250ms is too short for some protocols, especially
 	 * since the timeout is currently set to 250ms. Increase it to 500ms,
@@ -1880,10 +1882,8 @@ static void rc_free_rx_device(struct rc_
 	if (!dev)
 		return;
 
-	if (dev->input_dev) {
+	if (dev->input_dev)
 		input_unregister_device(dev->input_dev);
-		dev->input_dev = NULL;
-	}
 
 	ir_free_table(&dev->rc_map);
 }


