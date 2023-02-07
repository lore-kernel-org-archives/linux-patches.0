Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06C82F39
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 12:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CD9C4339B;
	Tue,  7 Feb 2023 12:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774799;
	bh=Bt+EPyA3cKRXVrJMXiAemRmgo7CuhkHhH/hgHK04cRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2FU0Y+2K4LtmNG0kQI6jk3vtwz3W8K2twsi4dGkNGEM3hVVBPKP/nOyZHUA9csCj
	 f9ydwn9QDHhY6alU/VUiLXpv8Bu6Icwxp7gcbQeqWceP2pcpcaUn2VRLSft39NR43I
	 /HeRZk5XIF+T/7cQNRzDroZE0fv3SieRakZ/9YXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/208] media: v4l2-ctrls-api.c: move ctrl->is_new = 1 to the correct line
Date: Tue,  7 Feb 2023 13:54:34 +0100
Message-Id: <20230207125635.230688314@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

[ Upstream commit a1550700629f30c5bd554161524f14f14600d554 ]

The patch that fixed string control support somehow got mangled when it was
merged in mainline: the added line ended up in the wrong place.

Fix this.

Fixes: 73278d483378 ("media: v4l2-ctrls-api.c: add back dropped ctrl->is_new = 1")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls-api.c b/drivers/media/v4l2-core/v4l2-ctrls-api.c
index 3d3b6dc24ca6..002ea6588edf 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-api.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-api.c
@@ -150,8 +150,8 @@ static int user_to_new(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
 			 * then return an error.
 			 */
 			if (strlen(ctrl->p_new.p_char) == ctrl->maximum && last)
-			ctrl->is_new = 1;
 				return -ERANGE;
+			ctrl->is_new = 1;
 		}
 		return ret;
 	default:
-- 
2.39.0



