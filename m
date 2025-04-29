Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E6B27453;
	Tue, 29 Apr 2025 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946828; cv=none; b=fV2OOq13jujDgzlEorokbuHC9lKugVMdypfp+06ngiPJD+MIbqo0GvmkCMi1SyaDoIokGK0HjYBmazhgOMOTqFUUQUBanolyDOjP0LN46ij6Kxk/i22BO6gWixVvtZHkxZL7mOGbLow6/WXc8l/ZhopxdzNR3/EpcMxulNkKxNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946828; c=relaxed/simple;
	bh=seYGX9VBdniFV++2oEqHMUaNz3QQY593ob2+LAYJ3Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLsLsJOTwZ6gb/cXhpD7fSOZCwiwYixM4tj40rwdgK+tYdFP0G3BPVAIYb+aRwQPxgDRCSLLfX1U4Ky8biOZML8iNJSiUREaJgcNwZgdWANAXuGzkLZ9w7CnfCoxb4iFt9TrnCTjcVCnyC9Q2E8lA/iwlJNPKfoZQu+Wm55sWcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnNO/osL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnNO/osL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6B8C4CEE3;
	Tue, 29 Apr 2025 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946828;
	bh=seYGX9VBdniFV++2oEqHMUaNz3QQY593ob2+LAYJ3Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnNO/osLm3tzXtMhCgSYNpRbSsUV92AnPWcAmMhgNEaa8DMWKPuptG8k0wAOdLN8d
	 iTWXvNIIFlURoHLgM0GL1PwPCOBaOu3EPexsFSfvlMvJVPhzphm/RZl3caLgzVfM4V
	 976dqtYa7AfiKp1gaXzEqkX1DYX8WsFw06b+NDyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 065/286] media: i2c: ov7251: Set enable GPIO low in probe
Date: Tue, 29 Apr 2025 18:39:29 +0200
Message-ID: <20250429161110.518289057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


