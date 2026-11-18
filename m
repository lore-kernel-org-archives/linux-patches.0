Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059049;
	b=STlDVrHY/cDyef6zREDtto1vqupkJ7DWd1OQebgVmqSR24174A9fwxDYkXSAzvX6qows
	 WGEKQu6vsFkuhMO/9R2L0sQIw6AFBVEWLLnEvaPPZ9EKsItpxTqDYfFZoRzKrjA8pUKvG
	 i4zjhbHJ41WF164NcxT5UHwT/dOjmzRuc5NqENhPMrut8H64jgEDQ+m5PM4/BIMFS+8Am
	 OEt6JU3622DNFpSk+UV0D6/FftXylQUphF3Ly1AtUNSC4fN5VeOpfyxISnwYUEFrksy6o
	 +DUDJ1FzYkf8+10BDmgYgSICjp9/3qvExetYE3GLlfFhqcdGV/65YWT5I0P34eAy4iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FlT5XkkSmOv7XcLtSCrbHzwC8NTUlbgqcCv5/zHGhVY=;
	b=e5nAtnF4MCdktE1AGPGnrAH2IbBhMNlclxoEq7jQzGvAmkCMSRQ1mYrTTWeSAVdHf3z/
	 BIZyyBdAAPeVuwcPVUmedIoqGG/XLjun9w7sz4oKzkI24bvJx8Kw1oi/EGuHahIO2LPJS
	 E9DAG5pbJXLWOrcRe67BozpUz48lb6rhf7zSS5gumPlbNThq5wd3nDhqPbBM0IgFGqo4a
	 cRzVXtvHeaTrFG02DB2w8PonROy6yHhw3SPSEQTw8A+/xp3S6L94pWxgfVNJWraUm6a8+
	 D2ktKUFuAe6EO19D/juCnG14+mRm5q0kDKNgd258kGT91wNN3Z+OkyOna65XMmAU/pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RX5hhvUD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB7F606A325;
	Thu, 19 Nov 2026 03:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RX5hhvUD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7451F000C4;
	Thu, 19 Nov 2026 03:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059049;
	bh=FlT5XkkSmOv7XcLtSCrbHzwC8NTUlbgqcCv5/zHGhVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RX5hhvUDY6gk/XLixtmtSNHCMUIhfTlfb1wTLsIDonu0sRswVM8iH0oaQ1UlmB9/k
	 a5AfGG/67YXhwp4uKpUGteVRYHqooYvCL1PCXP3lYktvcB+iUQE/0DpphEwn1iIuVt
	 LVFKHO/+g33vz8eeXi+yweY8YTBaYoTc2RoKTMk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0666/1848] iio: pressure: dps310: fix CFG_REG bit definitions
Date: Wed, 18 Nov 2026 15:45:04 +0100
Message-ID: <20261118145943.723370685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



