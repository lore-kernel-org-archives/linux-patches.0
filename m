Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CC6A47;
	Mon, 28 Oct 2024 06:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097965; cv=none; b=IJeWF/iDwjKL2FBaGlN7bSqD/oeOk6STv3BhkcPHJX2ETYhZcLmLDAardUlSDGM1yiGzhCQc5IOwZOlcgQmV7N0frZQ2QG05d60mNc5mYpJkUrZk9XsjMR92JDCyQelCR20ogI/y8vTWyBDnaTIgW0n6Xk5lt/4J9aGGdunKlRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097965; c=relaxed/simple;
	bh=s7vq1QYyBg+YA+ZBdu0kxAr8bX8FcUuUwTC0dUdwJIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCYQ5lSBJXPGB1zW7RjNp6HUnYbM/t+ZztlMgOmYxkdsj8zvOsza3A870MFqM3og2tiIjWEhP3EMINUTcTt+Vk3NbxZqGcUE7RRqMdsMiBqOtv34qalyjRn5ZMHQzTavdsEcTZkw7B3nynfgADioUqKaMBEGNbwWp14Q3sm1xS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iE3/S7U8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iE3/S7U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D89C4CEC3;
	Mon, 28 Oct 2024 06:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097965;
	bh=s7vq1QYyBg+YA+ZBdu0kxAr8bX8FcUuUwTC0dUdwJIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iE3/S7U8qELhsvsAzE47LVQU4DJL3yFlXzDKHsbba2oWDhqh1y6qD68XcXfyzyjPd
	 5PUj2/3mXf5PBkzjZ5sPhscuJ+GbdlWirL31wEMu0V6RC1be7APAFZoCd3hcpC62UJ
	 Cy4SHlbeNoGecRokLjRCwSpFVEHxNW1G5NoriCb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Hal Feng <hal.feng@starfivetech.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 003/261] reset: starfive: jh71x0: Fix accessing the empty member on JH7110 SoC
Date: Mon, 28 Oct 2024 07:22:25 +0100
Message-ID: <20241028062312.096216053@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changhuang Liang <changhuang.liang@starfivetech.com>

[ Upstream commit 2cf59663660799ce16f4dfbed97cdceac7a7fa11 ]

data->asserted will be NULL on JH7110 SoC since commit 82327b127d41
("reset: starfive: Add StarFive JH7110 reset driver") was added. Add
the judgment condition to avoid errors when calling reset_control_status
on JH7110 SoC.

Fixes: 82327b127d41 ("reset: starfive: Add StarFive JH7110 reset driver")
Signed-off-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Acked-by: Hal Feng <hal.feng@starfivetech.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20240925112442.1732416-1-changhuang.liang@starfivetech.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/starfive/reset-starfive-jh71x0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/reset/starfive/reset-starfive-jh71x0.c b/drivers/reset/starfive/reset-starfive-jh71x0.c
index 55bbbd2de52cf..29ce3486752f3 100644
--- a/drivers/reset/starfive/reset-starfive-jh71x0.c
+++ b/drivers/reset/starfive/reset-starfive-jh71x0.c
@@ -94,6 +94,9 @@ static int jh71x0_reset_status(struct reset_controller_dev *rcdev,
 	void __iomem *reg_status = data->status + offset * sizeof(u32);
 	u32 value = readl(reg_status);
 
+	if (!data->asserted)
+		return !(value & mask);
+
 	return !((value ^ data->asserted[offset]) & mask);
 }
 
-- 
2.43.0



