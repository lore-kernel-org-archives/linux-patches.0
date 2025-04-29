Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E621ABBD;
	Tue, 29 Apr 2025 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950188; cv=none; b=B62KRgqNJ9IjJyB807hydZ84K1WbZ8e6AIqoSU6cHIW6zl+g8aHc6rBY8ZREO6LRHp6QIzEnvcTe+UxOy2PWzrHNShHLuMOfCuzEbnm1FytZYrINRZjybwv4CFFek/0yVBhwqmKXILKhZfbJ8HPFB7iJ80+ihpJ1DbeDaE+SsKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950188; c=relaxed/simple;
	bh=5tZKboWF9+P2t1tGAJYtBcYBwzQTRr7FxCWddsWsai4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VJrewJZqGB2N2qGX34po5k+G/e+Z2xFrBfjoR6VuHA708Dn4aHpQ7u1qIcCnuaBZ/PrNNn2MwKgwpiyhAnjGr4wVyRQu+/BaO6s/LifRm3CN/es1eJBigvWdvyIIF8iWuERF0oumF/cY+FMv2DDMfm3VsJNg2BrRa2VJdpUU6jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VR11OVef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VR11OVef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C572C4CEE3;
	Tue, 29 Apr 2025 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950188;
	bh=5tZKboWF9+P2t1tGAJYtBcYBwzQTRr7FxCWddsWsai4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VR11OVefbwfwD+ND/r3YNEQJKt/hcfbm6CjnLVBSJESVat7zer45o0/QoeWUFTpkm
	 sSJqc8s6EZ9Hl3wmRa5JUJBKWdNSXBFgvItQdgTDLsHjPmPMmcWmrjOTqcr5yNQnb3
	 AMdYnNavxdJvyjCft/M647yI8ezf8Qo45RGCIB/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/204] net: dsa: mv88e6xxx: fix internal PHYs for 6320 family
Date: Tue, 29 Apr 2025 18:41:44 +0200
Message-ID: <20250429161100.087535211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 52fdc41c3278c981066a461d03d5477ebfcf270c ]

Fix internal PHYs definition for the 6320 family, which has only 2
internal PHYs (on ports 3 and 4).

Fixes: bc3931557d1d ("net: dsa: mv88e6xxx: Add number of internal PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: <stable@vger.kernel.org> # 6.6.x
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-7-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index da7260e505a2e..d66448f0833cc 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6114,7 +6114,8 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.port_base_addr = 0x10,
@@ -6139,7 +6140,8 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.port_base_addr = 0x10,
-- 
2.39.5



