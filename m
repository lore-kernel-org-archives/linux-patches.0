Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591015;
	b=S4c+WDhIGSenKAO0fmAgjhQFtFyxINvhBD4B5H0ZFVFlbN6QhjveBGWBeDMcnzh9JCh2
	 NXCGYKyHubomMz9rFrBek176FU1tW0LNrl6sjajLktoiCW0Dq03B3uNzN9j7yAEaJlP2g
	 5tzXJMKppmS8cxdx1XuHQ1CoagYtGJTevTu4VUQg9EqKmQJpjAo0dxo/lL3pipnt0hXmw
	 LpcX49k4CFcoo5ZlCQ/f0I5he5/qMeSL+4ZeUAvh+p1oWq3Dd7egYSqqW7Hop5m6beXj0
	 OPmy/cynQde0+mvk5qrQWM7ZqXlyRnOkKz20ngbb/G76m0wHEtB8lbwGUx3Jq/nsk7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=13iOjSnK+4OGzZbpf4DU6GJGLpC+aHu1aqcRVPpcAMs=;
	b=dqgGhASC3UjU5C0UZQbIzE3kQkhksgQG95Oer7RRb4dsXluBvgmcf2BdI9WVCGy21PCZ
	 3GbxyLUoJqmP4JpG37gBpt9o6iCeQoY9QTl8u+4K0R+W/wGludTvpUb2aeqfwXXZQrJVj
	 EzU+8NKLPtY4tWo594aMYdrENDBAkELU9lt+dAE4fdAi0UNo6Mxr0vxDP+rSRsdNGUwat
	 IvouSx57vADiN6PWkvJj31GpJZwQSqYZALzQGKVxYCqXHEezt5lVmdeufBELMoZYwO/Za
	 hyXY8jHUFl0W35hbFzLYCS57vJXngBrwMfn16G8wHvrpqceo+DkGI1L5i7hZ62Hct6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dm8B0LT/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2155B6070F1A;
	Fri, 13 Nov 2026 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dm8B0LT/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C9F1F000C4;
	Fri, 13 Nov 2026 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591015;
	bh=13iOjSnK+4OGzZbpf4DU6GJGLpC+aHu1aqcRVPpcAMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dm8B0LT/AcQa5xkDQ05LISSpHAoPoZ69e0EIVbrnM7kyhH6brWAnCiAW0spR2TlKv
	 wb24jdImyTPWOAwpdzDvPfbGYB/DGRd/BsbhJo9j9AF5NjoBWzlZpAGCebLYk333Mm
	 bleKuitKmNMd1/e0DYpFMdlarsjm6sEI9jgC0fRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/670] iio: pressure: dps310: fix CFG_REG bit definitions
Date: Fri, 13 Nov 2026 10:45:11 -0500
Message-ID: <20261113153816.909463917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 5a986d5d6b66f..aa2284b388787 100644
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



