Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAFC1A76AF;
	Tue, 30 Jul 2024 17:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360145; cv=none; b=FyCNcRVgD7qHPSnw1wKHfF71q/iEm5jeVAuQk1GT+3SKr8d4q9zDnvgQrkm2MskdAakltsE9jcoYjTAbSnYhndXGcowrWGkrTR6MB3gnHOBJ47MDqJfvtzPKdmxFuHDLvi5hUwikt1L8s7ruP2tCc2PEJGV/KDBJSFW2KpL4ybw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360145; c=relaxed/simple;
	bh=I4gRRdwpB/551XUtpja6zR4A89eGU6CsuvDc1RBVtss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fshay985Ehao++VFHs6PT3t94SGwtFh/XU1drVLgytAVBOTqraKFowFMxuNIqIBtkknLN3bUpeL0iyFIXXPLuljI8unjdgaOpYJC+nVVGFX+0oOSlxth59EwP1ZZMnf2+Q01sqrgFVcfywzOIC97X9NdyR/SDXmvKmLuzkKSXU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWNvKVFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWNvKVFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51621C32782;
	Tue, 30 Jul 2024 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360145;
	bh=I4gRRdwpB/551XUtpja6zR4A89eGU6CsuvDc1RBVtss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWNvKVFbgys1VDlVVbPjAZLHHri5b0uCqeMQ03vUP4XgyFyLK3bwnwWc05FRCStgH
	 rnnC+OQuHzpuaKCwLnKMss9ckhLMLdy1rSyAHN60vdBaQsHMKJVxyxIBR1HBkDDePY
	 zIgh26SyjXgc0YjN3gR7cVeZfS1ujcdUAwoQF5C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tomm.merciai@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 610/809] media: i2c: alvium: Move V4L2_CID_GAIN to V4L2_CID_ANALOG_GAIN
Date: Tue, 30 Jul 2024 17:48:06 +0200
Message-ID: <20240730151748.931825333@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommaso Merciai <tomm.merciai@gmail.com>

commit a50a2a3242f35dd551d89a6bad17255a410ba955 upstream.

Into alvium cameras REG_BCRM_GAIN_RW control the analog gain.
Let's use the right V4L2_CID_ANALOGUE_GAIN ctrl.

Fixes: 0a7af872915e ("media: i2c: Add support for alvium camera")
Cc: stable@vger.kernel.org
Signed-off-by: Tommaso Merciai <tomm.merciai@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/alvium-csi2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/alvium-csi2.c
+++ b/drivers/media/i2c/alvium-csi2.c
@@ -1962,7 +1962,7 @@ static int alvium_g_volatile_ctrl(struct
 	int val;
 
 	switch (ctrl->id) {
-	case V4L2_CID_GAIN:
+	case V4L2_CID_ANALOGUE_GAIN:
 		val = alvium_get_gain(alvium);
 		if (val < 0)
 			return val;
@@ -1994,7 +1994,7 @@ static int alvium_s_ctrl(struct v4l2_ctr
 		return 0;
 
 	switch (ctrl->id) {
-	case V4L2_CID_GAIN:
+	case V4L2_CID_ANALOGUE_GAIN:
 		ret = alvium_set_ctrl_gain(alvium, ctrl->val);
 		break;
 	case V4L2_CID_AUTOGAIN:
@@ -2123,7 +2123,7 @@ static int alvium_ctrl_init(struct alviu
 
 	if (alvium->avail_ft.gain) {
 		ctrls->gain = v4l2_ctrl_new_std(hdl, ops,
-						V4L2_CID_GAIN,
+						V4L2_CID_ANALOGUE_GAIN,
 						alvium->min_gain,
 						alvium->max_gain,
 						alvium->inc_gain,


