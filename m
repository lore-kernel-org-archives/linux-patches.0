Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EDE18E350;
	Mon, 28 Oct 2024 06:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097687; cv=none; b=FBl/eSpKsFp6CvLIQ1qfRqGqkKdAT1I2diOA9ucAChTJrVRfUGFDNuPyHjN0DpDC5OBTfm6/TnQ4pXXpNZQ3f4fFH+OGh6TTFbkwzvdfbmgr9n3TGhTf0qK/pno1bCelC6U4zixrqpL2C4i7X0hb/OI9O3/qc9k77QkN7eBDkak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097687; c=relaxed/simple;
	bh=ClrYG14wb2W/fHr5fgQj5+AuO1bwdmfqI6FnZo+EbWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFeGvaXhBxpBIH2ihZsDeAWOtTQ9kDgcLjewNdtd68vGOl2qNDMeLtInztE1U2+BuehHsKSs/M1ZRpwLpvRzPMKkToSRMZnlq48b2HozQEJeq3nNXIoLsqPMh5RTrYnEzrE0Z33CxRhDnY/8+mQxf187VJpHvj3PF4wvclX3ybg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qk7iv2Jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qk7iv2Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA62AC4CEC3;
	Mon, 28 Oct 2024 06:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097687;
	bh=ClrYG14wb2W/fHr5fgQj5+AuO1bwdmfqI6FnZo+EbWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qk7iv2JkCaQRSqT3o8nCwPbuoKJoIOoPZzyBCTQaAqFG2pEJR33x7o54k0sKlrnZV
	 aTBS7XZwvgS4PWHgHtKyAzaSygtyO7KxUa8CD2Hok0LGO4o/uaax+2CmBNOdq+Fyff
	 FrwkMYS8bvb9Me/mWcVHcPBUSqDJt7RQG8d4hu1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rashleigh <peter@rashleigh.ca>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/208] net: dsa: mv88e6xxx: Fix the max_vid definition for the MV88E6361
Date: Mon, 28 Oct 2024 07:24:07 +0100
Message-ID: <20241028062308.302407872@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Rashleigh <peter@rashleigh.ca>

[ Upstream commit 1833d8a26f057128fd63e126b4428203ece84684 ]

According to the Marvell datasheet the 88E6361 has two VTU pages
(4k VIDs per page) so the max_vid should be 8191, not 4095.

In the current implementation mv88e6xxx_vtu_walk() gives unexpected
results because of this error. I verified that mv88e6xxx_vtu_walk()
works correctly on the MV88E6361 with this patch in place.

Fixes: 12899f299803 ("net: dsa: mv88e6xxx: enable support for 88E6361 switch")
Signed-off-by: Peter Rashleigh <peter@rashleigh.ca>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241014204342.5852-1-peter@rashleigh.ca
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3877744193e2a..062bcbe6255cf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6208,7 +6208,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
 		.num_internal_phys = 5,
 		.internal_phys_offset = 3,
-		.max_vid = 4095,
+		.max_vid = 8191,
 		.max_sid = 63,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
-- 
2.43.0



