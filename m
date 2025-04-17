Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE0825335A;
	Thu, 17 Apr 2025 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914547; cv=none; b=eXsZ8P7r3FL9yS5M0cJA/RQhtk6CNi8rI6kY2qm8rp1EDVjNg7clEa/obuNBqVKgEU9/FJJCTwzt2/5G2MjU5c+AEuwdExmuXhkCP+u8isWPbuELEmVQn5vU23bVJiAHEyHgFHBYU6iKVp4opXpS4O9lPPOUZkwvGbaag18hdVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914547; c=relaxed/simple;
	bh=Djksj07bEC+L3xTTkPvIp5aYGxbOq3LSVcLZ8MnEzKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4P6/EavoMbdSBADWUL82AYlm2hfxiiNGHrQWZYn7khiq9J2j+OEjNocDnPVKAPiZFtwzuexkGTwz+GQQrMJ4UNSWyjJTXT9qyfQq920zctLfUxgFytJLpp0FISxqprvsBW1P4APd/oUYbn99WGhIO+ux8xcZlQotcfY4JlrAv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fisRIPiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fisRIPiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06C7C4CEE4;
	Thu, 17 Apr 2025 18:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914547;
	bh=Djksj07bEC+L3xTTkPvIp5aYGxbOq3LSVcLZ8MnEzKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fisRIPiSduxr3FZveSbsgnO88a0jZx2J1q9H/wHN+MBeO7bgGmq3CB9LNePoeFd6r
	 noiJpyHlbvTbultiblYnusYv+yYdMfgJb7HcFLjcMg/pe1CBWIvo6FLk+oJdgRoZp6
	 8SArMGS6YNrWd9flN8rogtAlvu8e2eyLuXTgGiio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 252/414] net: dsa: mv88e6xxx: fix internal PHYs for 6320 family
Date: Thu, 17 Apr 2025 19:50:10 +0200
Message-ID: <20250417175121.556105921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6174,7 +6174,8 @@ static const struct mv88e6xxx_info mv88e
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
@@ -6368,7 +6369,8 @@ static const struct mv88e6xxx_info mv88e
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,


