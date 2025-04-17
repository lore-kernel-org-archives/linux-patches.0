Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC12566DE;
	Thu, 17 Apr 2025 18:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915749; cv=none; b=mBZ166jk46ZzfTXTkWXrX3ojJgClGiQ+j/yvb49BSE0rh/q0lY4IJmEsRmVbogp9AxEtmJwqjtLra16iVlweos3C3XL76zPc2l/+UMByk6q5WrETDvcgWLHeFQuij6gomjgcyxpq48h3iEaVFJ749OBOtquCuQ35exTzeOJV928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915749; c=relaxed/simple;
	bh=NV94YR6GPIQlQJ5X5czT11k8NXhZ9Sf7JfU7F5BvqwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USDz5R6FSLcf5TFI60c7la/sN/25HzXiMRKy+8w5C9LGrQi3LZ5wPkeARGeP6i2pgIerdEOGPjl9Zu5Qyqzxx6cVpmBSItSWF91KX4J6jVlUWsi9fLjhcvuZgiakPlGJY9nXhabkzRXQ5wFbkUHGVniUGgCEyIpOHtnjlCLWoc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAWky6NE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAWky6NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C8BC4CEE4;
	Thu, 17 Apr 2025 18:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915749;
	bh=NV94YR6GPIQlQJ5X5czT11k8NXhZ9Sf7JfU7F5BvqwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAWky6NE498nOm7f+Ux1dWzNXwCG0ASfB1l7gmPsKqDyhI+Zbc+l/rrrz70Bm2bTp
	 iOR5Ne0KllXV8tSMybejxlgidGat+/fB9BniBbXqXdWvL+yhqVVALTPuXO7yXlwrNd
	 aLfwLftcE5KXdidgYP5+urlhmBL7+PGaQ/M0Gok8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 220/393] media: i2c: ov7251: Set enable GPIO low in probe
Date: Thu, 17 Apr 2025 19:50:29 +0200
Message-ID: <20250417175116.437116940@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1696,7 +1696,7 @@ static int ov7251_probe(struct i2c_clien
 		return PTR_ERR(ov7251->analog_regulator);
 	}
 
-	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
+	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(ov7251->enable_gpio)) {
 		dev_err(dev, "cannot get enable gpio\n");
 		return PTR_ERR(ov7251->enable_gpio);


