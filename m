Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C9022173D;
	Mon, 23 Jun 2025 21:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714081; cv=none; b=dReKU8ivxUQ0LRQdttOC5JluDAWQJZhX8UiVF+WHTIMUchjoiqC5b+OYyZgdkCrGyem4ErIuAO0F3WNrEpG0ASvxKnpangFEjGrnwdCCAONpHTcbOwM4X+nfF+FRUYNOwDrnaE264ZIN/fk6zJlqekAis8chJD3oyp8P2q9DlzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714081; c=relaxed/simple;
	bh=/9rZbjx7wgAZefd/W4fKwDDchEjdNXOYtUciA4zNMUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJYo5ikcdVwTsAfW+HG3bxIoH3HKnAm+0rYomlzrn3yTL//n0Y5J9zrvziwflYt8S8sJpS3SbRDNdxcXxnoo52BiNYL+mFIbwx/FOEpQk4Y5ee+9xGAPCuRj9YETL8KWoKPm7OQ0EQTiimWeRVbnvsWDceDb/r0jGg3xf8A7uUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2Yqw0Cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2Yqw0Cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74858C4CEEA;
	Mon, 23 Jun 2025 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714081;
	bh=/9rZbjx7wgAZefd/W4fKwDDchEjdNXOYtUciA4zNMUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2Yqw0CvvoYEqAqe99fa/KML01ERfCX437rW/4W0Uri9kZlxMDpURaQ0IUjye4+7t
	 iSVs7X7BR8zxx+uLiN7azDhMWdJreZOinP6Z4uolendPfdW/GDoaP4WLvA0Mwz04qv
	 gnZa+cSL8e9xRJzlN0Qzm8R9zN794JyvIuwFJMOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 112/290] iio: accel: fxls8962af: Fix temperature scan element sign
Date: Mon, 23 Jun 2025 15:06:13 +0200
Message-ID: <20250623130630.322962524@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -737,6 +737,7 @@ static const struct iio_event_spec fxls8
 			      BIT(IIO_CHAN_INFO_OFFSET),\
 	.scan_index = -1, \
 	.scan_type = { \
+		.sign = 's', \
 		.realbits = 8, \
 		.storagebits = 8, \
 	}, \


