Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC433212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72C8C433EF;
	Tue,  7 Feb 2023 13:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775567;
	bh=CQD2zTRv6IvxSk0ehkLp5YyyC7+HnZAr7mRo/tKTSBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPq+mYjnZ7cKk3/fDYtEUUULaqR1q45V86vXjT8THRn5AjT9xkkctHm31LHweK2rq
	 VHtnnwNkV5JGvs3Uj8a42e73vRVEfIGhJJcMQqmFcYyJOYdOMFviZwtj8bCOjwpIYF
	 ZbhERMCNZrGGzyuHVsmY4hf0cCGrpqEM/adOMiaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 084/120] iio: imu: fxos8700: remove definition FXOS8700_CTRL_ODR_MIN
Date: Tue,  7 Feb 2023 13:57:35 +0100
Message-Id: <20230207125622.325745555@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carlos Song <carlos.song@nxp.com>

commit ff5e2cd92ffda9a25ffa2cbdb3a0cf17650172a6 upstream.

FXOS8700_CTRL_ODR_MIN is not used but value is probably wrong.

Remove it for a good readability.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20230118074227.1665098-4-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -146,7 +146,6 @@
 
 /* Bit definitions for FXOS8700_CTRL_REG1 */
 #define FXOS8700_CTRL_ODR_MAX       0x00
-#define FXOS8700_CTRL_ODR_MIN       GENMASK(4, 3)
 #define FXOS8700_CTRL_ODR_MSK       GENMASK(5, 3)
 
 /* Bit definitions for FXOS8700_M_CTRL_REG1 */


