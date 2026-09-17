Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247374DEC26;
	Thu, 17 Sep 2026 17:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667350; cv=none; b=As2tIf0y87Tx96CNsVzwEIJYLqTj1qJpWNxuTS5JP8ZFtPTvDG0cAL7nvMBZ3xURuTjarcvZxEWbLiIBnwgJYenxRHXzyTck0wKyL1e7HQVw6iBUjQkizqzmP1WwV9JoFT9xMy7ZUDldmqp3DHKZAe/+Uo+rUFCjFbJIv+MYWws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667350; c=relaxed/simple;
	bh=l5c/F+OpB8bpJTl31erZG967Ses9rUVG9525j78978w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SKtvJ9q7AYSGQAgMS5iJijVyXN+Am8UiJoNR7VG/hoB74cypU5AyRP99dShw7oOUEWKFHLjHyfUhsCpiK7fLCQsuOQ7KrJgl451ObRm+3ExuQA7nLP1r7CjCm7QvhRPP7voHAkoAa2RsbyakgyI2JpwAKLSnQ4HwsDMqQNhKmmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGrHQp+V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGrHQp+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4C51F000FF;
	Thu, 17 Sep 2026 17:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667349;
	bh=yD5ReHrARBur9mAr6ZWsDm/RAro4PSbbrPL6JA5/cOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGrHQp+VIEC/K4I8LHq5viLoo4KV2u5bV+xtlrMssV1wJDIyTflRvFs1OABZJ6gTH
	 fMElwpMqLTNgdCrZ/4/4Ih6/AXxEQNJCLxc0Zmn8kx0dpG+12yUNQ8io4eDs+nrG0I
	 NcLk5WV3+f4GEJVnIGGWLwvDxqNC396dfv4ahjNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0046/1102] net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family
Date: Thu, 17 Sep 2026 15:59:49 +0100
Message-ID: <20260917151540.604391628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 211c219dd52db..9794e44977275 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6268,7 +6268,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
@@ -6294,7 +6294,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
-- 
2.53.0



