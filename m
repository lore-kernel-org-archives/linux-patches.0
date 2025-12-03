Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8559C32E755;
	Wed,  3 Dec 2025 15:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777061; cv=none; b=JMHbXOJrrvZ2IBLzlv3RIR51/3FM4Oq6hImtgpjxB0Uoy89h647s3TVdVmIJwQBD9v6VkiCEY/qzrE3eN7hqZVhq7ABeaNYB1KHDtLLELE/J7GuaBt7Kp0zdDBXrEzih9/pjv63vpEV0PfIbx0VFrrtA/msiSGDmNxLMP707keQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777061; c=relaxed/simple;
	bh=+BhPiWak2vFgolUsIr8akPEejOUklIVhLm7Hw9j6LBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPwp38vUuXdjhhVO7t0BL4CYHhzVO1RIagz4GBmFdNCdH+oVT3vjXxyISdMfCeYpDh5VPl28yn6sr9Xwv0oyi4hTG68lM/FBeuSHchyUTjaYASdQ/T2CazlaoF4syZ8/xLipN0GwdQ1hVHf59Phfy6lBJkT+cdpBbLe3agDX0so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zP4psUNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zP4psUNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E34C4CEF5;
	Wed,  3 Dec 2025 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777061;
	bh=+BhPiWak2vFgolUsIr8akPEejOUklIVhLm7Hw9j6LBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zP4psUNmfdmQGnWdMr5ddK6Gdi4v+xP9k9yl54dJOo72c5l0YMqmHCIU15+5kkJLk
	 uxJXF5Fu+wW6kAskpSPBHPb3y0/bqv9HkweJy1/JvPP/QWbOyonYJ6GHuxCR3IG0Zv
	 0h/kuTtJ03oL/26DxJYL95Vu3mlSP9awnW7QKxI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Hsu <andy_ya_hsu@wiwynn.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 069/146] iio: adc: rtq6056: Correct the sign bit index
Date: Wed,  3 Dec 2025 16:27:27 +0100
Message-ID: <20251203152348.991820924@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

commit 9b45744bf09fc2a3287e05287141d6e123c125a7 upstream.

The vshunt/current reported register is a signed 16bit integer. The
sign bit index should be '15', not '16'.

Fixes: 4396f45d211b ("iio: adc: Add rtq6056 support")
Reported-by: Andy Hsu <andy_ya_hsu@wiwynn.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rtq6056.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/rtq6056.c
+++ b/drivers/iio/adc/rtq6056.c
@@ -300,7 +300,7 @@ static int rtq6056_adc_read_channel(stru
 		return IIO_VAL_INT;
 	case RTQ6056_REG_SHUNTVOLT:
 	case RTQ6056_REG_CURRENT:
-		*val = sign_extend32(regval, 16);
+		*val = sign_extend32(regval, 15);
 		return IIO_VAL_INT;
 	default:
 		return -EINVAL;


