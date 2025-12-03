Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D1A393DC8;
	Wed,  3 Dec 2025 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780685; cv=none; b=Mhfp8qRDoA62G05M/R2V5TGxDf//WovafJX2Nxx9kbIZ6eL9Kc4i5He0k/nyJZI8KSMBwwx6eN35G7R7IbG4JOkNpOcaaTW+2CJRO7eeUFxgYzRUeidUDl08etOvAiSwZSBM9iTjgOpxVSUmOYUucCpLu0ipJoT0HkpHVBN3iWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780685; c=relaxed/simple;
	bh=xYYgnEs+7y053+nGplvB4Szg/BuZhm1eFzSUv5EiuGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdjlsP7BMRYAt0aUXq9IFpvEBJWRdqxvTaMGlk4KTGYlHdXWtHxtla2mZitTvu6vR7yFChPkjGOgap1K+F4ZbAqkX/LQloxe2pmiQX6LkDccLIUSE+8/exwdekKXv/TnpNbq9CaLJjrs3CMR0lXrC91M4VX2zLsTopHwqwCFl5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWC0CAbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWC0CAbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20748C4CEF5;
	Wed,  3 Dec 2025 16:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780685;
	bh=xYYgnEs+7y053+nGplvB4Szg/BuZhm1eFzSUv5EiuGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWC0CAbmFtIcjKYVrT92zagZS49zR/Uij3wJHMbVlLZTbW62QN9mlwNKj7ynvSLZz
	 WZ8bsEQiQfgmNKNw9t1AygbSNmMOyEjaMO9o4oBROoVyU0LHLOjgxNyYAQHoI+7v0H
	 fbCqZE8QVMjhxCScRLxOwmTF8kpUcA8lJKmVrKTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 058/132] iio: adc: stm32-dfsdm: fix st,adc-alt-channel property handling
Date: Wed,  3 Dec 2025 16:28:57 +0100
Message-ID: <20251203152345.446334559@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Moysan <olivier.moysan@foss.st.com>

commit 8a6b7989ff0cd0a95c93be1927f2af7ad10f28de upstream.

Initially st,adc-alt-channel property was defined as an enum in the DFSDM
binding. The DFSDM binding has been changed to use the new IIO backend
framework, along with the adoption of IIO generic channels.
In this new binding st,adc-alt-channel is defined as a boolean property,
but it is still handled has an enum in DFSDM driver.
Fix st,adc-alt-channel property handling in DFSDM driver.

Fixes: 3208fa0cd919 ("iio: adc: stm32-dfsdm: adopt generic channels bindings")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-dfsdm-adc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/stm32-dfsdm-adc.c
+++ b/drivers/iio/adc/stm32-dfsdm-adc.c
@@ -721,9 +721,8 @@ static int stm32_dfsdm_generic_channel_p
 	}
 	df_ch->src = val;
 
-	ret = fwnode_property_read_u32(node, "st,adc-alt-channel", &df_ch->alt_si);
-	if (ret != -EINVAL)
-		df_ch->alt_si = 0;
+	if (fwnode_property_present(node, "st,adc-alt-channel"))
+		df_ch->alt_si = 1;
 
 	if (adc->dev_data->type == DFSDM_IIO) {
 		backend = devm_iio_backend_fwnode_get(&indio_dev->dev, NULL, node);


