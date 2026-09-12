Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D287B2E7631;
	Sat, 12 Sep 2026 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221802; cv=none; b=iyxlO2wxV4N2n0XvfmqFW0mc6o2JdyAHhT5fUj/3TOUGg4W+hZ0cC4Hr64ITLiuHWh94w5s6mtpKDexGc2Iby6WYmHHw6o4pB0oeZTwrpXxG0bdN2GFJA+IugK8Orq0pqYZMn9XdDozFiG1P1n8ouDULcwio1ize4kyLFO6Mlko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221802; c=relaxed/simple;
	bh=dkA6Xqk+25Y/lrRjSdxuDsrJzmGLCt2U8E77yabUujg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiRqkUqQBZey23c0mvgq7FWliYWzwvP+2EYmhDDSNnpePQUtaGvW8TolsZG/eA6ls8BnsJvn6QVhQ75TGi1a8YFlfEwjPCUnt24Cud0h1lEu4otBJE3/RnY2fPrVUVN0er1O1JAuGRoC4wEnRaHElkEfO9Z2ecCQyrsMALMHgS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx3sbziD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx3sbziD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9F61F000FF;
	Sat, 12 Sep 2026 14:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221800;
	bh=NhulknYKaUkiFYtFNKTgCLhlAyOveKyjoV3BohmzVQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hx3sbziDcosJ6sJvPwWvgnUcqE4/RYtTS/dvZb6KbIoHJIKaa1Us0p3+wLTUhHoB7
	 BNPEooVPE0oEKHJEOf6J13H/Crosn5+hTo3MSq4b/I6ID5zsvMuwu/kCdCW0Exvl1t
	 q8uxtzMajrjcLpILGR9yzFJxsKLcGcYXjnVTzKaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0457/1424] media: nxp: imx8-isi: Use BIT_ULL() for 64-bit stream masks
Date: Sat, 12 Sep 2026 08:48:09 +0200
Message-ID: <20260912065617.520376110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


