Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1DD1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1BFC433D6;
	Wed, 23 Nov 2022 09:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197274;
	bh=xHDR+dG8nl0mSjuWI4uVWoZwZCT7PEp/mGc7sjvlfJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPTWygkbahz4lTMQ5RytJQsVlKy+q49jRx/fiw9f1OLZ1X3RNKl4CBZdN8ryGt5W+
	 mBugObb26HX+XjEX39xPO3JC/F8Wmtl5YDBcgFBwDu23fKGj7HbnuqY0cCk/MYd1MP
	 k3iyDQRwQPwbjeqzsb/UwsbIZ0EHwpngF1CNwlCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Sekar <sravanhome@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 248/314] iio: adc: mp2629: fix potential array out of bound access
Date: Wed, 23 Nov 2022 09:51:33 +0100
Message-Id: <20221123084636.749533707@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saravanan Sekar <sravanhome@gmail.com>

commit ca1547ab15f48dc81624183ae17a2fd1bad06dfc upstream.

Add sentinel at end of maps to avoid potential array out of
bound access in iio core.

Fixes: 7abd9fb64682 ("iio: adc: mp2629: Add support for mp2629 ADC driver")
Signed-off-by: Saravanan Sekar <sravanhome@gmail.com>
Link: https://lore.kernel.org/r/20221029093000.45451-4-sravanhome@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/mp2629_adc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/mp2629_adc.c
+++ b/drivers/iio/adc/mp2629_adc.c
@@ -57,7 +57,8 @@ static struct iio_map mp2629_adc_maps[]
 	MP2629_MAP(SYSTEM_VOLT, "system-volt"),
 	MP2629_MAP(INPUT_VOLT, "input-volt"),
 	MP2629_MAP(BATT_CURRENT, "batt-current"),
-	MP2629_MAP(INPUT_CURRENT, "input-current")
+	MP2629_MAP(INPUT_CURRENT, "input-current"),
+	{ }
 };
 
 static int mp2629_read_raw(struct iio_dev *indio_dev,


