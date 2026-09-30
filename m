Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850D04FD78D;
	Wed, 30 Sep 2026 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784199; cv=none; b=W3RIZ0s6+PGfscCO3Elqktm1qAwOfwoYCWcnCBdKbCJGVS81aJmpRJItOmnz8vLvSEZG6rm7Tdw1ZGSE2VRouqiVDy9kz23x5JfV2Ml8p++3hzYrKJ2O2d7ifSCis5axqVutHHA5L3YkFdLkhN7HXJ6UtfYZ9wsjou82Bo6PgqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784199; c=relaxed/simple;
	bh=AA2iM59EkFr8FKRVOnnGdTyUj0VqEmwvOs2E0a1sMsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GlmqTPDtjzofw9b0r9n11S1k4hoVLvyeyMY7kJ6auQHnyhNQHgcReK+kIrrsjU+KsHjQw6u3UIu3YbkOiHfTRvr64DuGTv3Gt8HZuBW2ltObTi3vXtl1iSkp9NWeVbsxwkzfFTfq5dy6Ax+UrW5sp9F4KGsSyBoDc/wZFIwsR5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFcgQIK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFcgQIK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D161F0089B;
	Wed, 30 Sep 2026 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784196;
	bh=mOpjJ/zxmaw6qDldvH/eZLMLSZI3jnkiZFA1ek8vq88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFcgQIK3pp0Byi7hyv35UYHxmeW7pOkEE9KQxEMctULCD4BqwGRAwwYM9QvLGcUUe
	 WGhmKK72G0jYav1ylU2zsS4+mPhM4ASOdc/brXct0X24prCa+kD+NDS2BVs0HCo5wO
	 uKR/i3rSJJWzWw6E8VC9SKV3tAPlmWHQ/9cKi6qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/982] net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family
Date: Wed, 30 Sep 2026 17:12:40 +0200
Message-ID: <20260930152417.315057322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 29e4c94c84051..783d7035f065e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6228,7 +6228,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
@@ -6255,7 +6255,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
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



