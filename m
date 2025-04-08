Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ED8267F48;
	Tue,  8 Apr 2025 11:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110906; cv=none; b=HMrqNvc1kp8bPUV11l7sv5+VzgL9HlpkASDI/MSvtw/kcNeBspvQbO0v/UfR67p/VdoiIsidV3vPCpi2Loz8yobTbddoMFnWlSG7i1Fa7dAj5uIg/b350lgTulENrXWInCCMvbNaF2Nv0VYoIJxX3nYpF0rwRRN43jrQ5AocLOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110906; c=relaxed/simple;
	bh=SBhgwA/7znVom8v4v6FUsL7Cnl/+my8vyB+wi2eYPPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AtVPnGgk0qUgm3zmC1H0JgTWu6BFg7ASbKpX5++2HgMMoYuqi7FhC98TBzapRcsmNtypvyDz0QgD3ZPenl5EbvVIGcV7YhV28iaxlUhQ0Z/cKR77fCF+ogHP12m0oli52MuOYWnpnLConHnNVK1VpkUIxny3/HjK3as0KGva8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uk2fOvVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uk2fOvVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984B2C4CEE5;
	Tue,  8 Apr 2025 11:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110905;
	bh=SBhgwA/7znVom8v4v6FUsL7Cnl/+my8vyB+wi2eYPPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uk2fOvVuBCjhkDkdm7wcme5AsyWKbUKggstFwrFPJzqrdvkuESXYE8y8enPCVBzDs
	 N1mIW0w3UQUNuS8SJ9aRYEQeW+43x07hnWj17yJXL/qPYYBsNkaDtyVv3DkheIZ9pI
	 06UbIl6vhMqoJBTvFXbeQdDtlD3d/F190tOrtbBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 238/731] net: dsa: mv88e6xxx: enable PVT for 6321 switch
Date: Tue,  8 Apr 2025 12:42:15 +0200
Message-ID: <20250408104919.817756711@linuxfoundation.org>
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

[ Upstream commit f85c69369854a43af2c5d3b3896da0908d713133 ]

Commit f36456522168 ("net: dsa: mv88e6xxx: move PVT description in
info") did not enable PVT for 6321 switch. Fix it.

Fixes: f36456522168 ("net: dsa: mv88e6xxx: move PVT description in info")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-4-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 841da8437738c..d8f037da5e294 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6274,6 +6274,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g2_irqs = 10,
 		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_BANK1,
 		.atu_move_port_mask = 0xf,
+		.pvt = true,
 		.multi_chip = true,
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
-- 
2.39.5



