Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACB6227E95;
	Tue, 29 Apr 2025 17:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948659; cv=none; b=fYB0v4m0cSRHE28LeMDefPc+dR4yv7a5xYbNd/y6mNeVnsBCwyFTXjLtVHrK20bIz+FLFI++p5rhtFm/34b82qZ+h+FTMOS2uRUzWqPJEc+ujUnQhbxy3RTLdukUUaQXX1UWXB6J4aCoBa6qA38owSyf7X+4bmrGbM/dL7VxsTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948659; c=relaxed/simple;
	bh=Ee4/o76BkEvnXcngJXa37dR/jFQFQh+XXv5aHHr/tRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSPNHlgabV4LNf/qKrSur6Sma5JMmB1CuOOaZLwmk+c2egm8W/AhlEZltHoDTSvTZ0YvPNO9k+Htt4JDtuQHCVwYWZgXBU7sipP0MzBAQCwJbRJXZ5NFlAnwwvWxhiSW+4CCdK3q0kfCuDisorpX2nWVbrdthdOU8uHGf+RAlOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jlkj1GoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jlkj1GoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4899C4CEEF;
	Tue, 29 Apr 2025 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948659;
	bh=Ee4/o76BkEvnXcngJXa37dR/jFQFQh+XXv5aHHr/tRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jlkj1GoG7x9PRPkeow+uxbO1tIx42boHa+Eri/Nfw/uj/1ToFYyiDM+ZrX21CXiWy
	 gbHCgFDGTHqEQcdo1MCiXmsoTEhrF9LZ+45s6whiOAiVeXNYb/vyu8J3p8CNTDvlpU
	 +2xs2AJtdz8+LFDfZeAAPxQU2qLpwuRfn3KqKPlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 074/373] media: i2c: ov7251: Set enable GPIO low in probe
Date: Tue, 29 Apr 2025 18:39:11 +0200
Message-ID: <20250429161126.197228498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1333,7 +1333,7 @@ static int ov7251_probe(struct i2c_clien
 		return PTR_ERR(ov7251->analog_regulator);
 	}
 
-	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_HIGH);
+	ov7251->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(ov7251->enable_gpio)) {
 		dev_err(dev, "cannot get enable gpio\n");
 		return PTR_ERR(ov7251->enable_gpio);


