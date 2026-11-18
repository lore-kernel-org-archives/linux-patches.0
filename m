Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039693;
	b=HmaJqc98t/EUoB7AsI46XL1jbRH06RILpOmw8KLTOvJdyqh1H3M6juMu7WYYF+DDbLnX
	 /Y7qKCy3kNWzrCE/WFKC3PMpRBLlOU+l2YcDHx59XmUNG/ZFHWw4XHmE6YnnlrkPvkOL1
	 p6DX91wp8kQppQlQfvSlspPem1yyT5Qx6YKs5c9UWCBuduWjrhyDC9315hd624hrYKt4L
	 1hfRotrpqzQwZGtdAJMemwzVZzBiMNLB5I2NKKfzO3Mcn5HqPKbf/9VOQhikXIuVETwD6
	 7IDLMmrRsiLi0DUYbTAaR+0pjxdq0id3LLvIVa5w/EXkaqwwHiT1YLz0VgCdmFfcUjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G7k/qiQrbhbDEf50przYdEIAZnajniWz2y5FUZWFRqU=;
	b=phLzSbX3Ww8WrDygSjtoH8FYv/JgTYbOChGWjqQl1YfPgY1s8Y4I1yqLDcLCJxyul/oC
	 eIsFRhwbPtB73zUaZ6fNvnDtSbLy83aZnH7yrtsiHKhfCvOgp4kpu91dySubpbZaQeB6Z
	 ehxEg6GuYL8zVe4V8epTaoFoY3KB9HxH8BcLIEINiSdmeU9wmZViHBj6qmPa8xXVDdZvf
	 d+PDq9/ubScya/EGydK6TQj1tYXs7nI9GVDjf7pr6Pe39GG1LxfVW2RV3bKsGht8tns17
	 0oApC2LuYw0qhllchrvlSgqgP8OQTiHKbNcbFRO6f2jZmU6CM+sI35epI5RseRD/W4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQ9z+ig0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520AA606A325;
	Wed, 18 Nov 2026 22:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQ9z+ig0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76201F000C4;
	Wed, 18 Nov 2026 22:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039693;
	bh=G7k/qiQrbhbDEf50przYdEIAZnajniWz2y5FUZWFRqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQ9z+ig0dhTK5M6Xphhsetq3TdYpARyPcUVy8F6V6UxxTI48Om+Wmlndgqpx0iQxn
	 wXEa4LgT3x0MevHiQ/t1BdDCSKhpEL2WSDr/mhnRsHFSQjQm/+LmgmM2trIfgZYHIR
	 vFwCicYqzdbV2TrfieneNbezVzwoVX3Q74cmEMzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2192/3318] spi: Fix the return value in spi_new_ancillary_device() kernel-doc
Date: Wed, 18 Nov 2026 15:46:54 +0100
Message-ID: <20261118150427.708717221@linuxfoundation.org>
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
index 9a011544d1544..9681b05e0d5b6 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2423,7 +2423,7 @@ static void of_register_spi_devices(struct spi_controller *ctlr) { }
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



