Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035826;
	b=18Wr3N7aOblOj5R6ZDK3stbY3gIOv8Qai4/zbaPgv0BZnc7OLrgmAu0ue/jeBTXrbhjQ
	 5fn0YCRSzdYAifHkr5ecgRAcZ73Eu+wVPjCAHr1S8Jek+ZqmPgDUS0XfnsZ8N+hTdpswk
	 6hKCjv2EaMnfEI7okVF/sABOvh0r6n0YS0wvj6QXLDw+9gv2AMkcgBYKZ11fnweCC+KuY
	 VHl4rEyH6ENzDRQ9VJ5H6y4YJ9MQh+eo9/Vsid7zUsJfcgGECgjZxRQBU1bt6MEcKPoon
	 doCfQtwY1XhFib88vhCYU/qSKqE8vulhhSZ9sJVKqWcTIt6lVrRRn/wxvPbGNF6I19A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M5LHLQjMTnXxJlFXztE9NJHAaozewl5GjgwUIu5ksnM=;
	b=PeY1tIqSnA/pXQqKncC6eAwjRdFRdJwuao1hdfbPY4fDELZC0A4mi/AVxTxZ3NQARMvA
	 bHhiBpTSuLkh94NST/BFKOE64lEgRebNzsVY7K/Gzl3xzfEa+S5AyvoB8/OI2townjlXd
	 1jxHf7aTCTbxBsZ5j2ySzVzoQrCps7QZLSc0+Obo7EqllfL21U1NL5xYZXzYXluIAkjAO
	 XkmsITsrckxSplweuNgzo69le/hqnMgVAHdBcGzXT6ZRRm3HDskamYpcv8U+0yLeoqyWH
	 NqRsvtqyecqSkurBFBLNMgxuB+6MFMF1ZuU3uOwH/3sUkhB6NG9XYVTLEhhMPsFWo8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyvgBp+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C29606A32C;
	Wed, 18 Nov 2026 21:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyvgBp+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151661F000C5;
	Wed, 18 Nov 2026 21:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035826;
	bh=M5LHLQjMTnXxJlFXztE9NJHAaozewl5GjgwUIu5ksnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyvgBp+3auCJ/hcpIoj5AI/523epK9USwFXFRAv5fbLTEXasti8xjvNPopm5yTlBt
	 RgtNujwPPyGq5jBrGqa57sa08JUSJPoERar3eR/FQrPZ8Bk1dLtKjaI2ioC1eU9zhi
	 AYEynHlyVMyUr2WxZnarQBf5XgzkisrmJR+1N0iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0842/3318] staging: media: av7110: fix corrupted BER reporting in sp8870
Date: Wed, 18 Nov 2026 15:24:24 +0100
Message-ID: <20261118150344.438423281@linuxfoundation.org>
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
index abf5c72607b64..3a9fbfc5adf03 100644
--- a/drivers/staging/media/av7110/sp8870.c
+++ b/drivers/staging/media/av7110/sp8870.c
@@ -384,7 +384,7 @@ static int sp8870_read_ber (struct dvb_frontend* fe, u32 * ber)
 	if (ret < 0)
 		return -EIO;
 
-	tmp = ret << 6;
+	tmp |= ret << 6;
 	if (tmp >= 0x3FFF0)
 		tmp = ~0;
 
-- 
2.53.0



