Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061567;
	b=oLdlHFO6EV8A9ebaad3MNgSHZosHJQbFRPVO+NgKGDPIrkuJU1pi+VnmSWZvhpdAu4x9
	 dpJmrCx8dWXnWbzMrlA8R5PUi7tWBL7EkwmoptEwF4J0fI8WC7s7GVsZDCtxtKpw3efhR
	 2viXvsBjNuq6p8jm715tU1anmFtN5GX36sfZs2CAPeJkz5V1ztarae14lvfBhNGJnnxnc
	 z9plR4ARwDT2uqe5IGHpIfGk6+3XkGMMtYUhrTSUA7hIYnrrnRtLjc2JU/qXuCbQZGpNI
	 TAYwLhgWL0wuIswfuMVuG5eF+LwHL3Ox9pVjP5/WXguHcHkwvf5uY+lJAMxHgh+pqgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J5m6BKztOqnoW+Fd0u/GteZjyfUx+Z5u0waB1bKvouw=;
	b=oYDhoYPquan0Ul8oElikUvv75F/FY1mBgEUCc0ixRBxAbrmTdJER2vruAEyA+u/DmKDc
	 OMjXc4xRdC8M8dG+/gPUpF2qoaOx5mb1gC2vfP9fs1GoIb89CYa+GzehTyulVXh9kpvl4
	 bdfWqj5Rw7iNJH6ZpeeOAHq4X0oyXLsAd6M/71VKUUrttU4pRNd4P/Dk/MV8/zvsAHNEq
	 JtDS7stsi2wxDsNAjq6F8C5jltu3sw5CasCh9T2tD95FVCHkIcRZNtVLEJB5eIc1B37JS
	 pwL1bz7EY38Cu71lfHvgxPIsa3M7/MQeBGFqd6IWwKHX6xzduVH2UF4m1v36pO+ftjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Elb9XPx7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4A960A2610;
	Thu, 19 Nov 2026 04:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Elb9XPx7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A181F000C4;
	Thu, 19 Nov 2026 04:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061567;
	bh=J5m6BKztOqnoW+Fd0u/GteZjyfUx+Z5u0waB1bKvouw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Elb9XPx7yqKRpyj0Vb7aGV5AeSGg/350M2GrUeocRnCzC9Fh80zAjOL6plZe+XpmI
	 aq9YybSO4Eu362Oq2ub3rlo4VoDZc+MUoF74WzzP9Ykvk9SkbhrEBsldn+L81xjxzC
	 UaqOu/1OXBH6rvT7Im61NciYKr2d1Il5iRvh90XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1557/1848] rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()
Date: Wed, 18 Nov 2026 15:59:55 +0100
Message-ID: <20261118150024.796589781@linuxfoundation.org>
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

From: Antoni Pokusinski <apokusinski01@gmail.com>

[ Upstream commit 07c57022afb3afc0d7c20efef45a4d3c7389b1c0 ]

i2c_smbus_read_i2c_block_data() returns the number of bytes read on
success and a negative error code on failure. The existing code treated
any non-zero return value as an error.

Fix the error handling by checking only for negative return values.

Fixes: 718a820a303c ("rtc: abx80x: add alarm support")
Signed-off-by: Antoni Pokusinski <apokusinski01@gmail.com>
Link: https://patch.msgid.link/20260916205138.16771-3-apokusinski01@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index 280de9a9474dc..b4be5ad6366e3 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -276,8 +276,10 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	err = i2c_smbus_read_i2c_block_data(client, ABX8XX_REG_ASC,
 					    sizeof(buf), buf);
-	if (err)
+	if (err < 0)
 		return err;
+	if (err < ARRAY_SIZE(buf))
+		return -EIO;
 
 	irq_mask = i2c_smbus_read_byte_data(client, ABX8XX_REG_IRQ);
 	if (irq_mask < 0)
@@ -293,7 +295,7 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->enabled = !!(irq_mask & ABX8XX_IRQ_AIE);
 	t->pending = (buf[6] & ABX8XX_STATUS_AF) && t->enabled;
 
-	return err;
+	return 0;
 }
 
 static int abx80x_set_alarm(struct device *dev, struct rtc_wkalrm *t)
-- 
2.53.0



