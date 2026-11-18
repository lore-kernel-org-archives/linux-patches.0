Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047394;
	b=rwTaWxmmHW+LWEjn0XBchOzhH3BTZW93eZSjGnipCs4ftxVbJlXWEgL3HQCTYrQ907Ie
	 Kq+R1MeXh165ikW1oI1HJBo0RXBpmaxuLaBH3qJAVQxMU4wvZkcSWOXPCKvcr0X7ElYcZ
	 SlPBVz5XFkXMMl/z9R6UyR7qJoTTXQ0MC5pQ2lCgzj4R/QSdmjwqmNECareWv8UsecdQj
	 GMv+omWUhHZo1NyQ1KSJjcG0sj9AygHW+JhEnAtu+I9VOaC0eoazZg0Mec0lr1a7Lnb5g
	 /zfBE0pp9ccsNBrsVp4zjEUoTXPXy3kEUh5vjwM4Um07OHWjaAJMAMvAy1s669jydtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tya5gptw47M8W6AmP3CMWRSeIzY54i7qZsc/YFWjOdk=;
	b=GnV+pnkc/zQk/ku94tzCrH/mlK+8eE1BPskL2FUhjcy3UVoUU8EXObqY4C6ZpuEwxvt+
	 pavzEwUd3rS94ZKPhXXD2zsfdz9p31XQ0Hhq470sfz129peZ8widsi3N45j5hQD8dXNIU
	 NlivvBg1w2npqn0e3lUUM4htv891sm7CNjfS9ctIrKX83nJJdy8WK4vtUjdVfIdbrlxGy
	 eUHlqjMdBFJxYqmcOP0q3DbzxofKFcqXskpNg2ZVK/CPLnYMl17UTPGrfD8ZT6LnEzTGP
	 ZXjhZUgW0KZSlpp9lXhRnUajtWDCgKp39ZVzENVK+cvdMiTDgpHX+evNFiKQwnuIV8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GOtWYB03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3622B606A320;
	Thu, 19 Nov 2026 00:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GOtWYB03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897C91F000C4;
	Thu, 19 Nov 2026 00:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047394;
	bh=Tya5gptw47M8W6AmP3CMWRSeIzY54i7qZsc/YFWjOdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GOtWYB03T/My8Z/nRz07FI0MLbxvB2N2V9aBbsJswbTTV/v1iTzoQHvcoeX07dnyV
	 iyDzZLTdZDqUIRHIX/WNf3bejEcRxihpDG09qt4yJ3fPCSQVIzPbt0rcUfCl2VlE6z
	 eNJ+CpGt0lynaChUZZSlpBliLuiggKNfShCK/9CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1596/2857] media: sti: delta: use unaligned accessors for MJPEG SOF fields
Date: Wed, 18 Nov 2026 15:43:50 +0100
Message-ID: <20261118150258.840013873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the unaligned header include with its older architecture-provided equivalent. ]
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



