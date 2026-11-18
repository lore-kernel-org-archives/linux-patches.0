Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038731;
	b=FC2Nbd4W0RmYSsHbFtBvawn/Gd62YRrWdCey7/K8vT+pXe06M5OAiSnOJqxUm0OYm/uP
	 ISPZ/yAwS7gPDkXct7R9gu8ekJmM1f0cQK0DKUmLRV3CknE5TWMa9NrQKZnCRxIap4XPj
	 ieOCc/s/N8bFI8B/2pc758pUMYYCILPrDnuacOwDYGVmD59v/gNzMvESqd2rKkwig6Jxc
	 O4ZnZZryxVgbekvHcpba8VhXMldNPTwXbK5iju8ZZVXJ4Odp6X04zPzJRtMaLFmMSN7uD
	 Y3LLfV+tsK2+jLmzZUW8baadAsmBvkRkH7Utu2ZTpHrl0gzS6HIxhTLhPm4NF7k5TVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+xnt9a1pxrVZ9FfrdFBvHfx99MH7f0xJt+gH1wLBxvc=;
	b=soFNxARPC0UlNQvXIM4xibUk/DAgVAqKbiHUA8wUfUO2RAKc80FCosBBaygr/OcyoruV
	 J1bo1H0TON1Hr869I0YVzX9JfL8BaDpx+DwlBb7dxDWBHta4YratajKa4lgoGUhcsQXvc
	 1iFRqoWoEfIGtM+fYefuYpBkjHKRG03Sv6r6bG8Ra02b3DI52aP67mL55ajaPFAiXI/Ah
	 z1HnVzeYZNeJ0j8yYa4WYOLHY7gZ4qXjaCYaR4Kf6Jjb9/bLyBcnrYJ6VpvgvN30+4/Ug
	 kiYAwCSx1T2PFpedpFWsQCKLi4patRoq8Ze4BhTsVDFDWq+Eaaoi5zUhh+cwY0m5vMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Re49SFPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA47606A320;
	Wed, 18 Nov 2026 21:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Re49SFPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA53F1F000C4;
	Wed, 18 Nov 2026 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038731;
	bh=+xnt9a1pxrVZ9FfrdFBvHfx99MH7f0xJt+gH1wLBxvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Re49SFPm7BXKekODEIvN/lmnGtW8Ip7oZI7gMpvuFC80Yzl/SRE7nb7zcxFwPt5FU
	 8HYnX9tFFNFdyv5CoW4pSYxr94458Er5tgWKbsf5mq8JQh7JLM78pgyNKT3uMgj5E+
	 oCRAUD2vlNWiEcKsSTCNQ42GMhiXW8NJsSYY8nKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1847/3318] media: sti: delta: use unaligned accessors for MJPEG SOF fields
Date: Wed, 18 Nov 2026 15:41:09 +0100
Message-ID: <20261118150417.270279193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the unavailable Linux unaligned header with the architecture unaligned header. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c b/drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c
index 90e5b2f72c82b..6e156cd806bb5 100644
--- a/drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c
+++ b/drivers/media/platform/st/sti/delta/delta-mjpeg-hdr.c
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



