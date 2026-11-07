Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063901;
	b=uBH3MpCyW8MFdRPUOAWCrxF7q3CsHe5CnW494N7PgL8gEOlwg7Pn4MeY1rjuGdrg4TiF
	 VS9f5YAr+rI7ctqwFvMS0DChdVXDxvKAzurbTuAV0gn3tcNhz2W8EcTeakmwMzDyTkInv
	 B5TuhyB0lZjVy7RZK7rdWAwWztBY0Pngz3sUrRRYDlFDv7yHluWvpr/EO73mOlNd7nbcf
	 TonJ5lpdOO3B6JV+/vInbm9Fkx0tlEYxvCVMaXKiFvTv1Ye2QUwHrQ+9w5hLuQnaNEzX9
	 zUgaBRJDJ1meJXP+izT1iMFdtRROkiPqPVLk9HZKTS7wnCadmdEQBcSc1zU1nBl5+Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=41TQBnnnAtEYS7LHfcWQE2Bh77RfknOG2/SOcilWqSo=;
	b=Q7CqqvUcrDpBzq3pUXfHZb59JH4AHsG7fBWu3l3qJdoAflPfYxwhNelUE+XmOQg8XHBD
	 nzO0iuV58PwzhOWP42RwagR5KFqWg3zzqk5n++pCcCQeTC5YyG6vAB7wp0sh6rMUeSbBD
	 BFFv1kzeuEbWuLx6ds8dCRtSZtzJeHBq7TMzxtdiUXc+D3Cg8BIhtwoi7APmnmXUoGXba
	 pEq3FpCRyNNa9W/Sa7TXZJ+ZpK/rK8dhqxDgi/BKG2YL++NKkcKAWQQwAhDkuSDdV7a+s
	 6rU7wtjrl2jJ/ej8n/h9KrJqWpS6JwKlJIVcK2gsa/UQmmDkSL9j8jw39/fB3vRAUGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdQKNTFI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262D9606B8AF;
	Sat,  7 Nov 2026 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdQKNTFI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C1E1F008A2;
	Sat,  7 Nov 2026 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063901;
	bh=41TQBnnnAtEYS7LHfcWQE2Bh77RfknOG2/SOcilWqSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdQKNTFIESLMQxEJnKK8pjaYM5pGK2Mm3yq2yYXwWN7RuYr87bZwuQmZd7kVYpyWw
	 YRTgxUKST0tiztsfWZcKn9HsM/Ln1JfeUrngqK84qGVyQpBexmx86Z2WmlX9J9/F/R
	 ej09Y3YZb2RDqP1UL5LcPymQNC7weIoUoY0ad7Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0102/1257] staging: media: av7110: fix corrupted BER reporting in sp8870
Date: Sat,  7 Nov 2026 08:39:58 -0500
Message-ID: <20261107134942.174859295@linuxfoundation.org>
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
index 29fb4934c039c..77bebf2c7d5d8 100644
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



