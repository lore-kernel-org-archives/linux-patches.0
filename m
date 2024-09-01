Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECF5183CC2;
	Sun,  1 Sep 2024 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208479; cv=none; b=d0Vf8aRFSGksMK3j7GZ1JYECE/4cRvjHW0dOrVZfK+EO0ww00YomkUgbt3rVGcyCsNhXxfw/tvwAB0vEjryNp8Txe5f4u8ukjbLtywUwRJDX3wsDqJcykdy7jW0UHVieU8cXkKdBdNJ18/Zffy6pa5HppldKUSy5S6MySJccqGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208479; c=relaxed/simple;
	bh=aoneMT/uicfKVc7Kh8Q5Jde3sb+kT9zEOUhU22unMqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQ5y/UpBfAtGm+WXzK84xrra225ndgpYUYyRVuLGphDr93lrzGoA3tMPUnPFJqymnP46aFzIB+Mvij+9+i7AkR7LcGeIiKhzmlv0STI9R6UnKdBXGiicJp/YskQl2gqn3yXyfuKsDwJ5AJ7Dmf7iZY2dpE1SSV0jsnD9VTcrHEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwHZOPFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwHZOPFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B56C4CEC3;
	Sun,  1 Sep 2024 16:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208478;
	bh=aoneMT/uicfKVc7Kh8Q5Jde3sb+kT9zEOUhU22unMqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwHZOPFumfmvPN+ioG/NVuVnTWX0R35+7iSBvuc3rnML6jz18phmmbzoozs8HreR8
	 aH7Cxny00zkXLvm/KCfUvJJgIusx/gE1IbMaHnz0U0ok64meryeJGQjpDK8XqSMxU8
	 iz5hiaMgATt8wgibmhpnLHb5ZDAQ0qCF7biGd3tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 063/149] pinctrl: starfive: jh7110: Correct the level trigger configuration of iev register
Date: Sun,  1 Sep 2024 18:16:14 +0200
Message-ID: <20240901160819.836744644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 639766ca10d1e218e257ae7eabe76814bae6ab89 ]

A mistake was made in level trigger register configuration. Correct it.

Fixes: 447976ab62c5 ("pinctrl: starfive: Add StarFive JH7110 sys controller driver")
Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
Link: https://lore.kernel.org/20240812070108.100923-1-hal.feng@starfivetech.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c b/drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c
index 9609eb1ecc3d8..7637de7452b91 100644
--- a/drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c
+++ b/drivers/pinctrl/starfive/pinctrl-starfive-jh7110.c
@@ -795,12 +795,12 @@ static int jh7110_irq_set_type(struct irq_data *d, unsigned int trigger)
 	case IRQ_TYPE_LEVEL_HIGH:
 		irq_type  = 0;    /* 0: level triggered */
 		edge_both = 0;    /* 0: ignored */
-		polarity  = mask; /* 1: high level */
+		polarity  = 0;    /* 0: high level */
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		irq_type  = 0;    /* 0: level triggered */
 		edge_both = 0;    /* 0: ignored */
-		polarity  = 0;    /* 0: low level */
+		polarity  = mask; /* 1: low level */
 		break;
 	default:
 		return -EINVAL;
-- 
2.43.0



