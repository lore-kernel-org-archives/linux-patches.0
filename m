Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556D22566D5;
	Tue, 29 Apr 2025 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950803; cv=none; b=XskQmWWQnQeS9qLu6yPDT5UjtRgrYI0dXJXgEREc0eXIcOQTJpoIPzaA1Da/aJKbwbt9ZdQh6r+EvMgcNzbZzHtCU7xHKuqdHMmmfGjnXZt/LlHVSxliwPgI1d28v5hSsr+in1V8+tv0NFcZHyEUovuVOmS92LVkhatSm8hAoCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950803; c=relaxed/simple;
	bh=sXJ0IoNqK7aCzDDgQuKX9SXgQYuHx04Gk5TsK/ehiRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sj0OeJReGNb13WNMUyGdJUUoX7par1lazuXxHmpMApSe5ZHW3LKKxDS91jBm6R08l6KigjjySG3aCU+wiiqUyzhee1tYldG5h+D61Yib0NLYd9tdPn3F3jv7ownUEago0qhDQzlHjXblDir5u7RlPQZXk9dtWIhN86zX1DJ7rdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TX1kX4oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TX1kX4oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C895EC4CEEE;
	Tue, 29 Apr 2025 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950803;
	bh=sXJ0IoNqK7aCzDDgQuKX9SXgQYuHx04Gk5TsK/ehiRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TX1kX4oz166cPGwPd2VtLQD0joXAkLxwBZCuUAYg7YNccIK2ByFxCJ5glJGhgCCkO
	 t3/gh/6gIjum8HDmHo/wN1ZgqFYxuDh1wXX4SsbIiRsYfR7XL4ahsA2NbCFEDfIV/H
	 07P4NIq4GSuB/zKw8xQbC03V2wbwTG+62SKTdp7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Sasha Levin" <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 198/204] net: dsa: mv88e6xxx: enable .port_set_policy() for 6320 family
Date: Tue, 29 Apr 2025 18:44:46 +0200
Message-ID: <20250429161107.479583040@linuxfoundation.org>
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

From: "Marek Behún" <kabel@kernel.org>

commit a2ef58e2c4aea4de166fc9832eb2b621e88c98d5 upstream.

Commit f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
did not add the .port_set_policy() method for the 6320 family. Fix it.

Fixes: f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
Signed-off-by: Marek BehÃºn <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-5-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5047,6 +5047,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
@@ -5097,6 +5098,7 @@ static const struct mv88e6xxx_ops mv88e6
 	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,


