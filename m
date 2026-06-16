Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB8247A0B0;
	Tue, 16 Jun 2026 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628318; cv=none; b=R4M8ggzz9CpBJSKQS0b2sLaq6pgEi5lrCSnyrx+juYzbPtBzvMnNN+t3YbSjzMiQTXITRwVO8kceJrlqx37CP85acrdhUVm/SFI0DvcJMw0LaRI+a2PwiMzbr5gGcbGPnBiziIL1dX6sV+QU2vthgrdLoL4U8Rj+Wu/1fwrQXeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628318; c=relaxed/simple;
	bh=sWRuqtKc7vtPSUPt0hNrQsj5ohT4IOL7hT4O3+3VvZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e7qrEumC03N85wPFSg/97ktIc52KXfR5XX8vens5S29QEBMhNwkptoCYrPLdvaB0qmQ+cr/mFcyAv2ivKC8Ut7NAOYua4/EFK4LQDiu8cTNGINIj7+/OrstP9ZM36B3D6ZJXe6VwEySRksx4q609EhjP82pHTvK62I36oPyzJok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikTxRuNN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikTxRuNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19041F000E9;
	Tue, 16 Jun 2026 16:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628317;
	bh=r92yx4vefM9GnVErJ9s7/MhrZ7rxx9aFXsTVOak+iQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ikTxRuNNPkjcW9keAfELvySgf2tSwK9u/9pV9wKN20m3nQiMeS3Lgh3xVsg6NSz2o
	 TTZcGXMY6QWIhEnS6x2KackUSe5LnluAYilnFMSmF+4KXOk/F44ra7HjeHf7Ob7RAU
	 VyE1ys0frk/7C6MG0oPq7a07lVD1s+sJOyrZCiUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Ben Kao <ben.kao@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/452] drm/dp: Add eDP 1.5 bit definition
Date: Tue, 16 Jun 2026 20:24:58 +0530
Message-ID: <20260616145121.656216557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

commit 5dfc37a6b77bf6beedbd30d70184b54e1a08ccac upstream.

Add the eDP revision bit value for 1.5.

Spec: eDPv1.5 Table 16-5
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
Tested-by: Ben Kao <ben.kao@intel.com>
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250206063253.2827017-2-suraj.kandpal@intel.com
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/display/drm_dp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/display/drm_dp.h b/include/drm/display/drm_dp.h
index e69cece404b3cf..861527bf9ccb7f 100644
--- a/include/drm/display/drm_dp.h
+++ b/include/drm/display/drm_dp.h
@@ -959,6 +959,7 @@
 # define DP_EDP_14			    0x03
 # define DP_EDP_14a                         0x04    /* eDP 1.4a */
 # define DP_EDP_14b                         0x05    /* eDP 1.4b */
+# define DP_EDP_15			    0x06    /* eDP 1.5 */
 
 #define DP_EDP_GENERAL_CAP_1		    0x701
 # define DP_EDP_TCON_BACKLIGHT_ADJUSTMENT_CAP		(1 << 0)
-- 
2.53.0



