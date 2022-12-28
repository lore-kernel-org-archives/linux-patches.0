Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAE91875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D8DC433D2;
	Wed, 28 Dec 2022 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243351;
	bh=O06DxMDpDwReMJaTUXeOMuW1sdenikFy2frdIqBET2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLvKbNiFqQ6zTC7dLxCDcPwM3HWZyDn4M7bjs2AZWBy30djzhB301wb02dxpqWysw
	 E8yOwvV79mWXz3V6A8NSwdL6+vtLOuXge9xyZGNKGZQBTsHvkKym4jyI1oyeC7MfAQ
	 5oJyTeuq9h/FbTBWRA+iCtYvzvZmyYTLg8uyRssk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guoniu.zhou" <guoniu.zhou@nxp.com>,
	Jacopo Mondi <jacopo@jmondi.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0483/1146] media: ov5640: set correct default link frequency
Date: Wed, 28 Dec 2022 15:33:42 +0100
Message-Id: <20221228144343.301873822@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guoniu.zhou <guoniu.zhou@nxp.com>

[ Upstream commit d7b41196927ba2a2b5badad1a85f9087eb90b076 ]

current_link_freq field in ov5640_dev structure is link frequency,
not link frequency array index, so correct it.

Fixes: 3c28588f35d3 ("media: ov5640: Update pixel_rate and link_freq")
Signed-off-by: Guoniu.zhou <guoniu.zhou@nxp.com>
Acked-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 2d740397a5d4..3f6d715efa82 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3817,7 +3817,8 @@ static int ov5640_probe(struct i2c_client *client)
 	sensor->current_mode =
 		&ov5640_mode_data[OV5640_MODE_VGA_640_480];
 	sensor->last_mode = sensor->current_mode;
-	sensor->current_link_freq = OV5640_DEFAULT_LINK_FREQ;
+	sensor->current_link_freq =
+		ov5640_csi2_link_freqs[OV5640_DEFAULT_LINK_FREQ];
 
 	sensor->ae_target = 52;
 
-- 
2.35.1



