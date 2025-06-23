Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F799252912;
	Mon, 23 Jun 2025 13:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684902; cv=none; b=Jo0D5+o3TQQPncVRl0/llMJ4zXrV+YDWMkFyLgIJhz8/fHx/G0YYnmArdNifSkzUS0AFlr8SvOZLPYXp8aUAQICAGDIY07Gtpmo0y3npPV9Li9kowYmei0p7Nsh+kQxUiwO+oNQjF1djr/VD0kyhlEW5dcvx2OeCSVyPT7mrxOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684902; c=relaxed/simple;
	bh=+/gPUGpsUdtM/wRpKaPPr3gmXCpXgM1hK68KptBOrSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANU5bxBdjNsdV4JVX80ZSGYk9iFL0mvsRkiEBuPKErnUtvohNSaZuje4oyOHfpFD5+Le7NCbTp8AkXjXlrbp3b8eXOmEtEaLO20oVWgaRiE+44FqhAuHZc1PmWfnnzY25AKD2N7qseidGuqiGjrszQvobZw4ie78jHnthI+R9kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJdQmubv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJdQmubv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B10C4CEEA;
	Mon, 23 Jun 2025 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684901;
	bh=+/gPUGpsUdtM/wRpKaPPr3gmXCpXgM1hK68KptBOrSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJdQmubv/+JLceLjfqEqmXtdZmTLd9lnNfEPfpmiIJtK/4UdFuM1dgdPfiJ4+mlSA
	 8JIfqAYbbGqiRDrCi4Zs6P3N1bitHamAkSLh8q0Hnpwe9pzJ1SqkCKJtqB1GYpmCow
	 +PLZ0+HzvBv2fXrgry8F93pCEJ67Q0TrfDzQ0wws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 188/592] iio: accel: fxls8962af: Fix temperature scan element sign
Date: Mon, 23 Jun 2025 15:02:26 +0200
Message-ID: <20250623130704.754945235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -739,6 +739,7 @@ static const struct iio_event_spec fxls8
 			      BIT(IIO_CHAN_INFO_OFFSET),\
 	.scan_index = -1, \
 	.scan_type = { \
+		.sign = 's', \
 		.realbits = 8, \
 		.storagebits = 8, \
 	}, \


