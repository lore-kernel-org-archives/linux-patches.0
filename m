Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137972108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE7DC433D2;
	Mon, 24 Apr 2023 13:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343444;
	bh=wegdi/JDfRGu8EHJhCCM0Cv8OmE7QPWQ4UqhyOr5EPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1C+zmOnNsY8KhheRuqvdNlKTemzzdzQNt9KoQPx3BWsEUkK3tp+XJ50ttjf2Of7O
	 eSuUDewBzuSJR44cafdCzoCqa3eX2lLIaoxbmYwWoORPSW4/zj9tose7N+gelJNKcZ
	 Yeh5He4YCND+BYsWi/B16CM+mnGlkRH4HPGR5OCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 27/28] iio: adc: at91-sama5d2_adc: fix an error code in at91_adc_allocate_trigger()
Date: Mon, 24 Apr 2023 15:18:48 +0200
Message-Id: <20230424131122.244541163@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
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
@@ -400,7 +400,7 @@ static struct iio_trigger *at91_adc_allo
 	trig = devm_iio_trigger_alloc(&indio->dev, "%s-dev%d-%s", indio->name,
 				      indio->id, trigger_name);
 	if (!trig)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	trig->dev.parent = indio->dev.parent;
 	iio_trigger_set_drvdata(trig, indio);


