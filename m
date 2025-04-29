Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB1C254842;
	Tue, 29 Apr 2025 18:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950806; cv=none; b=pIy+NJCsJfUBpXHy9Au68PP3CWHPDJ7UmAUXaX55UlPi9YwQI9IdJnJ3yxi7SRmVkV+8whLoyL6R193pmLOu8JqumXOD5U6jS6VfSd39L0JVm3XuE6PdoywrrZrYKfVrLm6teBJriCi2vqcFBoM9+Z5nSa6GBqhTt0QFtKAplD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950806; c=relaxed/simple;
	bh=/1dDhpaIbvxqC9Y0683gL5gM2mIgKH/S2gEgjY6sQM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VN+vjkJZT00bphyjgvbbc2b/Ox1F6N32JTy0mTvAjCxPYo0bv7UOEu5t8ppftzDYXt3KrJq0OoumL1cmrm1I1Tcsh7Y8NggYhKaS2zPXZw0aEX43Ds6RVIXsvyW04lHp6eATg4qqSdVxRbHjrjKGIRh+F+9q9wyc+Q8gkixm/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxgWBwOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxgWBwOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3A5C4CEE3;
	Tue, 29 Apr 2025 18:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950806;
	bh=/1dDhpaIbvxqC9Y0683gL5gM2mIgKH/S2gEgjY6sQM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxgWBwOzwNdsLLyreVHKyGs7owowMr6IVWtCVPjMQeupX8158rKRwPmPFAZY/fuBf
	 dy14O994DqqdDoX2ASoZQP4lfDFZKON4oQIAPfhb7+HIgfYrn0NcxmzynUYYTn8Nt6
	 SwQVN+jmvj3SV6UG5ruWLilkJapl6ObL59QWe4Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Sasha Levin" <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 199/204] net: dsa: mv88e6xxx: enable STU methods for 6320 family
Date: Tue, 29 Apr 2025 18:44:47 +0200
Message-ID: <20250429161107.522583467@linuxfoundation.org>
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

commit 1428a6109b20e356188c3fb027bdb7998cc2fb98 upstream.

Commit c050f5e91b47 ("net: dsa: mv88e6xxx: Fill in STU support for all
supported chips") introduced STU methods, but did not add them to the
6320 family. Fix it.

Fixes: c050f5e91b47 ("net: dsa: mv88e6xxx: Fill in STU support for all supported chips")
Signed-off-by: Marek BehÃºn <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-6-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5074,6 +5074,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -5124,6 +5126,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.stu_getnext = mv88e6352_g1_stu_getnext,
+	.stu_loadpurge = mv88e6352_g1_stu_loadpurge,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -6120,6 +6124,7 @@ static const struct mv88e6xxx_info mv88e
 		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6146,6 +6151,7 @@ static const struct mv88e6xxx_info mv88e
 		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_sid = 63,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,


