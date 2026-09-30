Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358D750C2B4;
	Wed, 30 Sep 2026 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782387; cv=none; b=XHVsvch9Eg2j0HVfY321mvNZY7Zu6GXTOWTHCVTnvvTh1MVVqjzHFRtefplfk1WojqpQXhfvYblG1NR+YWwjIoWiOF+5/l3DrWHY9M9U/03zz9EbNLxrlvHEB9lHjUdRYPIkhI7gEGSe6WSc+IdGY7vdJadwHCJhl7IG7dCdJXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782387; c=relaxed/simple;
	bh=Li8StG6KiTGS0PMQP6sM1QSdqjP8uyG4dpZmNE32ZPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2T5jnarc3I8aHxz+liroLvdE2F/x571CmGSbaPFu9Cw2gaDr/zuiSQolS7JmL374IRlZLfDf4lqyekL7B/64XybrVV9QiQMm4fWYjBc4bV5up+Ypx795q8RX3J7SuqxITzU1MnoPRMC1WAqvaqmm0LbDXcsxGVUFdgw2ZrMBy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+ewA90U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+ewA90U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7911F000FF;
	Wed, 30 Sep 2026 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782371;
	bh=xhTtpLbTYWbt4/RI6bULY8xIXxSxMbBZmwjgfvwCF0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+ewA90UgO07pYebDMkvIaCg5bw1N6G0a3AUYWwju8Yes3AkcMO53m63h/uZL0YpF
	 C11ks2xO8kFR7Al0Vh0BzyNA9uzmDuuLOMEzoW9zhfUGCfblFD6RuEKfAw/twriVNg
	 e4xhUgITB0pWHs+qQroEJrCUlDnJzM0QlkHhlEgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/595] net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family
Date: Wed, 30 Sep 2026 17:18:29 +0200
Message-ID: <20260930152348.072219639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ebc8580873940..5f38b5d2da155 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5036,7 +5036,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
@@ -5061,7 +5061,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.multi_chip = true,
-- 
2.53.0



