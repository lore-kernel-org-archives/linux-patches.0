Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053165;
	b=q3ObdtwwI+YEHVjgu38DQ9mocJ89GDr2QYkHSuhxNsgeM9oxBqs7OWPfYNr2K/joxUxv
	 Ba9LST9ztIMIOFGfvegKxQ517BT1UMq9ogrguL8dFRl10FjGrhBnxzLngRUBVTc4JCoBx
	 SCzSVbNCNCcSz397bHJ2+ma6RpLR5dUkZstn6jQXN2iYfDOXCP1guGqGGxnhCRA42bw35
	 IYV1md/EC8EJquj2vrUFAxBMX0Q+aaZ2JEaycRQVrc7B1EVyahkrqSJLulIFiBJpC/+Xr
	 UgZvQV/RcoRka1fkcY1zKG+fCQaKtS7N0k//QmYf/Vrv1RC4hV2y7EKJ1AbnZkhocsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uIbCwiDnbuN0aKfYvPxefsF+KM50kgm4s0Q2hOb4lPA=;
	b=1fmcrJwXhcN9PC+K6KQLCCoKTlEm5lIegnjbPHKNM8MmiNvcxuV4V08AvPwNbAKfE6iQ
	 aWVbtkrSrhbwCqspxJE2S2fUILs/rUt8KnTXtygyQNVJWirQHQMMzThZ4fSEx17KGmLqF
	 HVHErci4i+JP9Hixhqu5vDsWGw64cNNEY0YSTmrqNbdU0ptyf3r8OhYwKMdCOZPvne+WL
	 48yWGRAZSCMUi7g0OEPTTYpqExjjeDlZULzgHD9j1BJ5qD+IWS0r0Et1McxqMEXrocAA8
	 snXyzkDTPAPtsFSjcio7E/HbZberabTag/YGwWpwmS0wzXgtwabXvhoC2hiSS5OH8QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlP5dcxw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E279606A320;
	Thu, 19 Nov 2026 01:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlP5dcxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758651F000C6;
	Thu, 19 Nov 2026 01:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053165;
	bh=uIbCwiDnbuN0aKfYvPxefsF+KM50kgm4s0Q2hOb4lPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlP5dcxwsw0e/oSihvAihKTXqsE8A9dfxppgJIVueWIlDryFfbOhllAx4SIIKKq6D
	 jVhlhlbxctp4uM/+VdjB1jXN7S7oJGiWG+bOBy8C0+D8dvslpYJPd7i+q3FEFLf6OF
	 PhlEE1aphCjd1XUjXGvepU+fa1OIMYfq0QfmBQ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0821/2214] iio: pressure: dps310: fix CFG_REG bit definitions
Date: Wed, 18 Nov 2026 15:41:37 +0100
Message-ID: <20261118150044.538736100@linuxfoundation.org>
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

From: Rupesh Majhi <zoone.rupert@gmail.com>

[ Upstream commit 4334dc4092c271e6cd010c2ee70b7f4415c4c199 ]

Driver defines them as BIT(4), BIT(5) and BIT(6). Per datasheet P_SHIFT
is bit 2, FIFO_EN is bit 1 and SPI_MODE is bit 0.

Only P_SHIFT has a user. dps310_set_pres_precision() sets it at
oversampling 16 or above, so with wrong bit the result register is never
shifted and stops matching the scale factor compensation divides by.
in_pressure_input returns -ERANGE at oversampling 16, 32 and 64.

FIFO_EN needed by FIFO support later in this series.

Fixes: ba6ec48e76bc ("iio: Add driver for Infineon DPS310")
Fixes: d711a3c7dc82 ("iio: dps310: Add pressure sensing capability")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/dps310.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/pressure/dps310.c b/drivers/iio/pressure/dps310.c
index 7fdc7a0147f0e..f974e7b516453 100644
--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -50,9 +50,9 @@
 #define DPS310_CFG_REG		0x09
 #define  DPS310_INT_HL		BIT(7)
 #define  DPS310_TMP_SHIFT_EN	BIT(3)
-#define  DPS310_PRS_SHIFT_EN	BIT(4)
-#define  DPS310_FIFO_EN		BIT(5)
-#define  DPS310_SPI_EN		BIT(6)
+#define  DPS310_PRS_SHIFT_EN	BIT(2)
+#define  DPS310_FIFO_EN		BIT(1)
+#define  DPS310_SPI_EN		BIT(0)
 #define DPS310_RESET		0x0c
 #define  DPS310_RESET_MAGIC	0x09
 #define DPS310_COEF_BASE	0x10
-- 
2.53.0



