Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062835;
	b=h+RfkARxKbR1ob+WysKU+/JMUb6ju8z/fEypKkaq9u8Iz71sfDsazM9Et5kGQwQAtu2/
	 otBMed4GWM3lc2ZaXSWNLIHHA655Er5HxnFSFulbPe8XR+3mpZWQXIhYlf+ZqLyaYxUp1
	 Z9+EIK+/jCzFW4AW8KKjklCK7Z6Xh3yT+bslp7M61gMNbPLQk0J7KoKscjVEU/g5pd1Rv
	 VDfyX3EQUNnwtPGEbd8euimZxUS0jnqtSCMjc066/rF+co416L8dt3/3TYbhpaLkc8W28
	 J8202eiVVDA9y7BKC2VC92iqX5odR4fnO5IZ8YolFXSqYJ3+myq/hvsuaVXhcxNSVJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KVmZxPwOonkDnXFqZcB1STPXGO78aU4cTw+Ewu+CNgs=;
	b=ejGrtDAx2uAANDCLPe0biuGskeO69yOH0/nQ+5hgdcdo92kctmKPxqBIyuQ0GdRjLWn1
	 2SlXpm6KU0MDHPL3sDoeHKndp/DRskvzPrUhXp4vxJvcIBuXH15+t8x9hlzqVlJp1TstC
	 1N8LNNWAewBU+r7FxytUV6H2iWog13/rwNVarVdQjrcfRJH7e6OQWHtJ/K2qPnDVduZ25
	 Hzzlv6dkeZ4/pUjusnTJ6nXpPPG5I29cEo5woTyX/FpfWR0KhohT2Ce8rDTWk1a7Iiwa5
	 2GiqQClRUnT1BERFweWifDOmKWZIMgLf8wESPwNBW9714W3VNahHMTo78umgPGsoKgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tSvCeLYZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656B6606D80E;
	Sat,  7 Nov 2026 14:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tSvCeLYZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9E61F0089F;
	Sat,  7 Nov 2026 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062835;
	bh=KVmZxPwOonkDnXFqZcB1STPXGO78aU4cTw+Ewu+CNgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tSvCeLYZNJbQcvpG9I9z4XH6pLpN0yJ1VyxG2Y5U+wGbhrzFf6GQbtbTPnxtZ+DjV
	 j7lCq/IWtOmKtf+SLkOw8M/scUE+0uB61Dt3k1+EevSC10yzDQoDbX5Y40ARG6EK+M
	 4I0Q8jRbuceQA4zsrMWgzLuYBFzypOp7Ri3C0BXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/869] staging: media: av7110: fix corrupted BER reporting in sp8870
Date: Sat,  7 Nov 2026 08:46:12 -0500
Message-ID: <20261107134855.771187832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Punnay Sharma <punnaysharma805@gmail.com>

[ Upstream commit 5764f9bd7b7a72c6df49db6c8c00d4f9994a55ba ]

In sp8870_read_ber(), the 14-bit Bit Error Rate (BER) is assembled by
reading two I2C registers: 0xC08 (lower 6 bits) and 0xC07 (upper 8 bits).

The current implementation masks the lower bits via `tmp = ret & 0x3F;`
but subsequently overwrites `tmp` entirely when processing the upper
bits using a direct assignment (`tmp = ret << 6;`). This logical error
causes the lower 6 bits of the BER hardware metric to be silently
discarded.

Fix this by using a bitwise OR (`tmp |= ret << 6;`) to correctly merge
the MSB and LSB payloads before returning the metric to the DVB core.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Punnay Sharma <punnaysharma805@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/av7110/sp8870.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/av7110/sp8870.c b/drivers/staging/media/av7110/sp8870.c
index 0c813860f5b20..96fd738777744 100644
--- a/drivers/staging/media/av7110/sp8870.c
+++ b/drivers/staging/media/av7110/sp8870.c
@@ -401,7 +401,7 @@ static int sp8870_read_ber(struct dvb_frontend *fe, u32 *ber)
 	if (ret < 0)
 		return -EIO;
 
-	tmp = ret << 6;
+	tmp |= ret << 6;
 	if (tmp >= 0x3FFF0)
 		tmp = ~0;
 
-- 
2.53.0



