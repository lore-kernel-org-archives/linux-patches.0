Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1838E1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E43DC433C7;
	Tue,  1 Aug 2023 09:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883054;
	bh=+21/ymggUEfksUToKNnnOu9YT62fk9C0mkY8CafhxXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVzJ27a5M69hsIvJ7pSMb+/8nYo8RBtz/QCACqeDas1lKk9vtkgWuqtZ92749Wjto
	 TYjmQx3bCb7Jsz8Lhmm21+ZawG3f20RsQy3SujqS/pIpK6hJ1USN32a4hxZaT7vWTH
	 rjLPOJGqlWqz8mWwJ2l1/oNNAz6fzLDMp4AqmEDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 060/239] media: amphion: Fix firmware path to match linux-firmware
Date: Tue,  1 Aug 2023 11:18:44 +0200
Message-ID: <20230801091927.814036325@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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
index de23627a119a0..82bf8b3be66a2 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -826,7 +826,7 @@ static const struct dev_pm_ops vpu_core_pm_ops = {
 
 static struct vpu_core_resources imx8q_enc = {
 	.type = VPU_CORE_TYPE_ENC,
-	.fwname = "vpu/vpu_fw_imx8_enc.bin",
+	.fwname = "amphion/vpu/vpu_fw_imx8_enc.bin",
 	.stride = 16,
 	.max_width = 1920,
 	.max_height = 1920,
@@ -841,7 +841,7 @@ static struct vpu_core_resources imx8q_enc = {
 
 static struct vpu_core_resources imx8q_dec = {
 	.type = VPU_CORE_TYPE_DEC,
-	.fwname = "vpu/vpu_fw_imx8_dec.bin",
+	.fwname = "amphion/vpu/vpu_fw_imx8_dec.bin",
 	.stride = 256,
 	.max_width = 8188,
 	.max_height = 8188,
-- 
2.39.2



