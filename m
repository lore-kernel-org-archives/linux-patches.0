Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31A42571C6;
	Thu, 17 Apr 2025 18:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915776; cv=none; b=gD+X3op9Rg1/xc+Wom+U75Tmg3DLwB2VKHbql3iFtrpHuUAkmqcezac1KT4gjAuKHokCghH6HvtLKQCptpphkD6/Q0bDtVvFtvny8CSOhzWkeXEfFinq7PjBI2BTarQLehFwtGsx0x8SfcDsJZJfDc55/5yInHKwxjolzztzu0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915776; c=relaxed/simple;
	bh=FR+vV/fr26ayipu7PZiPLyhLv6MZKdORZv4n7ljlAbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3lwaykZJPdKQqeY6UFgKeaCUTciZQJgtocjUFt64qhHmL6zQxCN+h14JWLJDWl3UNViSpC1fIFRe1OyVnpgThO2diKcIsA2+kmKmpPjrsy7DE+X8kelX1AhCAJ/6WWHXDs1CTAt8iAGNnNe2MaaHsTVwHVrpEd6SGfcAhzZEa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDO6gVpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDO6gVpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3E0C4CEE4;
	Thu, 17 Apr 2025 18:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915776;
	bh=FR+vV/fr26ayipu7PZiPLyhLv6MZKdORZv4n7ljlAbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDO6gVpqnkiPyolTlJg5WiAfWG+ZK+ZIbIeOjXNgiU42jzj9a6LSrQmte1X67zWwG
	 o7pGoZUZCoDrpkDBtcegHl3B9eWKYYfVjge4o8lhmvkcymKY2Oc4k9xoI0CdGqlSPg
	 AXYxO2NiJXN8HRz7QRuDoWnpq5FgY7ZAtEugJQNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 237/393] net: dsa: mv88e6xxx: fix internal PHYs for 6320 family
Date: Thu, 17 Apr 2025 19:50:46 +0200
Message-ID: <20250417175117.132363620@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

commit 52fdc41c3278c981066a461d03d5477ebfcf270c upstream.

Fix internal PHYs definition for the 6320 family, which has only 2
internal PHYs (on ports 3 and 4).

Fixes: bc3931557d1d ("net: dsa: mv88e6xxx: Add number of internal PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: <stable@vger.kernel.org> # 6.6.x
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-7-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6171,7 +6171,8 @@ static const struct mv88e6xxx_info mv88e
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
@@ -6365,7 +6366,8 @@ static const struct mv88e6xxx_info mv88e
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,


