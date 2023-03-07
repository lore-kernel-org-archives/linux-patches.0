Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874EEBA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8342C433EF;
	Tue,  7 Mar 2023 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215837;
	bh=prsMAXBLEpmcHoAVQhQ3yXiTOi7C3nvSr56IzG4XjhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRmBRCbjS4n9NCkSvkuZ+5hGJ8xMQXSoH/3XrR/u1Wxupjc8i8WiHGgHUT55oZlT3
	 rze0b+PX6WRsC9bFC/BbF0acSbY1yhlTpttgT+wuolVzvF1fwe7dSvN+cwrKJzFvmb
	 t2/zOxK4mtuXvf3gZIcri+hS0R75Zc9ZXfLfXDRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 363/567] media: saa7134: Use video_unregister_device for radio_dev
Date: Tue,  7 Mar 2023 18:01:39 +0100
Message-Id: <20230307165921.591837766@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit bc7635c6435c77a0c168e2cc6535740adfaff4e4 ]

The radio device doesn't use vb2, thus calling vb2_video_unregister_device()
which results in the following warning being printed on module unload.

WARNING: CPU: 1 PID: 215963 at drivers/media/common/videobuf2/videobuf2-v4l2.c:1236 vb2_video_unregister_device+0xc6/0xe0 [videobuf2_v4l2]

Fixes: 11788d9b7e91 ("media: media/pci: use vb2_video_unregister_device()")
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 96328b0af1641..cf2871306987c 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -978,7 +978,7 @@ static void saa7134_unregister_video(struct saa7134_dev *dev)
 	}
 	if (dev->radio_dev) {
 		if (video_is_registered(dev->radio_dev))
-			vb2_video_unregister_device(dev->radio_dev);
+			video_unregister_device(dev->radio_dev);
 		else
 			video_device_release(dev->radio_dev);
 		dev->radio_dev = NULL;
-- 
2.39.2



