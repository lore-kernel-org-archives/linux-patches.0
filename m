Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049605;
	b=H+dbsICvmd+kEbVKkDQiS5T9kMP2O0mFMcSZqN19va1WuQtPdjT6J/HRxw4w4nYKY8nQ
	 qd1Z/tM/UDNA0+hbkq+XnInvSjbUsNtT5GxyUte1OAX7Dkk2G27QYVSDZ3LuEE+GsZmRK
	 V+5Th9bp2m9ROmtLEus9Ztk+byLz3IMGIAd+c5XfMMdrZIl0HPselEcTf0Rz2y1fLSN3i
	 S2XgGR8GYakyRmXqOEH0y0Orl5wR64E4142gGVGPkUYhKBbIJWWUCdocJAASL0YAy8voc
	 vg13+SEBK5PFdwmvRcjkqptqspOgMTdYVGGiZY8WoHf6/vr4auBo1pHgxxFEoos99xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g6z7UW75tROV5VcM0Xy1WFCW6M+DEvLzRyZ/qLEfkTQ=;
	b=NLThNmNlUCTkiOPkEdYWP+fQhjrqXhtiZB/+TS8y5NK1Mce6TbzeqrdyT7+WVFn10FhY
	 QZwO7Gl1MjsWgiXLyrruXy17vrXEttchygjdZESkN5iUMCE+r5gepfTYipuogrnILs6ro
	 yjtt9AKgefMwztSNS5Z+ef+UGqhR7Ormi3Loy8NHcEmJz9pzv+I+pVztYdNgDLR9RQF7E
	 vAVwZZb1ywahWXKiwd3SpVoediqyuj+ZhE9Jn5RL9LUJmidN8nOtzXtH6RbDMvI4RtYaB
	 Z5SXrM8OrLu8sQxCI32cYnXFmo+2r8YNwjkHVjg7VAXCLEKhLWOdbNTlxwdR8Fb4cBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HRhKaFX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DD6606A320;
	Thu, 19 Nov 2026 00:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HRhKaFX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781511F000C4;
	Thu, 19 Nov 2026 00:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049605;
	bh=g6z7UW75tROV5VcM0Xy1WFCW6M+DEvLzRyZ/qLEfkTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRhKaFX3ASGBPwMhuMwogIwZ4gfKpRIA+LUH8SjtFz4O868XxXaWKMC2ZBfcRu9E6
	 VOff1VMOD8REwvDdRJ8kNhPx6Sezf40GAUypVZU9Flj1g4bhyp1Bx+E9lmKMG2TqQZ
	 p2YGmFV6WTgBtYuXnDBGCvFDyekcleN3z0sOVHbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2404/2857] serial: max310x: remove holes in struct max310x_devtype
Date: Wed, 18 Nov 2026 15:57:18 +0100
Message-ID: <20261118150328.098370881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit eaf29135abb1c152a05572a5454c61dcd65bdeea ]

Running pahole shows that there are some holes within the
max310x_devtype structure.

Remove holes and optimize alignment by reorganizing structure members.

This can also lead to data structure size reduction for some CPUs.

On 64-bit CPU (arm64):
Before:
    /* size: 40, cachelines: 1, members: 6 */
    /* sum members: 34, holes: 2, sum holes: 6 */
    /* last cacheline: 40 bytes */
After:
    /* size: 40, cachelines: 1, members: 6 */
    /* padding: 6 */
    /* last cacheline: 40 bytes */

On 32-bit CPU (i386):
Before:
    /* size: 32, cachelines: 1, members: 6 */
    /* sum members: 26, holes: 2, sum holes: 6 */
    /* last cacheline: 32 bytes */
After:
    /* size: 24, cachelines: 1, members: 8 */
    /* padding: 2 */
    /* last cacheline: 24 bytes */

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-7-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4efacb600bf9 ("serial: max310x: fix breaks not reaching the wire in RS485 mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 56bd6de30c5bd..d08970f73cbe1 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -268,11 +268,11 @@ struct max310x_devtype {
 		unsigned short min;
 		unsigned short max;
 	} slave_addr;
-	char	name[9];
 	int	nr;
-	u8	mode1;
 	int	(*detect)(struct device *);
 	void	(*power)(struct uart_port *, int);
+	char	name[9];
+	u8	mode1;
 };
 
 struct max310x_one {
-- 
2.53.0



