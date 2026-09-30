Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F3A516165;
	Wed, 30 Sep 2026 17:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790623; cv=none; b=lxQVAHe9HTPfEVv/clVOgoZbgepxjjSR+67uX+KZZ9jNR96da/F5w19c0Al7STbfN0ZGBSV9Y03f8Qkgm9wH4fOoMwR7HZrojdLTSju6l2TewSzHyjJnR1SBpsnHieZQOJy3cCYyrGYkXXclahCo5N3ria+Xw3bsF5Uj57hdpAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790623; c=relaxed/simple;
	bh=bTggM6O3rdEHi2Q9UIM5dRUVfEUSk0fwIGCG5uFc4cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GbA8LxFdV2yKVD4+V5yFqqqc0YA54elU3BqHChsNfhM1mAgA7UWDTHeoQi5whQx/wK55oBFMUZhjKVKjCaXOAHR/AsWSnKuKI8QMtWuN9xCE3pSIVgx1z8JRgU9TbZhcFpWE7QKfNsmo9SCEiF6Giitc/1LVm69SffWTvbmWJWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlO3C3+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlO3C3+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBF21F000FF;
	Wed, 30 Sep 2026 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790622;
	bh=1LmAxWfxTwe0abHIYOcoQzWo9v+qjjeo9OQxKntAkgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlO3C3+PYeAZxDR3yQk4rwdfL8JxWaaeX8etFBO+hcWo1BZ0i0Os1Ma6FfbdBOPNr
	 chPCn6EewEYwnGbxJeuB0BnUj8vOBua/5ITnOFr0scxqIjy9DbQT60qbE7oqDLcpeP
	 sMh2yb9nJUXgz8rT+4Bdk6ST/3o7maiU/YJRntDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/752] net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family
Date: Wed, 30 Sep 2026 17:18:07 +0200
Message-ID: <20260930152358.525170492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2d1d60dbe7f0e..4dc2c465bc434 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5613,7 +5613,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
@@ -5638,7 +5638,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
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



