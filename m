Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F971DC988;
	Tue, 29 Apr 2025 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949582; cv=none; b=DwhzGXF34RV9MZ3AAsXLNrp4TARX65Z6XvQXIJyDdpnZsJL4/NYcAesJZMFtamSjs4le0K0u+rTzaJkee0VvTSt6pnScKNJXW+qTCvwc22kY9HM9NyxIgAuNgQT4DOhwGmXD/u1fY7q4EmqcS7ZG4QIP8w3quIgP36C5yTsW/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949582; c=relaxed/simple;
	bh=oaKfohL0EAElSmgAgDCq/Jdv2dH1l09o0XNkuWKzFtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZOzKDhoPA+zaszzJtVw9X7DWkCIOwt/3iCA1dhuVeVk6PnzMuTvMd3SQkYdPMODYXeR47gcEhx3nQOIda/kcDhVXyB4B5PFxvO10R0dHzbRGun20NFo/ejiqNdk+fY81QTGTKOsaKuu0T8ZhlI2tM2ibH5pWoZwPjfNKJtprmnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpQeYoHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpQeYoHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA8AC4CEE3;
	Tue, 29 Apr 2025 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949582;
	bh=oaKfohL0EAElSmgAgDCq/Jdv2dH1l09o0XNkuWKzFtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpQeYoHNbHMjp+7AUCF20Zd8BzMeP4KUsewfUIhUysxjQexS5S3U1sTIUvVNKFBeS
	 4QSnMqGBkTix71yRqiNoeZYFAXmJT8H1TyyZJ8xOJwGF0+8mr0rYq/Ivcs+Oj5yKI7
	 sVCCTfIM20Y8zPWcjdmQ0XPKNbTbn2/r65pT8XeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Sasha Levin" <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 364/373] net: dsa: mv88e6xxx: fix atu_move_port_mask for 6341 family
Date: Tue, 29 Apr 2025 18:44:01 +0200
Message-ID: <20250429161138.103807748@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Marek Behún" <kabel@kernel.org>

commit 4ae01ec007716986e1a20f1285eb013cbf188830 upstream.

The atu_move_port_mask for 6341 family (Topaz) is 0xf, not 0x1f. The
PortVec field is 8 bits wide, not 11 as in 6390 family. Fix this.

Fixes: e606ca36bbf2 ("net: dsa: mv88e6xxx: rework ATU Remove")
Signed-off-by: Marek BehÃºn <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-3-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5217,7 +5217,7 @@ static const struct mv88e6xxx_info mv88e
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 3750,
-		.atu_move_port_mask = 0x1f,
+		.atu_move_port_mask = 0xf,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.pvt = true,
@@ -5660,7 +5660,7 @@ static const struct mv88e6xxx_info mv88e
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 3750,
-		.atu_move_port_mask = 0x1f,
+		.atu_move_port_mask = 0xf,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.pvt = true,


