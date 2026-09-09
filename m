Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D36F550DA6;
	Wed,  9 Sep 2026 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964088; cv=none; b=ShQtG9fBEzDbWJENDBLunIM0DZzs0iATT8Qqb8kLKWEiuODdTzFkd53wPvL/1Kjg/+U4p7NE8PgwqpXjwesp7hsjIIkda84RGcCX5bSD1PxT16IxbZM/GQW0GYlS0YJ6yerKjbUi7wWGWrUip3lS3nRQm0N40Y/8TXtA20GWo2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964088; c=relaxed/simple;
	bh=TkKoeqUEUnYSbxO68DKXWxv0YhYSCpS6aF4vN7ClWpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1muWyLXxrLtCGAVD0GDbiS2uWuLx4exHSf0NOm4gdKf6G3Ajpq3y9bsc7iaa457Goik2DxhjAIN9JhR7rr7kQyatdkBYBkywmfz2OxNoqJGF6KXWuWEVTsJM2us6pXkWtjJ9Lah71SMKLV7upm3cigZ01/MX0V5rsuZyFIr8Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbrMWhL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbrMWhL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62DC1F00A3A;
	Wed,  9 Sep 2026 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964087;
	bh=OsCeO1OUJ1T+3AEH2tRROlv7G6DCjZtTEnHmwldXRFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sbrMWhL5xMZfoBQzmU3GdoCM/CR2fqky9n6sx3CcKOO8epKne6q3BQhx7xlCpdTkx
	 KuUXVwDW/5LAtOP5vrHnJ7SB8ZPofbkEjxoU5EN9gdO7Adg9JNK2/BNCIqq8V1AmVz
	 yw4xoDUT9O5VLAR1+st31aQqj09wwopTqOs8P+ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 301/583] media: nxp: imx8-isi: Use BIT_ULL() for 64-bit stream masks
Date: Wed,  9 Sep 2026 15:39:46 +0200
Message-ID: <20260909134248.451990571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


