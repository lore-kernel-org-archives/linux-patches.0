Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7F3B776D;
	Wed, 30 Sep 2026 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793923; cv=none; b=XJ1RcBwA1vAL6KQiaDJeo9xM+gb6kf0WIiRsyoje5adFkSom9B+zXDM7KcIQGQi7Cqjl8p3FVGx3s5fCma2N8+3oMyxJgoZ0pSTDJMlBt4wQvMkQ3bVmogG9K4OHot3mtEEkYDQ5Wmq/cnMIZXLxUnP4KPR55DqkYKzZvVIIIzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793923; c=relaxed/simple;
	bh=hyFXM59whFM3f12+lMOfaFbjr2drKqW3eJxAQLT1AtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HSPNh/aKRBkXIjZkGJjliN+EOduPmCaHMh1cP0iS6i7bNhZ935JqtzC1by7hJdXjIjvXUDvMBrIc+H6JKaQh8cd5CoHTpUIJnUOqd959vooggWMC1vSRtBmC9O/PIKk6Ydcqv0V8eYgfjnD8JjYXHTH6pcYR1fHV48C+m+CCetE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OA+Vh/x+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OA+Vh/x+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3F91F000FF;
	Wed, 30 Sep 2026 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793921;
	bh=fMDuExr+GxGuRl1eFr2wVal28FO7wGYjLYvCMgiPYbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA+Vh/x+uPO8TSqK3+Qps9hKD8yAyajrw91qfmudyJLHuvrnfkycFQGll1YO7tM5a
	 2rtJ5S/4xn8s6Prcjt+YRBiXqUTfO6wg6Oxnt1sft3w7iNM5YBRyL9hEo3Zo0g6dlp
	 SWBgmzE2/Sh69b17OoK1nU/ZV42V9Ucme3Z6tDEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0029/1193] net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family
Date: Wed, 30 Sep 2026 17:11:53 +0200
Message-ID: <20260930152434.938132829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ef52d1ae27d69..a3f481263d072 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6130,7 +6130,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
@@ -6157,7 +6157,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
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



