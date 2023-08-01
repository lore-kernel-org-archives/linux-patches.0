Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1501F959
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A011BC433C8;
	Tue,  1 Aug 2023 09:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882475;
	bh=kBBgDVDUZifAbBP8gsbhqfnQWJEadzb/7Jk/QGTido8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4YwhamteLgFRnB2+PHEqg5KFn+c2gxr+3RRBV3ccnbCD5m0IR/iEGgkAjnS8/mBY
	 hYQ6M9ACvTIhRphE+Bgz17uEVqpGBS8a6KKPIAqFnXEnqBTSAgrpEaeLpxzqj7xV4h
	 eCOdahmhRky61gPQpx49JlNDob26JlNkpOeGGgRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/228] media: amphion: Fix firmware path to match linux-firmware
Date: Tue,  1 Aug 2023 11:18:58 +0200
Message-ID: <20230801091925.721169736@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit dcff0b56f661b6b42e828012b464d22cc2068c38 ]

The path did not match the one it was submitted into linux-firmware
which prevented generic distribution from having working CODEC.

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index f9ec1753f7c86..be80410682681 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -828,7 +828,7 @@ static const struct dev_pm_ops vpu_core_pm_ops = {
 
 static struct vpu_core_resources imx8q_enc = {
 	.type = VPU_CORE_TYPE_ENC,
-	.fwname = "vpu/vpu_fw_imx8_enc.bin",
+	.fwname = "amphion/vpu/vpu_fw_imx8_enc.bin",
 	.stride = 16,
 	.max_width = 1920,
 	.max_height = 1920,
@@ -843,7 +843,7 @@ static struct vpu_core_resources imx8q_enc = {
 
 static struct vpu_core_resources imx8q_dec = {
 	.type = VPU_CORE_TYPE_DEC,
-	.fwname = "vpu/vpu_fw_imx8_dec.bin",
+	.fwname = "amphion/vpu/vpu_fw_imx8_dec.bin",
 	.stride = 256,
 	.max_width = 8188,
 	.max_height = 8188,
-- 
2.39.2



