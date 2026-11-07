Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064365;
	b=QOWFav7uokrm38QC8wY3VWEHQ1ccliwYzknGsV28sm2yjCrh+d++CNJp39gglthW/tSc
	 IHTTdndXMzVRlFmoC/+N3x6XeAXVet+OCYISMOWJSC28kTrmvnGwxq4Zzf2ozYgJq3yjo
	 P4pv2TREByjhRpYxR0LpCj9W44a0F7XVF+3Nkoiz9rXoKDzDR111VS9zuantXB61dfC02
	 BO5dyjZwfxfmkkmgER+noSWWZtJQdVAC3kQzeWnOcMj1KjpH6+RkprObnV/ulISkxpvxn
	 pKGpXM/zDZyS+PXqNc9pc4/DcZJkFFvm1iD4F5r4t0ZLZmEuR1XmEsnuN260pFf6UXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sX05RaT7pcP7MXIFd6zHbLMwS7UVcpcr8UoonLXNrkA=;
	b=PZz91xCvAaFjkmcN0NlF3AcdrD/8A7sfYNANZC3fMEGiuLvO4BzUpWmrNHLVQeWRF7gu
	 wWsWav1t+zyS5P/WSVT1yHIwILP4/DciAWCXCgprICz1Pl3whZpaoWs+EZqUxJnnxSWnQ
	 jp71wUUP2PDUC3XbPJ2gAvrH9o6x7+/0vtfMWROWcABcZe3TstPid3o6C2F1fhrM3jvru
	 wwz08wdPFFrohAt5EZzcN2gACjZZfL40GtGp7Y+bjWh/J44FpD108qcuWHEiCc9NiyInD
	 HZ8V4yEC7CtEz+OEih12yYCY+vMx5ZjqF4ugFNc6laFVrFVpySEnGYnLLVQs96wcZag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AI6/Rm3d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F270606A338;
	Sat,  7 Nov 2026 15:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AI6/Rm3d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6A01F0089F;
	Sat,  7 Nov 2026 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064365;
	bh=sX05RaT7pcP7MXIFd6zHbLMwS7UVcpcr8UoonLXNrkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AI6/Rm3ditQ4tcOB3+Howq6zGTvYvx82es5Q//tJePxEHhP/NwPG5t6TUnK3dLgBH
	 4dQUhrIsy6YlsjR97HdideOpAPG5leUCz5tFgzLA1jlH1pV2ygVfWVtL98Ku3nIoA9
	 F6U76iYcipV2vZHKt5TEIfKZtqgKDty/zKAgufSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0446/1257] media: sti: delta: use unaligned accessors for MJPEG SOF fields
Date: Sat,  7 Nov 2026 08:45:42 -0500
Message-ID: <20261107134951.799511632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c b/drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c
index 90e5b2f72c82b..849a5e118aec4 100644
--- a/drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c
+++ b/drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c
@@ -4,6 +4,7 @@
  * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
  */
 
+#include <linux/unaligned.h>
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



