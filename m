Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888C339A27A;
	Wed,  3 Dec 2025 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780840; cv=none; b=hAVqD1edrpx5EzyK3EQNCZ00Ja1exdDdHpDa9kvdkfb1uBXPj1ietc1EzW8QQk8dUD+An/13f3XJPuQDym6ExLS/n5jJr/fR9EQaEnV8V9vHPMsOmQzVhmeTq8lqudHqXoq8SwpDLf6axy2UwJgpZDWOLbJdafLpqTXUDfo0l9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780840; c=relaxed/simple;
	bh=L9ERdOo2BdeaN2bgxerimMHL9FLdvLU7sNMcS8u+bYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px6nw+ATVUfgtlvrKP1uJsH2Ehm1pBCWUrMUr9wLOQ8hiGzZ8XOeUf9+YuXzeHkOhVq732VKWX4SKgzrjfPnTFsYILNrdU6nwEhLI+glJlxrYL/YWs0bllXMfjeEoeULkye3zVhVgOIOgEHghE+6mNoE2uMwQriUEpYRJ8OPDlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgDUHKvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgDUHKvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF374C4CEF5;
	Wed,  3 Dec 2025 16:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780839;
	bh=L9ERdOo2BdeaN2bgxerimMHL9FLdvLU7sNMcS8u+bYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgDUHKvdQXoJV3NXGRcOm5lREIj/sDZLNRBMBRx3DlFdl+GY8FSn4FS9Qa6yqAROK
	 fsPj84LK4tfsS6j+ltYXfnlgqtF1fee4634v5CSu5c0sjobmDc6CBqlKREBGkQfwGg
	 4Ngu9W0miJAla44tJSb5c3DAJNO0Y/5clFMoZRnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Hsu <andy_ya_hsu@wiwynn.com>,
	ChiYuan Huang <cy_huang@richtek.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 062/132] iio: adc: rtq6056: Correct the sign bit index
Date: Wed,  3 Dec 2025 16:29:01 +0100
Message-ID: <20251203152345.593354603@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


