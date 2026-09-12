Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982E34746A9;
	Sat, 12 Sep 2026 11:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213839; cv=none; b=f90K5qzzON9eltiHPzeoiBNeoP6MHqBMnGstPkt26dbpoZV4gI3zfO/j7tcGG4c+B2ZbDlCSFxmdeQVHnF8X7IbHswZBuqv8KtmJTuE8tr9NnOAbl1nFFwCMcOZXLvrM9f+GW/ZcidgVcZc1dwRGeKJHxFEJMwR5QK+peurXatg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213839; c=relaxed/simple;
	bh=24ejscdpOBhrUiv0RgK9VmbkGI4bP1Xqu6qI/660ihY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GA3uycBuKRPsVNzCZkIBF5bsIgmt6uV6r6KaR21/deiw7td4+BUWo0rlorzp/7v9OzERbPhl1NRYt5WY1Yxm02LIhIZR96/1ECxVBI4nJfexORMozteUUj549r8J0IW/8YrfFVKsKduNwm1KpufB/5AS+sJYtzRXvowIZ89XJR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSSZC+V0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSSZC+V0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500521F000FF;
	Sat, 12 Sep 2026 11:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213836;
	bh=ctTfHrnRrjzKKRFmNP9sU4XpojnKQDuch5YzdL2xmoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSSZC+V05UoZeM5ab94ShjDucOsBKFTO0CtfYWx70B58Q6CuxqI7Ov6j/Wacwrjfj
	 28cusir0TtM0gxEBxA0XZVdmGszzC3C0pvKKH5LvRfQkEWXw8YGAed3JArUycpma15
	 A/I+6FIa/VJd+TjEmhgmCj0CfZR9IBG62rzMeuCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0203/1376] media: nxp: imx8-isi: Use BIT_ULL() for 64-bit stream masks
Date: Sat, 12 Sep 2026 08:43:49 +0200
Message-ID: <20260912065612.074732006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

commit 77e60a2c5d824ad2d493f53dc17137ae065753fe upstream.

Use BIT_ULL() instead of BIT() for u64 stream masks to avoid incorrect
results on 32-bit architectures when stream IDs are 32 or greater.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260728-isi-v5-1-1d22ab91602a@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
@@ -145,10 +145,10 @@ mxc_isi_crossbar_xlate_streams(struct mx
 	 */
 	for_each_active_route(&state->routing, route) {
 		if (route->source_pad != source_pad ||
-		    !(source_streams & BIT(route->source_stream)))
+		    !(source_streams & BIT_ULL(route->source_stream)))
 			continue;
 
-		sink_streams |= BIT(route->sink_stream);
+		sink_streams |= BIT_ULL(route->sink_stream);
 		sink_pad = route->sink_pad;
 	}
 


