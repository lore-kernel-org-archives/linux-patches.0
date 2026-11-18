Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054175;
	b=NNIbgufCUCIFEwYM5OffagZSkJ9F7mP1uzQ/jUKFX5bx5v0UuRLWhT3B672SthRhRSKN
	 +bGkOJb/mB5x85kwiTcznGhu9Th0VlCt0Wwch/K8YG2n3HFGqdOEUZYRVrZguJb06wc2i
	 tgZOR48yFKibqRNMh0v8h5ip+kayxt+DzWDH+RgzxuW8n5vHHc2h0pplmzBj2EyulO9jM
	 YvxtnGYMffAv+ubvlL9zsqhrfkWPFausPZIDO9vCeHbT/e2T2UF4+rOp8N8o+pZBEzw5k
	 7GBELCs1WKHz8T7ZsczbMIVln/9q9IvTFp2UBQ2UuDXafiMKv6haGmSmCEweAY3YOyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f0lZEw4X+o9Xp0YfmIqBnDbGB54N8UPPMXO77KMtcrY=;
	b=BFPR26Jat9ycJ2vs/DWS7/GllOTmIXvvS/tKnovrQ4QR12OsG0igcONlhcjE+Y2UX4zI
	 2XmRtuDu+UtYUxrL0YcGKdAZ5KKckEe76LOnDCJQG0Z+iEwqdEueKu1tmcCQKLxFa0BGB
	 x4kSXaHTwgmooBOjCbspVDiRFQVFQLlt2RokwI64MrWxJ5qqsQespPw0lT5fszZk3flS7
	 UG8w96ty3hL4fdPFSFJmIY7U/mC/AiGJ/comsUCX9ZfJJlwE+/qhgZIBTFjvLpXjWLaKn
	 tceaIpxH7KKNKqnfthJIxeXrmFlGvD7lc+5Z9jkuNpemIVbVFOKgRXM/yWLC2y5Z+0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2ysvqtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D644606A320;
	Thu, 19 Nov 2026 02:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2ysvqtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36831F000C4;
	Thu, 19 Nov 2026 02:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054175;
	bh=f0lZEw4X+o9Xp0YfmIqBnDbGB54N8UPPMXO77KMtcrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2ysvqtMtP1j2TmwqOHqXtr5VzdyXTf5fn53ay2GGbjPa8YGU9xcW/9HgYvgDsJi2
	 GVIHr5rSuVps6PWFstWCtUxahmYUQpU3hkf1KXrVemS37eF/B3o2ehC4qaN+f1EGeI
	 9WWaXtnJcHB4EJW/6iGz+hZGSWHhhOv0gUeT6gIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1181/2214] mfd: wcd934x: Fix an error handling path in wcd934x_slim_probe()
Date: Wed, 18 Nov 2026 15:47:37 +0100
Message-ID: <20261118150059.187765905@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f190b4891a3f9fac123a7afd378d4143a2723313 ]

If devm_gpiod_get_optional() fails, some resources need to be released, as
already done in the .remove() function.

While at it, remove the unneeded error code from a dev_err_probe() call.
It is already added in a human readable way by dev_err_probe() itself.

Fixes: 6a0ee2a61a31 ("mfd: wcd934x: Replace legacy gpio interface for gpiod")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/02d8447f6d1df52cc8357aae698152e9a9be67c6.1684565021.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index ac84d45a31ef9..874aea6c24585 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -253,8 +253,9 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	usleep_range(600, 650);
 	reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(reset_gpio)) {
-		return dev_err_probe(dev, PTR_ERR(reset_gpio),
-				"Failed to get reset gpio: err = %ld\n", PTR_ERR(reset_gpio));
+		ret = dev_err_probe(dev, PTR_ERR(reset_gpio),
+				    "Failed to get reset gpio\n");
+		goto err_disable_regulators;
 	}
 	msleep(20);
 	gpiod_set_value(reset_gpio, 1);
@@ -264,6 +265,10 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 	dev_set_drvdata(dev, ddata);
 
 	return 0;
+
+err_disable_regulators:
+	regulator_bulk_disable(WCD934X_MAX_SUPPLY, ddata->supplies);
+	return ret;
 }
 
 static void wcd934x_slim_remove(struct slim_device *sdev)
-- 
2.53.0



