Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5083515CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C50C433D6;
	Tue,  8 Nov 2022 14:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916595;
	bh=gya0bJPhRIzVdB0g3VDNw7gd6/xMQzaHVCvDAQ7OOLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0L765o1GkaZ3kDm0WSQiY+MbpYog79NLrkZ4TLNeIJ/axnubqeq8vC4khJsXf1JpQ
	 c/bWWb1T/cq9gDu7Wu6BKFo9l7rWDnOSueBSO2Xzi3RS/24UBT56NODASbxKZS8ugG
	 N9Y3FBXAuRSkl0zBPwyWcIfQVJ5wt9tYa4Eh7NgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rory Liu <hellojacky0226@hotmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 072/197] media: platform: cros-ec: Add Kuldax to the match table
Date: Tue,  8 Nov 2022 14:38:30 +0100
Message-Id: <20221108133358.135832941@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rory Liu <hellojacky0226@hotmail.com>

[ Upstream commit 594b6bdde2e7833a56413de5092b6e4188d33ff7 ]

The Google Kuldax device uses the same approach as the Google Brask
which enables the HDMI CEC via the cros-ec-cec driver.

Signed-off-by: Rory Liu <hellojacky0226@hotmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/cros-ec/cros-ec-cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
index e5ebaa58be45..6ebedc71d67d 100644
--- a/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
+++ b/drivers/media/cec/platform/cros-ec/cros-ec-cec.c
@@ -223,6 +223,8 @@ static const struct cec_dmi_match cec_dmi_match_table[] = {
 	{ "Google", "Moli", "0000:00:02.0", "Port B" },
 	/* Google Kinox */
 	{ "Google", "Kinox", "0000:00:02.0", "Port B" },
+	/* Google Kuldax */
+	{ "Google", "Kuldax", "0000:00:02.0", "Port B" },
 };
 
 static struct device *cros_ec_cec_find_hdmi_dev(struct device *dev,
-- 
2.35.1



