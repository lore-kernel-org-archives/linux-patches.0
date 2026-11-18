Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061529;
	b=y3cipDun3rdRTM8sQHp0ZxxvSkLQjd8er32JWiNC4DgqF1mGCgCVicdpiCTUAPXfL+tZ
	 Bt42huaRZEHT/y7RbSXEthxey7xBCelTuW9WPW6ozkfPJV+9qn9+41WbOzNPz6fl7lgU8
	 6RjRhPRrfUuiYGU8EY8Z37cOuB9FvHkDt9en9BB5DSrRQo3A38AXeEN6SmeprOTePTmSp
	 6YnoblvmlNCC4xqywibqjczVT6r5ySRsKmu+rrLIVEHVr7FYQcLxjm0DYh7TEFBdHZ0cO
	 y5SoLpbDoEB0e41p0bwgXtdSPgeV2z1k1+G3JB0kd1Gv2FM+WI87j59kjKH/LLpAviA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F7fczbKsISMj84UnNjhH6JkmOTE/VQGpWwOlLsiuBpI=;
	b=Pq0zX1JYauBqsEriFLgDMEtplAn7iP3qtN42hDlJnWBjCTZ9sR8TH5H1vOMcPcEioUNo
	 raYNAvihBnYUrPX0Piz/bbAJ8ZZ1DoOD9fCsVWFZx60n6l8sqGPfx5jy/rEuYi2L6JFlT
	 yVF+wUaqfEmTtbIK+/uyn0hEh1yNCwR5vFeRQ+YARPIJ85pyy1UINZWy1iAUYG5uy+x0Q
	 fePPX59oQ0aLsAtIc9Eovjs5YxCYRyQ81Ror5JABV4vDMDtcfIByEbNjIO5mVFGgdtSsz
	 1QKKyMGrLE5gB9W+JWI3THNpCKYIspdchC6agKcLS0Snuim3rfQE5tEUKdtmE+umlEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x339d4gB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20075606A33F;
	Thu, 19 Nov 2026 04:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x339d4gB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7844C1F000C5;
	Thu, 19 Nov 2026 04:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061529;
	bh=F7fczbKsISMj84UnNjhH6JkmOTE/VQGpWwOlLsiuBpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x339d4gBBtIhHi0v8Z9QR0RZtTUbVaXF5RGM2c3vibwJlUQzYPb3qHXUpDbnbzCOV
	 2DaF7TXYlhxTdD5EQMDD1WMGmdz4Mhq9YRtHWkEpmv3QRkGS5IGkuiudpTIS9WF2Xb
	 Ks52t+H6DYItTylUMHE3TdgZB608KS0+ZzjeWixc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1584/1848] serial: max310x: remove trailing whitespaces
Date: Wed, 18 Nov 2026 16:00:22 +0100
Message-ID: <20261118150025.866748741@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit cee8e0cc9308ab55d4c3bd8eae5f6b4b65898e59 ]

Fix coding style. No functional changes.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231011130317.3562401-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 8a706ab80706d..36f63519ebc33 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -412,7 +412,7 @@ static int max14830_detect(struct device *dev)
 	ret = s->if_cfg->extended_reg_enable(dev, true);
 	if (ret)
 		return ret;
-	
+
 	regmap_read(s->regmap, s->if_cfg->rev_id_reg, &val);
 	s->if_cfg->extended_reg_enable(dev, false);
 	if (((val & MAX310x_REV_MASK) != MAX14830_REV_ID)) {
-- 
2.53.0



