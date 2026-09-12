Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DBE3A7580;
	Sat, 12 Sep 2026 20:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243382; cv=none; b=rKzRoUGPyiq9p6ujiWXYIRY6+yURpPhIP6r+ux1K+2amfbu5yHDCkntJtjYNBJu3R3N638iVy1hxP26+YU3S4bnPRz5aQX9RLSnf0PLMY28YHn/+UpOFI8YoNDeipHwaUp+S9coJj1qqIj1giRIu4F9ZMVFFmzi0atyBW35Mz48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243382; c=relaxed/simple;
	bh=6S8xvBi4Q7iydWnuQ6md0uX+JtQ0Aj5XlNhgm6Zo+qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB1osXjDToKQERw1xd95nu/dqDePSi42eml+ItahNF5E78v0ZviGw9y7tin2+4Y2Wd+8AoNBU2zU5BdYZDCPplFYZD1OAK2amOGt8uBmT+oum5BP8ii8J6ZCgd3CfNaZJyhEJi9BCpA2NcgBRpZADAORl9KhgXagK1Xup1Waf+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6laQ/Ir; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6laQ/Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED021F00893;
	Sat, 12 Sep 2026 20:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243379;
	bh=MWn2LYZDZAT8DJhsiq5rItqwXk56syqFPxjGy+XmztA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6laQ/IrGBwSBcK3oPjFVwP4a1NpBO651EfKuDslbknFnho8ormuPBLyVpivBCmjK
	 SAdrUKgr6LYj+zhriBVidFTe1hbi7YQYkofk08BfsU56XSrJ8dD5fCH2aChZWqqrUG
	 Ue6sFPp8wx4QrsJ6oh4C4xOhIW75Dzj0Dr/N5BV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 698/798] power: supply: bq27xxx: bq27520g4: fix REG_TTES address
Date: Sat, 12 Sep 2026 09:05:26 +0200
Message-ID: <20260912065533.093407375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit c774a623c821a173c950e1297f8e8c85a89455be ]

According to the technical reference manual the StandbyTimeToEmpty
(TTES) register is at 0x1a, not 0x1c. At 0x1c StateOfHealth instead
resides.

Fixes: 8835cae5f2ab ("power: supply: bq27xxx: adds specific support for bq27520-g4 revision.")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-3-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 44198b181c962..fac8cbf92eb7b 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -323,7 +323,7 @@ static u8
 		[BQ27XXX_REG_FLAGS] = 0x0a,
 		[BQ27XXX_REG_TTE] = 0x16,
 		[BQ27XXX_REG_TTF] = INVALID_REG_ADDR,
-		[BQ27XXX_REG_TTES] = 0x1c,
+		[BQ27XXX_REG_TTES] = 0x1a,
 		[BQ27XXX_REG_TTECP] = INVALID_REG_ADDR,
 		[BQ27XXX_REG_NAC] = 0x0c,
 		[BQ27XXX_REG_RC] = 0x10,
-- 
2.53.0



