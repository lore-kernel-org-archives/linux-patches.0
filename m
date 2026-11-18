Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052158;
	b=lOlrQKTFmNYycj8FX8VtQpi5zlZAjbkKaZdIvBfzUop1PWz2zkIOgC8BAYVSWRlmw0mG
	 TytYzL9fWX7SlS4f9DuKgU8w+H13wkvESt2co/l2gGoKRwZ6dilZJc4RVLZ5RuvWm4P4R
	 +/CCD44HxF262S9DfZspfpXxp8BGDk7+Bejz4xLkThGPM1qUo8HadCmW9J8FEnexX+3mN
	 Y1aZWIqS0J60uCyiKoe/0Tte623ZIyYD/w0y2H6y9ASQ4qTWNpXk27Po12O282DiTeLPJ
	 04/Rz6OljBwz+4ZUxwx7IoNUOkhTmeCmwim3zmvMmutwaDrpYV3b7BIWraSUXagFuDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6zaM6NsXovL2FWsj6pMGE+0CUDx5d9mALWK5uzlEcS8=;
	b=t8DEaK1cZoi5s2IKGn38/VlW3x39euK4eDKivaDdlCu2edzWT0GI8Sos0lwwUE+xGm1z
	 rZhRbptoP12gnhP7zQSz4glsXco864uZPOZ+oiUTAxruVChEE1WyQQwLSpsWhiqF7D5Rw
	 RDcDz0E2KtObhmDUcQnu/51Vr2DDYrqta+2KPjLR/qF9sGxAGhYXXVPDBoFFw66/3YFHM
	 5mcFggqgLVsLEwGedWTJ+X1Oce22dvydxiMGUYlFT70474w1CdBAaABFmdhcTit7QXzBZ
	 5Q2x12INYI7bRBZbTtPQ4qK5T10nLIYVx1/MXAESHvBJKv7G0ufC1q6pfoMrCpcXFJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzxm1V6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F01606A31C;
	Thu, 19 Nov 2026 01:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzxm1V6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8ED1F000C4;
	Thu, 19 Nov 2026 01:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052158;
	bh=6zaM6NsXovL2FWsj6pMGE+0CUDx5d9mALWK5uzlEcS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzxm1V6I4986rAdQZubjHrqreZflyxpAoJw9q+2V4cSFhNczWGqHAQgF9VVXawD/j
	 ZplEJwVdqXmciKG+tt+M3XPualqUWHuYFziQKm+fKoU32PBI89LaaXA4UkZ0LWkfnC
	 1pvqMJBbCXCMfMzxsOWQ4TlB2D52lFTMcMhmfU4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0462/2214] media: go7007: bound EZ-USB I2C transfers to the usb_buf size
Date: Wed, 18 Nov 2026 15:35:38 +0100
Message-ID: <20261118150029.698786345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengzhuo Wei <me@cherr.cc>

[ Upstream commit 816c4628b23e8c3d925978433f4dd1a13620c01b ]

go7007_usb_i2c_master_xfer() copies msgs[i].len bytes into go->usb_buf,
a 16-byte buffer embedded in struct go7007, without any length check.
The adapter declares no transfer limits, so an SMBus block transfer
issued through /dev/i2c-N can write up to 34 bytes into it and corrupt
the struct fields that follow the buffer.

Bound the transfer size with i2c_adapter_quirks so the I2C core
rejects oversized messages before they reach the driver.

Fixes: 7955f03d18d1 ("[media] go7007: move out of staging into drivers/media/usb.")
Cc: stable@vger.kernel.org
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Assisted-by: GLM:5.3
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 762c13e49bfa5..6a0733c5925fc 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1029,10 +1029,16 @@ static const struct i2c_algorithm go7007_usb_algo = {
 	.functionality	= go7007_usb_functionality,
 };
 
+static const struct i2c_adapter_quirks go7007_usb_quirks = {
+	.max_write_len	= 12,
+	.max_read_len	= 15,
+};
+
 static struct i2c_adapter go7007_usb_adap_templ = {
 	.owner			= THIS_MODULE,
 	.name			= "WIS GO7007SB EZ-USB",
 	.algo			= &go7007_usb_algo,
+	.quirks			= &go7007_usb_quirks,
 };
 
 /********************* USB add/remove functions *********************/
-- 
2.53.0



