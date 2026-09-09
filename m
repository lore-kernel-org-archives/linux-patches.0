Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B20055409D;
	Wed,  9 Sep 2026 14:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962698; cv=none; b=UdiaGKO19gdyrPevP3/e6fUeBXRY9QxgZcw8p7bEiq9PAS01hUOBX9omlI+55sT2Vc/XThG6QcsphFJ2sLTeDXF/GYgbWot1kkBskLqHd3Pm1CiEjO88vVJy06kzkK3iUs8qZKQhoEQivH5/NM1K5g9YrzVMExADPUtZPqTk4Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962698; c=relaxed/simple;
	bh=azadDzjMrB6T6ZdVZvI9BH5r2nGWUGhdMD74dedcYGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8puW8FqV94A8UFX022QpARdih8Vr+iJokXASynjnHDGrwIByI+F9Yl80bvxNAdWRGoZmMCuNI8RDuyTcZ/W9nxjrs/PgiSKCG82m+McsfcW3p7WM6fh0DPCM/0mOzQLW47XNBuiWnfuX+UUioDLZihFrD0yaVOxNqiQiORJLlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9J03Z/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9J03Z/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937101F00A3A;
	Wed,  9 Sep 2026 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962697;
	bh=dTVfl3mJyjKBDHfZ3eBYujnFGdcGJWlggnb+LmC6IXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9J03Z/aUBLbJGyA64Mo52tjRSGYvsRwGx/d/3/DKZI/Fuzd8PbZRYb1Dr+1lPJwb
	 Jej360NGrs8tdBLAWOJhQ6YwZEJHjT7gctDHGVkr5B+s+IZU8sntXh/ROkHgbgjneW
	 U7TmKVY64DYhCOQlZtHFLGxELSDHxAZO+4p3T9so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 379/556] media: nxp: imx8-isi: Use BIT_ULL() for 64-bit stream masks
Date: Wed,  9 Sep 2026 15:40:59 +0200
Message-ID: <20260909134244.013340942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


