Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244F984D26;
	Tue, 14 May 2024 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686261; cv=none; b=airTBwt5ToI+VraR0zbam2sk790AZI0tE8dQHuMlZ5a6BPPtBoztDGji/hDKUVSAlZU2RhGxdqvTulZdaslhJ2M8KCzDdd6szh8ZpjBfkfsXVJtFIAz7o+5y08888ntpdASr9sPVPQ8R+9jAan/TZwY2udBKzsJNvpMI6ypq2Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686261; c=relaxed/simple;
	bh=gpSQqpvcitq/fM619TmwN80S4aE4H68JYcGUii6DnaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFnPvbIqKnAT6+BY/7iMcMWdOAmORSsbb9KW5o6viBHue6fi1XLvOAjSZRQjRcQA0GjiGLnhOXTQsv+7XyQzdKsSw6FEb3hP09e0HFNEjnMDWoCbcX0cygI9M7aOhi0ftzVn8YRk/k7YeLrj9DInY4GYSYlYSkXByS9/vUnCQ6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKBUMHFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKBUMHFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1F2C2BD10;
	Tue, 14 May 2024 11:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686261;
	bh=gpSQqpvcitq/fM619TmwN80S4aE4H68JYcGUii6DnaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKBUMHFHyXi6UG4WpTHeE5kSBW51BTGmRM2iK9RrQ7ggaLhOCSECajQYvix0++WUh
	 nex5yNXzcU5ayiaUkNQHYbPOYIIo3+uxmm8XhyejwtJOkaXF5j+9CcPOSVntrpDyWy
	 9qh2aVTw3g1xFXOaU3lMa+DOU2jPmrEoqnGgQ3kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/236] net: dsa: mv88e6xxx: Fix number of databases for 88E6141 / 88E6341
Date: Tue, 14 May 2024 12:17:17 +0200
Message-ID: <20240514101023.218400261@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ba906dfab055c..517c50d11fbce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5677,7 +5677,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6141,
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6141",
-		.num_databases = 4096,
+		.num_databases = 256,
 		.num_macs = 2048,
 		.num_ports = 6,
 		.num_internal_phys = 5,
@@ -6134,7 +6134,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
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



