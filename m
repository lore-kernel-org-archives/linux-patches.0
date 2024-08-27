Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F2217C96;
	Tue, 27 Aug 2024 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772144; cv=none; b=aZVjlW8VmWgk7PBnGnNU8t5a/tHseI5SUgzRLvJTj1b9ZIoXyeWBvdgpY7itek2ND18XLmILn88TZ6bPQkz1zL4YPWtV0DgeqtXVu0uAy+sBDDH20qoVX+YAVYnsSM/xJhsS3yETBE2+PztLN6EY0HFId2+K26VLmLsesEdlcHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772144; c=relaxed/simple;
	bh=MTUsQdpuZzNGLuNVsyYxIKAnd+7SqvbWHXe3DYrejyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjoBCLyRL17X/m6aUEybnRzFaEVopa1tCs7pNY8YcDlSWIXtbv0WCPOzqtkCvjUePT1BrA9WlTvcuS+OozVyCq7ym8AFripiXdsyBlcvs8sSX4fDF9umcXfk6zYYhSUl5m1w8vfrZgHBYDxqdWWFopssl8mrH45+cjLhZpqaxKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBByl23l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBByl23l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C9BC61041;
	Tue, 27 Aug 2024 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772143;
	bh=MTUsQdpuZzNGLuNVsyYxIKAnd+7SqvbWHXe3DYrejyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBByl23lUFeYR/9wTcRt0iA+rA1YQiiYKWm62jE6Sp5jlTYzL/u5/1Jz29ToGS066
	 tIUmS0YOtw93JS6MM0gKuGaJg9e4d9N7iMdGnNLkSPqWOOQclmFW5Ov1TLexPif1sc
	 EuktVhdR9oyDYO51lZbTPaXNZIoiexCtD58F9mZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/321] media: radio-isa: use dev_name to fill in bus_info
Date: Tue, 27 Aug 2024 16:37:14 +0200
Message-ID: <20240827143843.040987146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c591c0851fa28..ad49151f5ff09 100644
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



