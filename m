Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059888;
	b=4iKS+Ls30mqCEBLKjCqoY/MaCgA5MNG2EPuKvYL2GkiZpu8kB/NCxp6Zg5H2WQGCYG6B
	 gVsRMrCLzGYOeqZoUWEYAa43eOHBlj0LEVl848j8nE5LeBzo+uKoyZysXg5d7OncoL/qB
	 1lK/OlxuVPBG6DEhE8btvlEbOErE/1+bnd2xFiQpLGCgouZ3/Tc13cu8xal+NZG3VcES9
	 Km6+fm5027Ex8IcUVBkaDXrJkj1CDF+zk86G+tPNBEyZQLNBbfpGg/M8NgZkQ3JE6VLMF
	 FnFKPxdYBRv0RHGoNQO+OaSeoFtc91WYFYLM/493a1CGz5x/votoHq/U/sWlx9r247w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e/cX1yMM1Mo1tgiK3OubAnpScSNhosS9QZwPY20XcEQ=;
	b=s++leOEzPT388uZASCnQEokWRTPrr981gw6dLCWWYdyP5a5DEyy0UnHVVtSMoP+oc8si
	 7FMy4W25eiJ8gr1j3Ue+M9oYq2/zIR0D0NNxo8zVLb294hK9UGAIDjwz8DY1apGBdesiO
	 QSULasPBjKK+3SLp2ltZxYk6Qd5NBo0xlr4UmDcJKFdVd5jSKTWrvZpDx0kyBjof1NPHy
	 YH7IBhbGkfTtxT7X30xa6DdxiwQbrCfaSvZBudsJ3jrd6ifFfaaRci4SwFRcJzqyEV7sD
	 NbEzSoOQBuKbyKQP74Fr/qVTUtPaT66mn9K7w4Zexlcb7MHATGBn0x4lI5dRcLmlHzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plAoRfHe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68521606A326;
	Thu, 19 Nov 2026 03:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plAoRfHe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA7B1F000C4;
	Thu, 19 Nov 2026 03:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059888;
	bh=e/cX1yMM1Mo1tgiK3OubAnpScSNhosS9QZwPY20XcEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plAoRfHeVxG9UnZcDi8CvrM8jsz2s4q2YF3eUkXWsF6w6nu6GkBYUcv4GYK9JAxA+
	 MjaEmvQk4zLCU9pK235o6lBZTRM1+AhKoDNk7uKHf64QU3gYh0OM3w961Q2fWYh23m
	 WHPEQLX7GYBFTkW6neCAhKrOZIgDhKvU7zC0fjpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1002/1848] media: sti: delta: use unaligned accessors for MJPEG SOF fields
Date: Wed, 18 Nov 2026 15:50:40 +0100
Message-ID: <20261118145958.753612608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced the generic unaligned access header with the available architecture-specific header ]
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



