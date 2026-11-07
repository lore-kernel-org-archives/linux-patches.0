Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061649;
	b=J2J5SGgKYjbBvdHAgu7i8a5IDK6OihCiuf9lbcSXLM6o+w53vtilfaO6k4VofkEJsgzc
	 BYZpvxOSoOvoAev+a6od5v7937uUMatoDaab9rbuZsYe/LmZ55tIc/lX1uBawjWDfQvHC
	 ZAqQTEdtoau31hCzQ9atv41emwR2Wv/JbuQcacEhJ0sqM0Xld2JOFDKzfjX/sdj22MOva
	 juJUtqHKbRWED1BUdjPag/tQ6a+8/xqOlqChmwammbObQJBa5UipwlKql6kYQnvld0J1Z
	 JOGzdAw8GhmY1sQeFAbHhwsBl1gCkMFBYyUmMicDYJGHw7LGnAWUsMxTCeaJe4lJAXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T7aBBXXeUPhAtS69KBxfgf/0TxdRbJSavdhc8090ycc=;
	b=MpWsWh4pTPq9kpVKicloM9T5X+HF6dNhVk2TWhtu++D3j3BIibYOsHxdeu3ZO816woUx
	 +d0RvXQRMa6UjUVn8pGm4bUz6k1eWuGSfeVkmfy54bjn3oTZ1RkdOybt4sdSJxZp9B3BD
	 53B2s9IqBCQIdCIxFgkpwZe6H690XCk9qpHy0kPvueN2A7Xp52Tqev7rIrRUjRCv1S7HT
	 zNWTklUTm+08HcLh8wbcmTEAlryvr5pz2i+bK8A0ZnrzfM9Qrg3IxOdwpQOURywRa4Hyc
	 +Mh+XPZjDtI4HUsgi9kaWiQo5M9roozkAXH4KcnyZemo71mRt8FDgHqfywTD+cinQuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCSbi948;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CE6606A333;
	Sat,  7 Nov 2026 14:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCSbi948
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDF21F0089F;
	Sat,  7 Nov 2026 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061648;
	bh=T7aBBXXeUPhAtS69KBxfgf/0TxdRbJSavdhc8090ycc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCSbi948U9+iQxbPRBESDLziNmi7x+Du7EcEEN/sMHeAWbygKM2CR6atOmLkzUTPt
	 tb7j/ElnFGny3z7w63l8oE3FrfX40rSnQKx6TdBPows7nP+lR1NSGq/J3YkJD+WYTI
	 5urJ9nNxRr6dL7OnM/WIh3EBGk2ejuoTiI396JKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Sinyavin <sinyavin@gmail.com>,
	Janne Grunau <j@jannau.net>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 0660/1536] nvmem: core: Fix OOB read for bit offsets of more than one byte
Date: Sat,  7 Nov 2026 08:44:36 -0500
Message-ID: <20261107135016.056962130@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

commit 24530401e8001aaa637dd5007fcdc6fbc00300be upstream.

When the bit offset is BITS_PER_BYTE or larger the read position is
advanced by `bytes_offset`. This is not taken into account in the
per-byte read loop which still reads `cell->bytes` resulting in an out of
bounds read of `bytes_offset` bytes. The information read OOB does not
leak directly as the erroneously read bits are cleared.

Detected by KASAN while looking for a use-after-free in simplefb.c.

Cc: stable@vger.kernel.org
Fixes: 7a06ef751077 ("nvmem: core: fix bit offsets of more than one byte")
Tested-by: Dmitry Sinyavin <sinyavin@gmail.com>
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-5-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1626,12 +1626,14 @@ static void nvmem_shift_read_buffer_in_p
 		*p = *b++ >> bit_offset;
 
 		/* setup rest of the bytes if any */
-		for (i = 1; i < cell->bytes; i++) {
+		for (i = 1; i < (cell->bytes - bytes_offset); i++) {
 			/* Get bits from next byte and shift them towards msb */
 			*p++ |= *b << (BITS_PER_BYTE - bit_offset);
 
 			*p = *b++ >> bit_offset;
 		}
+		/* point to end of the buffer unused bits will be cleared */
+		p = buf + cell->bytes - 1;
 	} else if (p != b) {
 		memmove(p, b, cell->bytes - bytes_offset);
 		p += cell->bytes - 1;


