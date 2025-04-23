Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A743C27990F;
	Wed, 23 Apr 2025 15:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421217; cv=none; b=uNGTBHESaO7/gYs4BjrHdY28RhL/4I0TIshpps9RTscIS5xf4t1NPXaQzcJK6ypGlE1RJwA/QQS9f2NsrBwUcDcozykqY/UH0CT7uy0DSBqeQMozB/qdr+ksoMJ0Z0NVFS+XEYu0Yt4kfDQaA8WlhR0TdLLb4DXUyh8qgLLnPbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421217; c=relaxed/simple;
	bh=T9lRDC/QseRwAT4IJNQSenj4DN25YrqOa1khxbbUNIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUC2PqjlH7D3nMqD7lHxqrdNLMJ3kDk5vAbESSpkucpHy4s4fEf2eKrwIc9ToMEsRFRneLC/WOuP/Xjb39HSOQ5DhFh36v/w2hNOZzXHevF1w69JX2EAyHlFpD6AXgK947I0UnWnoNa+4F9KM9VGKP0t65MYVlr/iV2uTx6yNFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5V0yuxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5V0yuxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD08C4CEE2;
	Wed, 23 Apr 2025 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421217;
	bh=T9lRDC/QseRwAT4IJNQSenj4DN25YrqOa1khxbbUNIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5V0yuxxaOOjUVOMo29U0tB+SfiHt3HFNOPSP4Hepcz2w2G/K0JcIDjofTf5p03pE
	 0Hh1wAtAxcpAl2Hd+ggyRA6e1+D0MR/KoSBlsq7Y2Ja6ZzMWPkjygxmAKRhIYSU2oA
	 TJA0IbbiiN00uDHsuyyoGcdRRMknFpxUZTiu73rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 142/393] media: i2c: ov7251: Set enable GPIO low in probe
Date: Wed, 23 Apr 2025 16:40:38 +0200
Message-ID: <20250423142649.240436741@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit a1963698d59cec83df640ded343af08b76c8e9c5 upstream.

Set the enable GPIO low when acquiring it.

Fixes: d30bb512da3d ("media: Add a driver for the ov7251 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov7251.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ov7251.c
+++ b/drivers/media/i2c/ov7251.c
@@ -1675,7 +1675,7 @@ static int ov7251_probe(struct i2c_clien
 		return PTR_ERR(ov7251->analog_regulator);
 	}
 
-	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
+	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(ov7251->enable_gpio)) {
 		dev_err(dev, "cannot get enable gpio\n");
 		return PTR_ERR(ov7251->enable_gpio);


