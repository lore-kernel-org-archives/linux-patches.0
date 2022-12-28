Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AC41C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06317C433EF;
	Wed, 28 Dec 2022 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245637;
	bh=bwVhQvVtFGcdsk0y4e5dRoUJWNZOnOI73rTZM0UVM+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTwjzZYaLb7nZw7Xycap5478r2mN8/9PaE8Pma4bFMhp6ZOLxpbPIAFXaHJ42N7Rf
	 CcIVgZJE+iVV3RorE+wcN51Lem6S9u2Orb8w/Uc8L1qtIYmyLn8Ic5n2mJsT9B6jOB
	 Goqst0Ny2eLIPqHh79JdRmtsc2mWrwtX2lOQe3Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Yuan <alice.yuan@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0897/1146] media: v4l2-ctrls-api.c: add back dropped ctrl->is_new = 1
Date: Wed, 28 Dec 2022 15:40:36 +0100
Message-Id: <20221228144354.562874216@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 73278d483378cf850ade923a1107a70297b2602a ]

The patch adding support for dynamically allocated arrays accidentally
dropped the line setting ctrl->is_new to 1, thus new string values were
always ignored.

Fixes: fb582cba4492 ("media: v4l2-ctrls: add support for dynamically allocated arrays.")
Reported-by: Alice Yuan <alice.yuan@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls-api.c b/drivers/media/v4l2-core/v4l2-ctrls-api.c
index d0a3aa3806fb..3d3b6dc24ca6 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-api.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-api.c
@@ -150,6 +150,7 @@ static int user_to_new(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
 			 * then return an error.
 			 */
 			if (strlen(ctrl->p_new.p_char) == ctrl->maximum && last)
+			ctrl->is_new = 1;
 				return -ERANGE;
 		}
 		return ret;
-- 
2.35.1



