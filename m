Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054222;
	b=0HGT+nFtpkacBk06HFw/9JMTC21ISTzA1R7XBMcmsRiDRyFMUoY3bbD1RtrWl3pESW2n
	 OS2mydQq7oTtHq9HXITAHUmWfP1HLMbDO8u7vRgvTypX01l+Wc46Q8pQHDsOgLOlLfyQY
	 EmS7llfosjvPLqzc+3Kc0FZNtIf8PEY6+JABZLTEKchy0GCzMH3l/WlOcGyuVgGQQSRcZ
	 DwM0IE45rTk54Ets0Of/N0mPRmaR78kcVH7uFZLQ00qNI+VwNdSvI/44J4Pq/RJmcECK6
	 +C4TR1M+cAXBGswg3xBKU7vMtIoXEaR2S70tfYvO9pgdFNT5SntHc+B8cvXAEvVwiww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1L0VKqESn3P3LtVVNQbMhcjwdLjhiZ+bRMBeNjrkFs=;
	b=VuuKiXf4dFVMVYcWrzr7i6x8e9N+5sOJafSC2Xs332yhtZXG7HOUQcc11otxRhHkiJVt
	 ad1+qTcbob1ZG9q9JmO9iOEdjSXgizoCmJConieTGeIVIi0FZ519n9V3tZgf+aX1mD3wz
	 7+v6P70Rk5MMbFMAqff/hoz+1R52bCKRfMvROrOwFrGJ2ldnuKmfDdaqfxujuNw4hKHdT
	 t4Vn5mZRnlbDVnwF6N37d1v/AGSHH1nY6fqDfKL3RCQ7i8GbOmRT7Zrj4zgiI1vEvR2Am
	 jhC2CXGSBp7N7CTOIePUAfAbCacu3XLQ9rOW7HDAkc6kJHc1FevOAsNGUWwga7zX9WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bYv3r1c/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A322606A32A;
	Thu, 19 Nov 2026 02:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYv3r1c/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742F91F000C4;
	Thu, 19 Nov 2026 02:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054222;
	bh=u1L0VKqESn3P3LtVVNQbMhcjwdLjhiZ+bRMBeNjrkFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYv3r1c/SCvACFRFSpIIQhfLz4QjzbIYb9xipj9kFPZnRqKZYOteLyZLpesqHehg3
	 zKEBIihZNhh5wZHcEUSRBy4013LUO1WOv/pYzYjTzy7b7aPGX1nNSXWQHUjs7Lf17j
	 y2rdUsbcfG3xYHHZAxzF84BN0ZTPK07KIYFkEiXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1196/2214] media: sti: delta: use unaligned accessors for MJPEG SOF fields
Date: Wed, 18 Nov 2026 15:47:52 +0100
Message-ID: <20261118150059.734055335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit fdc5bf02aeaef04e7d13895db9b6eaf8083953f9 ]

delta_mjpeg_read_header() scans a compressed MJPEG access unit byte by
byte and passes the bytes after an SOF marker to delta_mjpeg_read_sof().
The SOF parser then reads 16-bit big-endian fields directly from that
byte stream.

The SOF payload is not an aligned object. The marker scan can find the
payload at any byte position, and the SOF layout also puts frame_height
and frame_width after a one-byte sample_precision field. Those fields
therefore sit at odd offsets within the payload even when the payload
base happens to be 2-byte aligned.

Avoid casting the byte stream to __be16 pointers and use
get_unaligned_be16() for the SOF length, height, and width fields.

This issue was detected by our static analysis tool and confirmed by
manual audit. A focused UBSAN alignment validation of the same typed
load shape reported a misaligned __be16 access in delta_mjpeg_read_sof().

Fixes: 433ff5b4a29b ("[media] st-delta: add mjpeg support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Changed the unaligned accessor include to the existing architecture header. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c b/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
index 90e5b2f72c82b..6e156cd806bb5 100644
--- a/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
+++ b/drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
@@ -4,6 +4,7 @@
  * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
  */
 
+#include <asm/unaligned.h>
 #include "delta.h"
 #include "delta-mjpeg.h"
 
@@ -48,13 +49,13 @@ static int delta_mjpeg_read_sof(struct delta_ctx *pctx,
 		goto err_no_more;
 
 	memset(header, 0, sizeof(*header));
-	header->length           = be16_to_cpu(*(__be16 *)(data + offset));
+	header->length           = get_unaligned_be16(data + offset);
 	offset += sizeof(u16);
 	header->sample_precision = *(u8 *)(data + offset);
 	offset += sizeof(u8);
-	header->frame_height     = be16_to_cpu(*(__be16 *)(data + offset));
+	header->frame_height     = get_unaligned_be16(data + offset);
 	offset += sizeof(u16);
-	header->frame_width      = be16_to_cpu(*(__be16 *)(data + offset));
+	header->frame_width      = get_unaligned_be16(data + offset);
 	offset += sizeof(u16);
 	header->nb_of_components = *(u8 *)(data + offset);
 	offset += sizeof(u8);
-- 
2.53.0



