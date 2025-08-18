Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E5734574B;
	Mon, 18 Aug 2025 14:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525873; cv=none; b=k5AzIw5gBmSAdamt4t/b+0saZXk/fxl9aywWjHtCD++p2vCmENUxdjWzG2I+XPr+IGcuuQ4ACPYhJnfM5i0qI1gIb4Wl1aq+4+4ITtjFXXpJO/fUVpN0dJyhmpxKFITSLR0dbEhCls+CYAM1UVY9PiuPOaVsxvlmWdTHOSiECUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525873; c=relaxed/simple;
	bh=bDQ3oBWhN6N+cAvQ/5XSeTms1UF2BozMpcT4ACM4Cv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lo9VmuvSosY+H6iav/KJ9oPYbxbvYvszl8Ky68acYgQET3XUZJqvSHXuciTrew7VlpCm65dDRtHGRu64WBfgyffgeNnmNaSgJF1PTaalS/I2EFWWXMrTM9wF/yVlcwqpDRT6vAA6XFXPORQAJ4TWdRc4L0nRKL+xJPHic5KRs24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1Acp2MK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1Acp2MK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50A9C4CEEB;
	Mon, 18 Aug 2025 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525873;
	bh=bDQ3oBWhN6N+cAvQ/5XSeTms1UF2BozMpcT4ACM4Cv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1Acp2MKvFFJiXkEOIPwAZqUJzHhVbtJoVVeAhrpcxNeyexkjmVupNXMgXJ4F1GDl
	 GqvcZcu+kfLBSQtPo+zI6QSzooA8TVPMkRpRQYGLptz6vqRpeRdTbBLI6oIUUgTNVf
	 ushEei1dBRKtAEEwIWYQI5ZP9uB8gZLJHqfT1W6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 392/570] media: v4l2-common: Reduce warnings about missing V4L2_CID_LINK_FREQ control
Date: Mon, 18 Aug 2025 14:46:19 +0200
Message-ID: <20250818124520.959415765@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index bd160a8c9efe..e1fc8fe43b74 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -505,10 +505,10 @@ s64 __v4l2_get_link_freq_ctrl(struct v4l2_ctrl_handler *handler,
 
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



