Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA77B749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA166C433F0;
	Thu, 12 Jan 2023 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532607;
	bh=ubAnc0ZCxNmJNm4glhdCyBOaacxvA6XoOMzOFAlwACI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpMHmp/YF7KJlaphrkS+zBrTYNgJ1UnTk4W5l9U0Xu297CVudc/zSFandldWd+0AU
	 kWvq3NtGEVhh4O2fsO3+0cYjLF/afy4VZGfL3pf8PTSPmTuoWds4K7c3xtknkcjgQ0
	 OHRMhGDpfxDxRy+EoeaSnBYIt4mv6ZRiPigmCXgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/783] media: saa7164: fix missing pci_disable_device()
Date: Thu, 12 Jan 2023 14:48:54 +0100
Message-Id: <20230112135534.453462490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 57fb35d7542384cac8f198cd1c927540ad38b61a ]

Add missing pci_disable_device() in the error path in saa7164_initdev().

Fixes: 443c1228d505 ("V4L/DVB (12923): SAA7164: Add support for the NXP SAA7164 silicon")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7164/saa7164-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 6c08b77bfd47..3cadfbe60fe6 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1270,7 +1270,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 	if (saa7164_dev_setup(dev) < 0) {
 		err = -EINVAL;
-		goto fail_free;
+		goto fail_dev;
 	}
 
 	/* print pci info */
@@ -1438,6 +1438,8 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 
 fail_irq:
 	saa7164_dev_unregister(dev);
+fail_dev:
+	pci_disable_device(pci_dev);
 fail_free:
 	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
-- 
2.35.1



