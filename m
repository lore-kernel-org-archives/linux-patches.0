Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055043;
	b=s0McenyzDgPc6KxRQb3ift7JGwbcuONIMTsIq0I6rNKJJQsa9rBmUq3Exy2f51mJf2b4
	 xCThNkfB1QfvMFT0k5vENf6gvSGfuS9DwwWPMyWDklM4hiX6A2+3n8Hl/k+Ey1bPhjWG6
	 uLjOzBQbnvellUCp8Ee246xmutwFLoCZyxFyWC+E4NAG9IeOHEvzV4Z+amk7rdeIVa+4e
	 5TnBHS2t8xcj4O6scCY5tvNNVjmWuZ5MGihsQUB6/8wziTpAxQCH4VVCVf0+lG095ZhZU
	 +6JmMXttxuicqrF0qvhxK6q3StyWpt/SzUATi5i86nmO0mEfR/GslpbCDB+gF+pmTYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tOzuFoSa5OwW2lUARGD3H/4/CG9wlsffsMgw4K9GjV8=;
	b=eDrqBvBJt+JFLRksYO1s0u1iKWB5c3BBVCqT6k9wK5N3KrrbytoNp+DJrZbZGaTG03pE
	 WFWJwnZydYa5iv1K3LlgsRC5LV+j++yWvft60uKdlxbbE323piafQDU+3LqZC8PeVwKJK
	 7wK2mJ1B3gxskea5nFJldxVuPDMzpDGfZK0Ed6fV6ucSGnjQ1FokM6U1l2gDXneLx/9fE
	 k4NkVGIvJWWauvoCHj4B5TYAkg3jJq0n8JLFfsIc3g4u1cspnz8I1QY3Lg/P/OOuVA7nu
	 zCSPaSyRo72GEOh/sle7NGp0BF+JdKCSbtAhaZH862XS2z0jWtNQVXnz2YFGF9QzZ5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tg+9Tv67;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C33606A31C;
	Thu, 19 Nov 2026 02:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tg+9Tv67
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7416E1F000C4;
	Thu, 19 Nov 2026 02:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055042;
	bh=tOzuFoSa5OwW2lUARGD3H/4/CG9wlsffsMgw4K9GjV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tg+9Tv67I3/xTp9BTgTW8WydUnsna9B1NKAsHMYC73JsEJxJCBR2YioeVwHOOuW13
	 Zs8K7AXlvG9aUA2JVp6xudYLjCeFUxecgskeXcm9dhOfHKzh6g8Acdcwdc9R5Yn8l9
	 acr+AnoRKgipuCyd6jwGmyCQT6cwc7qFoYxKJkBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1490/2214] spi: Fix the return value in spi_new_ancillary_device() kernel-doc
Date: Wed, 18 Nov 2026 15:52:46 +0100
Message-ID: <20261118150110.941865461@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3742867ce96539100ed5f4c754f04273d8aa00d7 ]

spi_new_ancillary_device() returns the new struct spi_device, or an
ERR_PTR() on failure, but its kernel-doc says "0 on success; negative
errno on failure", which was never true. Describe the pointer.

Fixes: 0c79378c0199 ("spi: add ancillary device support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260911230211.11755-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 962598f2b109f..490dfaad46e1e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2230,7 +2230,7 @@ static void of_register_spi_devices(struct spi_controller *ctlr) { }
  *
  * This may only be called from main SPI device's probe routine.
  *
- * Return: 0 on success; negative errno on failure
+ * Return: the new device on success; an ERR_PTR() on failure
  */
 struct spi_device *spi_new_ancillary_device(struct spi_device *spi,
 					     u8 chip_select)
-- 
2.53.0



