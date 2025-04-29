Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C8D40C03;
	Tue, 29 Apr 2025 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950137; cv=none; b=UwQjqWdZnRJfboxA6PYRE6ayAYDm9Rv5Cx6lnvmBZvLkZ7NXCO0D0DkPW+xOtpZePBO7dUH6wzDh2H8USX8gwXBvsVzzx6XMERRbLV3XiPvBupS50TdKXwGz7H5dr83EZeaLlfeDz7ELyE1csVG4Wj1nmnaY242A6xyDnoNgmXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950137; c=relaxed/simple;
	bh=R7cwTCPQJ+/LjwI8oiHdLIV4i1v/tXflHxQWF7Ozlng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFDuq3c3oPgoRbMHt+8JtfKuYSTYaAmSyIzC7jc30fd/wWHSPNJp4wjby3izIvWH0lSNMcuRvcMS21P8JTmFfyd+0rR54d/bphJJPO5N/MmeCiZeCHJHEqDxvkOaRwRdsoK96hS0e0YGhZDemmRCp01W+HwXCxHjJWSlHzP9tAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXuMy4S7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXuMy4S7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5231BC4CEE3;
	Tue, 29 Apr 2025 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950136;
	bh=R7cwTCPQJ+/LjwI8oiHdLIV4i1v/tXflHxQWF7Ozlng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXuMy4S7yUVSYe0aTVGvTeKeephHuCds0Q30ifqIiZNEfIjOUGfNXTz1vqsrvU/p0
	 sVXLKwX2lggGgsZjT8mhbN15JzAeOtXkCZgAuNf63Cf8NtOPfLFEHUzvZsRxLIR725
	 ox4dNtkobUAcbXOSB/7GkZA6ItCW8Z5so1pjlGbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Sasha Levin" <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 156/167] net: dsa: mv88e6xxx: enable PVT for 6321 switch
Date: Tue, 29 Apr 2025 18:44:24 +0200
Message-ID: <20250429161058.037540126@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Marek Behún" <kabel@kernel.org>

commit f85c69369854a43af2c5d3b3896da0908d713133 upstream.

Commit f36456522168 ("net: dsa: mv88e6xxx: move PVT description in
info") did not enable PVT for 6321 switch. Fix it.

Fixes: f36456522168 ("net: dsa: mv88e6xxx: move PVT description in info")
Signed-off-by: Marek BehÃºn <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-4-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6250,6 +6250,7 @@ static const struct mv88e6xxx_info mv88e
 		.g1_irqs = 8,
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
+		.pvt = true,
 		.multi_chip = true,
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,


