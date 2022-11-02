Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E7F7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D544C433C1;
	Wed,  2 Nov 2022 03:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358643;
	bh=yfVJnj4qU7DBg9U0o/KgIym9BIKgQvZmw+EgfH7OQII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij3Yz78zj5KHTx3dMOknMhq0XZIr3gjaU/VqRv2vB/yc99qC/Etf4vKi5VuMbHa2d
	 +1ZyDJN42cYQtp1QXVCgt6557r28fFCRLxQYhijxlfeexSZDz/lVCgKhTtgONKKHzI
	 dDHa/GVfkg4AS7fZ+DNrs/7K+jDydKI4PPS7K2Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/132] media: vivid: set num_in/outputs to 0 if not supported
Date: Wed,  2 Nov 2022 03:33:23 +0100
Message-Id: <20221102022102.182328924@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 69d78a80da4ef12faf2a6f9cfa2097ab4ac43983 ]

If node_types does not have video/vbi/meta inputs or outputs,
then set num_inputs/num_outputs to 0 instead of 1.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 0c90f649d2f5 (media: vivid: add vivid_create_queue() helper)
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-core.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index e7cc70a92683..065bdc33f049 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -932,8 +932,12 @@ static int vivid_detect_feature_set(struct vivid_dev *dev, int inst,
 
 	/* how many inputs do we have and of what type? */
 	dev->num_inputs = num_inputs[inst];
-	if (dev->num_inputs < 1)
-		dev->num_inputs = 1;
+	if (node_type & 0x20007) {
+		if (dev->num_inputs < 1)
+			dev->num_inputs = 1;
+	} else {
+		dev->num_inputs = 0;
+	}
 	if (dev->num_inputs >= MAX_INPUTS)
 		dev->num_inputs = MAX_INPUTS;
 	for (i = 0; i < dev->num_inputs; i++) {
@@ -950,8 +954,12 @@ static int vivid_detect_feature_set(struct vivid_dev *dev, int inst,
 
 	/* how many outputs do we have and of what type? */
 	dev->num_outputs = num_outputs[inst];
-	if (dev->num_outputs < 1)
-		dev->num_outputs = 1;
+	if (node_type & 0x40300) {
+		if (dev->num_outputs < 1)
+			dev->num_outputs = 1;
+	} else {
+		dev->num_outputs = 0;
+	}
 	if (dev->num_outputs >= MAX_OUTPUTS)
 		dev->num_outputs = MAX_OUTPUTS;
 	for (i = 0; i < dev->num_outputs; i++) {
-- 
2.35.1



