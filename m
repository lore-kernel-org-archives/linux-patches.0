Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AE9223714;
	Mon, 23 Jun 2025 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715110; cv=none; b=Vr8lajn6ZtSP6yL+vA+tzHmn1ReMjlGBsHt6dr2/QLqCR5PVkwCH+4VhALci/6ymm2f+lOHrwPJZK9SXPhegH1od9JUgCpF2cNjtRkRkNWRauK7XsuHiCI0MnOvygzpQOAcnk6RoAQvtN42XRcFO3EtzHS34+3C6VwzKX1CuIV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715110; c=relaxed/simple;
	bh=u+zwmQDeQqRHn/kdB7qKpbQO883udrKmQYc98ISc9Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFkZCW1YHF45ZPnkB3eegVfj79rbQWxOcLeFNVj1sYSMbU7x/2McycjaNaI8jquDZuDIL1d1frJpv9xT1Riv8QL3DfHjmQOROuI4TBTCVBOBpBusL6T5EPm4Y77kTRmXwgCAa046EEU+DpPsd6yBYSHFIzbXrmfjE2lPSjt3/pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnjh15Rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnjh15Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FBBC4CEEA;
	Mon, 23 Jun 2025 21:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715110;
	bh=u+zwmQDeQqRHn/kdB7qKpbQO883udrKmQYc98ISc9Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnjh15Rba7gHbj3zcFQKNqsathgqJZg+gpBXSRlY9DFsj3o61fIixFgy6cavL3YTH
	 x7qAgWiFOqBWolWcjvI+JlqdHCO4GoJc/aAT2UuSCYann8YxsB1vnWpqW4sdammmVD
	 ovY7bTlo4LboWTbw3m9bGzcED0xg9mHn+k8kV1lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 156/414] iio: accel: fxls8962af: Fix temperature scan element sign
Date: Mon, 23 Jun 2025 15:04:53 +0200
Message-ID: <20250623130645.941696571@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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


