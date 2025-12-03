Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73D336C5A7;
	Wed,  3 Dec 2025 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780668; cv=none; b=aLE+jxwWt6rUO9bNSr1fFyVCCLNQWljniDfH8Hij+7f59jmGRrH37g61u0XxlsMA0wnfJSrMa0K5YJMt4szcvIB5UEFyG/m7zfSCqGuNR/jxXM4xB03vJIr+4GXQMdv+HqMzRsmo9gDfh6JJ61zkhQM4mYcWZ94FAdfzu8XcMyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780668; c=relaxed/simple;
	bh=hwAvT5YVBeMDBzyxEVgGHjtm4l4vdRpjAqf9EqoFfDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryQkHhlJr14enQ13i2G3fF9W3keJxOP0hy7hWDS69mL0PJwybTFb6TdWfW7xWBzhW/Q3jECYdENI1mEiHXzUnfBYVK3aZbJxto6WRvzqaWcGq8RuI0lp9i3VoBtecSaDXNbieHHNNlg5PYhEcSDqm2mw0QIZgC8R7kzBuiIwDVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdEbQcUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdEbQcUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359CCC116C6;
	Wed,  3 Dec 2025 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780668;
	bh=hwAvT5YVBeMDBzyxEVgGHjtm4l4vdRpjAqf9EqoFfDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdEbQcUhKesFh7F5++85U1mHefw3DiWPsoHfJgtPaRRxVJfHcH7rViSkFwOqgkobi
	 a9sT9MgQd2pT3XuzLeoPHuAyxvZQdHmtPW+EcxzOi5gWWwN0kBBY/9vdkCQJPeUuCs
	 G8D+rfhuj/FNp57ykLSPu9Xj9VK6obArnhqNMCo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lesiak <chris.lesiak@licorbio.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 054/132] iio: humditiy: hdc3020: fix units for temperature and humidity measurement
Date: Wed,  3 Dec 2025 16:28:53 +0100
Message-ID: <20251203152345.298343082@linuxfoundation.org>
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

From: Dimitri Fedrau <dimitri.fedrau@liebherr.com>

commit 7b8dc11c0a830caa0d890c603d597161c6c26095 upstream.

According to the ABI the units after application of scale and offset are
milli degrees for temperature measurements and milli percent for relative
humidity measurements. Currently the resulting units are degree celsius for
temperature measurements and percent for relative humidity measurements.
Change scale factor to fix this issue.

Fixes: c9180b8e39be ("iio: humidity: Add driver for ti HDC302x humidity sensors")
Reported-by: Chris Lesiak <chris.lesiak@licorbio.com>
Suggested-by: Chris Lesiak <chris.lesiak@licorbio.com>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Dimitri Fedrau <dimitri.fedrau@liebherr.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/hdc3020.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/humidity/hdc3020.c b/drivers/iio/humidity/hdc3020.c
index ffb25596d3a8..8aa567d9aded 100644
--- a/drivers/iio/humidity/hdc3020.c
+++ b/drivers/iio/humidity/hdc3020.c
@@ -301,9 +301,9 @@ static int hdc3020_read_raw(struct iio_dev *indio_dev,
 	case IIO_CHAN_INFO_SCALE:
 		*val2 = 65536;
 		if (chan->type == IIO_TEMP)
-			*val = 175;
+			*val = 175 * MILLI;
 		else
-			*val = 100;
+			*val = 100 * MILLI;
 		return IIO_VAL_FRACTIONAL;
 
 	case IIO_CHAN_INFO_OFFSET:
-- 
2.52.0



