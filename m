Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C57214831F;
	Tue, 30 Jul 2024 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357787; cv=none; b=KjkWVKfrIEFImUvFIvFmUwh19bFzmo7ZgIZkbw8KyCXi/J8QzTK8EdpuEfF+hQf58DlBJEtTYBIAPPtdlnPdBQQvmXF3O0Qxpj+2QKcLnSEiBo7VAWkpUe3kv5B08kwbwJx49nGM2RMhyfY6qoN0J93T5gQeoRjkPHK2EBUYBjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357787; c=relaxed/simple;
	bh=wQzA39+30kyPS4Sz7OhZhECIZ4hu2XYrlPt/CdJ+HBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uspyUQZpMjvNb4okjLgv3lw5OwVnMPbMY3AgPOtMcJVRQHCn4TAgjASMwE12u0dbFJhY1gh+nvtqm895s9ujxAW513p1n5psxyYvOTlxpsDeRs6e6XwINIE1trHpNSsfMvlmAPxZg0b6/bgZ66gmISQfGBhWfgPjCIawz3g4ghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0nYS1t1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0nYS1t1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2455EC32782;
	Tue, 30 Jul 2024 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357787;
	bh=wQzA39+30kyPS4Sz7OhZhECIZ4hu2XYrlPt/CdJ+HBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0nYS1t1TCHezW8UkcIdpVEeBtc+MInN2CzjiiM7bCxcIL3OqfaTIjgCgpcTbM92k
	 L36/uq5L2/fKCK913zOAm4437ilky/Dn3gSSBdWt9yNiWtlzzvzj1o5qXoeI/uNXX0
	 ePxsvP1lUKH5hUX0STiXyku05bPluR/dq1EfAIz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 292/809] media: i2c: hi846: Fix V4L2_SUBDEV_FORMAT_TRY get_selection()
Date: Tue, 30 Jul 2024 17:42:48 +0200
Message-ID: <20240730151736.124892796@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 984abe0b5794a2aca359bb61555351d2ec520d2a ]

The current code does not return anything to the user.

Although the code looks a bit dangerous (using a pointer without
checking if it is valid), it should be fine. The core validates that
sel->pad has a valid value.

Fix the following smatch error:
drivers/media/i2c/hi846.c:1854 hi846_get_selection() warn: statement has no effect 31

Fixes: e8c0882685f9 ("media: i2c: add driver for the SK Hynix Hi-846 8M pixel camera")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[Sakari Ailus: code -> core.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/hi846.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/hi846.c b/drivers/media/i2c/hi846.c
index 9c565ec033d4e..52d9ca68a86c8 100644
--- a/drivers/media/i2c/hi846.c
+++ b/drivers/media/i2c/hi846.c
@@ -1851,7 +1851,7 @@ static int hi846_get_selection(struct v4l2_subdev *sd,
 		mutex_lock(&hi846->mutex);
 		switch (sel->which) {
 		case V4L2_SUBDEV_FORMAT_TRY:
-			v4l2_subdev_state_get_crop(sd_state, sel->pad);
+			sel->r = *v4l2_subdev_state_get_crop(sd_state, sel->pad);
 			break;
 		case V4L2_SUBDEV_FORMAT_ACTIVE:
 			sel->r = hi846->cur_mode->crop;
-- 
2.43.0



