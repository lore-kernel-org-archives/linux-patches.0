Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015460;
	b=bG4mpp9+wt/DrIm6WuI+Okco349GE/gFtn6ZmNaMbxpBVfpdsWLi9JkhqThguz5zDAer
	 YE/ibvvofFqqEIhMs3C3DyA3BQ0HJMQ9ACZAxhGrEmtkUrcayxZDtYwI/Q1qVHfCoyo+9
	 zifITTaFNA5U58+y7j7YurzYnLOLHkvASslXC1afpEyCLHVh0DpAYNsQVEbxAIcs53qla
	 HYzfKUY2dZ2flEe3zUF2XLMQHVpPaU1FRjV9x0LkFIV2/TvJFyI4aKWqn47t5P/b0YbCU
	 qmiMXZpk3uMZJhJkEmzu18EuZh1Nn7R7lTSbEyDu5Orm3SHBLpmeFit+/E148OGkrfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+7uwCR5gmyZVrFoo2kvt9CD2sSEn9Z0CVpwvL99Oafk=;
	b=O71kLw2fcFjHwHVGVPNdZQHSUwJQ8SMLa9kP9HYspavad7fbEFwVLYqlv5AP7qQq7RLH
	 7qTzbbscg5e3WY5463masq87PfAwGW6vqBxtbb409esdEcuRoXImKloRvOyaXqlmL+735
	 AVsbyedwjqzDfIkW5HshrqNenC63Z0TElUsGesSvtolTYKIKbauYtR6TztIpomJ7RFfZB
	 hrblQGIgxmkQXXHlvV30DX0cYf0tw2kSC6+eTA3jet3Enjm1eiaxYCouIRa9OcCN84WR3
	 rYPH/vxcJAQ8WC5t8z2kvNW95PmpA7Tbu+yzHBpE7/nwAc6+IPm8FPTiS4HwWoXTYFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxt18UxZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCC1606A325;
	Wed, 18 Nov 2026 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxt18UxZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA4F1F000C4;
	Wed, 18 Nov 2026 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015459;
	bh=+7uwCR5gmyZVrFoo2kvt9CD2sSEn9Z0CVpwvL99Oafk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxt18UxZUSWA7IuDLkma9xOusXXO2wL0BdenHlxvzAtVrLbBalif7UoXjy89tLS6a
	 2ZuOlLBrhNCOrRpRAwF63bXdvRVJiqQl9O7zRFKlPmPxZTgKPsULujvFNPEfNTUmOm
	 Ebz4phZfOidlJntmobQwPB04ZKkwKKQqyu1O/bPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0181/2651] net: dsa: yt921x: Check lock status with lockdep_assert_held_once()
Date: Wed, 18 Nov 2026 15:23:41 +0100
Message-ID: <20261118150254.379851073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit b1950d0426aabdda485c86b504106b1d7b11f325 ]

mutex_is_locked() was used to check the lock status. While it should not
be triggered unless a bug is introduced, it does not warn on lock being
held by another thread. Fix it with lockdep helpers.

Fixes: 186623f4aa72 ("net: dsa: yt921x: Add support for Motorcomm YT921x")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260831044818.4103477-2-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/yt921x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/yt921x.c b/drivers/net/dsa/yt921x.c
index 159b16606f6ca..44fcdd47ffb51 100644
--- a/drivers/net/dsa/yt921x.c
+++ b/drivers/net/dsa/yt921x.c
@@ -198,14 +198,14 @@ static u32 ethaddr_lo2_to_u32(const unsigned char *addr)
 
 static int yt921x_reg_read(struct yt921x_priv *priv, u32 reg, u32 *valp)
 {
-	WARN_ON(!mutex_is_locked(&priv->reg_lock));
+	lockdep_assert_held_once(&priv->reg_lock);
 
 	return priv->reg_ops->read(priv->reg_ctx, reg, valp);
 }
 
 static int yt921x_reg_write(struct yt921x_priv *priv, u32 reg, u32 val)
 {
-	WARN_ON(!mutex_is_locked(&priv->reg_lock));
+	lockdep_assert_held_once(&priv->reg_lock);
 
 	return priv->reg_ops->write(priv->reg_ctx, reg, val);
 }
-- 
2.53.0



