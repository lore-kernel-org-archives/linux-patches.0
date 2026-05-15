Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178353C4B72;
	Fri, 15 May 2026 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862338; cv=none; b=R+z+4S3jKrdWrvDmxJlKfWT2JBYvzZJxuXRALUSVwoNea5Lz2aXzMIVe8BdjPSligDWnWfIKT1M2yGWwGiyYV3G2G7hOQzilMmthIeizefVtCPcoGJksGh9umzzq4BSXf8B8d/fI++dijsYDsbP8dH8YDwBEEhQiFI4xswuHVks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862338; c=relaxed/simple;
	bh=aETMMnrD84khqTvPHiPpRziafrqFIJt3aEbgvV18RI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f86KDyqRVw26skHTejM6adYCl2ZFgaQs6mncSlfan/VKswFWHgJNjSuQLn9M5x9PNhGW2G1OO5Ruj3ITBb3bz5+daGZXoKc/i2E+nulg1LKX6H7Cjcu3VxCwMdT+jnlRJe/wbdGFcBKr+4Qu5e4jqbdkulVa3Ynko9Kl8P/OCdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmjLkYwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmjLkYwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CB4C2BCB0;
	Fri, 15 May 2026 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862337;
	bh=aETMMnrD84khqTvPHiPpRziafrqFIJt3aEbgvV18RI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmjLkYwtO7su0vjNf+CLaJo6F9Kwl+V8gipqXvhBx2WcvQZX9jYszwQMEUVD0qUl+
	 Gteytpdl+C9dm23wAP1LO2s7cZjLfUFKiHXIyHabf8r9IEvloorZorcTSSEyprmzcA
	 TeDqVR8yZL8UncGtG7rJTEG93QTFk4CMRRV7NBLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <barnabas.pocze+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 011/201] media: rzv2h-ivc: Write AXIRX_PIXFMT once
Date: Fri, 15 May 2026 17:47:09 +0200
Message-ID: <20260515154658.780496506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>

commit d901c428350245f2b26431e03c4ba0bdc7a71243 upstream.

The documentation prescribes that invalid formats should not be set,
so do a single write to ensure that both the CLFMT and DTYPE fields
are set to valid values.

Cc: stable@vger.kernel.org
Fixes: f0b3984d821b ("media: platform: Add Renesas Input Video Control block driver")
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c |    8 ++++----
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h       |    7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
@@ -218,10 +218,10 @@ static void rzv2h_ivc_format_configure(s
 
 	/* Currently only CRU packed pixel formats are supported */
 	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_AXIRX_PXFMT,
-			RZV2H_IVC_INPUT_FMT_CRU_PACKED);
-
-	rzv2h_ivc_update_bits(ivc, RZV2H_IVC_REG_AXIRX_PXFMT,
-			      RZV2H_IVC_PXFMT_DTYPE, fmt->dtype);
+			FIELD_PREP(RZV2H_IVC_AXIRX_PXFMT_FIELD_DTYPE,
+				   fmt->dtype) |
+			FIELD_PREP(RZV2H_IVC_AXIRX_PXFMT_FIELD_CLFMT,
+				   RZV2H_IVC_CLFMT_CRU_PACKED));
 
 	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_AXIRX_HSIZE, pix->width);
 	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_AXIRX_VSIZE, pix->height);
--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h
@@ -24,9 +24,10 @@
 #define RZV2H_IVC_ONE_EXPOSURE				0x00
 #define RZV2H_IVC_TWO_EXPOSURE				0x01
 #define RZV2H_IVC_REG_AXIRX_PXFMT			0x0004
-#define RZV2H_IVC_INPUT_FMT_MIPI			(0 << 16)
-#define RZV2H_IVC_INPUT_FMT_CRU_PACKED			BIT(16)
-#define RZV2H_IVC_PXFMT_DTYPE				GENMASK(7, 0)
+#define RZV2H_IVC_AXIRX_PXFMT_FIELD_CLFMT		GENMASK(17, 16)
+#define RZV2H_IVC_CLFMT_MIPI				0
+#define RZV2H_IVC_CLFMT_CRU_PACKED			1
+#define RZV2H_IVC_AXIRX_PXFMT_FIELD_DTYPE		GENMASK(7, 0)
 #define RZV2H_IVC_REG_AXIRX_SADDL_P0			0x0010
 #define RZV2H_IVC_REG_AXIRX_SADDH_P0			0x0014
 #define RZV2H_IVC_REG_AXIRX_SADDL_P1			0x0018


