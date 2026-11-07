Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062181;
	b=gBGtodIQG+jbwKlz32kI2sNmN1DtbOwyZal6+dKKlIg/7sTlFYpTjA4tdTFxvX4PHdn4
	 kerHsoWHKumrp0tELi1TTlUcKjNQnKpmU31pn9R+wfkbWIgVWi5XTmSdA05MUCpkRn3qq
	 tAoPQOeKiI+niKnmV1379hefjYjEnxVt5WVgBtaCtoHNmGrftoI18QbZM2toIDbtz1L4Y
	 EvvwnRNu6AK9NbNpo9yGv5ANJddM33X1eFWO9lbSibQpFVs0ued3bgMp/NJh9KOl0YUS/
	 JNQPjWTq4DCfKXT2f/TNnbSL2PXolOU/sszBNicGbbswNDCXgLPP+cQWI66qO4YJgpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a3to0UkAgEp8NQ9tNweHkIBerGHhG3trNf85oAQ8R+4=;
	b=PjZtFoNejjs/uH4ApcoiNmL6gxbMkyeGivg6wWEFkJ6jPp/a16gknhRp3KCo/m9IrGeH
	 HwWPePeapBUGmArd0h8wGt/TGpz6RATI7sB+xSR9NABDd2jjW3ir77FjhknWrHM5pcR0v
	 wUrR4y8cnuW02N89DBTqfbA71XyaRcfXMAbWcQ5Jt1f+Mz+WIjF0IOkIjJobhI/lrlh6E
	 RfDwzWPw2Day1jAhNYdSdsfFIAB62F2nvySKkrA75tHPcq3ahbX2JL4tvw2dK3uFq+dYh
	 1TSdVaavgKNdf6emT4hesfxQwzOmR+/is8gBCG2pW7ZZss+6wyJ6Hfnut1QfRm3qc8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1sbJe8a/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A17606A326;
	Sat,  7 Nov 2026 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1sbJe8a/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EA31F0089F;
	Sat,  7 Nov 2026 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062181;
	bh=a3to0UkAgEp8NQ9tNweHkIBerGHhG3trNf85oAQ8R+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sbJe8a/fzwVY9w7ur8YeM2vw98DsNoHVF2D01QF6dPXAGA4hno+viRgWkuxLOYQ4
	 KXHXl1gIuHyST9KGu1iJZdpjzUwTR+s9C9G711elkA+UM1IFJ2URcXHBJ02FAOL2Sw
	 mMgzlp4bUX30rX+LUgnIDUhFgaqQfYtQSXoEvQfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1140/1536] media: sti: delta: use unaligned accessors for MJPEG SOF fields
Date: Sat,  7 Nov 2026 08:52:36 -0500
Message-ID: <20261107135029.735715571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



