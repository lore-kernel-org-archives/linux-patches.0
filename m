Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC782A1D7;
	Wed, 21 Feb 2024 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522679; cv=none; b=Zp7EG5c5BVgUcOP9JJEd4+F4dGvmcTp/B0XIyQcEPKzSUFesl2WSq0k1zE05KjbPX8uMIAvyMT0T+R7GvV7bpdhkWLKy6BJGDEaqUjIjfP/TgrKArhSoJwXBQWS5KVXDIoJIvJ1iqF5HhQhhzBRawSsf80rPMi3LZvddWl1P0OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522679; c=relaxed/simple;
	bh=leTzhD2yFVohrxnfd3Rv6HErOSqkKTe4dvixwDTd6as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rc7U9HafanYCDBA+TwBmn2q/yd1olt8JjJa/eKPk20YyttHlEOaC5UAzIC51GvBDNHVakdKb78IdKQi+W9DR45F4F8NTLxhTMW3KV6c/zZoHL91JXRdo1WJXUW3mmYQVwol77cTr0N0E1wLr9qeenuXf4CM1l42vwKjVEN7xUXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0xzqHnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0xzqHnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D58EC43394;
	Wed, 21 Feb 2024 13:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522678;
	bh=leTzhD2yFVohrxnfd3Rv6HErOSqkKTe4dvixwDTd6as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0xzqHnK8wU9upb8TbZt823rZBCCcGXaBqHmwJLbp5xokhi4L44lKSKFJUjeMprvV
	 2JqoS+7b2zYm/cNLHeQrZcBjRdsr48Ts/L+EBaJ76/xtwReRNqXz/uKAcUQRUJeJVZ
	 k5hiyfXeb1T9JePK0S2YRxHzSN858XL5mgndept8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/476] media: i2c: imx335: Fix hblank min/max values
Date: Wed, 21 Feb 2024 14:04:39 +0100
Message-ID: <20240221130016.298474247@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 410d6b86feb5..780eb68b1894 100644
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



