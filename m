Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073BB313546;
	Wed,  3 Dec 2025 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780438; cv=none; b=OLvYE5R4rEG0tCpegDwYqzW1jC0goh12nUWTVkKhmG2PmqoCiLaajA8ttLk+CAM877iSFe4/n2seDwmwkV63jxnb/aOtf3J28WlCRtJvXAUu0odHhhDZr9rB+THKEfJePNrxX/L5lZ8SIHId+zp2xlYvQ/3NKqdQ+iOd3o3wgmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780438; c=relaxed/simple;
	bh=N0DQ/kRue98muM6QcQOihXbQqnY/WX6C5bv4JpsDsEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cU9lQ74XWTnQk61HoOOS1sU4K7T18XTI5ovzz69IUSGIqO0ALCJ0tGGmLlk+kl0QOJLzz/uLFSb457NLsmhhGj8BcSq1e20lJQZgGjgvsGWp8wE5iKWUsCytLZjRwNTaBtahMFDfh18LBljbgcfZEH9Rjvahr1JNqNGae1cb1cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCwtNolz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCwtNolz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFB1C4CEF5;
	Wed,  3 Dec 2025 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780437;
	bh=N0DQ/kRue98muM6QcQOihXbQqnY/WX6C5bv4JpsDsEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCwtNolz0MV+PRWhRYoKGmHSihTcacke5Dm/DUToLdPYLj9sD8TsX5doeeOOiiIDx
	 CFBsgnTbSLVtq6WLFWR/fXuDIhIr06e4+cys+aLKx5K48ufQRPwKKoaf377InaB+3H
	 SOwEpdnvKKcswj1Fu8+60V5GdzZ95rSHSw6QiNSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Hsu <andy_ya_hsu@wiwynn.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 556/568] iio: adc: rtq6056: Correct the sign bit index
Date: Wed,  3 Dec 2025 16:29:18 +0100
Message-ID: <20251203152501.072984150@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 9b45744bf09fc2a3287e05287141d6e123c125a7 ]

The vshunt/current reported register is a signed 16bit integer. The
sign bit index should be '15', not '16'.

Fixes: 4396f45d211b ("iio: adc: Add rtq6056 support")
Reported-by: Andy Hsu <andy_ya_hsu@wiwynn.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ adapted switch statement to existing if-else structure for sign_extend32() fix ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rtq6056.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/rtq6056.c
+++ b/drivers/iio/adc/rtq6056.c
@@ -171,7 +171,7 @@ static int rtq6056_adc_read_channel(stru
 	if (addr == RTQ6056_REG_BUSVOLT || addr == RTQ6056_REG_POWER)
 		*val = regval;
 	else
-		*val = sign_extend32(regval, 16);
+		*val = sign_extend32(regval, 15);
 
 	return IIO_VAL_INT;
 }


