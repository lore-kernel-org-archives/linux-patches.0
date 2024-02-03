Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD9B10A13;
	Sat,  3 Feb 2024 04:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933768; cv=none; b=VQpiK4e42NZLFcYL3/ywpNhUw9UNY58fQ99Xk8WvOYuWoOEkLauMk2QxI9wJvMoLyPvdwY0lOEklh8q7TziNe1hznU/mMhz2dth3qAfiV1tDDVXujzI6zlt9MXULpCv8VQ3LpmdD5odDP2eGoXfm3zKV5YC9a6ILZfNE2kK90fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933768; c=relaxed/simple;
	bh=22TDI6BcpLMOQniXuU4CGSa0qLtvmmDnL2YzkI5aCgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUIffBEZeuIO5wmrJP7i+mjxHpXRY6ovhRftew143pymlyXU9CakKyeI5UXF6Tb5ICikX/ILo16BZZU7hTA4bLDedH8bS1one5nbCeOOM6XjGDmhCGqf95mrsHZP47q4CSpx2l5deFVSi8qD75vmGat7t3J5DytVcIh2vM+ZAyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXCW9U+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXCW9U+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E05C433F1;
	Sat,  3 Feb 2024 04:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933768;
	bh=22TDI6BcpLMOQniXuU4CGSa0qLtvmmDnL2YzkI5aCgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXCW9U+pDHg9OReBJa8QEuePmFY7+U/7gX+2gmOecg0u9ib5f+O7GTNmZ2K07LEYj
	 Noszhufb36C8L6QjlD2FhQ8ytiI4b9kAdWzRgduTyGkgoeySD2JPa0oWHbVBS1gDMT
	 VdWbo/Ajnl/XPMmcYq/1E2Rl7nalL5FH0LeTBY2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 069/353] wifi: rt2x00: correct wrong BBP register in RxDCOC calibration
Date: Fri,  2 Feb 2024 20:03:07 -0800
Message-ID: <20240203035406.004644124@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit 50da74e1e8b682853d1e07fc8bbe3a0774ae5e09 ]

Refer to Mediatek vendor driver RxDCOC_Calibration() function, when
performing gainfreeze calibration, we should write register 140
instead of 141. This fix can reduce the total calibration time from
6 seconds to 1 second.

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/TYAP286MB0315B13B89DF57B6B27BB854BCAFA@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index ee880f749b3c..1926ffdffb4f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -8659,7 +8659,7 @@ static void rt2800_rxdcoc_calibration(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write_bank(rt2x00dev, 5, 4, saverfb5r4);
 	rt2800_rfcsr_write_bank(rt2x00dev, 7, 4, saverfb7r4);
 
-	rt2800_bbp_write(rt2x00dev, 158, 141);
+	rt2800_bbp_write(rt2x00dev, 158, 140);
 	bbpreg = rt2800_bbp_read(rt2x00dev, 159);
 	bbpreg = bbpreg & (~0x40);
 	rt2800_bbp_write(rt2x00dev, 159, bbpreg);
-- 
2.43.0



