Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06082C433C8;
	Sun, 13 Aug 2023 21:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963014;
	bh=bhPgTdJt7BL0YakLjah9u5myML6RzhTJaXXQDhgTapU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tqvuypryt8x0LYd7NeiKPo3REkuzWdl/nAHqwlhhnnK3nrWbF0v+0VWuEJvCC4eg/
	 C0xNqIQp3fMys0zUeyCNQyUCeXYv9sI2+yJW+MH562u/nlzFnm2rwbpIkT6Ek/DE1V
	 +73tQDP1dbNcyPSpDuynaHGwZRKwpfCTdfP+Qdes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Yiyuan Guo <yguoaz@gmail.com>,
	Stable@vger.kerenl.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 21/89] iio: cros_ec: Fix the allocation size for cros_ec_command
Date: Sun, 13 Aug 2023 23:19:12 +0200
Message-ID: <20230813211711.397291257@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yiyuan Guo <yguoaz@gmail.com>

commit 8a4629055ef55177b5b63dab1ecce676bd8cccdd upstream.

The struct cros_ec_command contains several integer fields and a
trailing array. An allocation size neglecting the integer fields can
lead to buffer overrun.

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Yiyuan Guo <yguoaz@gmail.com>
Fixes: 974e6f02e27e ("iio: cros_ec_sensors_core: Add common functions for the ChromeOS EC Sensor Hub.")
Link: https://lore.kernel.org/r/20230630143719.1513906-1-yguoaz@gmail.com
Cc: <Stable@vger.kerenl.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -259,7 +259,7 @@ int cros_ec_sensors_core_init(struct pla
 	platform_set_drvdata(pdev, indio_dev);
 
 	state->ec = ec->ec_dev;
-	state->msg = devm_kzalloc(&pdev->dev,
+	state->msg = devm_kzalloc(&pdev->dev, sizeof(*state->msg) +
 				max((u16)sizeof(struct ec_params_motion_sense),
 				state->ec->max_response), GFP_KERNEL);
 	if (!state->msg)


