Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E2A4E4C5A;
	Thu, 17 Sep 2026 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661055; cv=none; b=I3/cABjB83s5Zlnqy1HxNI+jb7E7pcEUpleLXNvOFJv+9vo196oFj6Ut89Gw8Gc6P4dWXZ+rTBIgQLO8q+LQV/7FWednZ4YRfMhyiAocuknHzdXvErKoImmLy2DvcsOx/E7gUavFamVeOyER+FkzmKZYrRe28mcoqUQVclM+oLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661055; c=relaxed/simple;
	bh=5dY/d7gsMgWjlNtOy9wQTtOei9wtcvgVCyXUJoBEcFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F06sXtzxuF+a4NDdsKc9BIYSuwnyuYM94cKgzvhuXZdl9OFidh01K815AcNs8MYTi8wUIfUkqKcfFYLOz4tj8DuhpPNOmzqp2km3EPOaRnTwpfmti4DZN2EqPNPMgmcRH+0UxYZdlvvBIUc3NJnRS/k59I2Fhdz5n1QtePpuslo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19X46wJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19X46wJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFFD1F00893;
	Thu, 17 Sep 2026 16:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661054;
	bh=cT6bm0zBVM3mwwHqWYscRrqInRhTIPlnWIJdYnPul9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19X46wJQe+CLJefh53BS57EH/GaENhJ7ozEfJo15fhFQYG5XcU7S/aUyOqVir3wRf
	 p+Z7BaAS97mh/tvqu0Uuo1pr3PdjmF78QkP9A8Zn18c2PyrnppR/lRbGS9Ibt1sDtS
	 i3J6e1Jdu/0rMalFj+QUyLpiYoWEP5XAlr2Ucv38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0066/1250] net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family
Date: Thu, 17 Sep 2026 15:57:41 +0100
Message-ID: <20260917151553.731529838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit d201c2612e5aada0c931cd55115175e0a5141023 ]

The 6320 family has 9 global1 interrupt, not 8. Fix it.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260504153227.1390546-2-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 09002c853b78e..b115575f157fe 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6261,7 +6261,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_BANK1,
 		.atu_move_port_mask = 0xf,
@@ -6289,7 +6289,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_BANK1,
 		.atu_move_port_mask = 0xf,
-- 
2.53.0



