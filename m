Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2236219E7F9;
	Mon, 23 Jun 2025 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717141; cv=none; b=Vtu5FXi47QOiXy46FZMoXutma+8MVPO6yHIRuZGtPqfXhsrI8oThOCMTJh1Kiu8W1paFjIcVayURK1IiG25lMnkmGFQkjvSFN1lY1/2lMJYWgfZmkrPiz82H8Spj+EGieVM+xV1Ckkn7tSxKe8TsrSluSiR49Md1kyVGmV+Qexc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717141; c=relaxed/simple;
	bh=7c4x0Wd+2uP4bwFRv73uJFJ4b6w39t9hAUf9TGNeG44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgncJXLwvx2a4gCJ9DKyqTJHb7szeDeXfWYnGmjMAni+QPBSyTiDZg8kxR5agKcDm2OKYxOd8H+o5bhT3bFme0KYsO43X+8yCTOIKmPH4aaeKy/+bMpL1b9nrcbkIIk2XVNkagT8My+O/fC9h1aYBJ37yrn9Y50tsT/7GxEFV78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqZqS5Wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqZqS5Wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE3FC4CEEA;
	Mon, 23 Jun 2025 22:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717141;
	bh=7c4x0Wd+2uP4bwFRv73uJFJ4b6w39t9hAUf9TGNeG44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqZqS5WkPwrrgj9gBa0uvh+1yYz5R65XVLGUxVjLCf8v+8Tv2vRfNQc1aAQ9t4Fqq
	 Jb94TU8uJuod0Fw+bfY6ZHrW7IQmUopJenQg23oLINGgBKHAa/wtuk2rqDXGnnS/3T
	 aRNLzgrv5+6d6cjEFVyWZQhz2TQDUlQU3mNhgRNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 371/508] iio: accel: fxls8962af: Fix temperature scan element sign
Date: Mon, 23 Jun 2025 15:06:56 +0200
Message-ID: <20250623130654.469139821@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit 9c78317b42e7c32523c91099859bc4721e9f75dd upstream.

Mark the temperature element signed, data read from the TEMP_OUT register
is in two's complement format.
This will avoid the temperature being mishandled and miss displayed.

Fixes: a3e0b51884ee ("iio: accel: add support for FXLS8962AF/FXLS8964AF accelerometers")
Suggested-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250505-fxls-v4-2-a38652e21738@geanix.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/fxls8962af-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -738,6 +738,7 @@ static const struct iio_event_spec fxls8
 			      BIT(IIO_CHAN_INFO_OFFSET),\
 	.scan_index = -1, \
 	.scan_type = { \
+		.sign = 's', \
 		.realbits = 8, \
 		.storagebits = 8, \
 	}, \


