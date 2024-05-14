Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938AC53370;
	Tue, 14 May 2024 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682503; cv=none; b=pL2e2N4ZnBgJC7Tyhs7Yb6r2HOYQXlvUB12Y0l1uRM/rmdzwu7Eh7VGOV7B9C5Ptf9q5F8ZLhZKN9kciU6k3631w30JVhuL4OvyCN0Lp8B9j6gifdVULg/t94XD4OrPwxDt6spPJvzuvTo69CMQN1ZFY1GhDQJgqRnLirV23xxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682503; c=relaxed/simple;
	bh=e0DTwvQpOtKdUCz2K4bo8satBN7woWzKprqdRK9ftBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGtVWwKQT1mXVVw/z/AudbJVI/Of7hkkXqYPy6IQkz2X2Ao7r5UdXgC9F+TBaLcBItwt2V1ZK0yEITFRutzYJESJAyr6nzML79Dr7Rw75ElVo8tPy6wTb5/9G8fbXKLIpqHt5uzMjbiAd/lJGGfN6GzN2GlcSC/vnmvq8teVsNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fs+rWR6b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fs+rWR6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75889C2BD10;
	Tue, 14 May 2024 10:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682503;
	bh=e0DTwvQpOtKdUCz2K4bo8satBN7woWzKprqdRK9ftBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fs+rWR6bQUI/5ERAs6C04S6wsH59VVQOCShl1svrto1SFBF55OniQQAC+CgIlV2/7
	 /+OHRfBT8RbAigIf+Tk+frrnjGxPzJAU2ZTmQSqT6x2XDugJo5sPjmHqG6nwQzrItB
	 WX8S0g+HgPmaHrHYg93VQJimPDVxUWfEkFs9Gprw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 071/336] net: dsa: mv88e6xxx: Fix number of databases for 88E6141 / 88E6341
Date: Tue, 14 May 2024 12:14:35 +0200
Message-ID: <20240514101041.286651361@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit b9a61c20179fda7bdfe2c1210aa72451991ab81a ]

The Topaz family (88E6141 and 88E6341) only support 256 Forwarding
Information Tables.

Fixes: a75961d0ebfd ("net: dsa: mv88e6xxx: Add support for ethernet switch 88E6341")
Fixes: 1558727a1c1b ("net: dsa: mv88e6xxx: Add support for ethernet switch 88E6141")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240429133832.9547-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 32416d8802ca4..bb0552469ae84 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5702,7 +5702,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6141,
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6141",
-		.num_databases = 4096,
+		.num_databases = 256,
 		.num_macs = 2048,
 		.num_ports = 6,
 		.num_internal_phys = 5,
@@ -6161,7 +6161,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6341",
-		.num_databases = 4096,
+		.num_databases = 256,
 		.num_macs = 2048,
 		.num_internal_phys = 5,
 		.num_ports = 6,
-- 
2.43.0



