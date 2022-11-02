Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FE87E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7774C433D6;
	Wed,  2 Nov 2022 03:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359203;
	bh=oyjrOxPhIVbcOY1tmzWJaqYu7495FSYHYMvTzskb8sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVT8rO1URL1+LbA/vzqZ1AyDFC0D8d5qf/gqW9Ct1Vdo3UC6Ua1D+btBAgCTqfNr/
	 yyEf4XJPE6df9JesZDaclAn8SLY2CHrQnE509a/MlBnlHYFUFSm6iwGYdoL8pCXBcS
	 pH1rrfzgR2dL1pHoawT2N7OdC41eczr8/RiJPemE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 68/91] media: vivid: set num_in/outputs to 0 if not supported
Date: Wed,  2 Nov 2022 03:33:51 +0100
Message-Id: <20221102022056.967281804@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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
index f69c64e5a149..761d2abd4006 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -872,8 +872,12 @@ static int vivid_detect_feature_set(struct vivid_dev *dev, int inst,
 
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
@@ -890,8 +894,12 @@ static int vivid_detect_feature_set(struct vivid_dev *dev, int inst,
 
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



