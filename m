Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF6811198;
	Sat,  3 Feb 2024 04:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933867; cv=none; b=c9AQ23CvmYuNLTIqJnNjwSIVF+vA0IldsdI/hW4MSuAZXpXsceyXp1SIvjrxRDLc9faWh7druB7cvebBh6j6b7zB8lm5O10WnwwyBE8vuDiTK7SSNUIxUbCY/mBTZW5QwC/Q4t6/5VwtsBpRR49LRrrUmGf86DTwCVJmf53g+fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933867; c=relaxed/simple;
	bh=tiq+ZI7ggMLSqzqKVwx6pQe5TJKUv8BxUDE3Y7i3kuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlPrtAfkvKwzNRKcOLfoLhioz7ivKg9SKFTVTrN06khb4tjpHignLUel2whzy10agPWYJLW/qksrEGBB8+SQLUiS55lpd/g5+KZyjI3G+Ucms8y/I4ICMWEU+YqNH9uYwftGyFlpvnYa9UEJPgnVbcOSHvCGNkLvXhdaa+kAC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCzSRzN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCzSRzN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048A4C433F1;
	Sat,  3 Feb 2024 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933867;
	bh=tiq+ZI7ggMLSqzqKVwx6pQe5TJKUv8BxUDE3Y7i3kuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCzSRzN1I+wgdHWsGo6DRoHmzV60L+4Ap7fMDd3V7HWRnq2eXfclayvohw237HRc5
	 ewGvE9tLLKuDjchoNR3p/dYaOKInvUBFaH7SitAEymNgbjdec40ZvENCudflZDrbGs
	 3q67sANDWOkJYl7B0L7pXezekvuU8OoC4d8Ykjb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 203/353] media: i2c: imx335: Fix hblank min/max values
Date: Fri,  2 Feb 2024 20:05:21 -0800
Message-ID: <20240203035410.111739124@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

[ Upstream commit d7b95ad7a8d56248dfc34f861e445fad7a4004f4 ]

The V4L2_CID_HBLANK control is marked as readonly and can only be a
single value.

Set the minimum and maximum value to match the mode value.

Reviewed-by: Umang Jain <umang.jain@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx335.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/imx335.c b/drivers/media/i2c/imx335.c
index ec729126274b..964a81bec5a4 100644
--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -962,8 +962,8 @@ static int imx335_init_controls(struct imx335 *imx335)
 	imx335->hblank_ctrl = v4l2_ctrl_new_std(ctrl_hdlr,
 						&imx335_ctrl_ops,
 						V4L2_CID_HBLANK,
-						IMX335_REG_MIN,
-						IMX335_REG_MAX,
+						mode->hblank,
+						mode->hblank,
 						1, mode->hblank);
 	if (imx335->hblank_ctrl)
 		imx335->hblank_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
-- 
2.43.0



