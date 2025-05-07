Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D144428BA9D;
	Wed,  7 May 2025 18:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644235; cv=none; b=L/9x3pqzj+ksnGe4cJuizlEJ5WWd4mCjz34XMtnpfS8SqhIcuZDpKCoCukY1edA+6bayum9ori0XsSgW3uWNFFE0paJzdBnbhOikVFxxxt5tjlBMeWSTUI4bzH4FyD6RU0bHBqem3xX2a+XRQj7TQctEjNLGqE7H8AwKz0ME3F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644235; c=relaxed/simple;
	bh=DTPrmJkpdXVHEy+qiuO7YxQ+GZBV4W5Xq+PweEZKbIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkDUhgcNusRpkPPk3pzk4XtC7dThJhZKLzW1iFGqkU84+Ojx2uBEzUDdpZ9eQxXUAlq6CFYI7Ooc4MKcPfp1hnJr3hCCnzy42FA0ItohXEyFN4sCBg3iceGGf2ZTSuI0ZMHrhLtlbzjeFBfB8FCCgGC8MzRCaC1wvLkC4kTbHQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I91YAe8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I91YAe8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5818FC4CEEB;
	Wed,  7 May 2025 18:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644235;
	bh=DTPrmJkpdXVHEy+qiuO7YxQ+GZBV4W5Xq+PweEZKbIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I91YAe8MT9mWtU+UQClZQd21h8B8ozL+5ByC/0+1Z987V/Up/Dx4hxy82oJXAOj4Y
	 YcamqKIzV7rvIZPygoiY/RMSAbrv+jpj+8txsD/tIizgkb9qZa2j54bqnWXKydRQu9
	 8jLlrTWnghQHd0szUDlzBYwGLgZ8sGDWQD2SqPBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 145/183] net: vertexcom: mse102x: Fix LEN_MASK
Date: Wed,  7 May 2025 20:39:50 +0200
Message-ID: <20250507183830.741849738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 74987089ec678b4018dba0a609e9f4bf6ef7f4ad ]

The LEN_MASK for CMD_RTS doesn't cover the whole parameter mask.
The Bit 11 is reserved, so adjust LEN_MASK accordingly.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250430133043.7722-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 92ebf16331598..3edf2c3753f0e 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -33,7 +33,7 @@
 #define CMD_CTR		(0x2 << CMD_SHIFT)
 
 #define CMD_MASK	GENMASK(15, CMD_SHIFT)
-#define LEN_MASK	GENMASK(CMD_SHIFT - 1, 0)
+#define LEN_MASK	GENMASK(CMD_SHIFT - 2, 0)
 
 #define DET_CMD_LEN	4
 #define DET_SOF_LEN	2
-- 
2.39.5



