Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED272676E0;
	Tue,  8 Apr 2025 11:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110903; cv=none; b=lA2s4KZ8jDDwEDkUOfJBgC+GLxD+MuYXWk/VW6BGvAVNXmdflPeTMn0epzrIiZ7vfljkiqYUTxVK9t95PWGvhjAyhauNKcyLhioUgCuw9s26SMhiJF6hx1uKHvopIQGVc80hv57vZ/FwnU6CQ1SAPOX9gnkQKkqf2l2RR2xtDow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110903; c=relaxed/simple;
	bh=s+6OigATznJrCoMSbyjyMyxPjO8oiEmVsJuuQhHuuoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IsM5lzXy20QPAOtu7wWypStFW7aqX5HiMYBbFqo48+SmCOHx5gEgUpZvfLK1HQzHuMuNLg+4Z6CCZw+PxtHxasLVSe0nlCUxsEU8fIqRzunQxyhUHD8swCvAxAJLnnViW8pdoFs56Z3cVeClYnNz+d6UVNtAYQ0qCHkbAUA7/5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8vtBHBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8vtBHBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D60C4CEE5;
	Tue,  8 Apr 2025 11:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110903;
	bh=s+6OigATznJrCoMSbyjyMyxPjO8oiEmVsJuuQhHuuoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8vtBHBRwfYx+2W+w+vLeoCXVUybly+Y9EH3oarR2ZqT2yQ7OwIX0jvmpJKERZHBU
	 ZFw6bafD2RriBTIDXt41Hvvfd1dtdn4s2X9n4N93N1bfmCgyzoxBNAXE5nA/Dxl2j0
	 NNlzYDhwhX9fBNM7jSVWyFlmqY3721v/0M91px5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 237/731] net: dsa: mv88e6xxx: fix atu_move_port_mask for 6341 family
Date: Tue,  8 Apr 2025 12:42:14 +0200
Message-ID: <20250408104919.793846180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 4ae01ec007716986e1a20f1285eb013cbf188830 ]

The atu_move_port_mask for 6341 family (Topaz) is 0xf, not 0x1f. The
PortVec field is 8 bits wide, not 11 as in 6390 family. Fix this.

Fixes: e606ca36bbf2 ("net: dsa: mv88e6xxx: rework ATU Remove")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-3-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5db96ca52505a..841da8437738c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5818,7 +5818,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 3750,
-		.atu_move_port_mask = 0x1f,
+		.atu_move_port_mask = 0xf,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_BANK1,
@@ -6296,7 +6296,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 3750,
-		.atu_move_port_mask = 0x1f,
+		.atu_move_port_mask = 0xf,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_BANK1,
-- 
2.39.5



