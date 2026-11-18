Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019208;
	b=yRgJh1IjYlj9TIGqHME+aYELZCNTlsz4+gboYRrmbWowX1k8zGl5tUc7t0n/ni/WJpCP
	 PJDZDZ8HFp7vp5SBHwgKeKOzNakD+R3es81pKlcu+dZ/hibArVUX36Zu4KEV6LOX+tZcq
	 s6R015+iQUwsLEWSYiXzLYdVjTBTKf+gqqbz2Y2qM0KOit5+hMmninJRG58vbNqTw/5u6
	 QKGhW6ya9dkOQRhGaAokzhjaXQrfnoNJ0E135IRd0O4M+cgGy/rItyz4FMsYYjP1TN2xA
	 O83laiWciZemZxU/PJRnShpEN9mX1he+WK/5h2MBg3BTS9iRJICBkhppnK/C6vXQRqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QCNEQN6McNKZ9AJcjSZs1pZP+jauZyP73PCTiBp+j+E=;
	b=asPuOPewb1TcFyfXDhIXTFvzkIJdXvrVlkRCmVDm5biXAppRI1GrcdkVCdQ4fC5ohgNQ
	 dPZ9XgG8qmO9YF8xd50OqoaxdR3Awa+ZFL9UBvFoc/+hnfetqDqHc65VqBE1Qhc8Uj8C7
	 d+6sdvJUdhcjGQAPSXel9VT+rFLCplIXbhHzKRxug16d8cY0XSGtFx0qVSWie9R91pGp3
	 AF5knGL+GNrBzIXTyusOoDtNddq7sCqa87BZeb1R6yIyA+qa+41doTOd8j6eEBGaT9idw
	 oY28dCMe28kvmBotLXrO0dpUolrZk7F9YC7RmAiZUgTH2O0t0FFpsY0NkQlvLQqgnzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z/6UYUek";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F08606A32A;
	Wed, 18 Nov 2026 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z/6UYUek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554D11F000C4;
	Wed, 18 Nov 2026 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019207;
	bh=QCNEQN6McNKZ9AJcjSZs1pZP+jauZyP73PCTiBp+j+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/6UYUekCCmNamMqEoVgq59dcSUEVW0jm10APVYqJi8Pa9xS3ES0iow0FlQDkx1MK
	 xKED4eaZVttea7/jaZIYoDcwE49Z21vpTG6Gvq8mzJb39FKhW30B7i55ioB5Wpl11v
	 d5QA4nJk5DFgfvmc0jlLGh3xBeCwhMPRZ+h9fH/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Hoffmann <f3lix.dev@gmx.de>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1513/2651] wifi: mm81x: validate YAPS receive framing
Date: Wed, 18 Nov 2026 15:45:53 +0100
Message-ID: <20261118150342.471322131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Felix Hoffmann <f3lix.dev@gmx.de>

[ Upstream commit 7e6689cbbf9e6040e4ce38656a126459aa994f68 ]

The receive byte count comes from device-controlled status registers, but
the packet splitter unconditionally consumes a four-byte delimiter. A count
of one to three bytes therefore makes bytes_remaining negative. If the
reused receive buffer contains a valid delimiter, the negative value is
passed to memcpy() and converted to a near-SIZE_MAX length, corrupting
kernel memory.

YAPS streams are word aligned, so reject byte counts that cannot contain
complete delimiters. Also reject delimiter sizes which do not leave any
packet data after removing the reserved metadata page.

Assisted-by: LLM
Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>
Link: https://patch.msgid.link/20261007093021.17132-1-f3lix.dev@gmx.de
[remove Suggested-by and fix Assisted-by]
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
index e1102b8fb8020..1d90137470c28 100644
--- a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
@@ -401,16 +401,17 @@ static int mm81x_yaps_hw_write_pkts(struct mm81x_yaps *yaps,
 static bool mm81x_read_pkts_h_is_valid_delim(u32 delim)
 {
 	u8 calc_crc = mm81x_yaps_hw_crc(delim);
-	int pkt_size = YAPS_DELIM_GET_PHANDLE_SIZE(delim);
+	int pkt_size = YAPS_DELIM_GET_PKT_SIZE(delim);
 	int padding = YAPS_DELIM_GET_PADDING(delim);
 
 	if (calc_crc != YAPS_DELIM_GET_CRC(delim))
 		return false;
 
-	if (pkt_size == 0)
+	if (pkt_size <= 0)
 		return false;
 
-	if ((pkt_size + padding) > YAPS_MAX_PKT_SIZE_BYTES)
+	if ((pkt_size + YAPS_RESERVED_PAGE_SIZE + padding) >
+	    YAPS_MAX_PKT_SIZE_BYTES)
 		return false;
 
 	/* Pkt length + padding should not require more padding */
@@ -455,6 +456,10 @@ static int mm81x_yaps_hw_read_pkts(struct mm81x_yaps *yaps,
 		return 0;
 	if (bytes_remaining < 0)
 		return bytes_remaining;
+	if (!IS_ALIGNED(bytes_remaining, sizeof(u32))) {
+		dev_warn(yaps->mors->dev, "yaps truncated delimiter");
+		return -EIO;
+	}
 
 	if (bytes_remaining > YAPS_HW_WINDOW_SIZE_BYTES) {
 		bytes_remaining = YAPS_HW_WINDOW_SIZE_BYTES;
-- 
2.53.0



