Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488067C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2463C433EF;
	Mon, 24 Apr 2023 13:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342513;
	bh=c3XQw70ulSJANuu9SOUbuqCOOyjdoP4Eg6ETQfnC3SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyJAJvPqlx98jLZbyIHzYVR7hwXPCc5Wt8xiJnNGIXg/6MCcymgZQSXE80oyhZY4z
	 749Y2/3P4L89j1OYqC21vxnxs09QZW7gFCNrtv2m56IAQuQajQNtqQvBBOjQHNSYRZ
	 K8AhchkgXpj6YGwf1Xsb40jrJDLirrVcm9FO16tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 67/73] iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()
Date: Mon, 24 Apr 2023 15:17:21 +0200
Message-Id: <20230424131131.558921293@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

commit 73a428b37b9b538f8f8fe61caa45e7f243bab87c upstream.

The at91_adc_allocate_trigger() function is supposed to return error
pointers.  Returning a NULL will cause an Oops.

Fixes: 5e1a1da0f8c9 ("iio: adc: at91-sama5d2_adc: add hw trigger and buffer support")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/5d728f9d-31d1-410d-a0b3-df6a63a2c8ba@kili.mountain
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1000,7 +1000,7 @@ static struct iio_trigger *at91_adc_allo
 	trig = devm_iio_trigger_alloc(&indio->dev, "%s-dev%d-%s", indio->name,
 				iio_device_id(indio), trigger_name);
 	if (!trig)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	trig->dev.parent = indio->dev.parent;
 	iio_trigger_set_drvdata(trig, indio);


