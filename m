Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835BC31E0E4;
	Mon, 18 Aug 2025 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522388; cv=none; b=sP+cvWNfh1Cc0iXTpvBsMTQz1SgRhRCa92Oue00pDVwe4sejm6KSKebMmUOQgOSjaCgDx67rNd5b9WeoI8D1pTldmPZnSm+TEXicJG/gk+mvPWmx9c7iHqcI564MLHTPU/gegXdmyTfTzraH8leFe+jBvb6uiXhGHPhdWQs5ayo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522388; c=relaxed/simple;
	bh=ftbjlEgpZNGzv92HEuLRZ4sOp5mfs497wRKOQ2rG5+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjDdAr0SqmVwdq4bgtA4MRFOUoZ54mSusclS5marGl+8fk2p/77rHkb0FrK51UWEx5qcJgF1UeTEvfdMd24sIEt54MTKhw1ZsZ1mnCfxUySzZpgdPPMUggzYdOLhq0b8LNS+xbYvVBaHOn032/UeD2RCyyaeZLQ8qrYIlco7P/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5BsvxxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5BsvxxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9485C4CEEB;
	Mon, 18 Aug 2025 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522388;
	bh=ftbjlEgpZNGzv92HEuLRZ4sOp5mfs497wRKOQ2rG5+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5BsvxxNanAGiyjHRhaO9EVUJXgtrhjq+LzcIm+nhygTB0x1TCIRzpDeghuxIZjph
	 n2oIxvuc7YA++z8SEoB7UkZDMa9DRqbU5OH5G+7fSF1eiJ+5GDY7THPUm56oNhvjxw
	 tXVYJqVVM61373c4GaTkHjMDV/kch3xR9W+eJmd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/444] media: v4l2-common: Reduce warnings about missing V4L2_CID_LINK_FREQ control
Date: Mon, 18 Aug 2025 14:45:28 +0200
Message-ID: <20250818124500.273455759@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0a2f4f0d0a07..807894af9057 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -494,10 +494,10 @@ s64 v4l2_get_link_freq(struct v4l2_ctrl_handler *handler, unsigned int mul,
 
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



