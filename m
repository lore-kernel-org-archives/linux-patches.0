Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A472566D7;
	Thu, 17 Apr 2025 18:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914490; cv=none; b=de2yMtnpf/hQD6DH8Eg/tFhE/XV7whLtIXmK8B2yxGTg+ax9dNobdL+T9ttyHlsgLpz6SzXfllLBV7oRde3T82YHzenBI4SP8IgaMU0ElOryu/EZv2A9Q5kcTBAsr/vm/YUW+SV/2yxYz71kL4qegLTKMHLlquTeetVWJs1Wkek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914490; c=relaxed/simple;
	bh=Ehaj4S8EsWyYM8s0JpjWcQvvHk7gfF8CFennWGefKvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdwksySlhUi0qj1OLhzh8NidkX5ekIa9dl7D7tbGL/v4cvh3v5f5sOGjydls35dh2lcQf5lFDTAq1v6bqMPmcMAa2TEUnx6+NeQfA2/spkHhgtfrhHqawrmXSWZl1eq2k2Tj6ap+L4AiCeB3DYvsKvo+UB/racKexG6FUn+Q0ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wm/IJ+sT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wm/IJ+sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C707FC4CEE7;
	Thu, 17 Apr 2025 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914490;
	bh=Ehaj4S8EsWyYM8s0JpjWcQvvHk7gfF8CFennWGefKvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wm/IJ+sTT9vdcJEgXw/+Yx+6hzVTVv39w4/wNVNkV0NsFcKCuUuKIrzoUnzFeR679
	 1ZmZOLCF+jV6X0lbaE3JlJ2+XWfAI5S/HuvNJ//2TBrTWQXhF1eKBKX66Esw39Es+w
	 mqpGVaklt1u8YjtbUPbRnbMhK1+G+oB2F32/CVo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 232/414] media: i2c: ov7251: Set enable GPIO low in probe
Date: Thu, 17 Apr 2025 19:49:50 +0200
Message-ID: <20250417175120.764326790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


