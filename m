Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043103;
	b=R9L95kfDuV+V4ZksOfKRdCy8hOWSP2R0WyCYgmPethMeWfaIoUj9g4mKgLFE61Pz8kJQ
	 82xQmTann8wIAhU0K2lFjw0s/dL09OcdA2aX+WmJ9KoEsIFoWXoZodHLhoteuNgdY9KfX
	 EeaG+f64cepev8d1IL67pXUKE5esSgspIWC9I1TJ13jBwHOmm/ZnU/SqWjKRWXcLnwltB
	 CZzw3c8NSMbK4BybqLRmwd9x/N8YtjLsE0Lc1EX51kAC5D6jm0F+ZcDsAAtmwCUUKkvrk
	 WsRTMOyPQomnc3uqW3lH23orXiQ9U3TupiILsb6Nd4vxMmfAPKRxHB5wxIZPB8qPCrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YjQdaVEk9UTRvbF7sQCtoIWkpqzmXIpz2a2gWSBifos=;
	b=FCMLE8lh2C01i0R098tZ1OuJQM67ZjSZsYPiKummSH6wka2go0akmW9qcVutIJcsddyH
	 3wLqbnvWIzyTUv0mK+4iqAAa+2u729BumoNKYZbX5A+QTRY3GzJjQw/hDsVYRE4qk2hlE
	 VtFCRZLTYPYuP9Pv30LdvK9Bo2v3YaNSlQbuOFS9uMXmWeGwd9vKSYR7bZkUYqw81N1L3
	 sEaqH9zRpJZ2vfHRA6nky2pzTjUW1hHDyWTLTYYozUqXhidpphHpYJJO9iK8UtZzurq0Q
	 KVFECoVuhxXh49PsUTtZKRK2AbcAXK7OXJq9Ba0oCrQG0qXCwxUillF2BR2KMf/Ynzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XtzGhNmp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21927606A31C;
	Wed, 18 Nov 2026 23:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XtzGhNmp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739A11F000C4;
	Wed, 18 Nov 2026 23:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043103;
	bh=YjQdaVEk9UTRvbF7sQCtoIWkpqzmXIpz2a2gWSBifos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtzGhNmpJcVQrsnMp5p8cEaMOJAsVdxfdLOucpW9evp26pbKFupS9qlyp10vbzeT2
	 c1lGmIPWs/0+u6iIm3qRdbcTUk/uVwTnpS7ojDsB4TbQ1O2poT07/74P27gFlR42EI
	 42erHZETBsJaiIJTFjB+KN43gmkeBfS6MOsH+6u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0090/2857] media: cx18: stop VBI start-code scan before short tail
Date: Wed, 18 Nov 2026 15:18:44 +0100
Message-ID: <20261118150204.521067891@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit bf533acaaa7dee21d49bcaabf8e813ea36bddcd8 ]

compress_sliced_buf() scans one byte at a time while testing a four-byte
VBI start code.  The final iterations can read beyond the remaining
buffer tail.

Stop the scan once fewer than four bytes remain.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx18/cx18-vbi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-vbi.c b/drivers/media/pci/cx18/cx18-vbi.c
index c7cce38dd7547..38b2cfd2372c0 100644
--- a/drivers/media/pci/cx18/cx18-vbi.c
+++ b/drivers/media/pci/cx18/cx18-vbi.c
@@ -135,7 +135,7 @@ static u32 compress_sliced_buf(struct cx18 *cx, u8 *buf, u32 size,
 				    : VBI_HBLANK_SAMPLES_50HZ;
 
 	/* find the first valid line */
-	for (i = hdr_size, buf += hdr_size; i < size; i++, buf++) {
+	for (i = hdr_size, buf += hdr_size; i + 3 < size; i++, buf++) {
 		if (buf[0] == 0xff && !buf[1] && !buf[2] &&
 		    (buf[3] == sliced_vbi_eav_rp[0] ||
 		     buf[3] == sliced_vbi_eav_rp[1]))
-- 
2.53.0



