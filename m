Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C537744AB6F;
	Tue, 21 Jul 2026 21:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667782; cv=none; b=En3eEx4WcDvJcNRDBhEjrfMIMIOINvDr4rDWq/W/JFB49gFKxjkfv0qZI0U+dPzk0wCdzxbO6XJtkGi+Hl65icsDnIaPbhqIIFCLw4IkIUEsyY6oErXJJQx/ZjgjNt6BFCYITNDLkvoasryDiseJIgtTIrsZmk3ZNTfSPJ2yVCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667782; c=relaxed/simple;
	bh=qxTngM44S1tmdtLXBapplZc1tysbAuyrPhlYcUdPyBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dCJMbLL+FOq135LVZjr8/HLQGxm/1OKAEAIIKi2iDigCgsjVaJHlToGKSQ4kKgPx0bYjhc/IRfkW56k7cgsmh3pPwbVTHF9Saka9LfZMzq2lGU0Apo8WZuBmtTLe0aHB0Uvarjkv4kNtieSrTYGxcS7AKNm9VzeycdyvxucNSm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmKZq3Ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmKZq3Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9903B1F00A3A;
	Tue, 21 Jul 2026 21:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667774;
	bh=JDubG4Cu6QFtcZDIAwFK2250bdE3/pW0+JTNMGyYo6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmKZq3QlgmeVAdcl+HuMqqIvyyh6Nh5+bUSGU8wpyfrjOWtuA0xIWDyNSB6YmEJzT
	 qC9/9gfdyeYqAmTQG84PfN34owv8G/G30TCY2oCjzfBHaIOI1YKIVh64h8Df7U60lt
	 KgOYTFdusqDwub6M2bTbVok6CzEuT0Tq/9Y6/HiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1187/1266] media: nxp: imx8-isi: Convert to platform remove callback returning void
Date: Tue, 21 Jul 2026 17:27:04 +0200
Message-ID: <20260721152508.357495840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e992ee7eb56f827088f63c9d5210ab4da25a5c4d ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: b670bf89824e ("media: nxp: imx8-isi: Fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
@@ -508,7 +508,7 @@ err_pm:
 	return ret;
 }
 
-static int mxc_isi_remove(struct platform_device *pdev)
+static void mxc_isi_remove(struct platform_device *pdev)
 {
 	struct mxc_isi_dev *isi = platform_get_drvdata(pdev);
 	unsigned int i;
@@ -525,8 +525,6 @@ static int mxc_isi_remove(struct platfor
 	mxc_isi_v4l2_cleanup(isi);
 
 	pm_runtime_disable(isi->dev);
-
-	return 0;
 }
 
 static const struct of_device_id mxc_isi_of_match[] = {
@@ -539,7 +537,7 @@ MODULE_DEVICE_TABLE(of, mxc_isi_of_match
 
 static struct platform_driver mxc_isi_driver = {
 	.probe		= mxc_isi_probe,
-	.remove		= mxc_isi_remove,
+	.remove_new	= mxc_isi_remove,
 	.driver = {
 		.of_match_table = mxc_isi_of_match,
 		.name		= MXC_ISI_DRIVER_NAME,


