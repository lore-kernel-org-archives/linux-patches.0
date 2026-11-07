Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062175;
	b=13MtYmGFpv3wTd4Zl8FJdwdyFaR2OMd8CO4VkXGelO6XS5UF6E6Cn+AesiMBoIpE3IUL
	 ZPEBKYEiWo6YkwM5MiR/51Hza8ajNBzwt5bvFaCyJL4WxHAhKAc4Ze10WgHMlwVee7Epf
	 HUwqEEv4dWSLytowJBnzZZJKh4MXxaNKIrndCmjJpia6v9JHoScPYOZRxr5mekllU8P0r
	 x2dM70EyMcm2JmIK4HhNvxXXJA5jjFgs9MiLUisB+yU54Z1krwTcpnHF0KftX3WEFTmsu
	 Q/2yYaVuQ7mBfmCl6eovKRGEmjKXf0Bqi8d83BEa0LntqYdUBMWc0q8170FUUE9VL4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=233q7nUD2kpfv9FiFB29OMB82raTCouKwHHR+asm1bM=;
	b=xkHEfBg4qkCMeA78pHmgXFbRNlOmwY8+UpcYh33lblGjIQPA2u6DEKnE6bO0ro+Hr+p1
	 PYxOC0EOHEgl7jRiu6a2V/Ej84bEkZQX1ykTW7xQAjFr9AUQV+XPB+9hdMzlJEbW5pt0G
	 rSDZM/IWUlceWWYUs0OuKVdOal9n7nlG8cFhupkKYQI2qhhpJ8IqN/gVPyBh/j+iqP9RA
	 5hQTD0bDmcEksEIvCvK1uOw9w/405tbIW25N6ql+rkQOLEKFQYdYGm9KaSqY9uqAcX+y1
	 aenPf+YvuuMLaAM3BUBkUGrKfhKj0xtuPpP6em7h0HkjG8QX/c5OxfdywL9gVD2XfhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZDgX9HD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2464A606A326;
	Sat,  7 Nov 2026 14:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZDgX9HD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03261F008A2;
	Sat,  7 Nov 2026 14:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062175;
	bh=233q7nUD2kpfv9FiFB29OMB82raTCouKwHHR+asm1bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZDgX9HDaV9i2GzCZpxH6H1ajbHMAJvKVInqc2cb55xWkliy8Aw5SQKMlevbDHuH/
	 ovyxC3MkVZX4uhZAzV1/usLGhI/THerZ+N34tUOxFcRATlu4TEkLkoYhSFP45ST9IU
	 l7IVlUEFyIF11Z+zKRETWPlcS2wEnGn1Z7mWPlSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1135/1536] crypto: nx - validate ignore before subtracting in decompress
Date: Sat,  7 Nov 2026 08:52:31 -0500
Message-ID: <20261107135029.594068857@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit b5c2df42977390a71f1940def5be9bd5c69ac2e0 ]

The decompress() function subtracts the header-supplied `ignore` value
(a u16 from the compressed stream) from `dlen` (the number of bytes
produced by the decompressor) without checking that ignore <= dlen.

If a caller decompresses a crafted buffer where `hdr->ignore` exceeds
the actual decompressed length, the subtraction wraps around to a
near-UINT_MAX value.  The subsequent memcpy() then copies gigabytes of
data past the destination buffer, causing an out-of-bounds kernel write.

Add a bounds check before the subtraction and return -EINVAL if the
value is inconsistent.

Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 3b82b6f67f8c4..fb30bdb55c009 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -418,6 +418,8 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 
 	slen -= spadding;
 
+	if (ignore > dlen)
+		return -EINVAL;
 	dlen -= ignore;
 	if (ignore)
 		pr_debug("ignoring last %x bytes\n", ignore);
-- 
2.53.0



