Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D19C17E00C;
	Sun,  1 Sep 2024 16:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208768; cv=none; b=YmqEA2d/nZ/oWgzJDXgagp9BxnygLIl98aQ+TsYiurzuCt4GUIcQGGSNHlpAUwfLum9+D2UgENAQ+eUpDsy6v5o4NukdBGUkeNPsOfp4hMFX12670EzERJy1eFt3Pa+zgDp66vWsUSqbAaRj+gr2S/QcaDB/rIJRMMathcGgjZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208768; c=relaxed/simple;
	bh=qe8uDsLRbGOuhXGxSJbfSrzvCNlKme5hzVO5ModOE+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/ahcgG7PbqrdwDINjqTYPoGirAaKtEQJpU9HxSnm3dr2u2Xvz6Z53eSIuEw3W+4uewnhIUae6afDbd7fWITqcp4SpIGvPbSPKaggzp8Jt1RGr9jaZRy/bvrSecW2uapgVcjs8tl0X/Hz9kbCsSKfz5/ynjm8buqK+ZJGN0PsGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6gEGIvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6gEGIvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE702C4CEC3;
	Sun,  1 Sep 2024 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208768;
	bh=qe8uDsLRbGOuhXGxSJbfSrzvCNlKme5hzVO5ModOE+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6gEGIvZ5XxgM7zDv07ySI/qrEJ9pRhPEVDbqS0DpO/H8aWSxfX6QXeDPPEGdoVyZ
	 zoE4DEzCh62OdnRzJ+Q32BnpEWB00DrO4RH0c0/+P3zRKexKZjt1lsjnT0WxjbmJz6
	 oj1lY1zbYm9j7bfEdK3lm7kyPOYClNMFa63+KAlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/134] media: radio-isa: use dev_name to fill in bus_info
Date: Sun,  1 Sep 2024 18:16:20 +0200
Message-ID: <20240901160811.387922551@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 8b7f3cf4eb9a95940eaabad3226caeaa0d9aa59d ]

This fixes this warning:

drivers/media/radio/radio-isa.c: In function 'radio_isa_querycap':
drivers/media/radio/radio-isa.c:39:57: warning: '%s' directive output may be truncated writing up to 35 bytes into a region of size 28 [-Wformat-truncation=]
   39 |         snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", isa->v4l2_dev.name);
      |                                                         ^~
drivers/media/radio/radio-isa.c:39:9: note: 'snprintf' output between 5 and 40 bytes into a destination of size 32
   39 |         snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", isa->v4l2_dev.name);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/radio-isa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index ad2ac16ff12dd..610d3e3269518 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -36,7 +36,7 @@ static int radio_isa_querycap(struct file *file, void  *priv,
 
 	strscpy(v->driver, isa->drv->driver.driver.name, sizeof(v->driver));
 	strscpy(v->card, isa->drv->card, sizeof(v->card));
-	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", isa->v4l2_dev.name);
+	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", dev_name(isa->v4l2_dev.dev));
 	return 0;
 }
 
-- 
2.43.0



