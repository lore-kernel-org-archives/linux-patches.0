Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F732459C5;
	Tue, 29 Apr 2025 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950122; cv=none; b=kLa06Brin0j6xFe0dwBJZeSV5Xxd1ygu9Zv9AJNsXbBzbX9GvSeOoDrbABlmURNhNfeQHSsreegtcvz5eVJ+YtZoBZE8PBNqE83OKh1MkCa9WqYCifSZDTcuVSAZnYZEBZjxisfGP4kt+5oh+Clp+PmXhe88FMfGsxUpBrXX3Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950122; c=relaxed/simple;
	bh=zmmJ8cxDVSjDK9BiPgRAaWqzAlOiyUSLARd9QOhT10I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uR3lPWXXCULuhwmFLASrkZiGJrjbluF8/2jwZ7tS39griS3I0FP5L8Ex9NfLOPrdOeccy6e/lGMZfx9cEWSuCov1vwpJ+RqG6T1eYzFubvlgKmVGCD+LHakuA2s8upxDYOtsk26avsZChzLbBk1gTO5Kbd/Ui6IAVo2Nm6im1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Inr/B9dG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Inr/B9dG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2E1C4CEE3;
	Tue, 29 Apr 2025 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950121;
	bh=zmmJ8cxDVSjDK9BiPgRAaWqzAlOiyUSLARd9QOhT10I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Inr/B9dGiQk9PF3ibeUeeGoPBdYijbUIz8WmgRZZETF2Q/+Bjg4z47qmTXa2e40+4
	 Z0q4/NrMztEK+0cCu/pToYziSSHWkxfT2Q+7mbLSc0QtN67zuWoqtfyT69DubIl08e
	 ueAHJyGo/OFVkwbqx8rHyHkwrL+NRNxaiYf62i58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Sasha Levin" <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 155/167] net: dsa: mv88e6xxx: fix atu_move_port_mask for 6341 family
Date: Tue, 29 Apr 2025 18:44:23 +0200
Message-ID: <20250429161057.997033553@linuxfoundation.org>
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
@@ -5813,7 +5813,7 @@ static const struct mv88e6xxx_info mv88e
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 3750,
-		.atu_move_port_mask = 0x1f,
+		.atu_move_port_mask = 0xf,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.pvt = true,
@@ -6272,7 +6272,7 @@ static const struct mv88e6xxx_info mv88e
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 3750,
-		.atu_move_port_mask = 0x1f,
+		.atu_move_port_mask = 0xf,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.pvt = true,


