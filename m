Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C93101C1;
	Sat,  3 Feb 2024 04:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933410; cv=none; b=ATfQcDowedBiOgJ+CWQ3XDNR1l5uAHGRLpIkfPUS9knAK/OBAx9rEZUBMpk+TYFn2UxJGwZh14dxPQNgh0TPc2//b0YVBX3dTS4G76olLslIBPMXsfWyvGg9P7n7MpDGS2KKSqdGzID/uJh0xyxAZ1vSnFe53roGv1jbvr+bHgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933410; c=relaxed/simple;
	bh=aWpGc/NMHrQ30jg0dn0e2x9uvvz+tAi2yvh0gGHU7lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD3to8uFQp4IzJ/jrdA7ShLF+jPobaZqzgOAcBIgv7scJ6I/4FPXHJTMKwqcbJVPwCjihYP6oH9kpFv2XDWFD7c9Ct7MCJIZQVyaGAD5Loh07mcRKe3UYw2iBNb1LcaJc/nMCpD86CEC2S8gSCcP8RkCWtrH+5KEPIUcSRtY+N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTYl34Tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTYl34Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA814C43390;
	Sat,  3 Feb 2024 04:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933409;
	bh=aWpGc/NMHrQ30jg0dn0e2x9uvvz+tAi2yvh0gGHU7lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTYl34Tx/Wv4L4qfoMNnNXzYYfQ001WSBL/ZouL6RBJQ/FV3/IK9oEy8/3QPu0xmY
	 hmAlsSbiV/ZB0/HmvO6hj3bBe07S5RiD5ETpcT9g2gkZl4BBpniGSeq+KsG7Tg3qlB
	 AdjH5BcUMdDi1EUOFZhRFNQlCRgU0dPmHok545zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/219] media: i2c: imx335: Fix hblank min/max values
Date: Fri,  2 Feb 2024 20:05:04 -0800
Message-ID: <20240203035335.906799958@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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
index 078ede2b7a00..8e91767d6130 100644
--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -971,8 +971,8 @@ static int imx335_init_controls(struct imx335 *imx335)
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



