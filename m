Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7781D21CC79;
	Tue, 26 Aug 2025 12:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213155; cv=none; b=smJu6mm4dBV5syscPGibI7XAVO+nlqcigXcSSB0L7GETZeKwK9WR3z7QPvMBkDqyfrbAlnKuzEerkRSrn/Fomq+XiDo9VTNOckYz6hpyusfE0ibJpijRRiJ7PI8mncSSALNb37CgrRIvFgWKSF1PfvCMIBNviwLT/zcl+9RrtEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213155; c=relaxed/simple;
	bh=xXlpf7/lw23afISbGa8YR9tRlQvq4Jzmjf46bgdNP94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSM1OSZ1k2a4u4rGrlBgk5JIxqB2HFHdHTtw7jzJtkWh7Dm4oofOAQ5qxcO/7aBqQfBx6VsPkX/CqJOS/FGRUtdu7WMQRCkXfjN5PA/v5+Od3Y2PP5oCBqQ0fsdGxXDVAx/WXoRI516ubcJXnivF5qVVrh1BkLl/LhI9Aw9boAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uYgRTPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uYgRTPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050C0C4CEF4;
	Tue, 26 Aug 2025 12:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213155;
	bh=xXlpf7/lw23afISbGa8YR9tRlQvq4Jzmjf46bgdNP94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uYgRTPxnluYA72ecFBBrJW5aXYNUOL+PES7zyxfj0p8l59yQHGg5YjfNs4t0zLsO
	 UoVAGFKTI0Am+ZtXv7fHw8v89ltoVnj37DUI+gnuo+laSR+7t9Wh99US9eleuRHtIp
	 KQd8P+fsTEHYMPIx8oDBEuXUei5yjiq+NdmTVPYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/587] media: v4l2-common: Reduce warnings about missing V4L2_CID_LINK_FREQ control
Date: Tue, 26 Aug 2025 13:06:30 +0200
Message-ID: <20250826110959.063687468@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 5a0abb8909b9dcf347fce1d201ac6686ac33fd64 ]

When operating a pipeline with a missing V4L2_CID_LINK_FREQ control this
two line warning is printed each time the pipeline is started. Reduce
this excessive logging by only warning once for the missing control.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 3a4b15a98e02..b37507e09339 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -487,10 +487,10 @@ s64 v4l2_get_link_freq(struct v4l2_ctrl_handler *handler, unsigned int mul,
 
 		freq = div_u64(v4l2_ctrl_g_ctrl_int64(ctrl) * mul, div);
 
-		pr_warn("%s: Link frequency estimated using pixel rate: result might be inaccurate\n",
-			__func__);
-		pr_warn("%s: Consider implementing support for V4L2_CID_LINK_FREQ in the transmitter driver\n",
-			__func__);
+		pr_warn_once("%s: Link frequency estimated using pixel rate: result might be inaccurate\n",
+			     __func__);
+		pr_warn_once("%s: Consider implementing support for V4L2_CID_LINK_FREQ in the transmitter driver\n",
+			     __func__);
 	}
 
 	return freq > 0 ? freq : -EINVAL;
-- 
2.39.5



