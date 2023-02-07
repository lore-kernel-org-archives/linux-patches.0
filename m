Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0596329CA
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A744C4339B;
	Tue,  7 Feb 2023 13:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775094;
	bh=sP9NFXg/tlRbb+P7nepIMIFKhcsu2YgWBrOPUaw2VAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CudZhk0jW6rI/c/d/zV6aG14zcK2WHvmYr6/aJ58jhrXKf0web96YJyRZXpoRzMfe
	 Wwubdu4tFl1S97AvroXjbycpc/+8Idr0ZCjNyBFw+liBZEZab7sjzJIClP5lIK9tXP
	 f3r2tiMEVI0ODGUluYptf045igiCWLjoSOH6W4LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Pagani <marpagan@redhat.com>,
	Michal Simek <michal.simek@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 134/208] iio: adc: xilinx-ams: fix devm_krealloc() return value check
Date: Tue,  7 Feb 2023 13:56:28 +0100
Message-Id: <20230207125640.500768222@linuxfoundation.org>
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

From: Marco Pagani <marpagan@redhat.com>

commit 6794ed0cfcc6ce737240eccc48b3e8190df36703 upstream.

The clang-analyzer reported a warning: "Value stored to 'ret'
is never read".

Fix the return value check if devm_krealloc() fails to resize
ams_channels.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20221125113112.219290-1-marpagan@redhat.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-ams.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -1329,7 +1329,7 @@ static int ams_parse_firmware(struct iio
 
 	dev_channels = devm_krealloc(dev, ams_channels, dev_size, GFP_KERNEL);
 	if (!dev_channels)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	indio_dev->channels = dev_channels;
 	indio_dev->num_channels = num_channels;


