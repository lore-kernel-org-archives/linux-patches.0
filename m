Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF4F24113C;
	Tue, 29 Apr 2025 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945282; cv=none; b=VCBbLa0wC8q42o28xls3qYbPV340HfXAnr81IFgxpaAwYqpVhOVRjyUMjSXMKVYfktMd1afPgBeC0h/oCRGoHNv6ibO/A5s2/lXRnXqRa0M6iIZ9HLDwVj9LyQRJoNq7QWfKCzlEQPqDAXYCa71BzABI/Pv2liMTt9rHEYaZKV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945282; c=relaxed/simple;
	bh=l8tKARZ8SVfd65o55HA+NemItSSraUgYx0yZl6lo+YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0/EsuvVFGT+6V8bwT5J67Vs2taI/Bw8xal67hL8JmoaqAQmEZW+aPeIn1gRnnsVEa0Er5BE4ORsPo13M6XHbBxGqe1zSMNvaItsq8DrpiWPlpY5ywEF359LYvyDaXRh+EEr3jJFyWMLtCCbtRhG5w8VvCNSF4aRnF0s2omhY1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caVXsdD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caVXsdD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC69C4CEE3;
	Tue, 29 Apr 2025 16:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945281;
	bh=l8tKARZ8SVfd65o55HA+NemItSSraUgYx0yZl6lo+YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caVXsdD4Sb9wCF4DKNALK3Qs9KlIXQcm9B3Sn5sY3UI5y5w/6Z7jlianANXYN7cJG
	 AE7hNrZbSLiKd9lrZVzGUHFYwEFtbEsBC6K3P55+NAJEJ7hJx+06C3EZV5+fg3r6xu
	 6lqlqOUJbycG0LTmxziRRdroihRY/QxzTl2idxqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 053/179] media: i2c: ov7251: Set enable GPIO low in probe
Date: Tue, 29 Apr 2025 18:39:54 +0200
Message-ID: <20250429161051.544748691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1330,7 +1330,7 @@ static int ov7251_probe(struct i2c_clien
 		return PTR_ERR(ov7251->analog_regulator);
 	}
 
-	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
+	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(ov7251->enable_gpio)) {
 		dev_err(dev, "cannot get enable gpio\n");
 		return PTR_ERR(ov7251->enable_gpio);


