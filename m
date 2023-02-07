Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175682919
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FC3C433EF;
	Tue,  7 Feb 2023 13:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775091;
	bh=goxfcl1FFRAEnODy5PYLrPZbgVVInMCfajJ9h9X4jTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwM1pn0JvoFA116/D8lNqXulKeCa3ufY/4O+EMO/ZN9Y1S2zwVQVx+jFwC+YoF+Hd
	 VaTN398DC9PnuT01ETdT6HfcTOrijn6mzsVEvzKudHTUmYInl3ffLe2WyqmEySWnY5
	 1cubAvqlMMdr9xkQ2/uYRXkFoWAG2ZLhoaXh+g+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Perchanov <dmitry.perchanov@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 133/208] iio: hid: fix the retval in gyro_3d_capture_sample
Date: Tue,  7 Feb 2023 13:56:27 +0100
Message-Id: <20230207125640.449891082@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Perchanov <dmitry.perchanov@intel.com>

commit eb50cd5bfdac61627a5026566cf3b90ced7b141c upstream.

Return value should be zero for success. This was forgotten for timestamp
feature. Verified on RealSense cameras.

Fixes: 4648cbd8fb92 ("iio: hid-sensor-gyro-3d: Add timestamp channel")
Signed-off-by: Dmitry Perchanov <dmitry.perchanov@intel.com>
Link: https://lore.kernel.org/r/7c1809dc74eb2f58a20595f4d02e76934f8e9219.camel@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/hid-sensor-gyro-3d.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -231,6 +231,7 @@ static int gyro_3d_capture_sample(struct
 		gyro_state->timestamp =
 			hid_sensor_convert_timestamp(&gyro_state->common_attributes,
 						     *(s64 *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;


