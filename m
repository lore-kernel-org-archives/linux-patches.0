Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CE92144BF;
	Wed,  7 May 2025 19:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644713; cv=none; b=A2vW01kz4BJt4CThT557FaI4LQbBG86iGdwFzKduMDDLvSgSPa3HITg/QAYB7vTHY/vRNZMYqU/sRZM9ROg/gidnD0T8ulMxr6OE9LHO+CO7B0jUZh0EPqX/uQcJFAwFOxD7LJhsT/FDdM7azF24tf+BgHrDmAU9M3XjhgGCrp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644713; c=relaxed/simple;
	bh=uKg8vyBpmflQJqSqjT3i22kT2s1iE/TBqL7gLzuN5Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB38qtJ7S4cI6+L5I/MABrlpSRDxnQHfL5HCoeKlfiWt+O0hRh9pYoUgfVdJXmK34de9pno3d3tdDqmjdjdkOmQP7ZG+ol6q/OYjhFntOatV+bXwMNRTe3Cyhdk3LwomvGK9LkzUwQj0RQ4qIS9g+AyBB3GonSYOcZr2zpUQeTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpnBxomO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpnBxomO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0E3C4CEE2;
	Wed,  7 May 2025 19:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644712;
	bh=uKg8vyBpmflQJqSqjT3i22kT2s1iE/TBqL7gLzuN5Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpnBxomOBuXb+KBESHVkhGNg6U5czTklOW9mFzurk8N4R0D2+UhyMsahjUKpRkDnW
	 UcR2QHEn3oqMyHo5qcd7LQo3kZLLZuHY5gYHs3LC0z8kLx+jHsXgLWAtDrLneuT8NO
	 rjcTPNbfnIOlwzLZRrrw0INmx1xpXvY2YbnfSEtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/164] net: vertexcom: mse102x: Fix LEN_MASK
Date: Wed,  7 May 2025 20:40:18 +0200
Message-ID: <20250507183826.359581280@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



