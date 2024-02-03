Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF46E3C46F;
	Sat,  3 Feb 2024 04:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933617; cv=none; b=CjtArQPGb4pB4MjP7Mpe3Kj95rLnhFwMDOoaF/iFBM71esIivH1cp3fYAOL78e5OZLU2tyXpgxGMLccF6iyjLVXEXIxJtbqFK1l31G4IdrnDOJYzpEQp84K7M1vJE7tzwR/gHlF6vmCcQ0OEO2GWiLFDjHS+GtbzVQK7WQgtWU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933617; c=relaxed/simple;
	bh=XVjFhojQkpFV2vN+XhU5OG7lFW3Zs7DcJsIas+0p/Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIVpOEpW8LQsiMWg1+6pJ3SqrRv86EM1JTRKZHQKUfTdmLqnTV8RPjQlPwCBz6UL5d9gPfQ9ML2oPm15aqx/Q2INSJIOC0MYqkK+diBZ4bOvMU/7x/pqif1gFdPkLtIMb0DK58fa/PN0P+ge1u8q7uI6QHstKEZFlaazYZpX9bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2iizRes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2iizRes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAC6C433F1;
	Sat,  3 Feb 2024 04:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933617;
	bh=XVjFhojQkpFV2vN+XhU5OG7lFW3Zs7DcJsIas+0p/Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2iizResTpICk0PnBdbMOtpFcZVbHLhiV4Hh0D+akYHdnH0duRtjilL3HK7064VA5
	 bGbLNfkf+5CPoFva2HYF93Jib9Thkr/vA2a02kNaxC8Z1QaINC1BaEaj8uilC5//ZG
	 2ccT4cA6WLuCwKjiCAU6WviKDo4CUvzrSHLdTapA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umang Jain <umang.jain@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/322] media: i2c: imx335: Fix hblank min/max values
Date: Fri,  2 Feb 2024 20:04:49 -0800
Message-ID: <20240203035405.454065892@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 482a0b7f040a..26869abd77a6 100644
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



