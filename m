Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D247E197559;
	Thu,  6 Jun 2024 14:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682923; cv=none; b=caVKkxzP85ALYRQ4DRBAWvYYaRuFJZMjKM2CaQJwGK2VLmwkbUdo/l5wClZHRxkItMevGAJPplgPyPLYwsKB71yu1YEdA2BHuYE746TtfI3TIXEoAg+/ySFduqPu2/0v3pAdMeAMV60HQhk7lI5EWRPj1bouh34ZssWwaHCEhq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682923; c=relaxed/simple;
	bh=DCyFddNiHZvuiZYa+g12ADaP3/Q1bwhcuxw4Y/HbnEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyLH1vn01dXm/RPHo/mYluCAjDQjCRhGFegiPyE7Rzrx8fVwF4l42YdoHSHmFrUp7oZI/Dln3Ot5JlX3HpM7Q3F4IgRLpDqklQflrodYAUHs/wdOMqhqzWC/4OopGkJHaSiYM4wQB7rkA+5SWFJ2iADiT35HqSOrwUcZxxCCd7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3DBfcaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3DBfcaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B010AC2BD10;
	Thu,  6 Jun 2024 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682923;
	bh=DCyFddNiHZvuiZYa+g12ADaP3/Q1bwhcuxw4Y/HbnEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3DBfcaWQHlSRpmmvq4daNJSyjQ5rGmIBLSjvxKmnbZ59p5UlCupZj+m0s6aybIaC
	 GH7MgRYxhsHNWYktd/VuEBIZBo/Yx2o5FqrEtdGAY1r2Y9OkKZz36yCx2kSL6or3Et
	 lqsrw8B6cf8VxjOrU6kKThtAcUvQXx43BP6Ov9Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 065/374] pinctrl: renesas: rzg2l: Limit 2.5V power supply to Ethernet interfaces
Date: Thu,  6 Jun 2024 16:00:44 +0200
Message-ID: <20240606131654.019412037@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit cd27553b0dee6fdc4a2535ab9fc3c8fbdd811d13 ]

The RZ/G3S SoC supports configurable supply voltages for several of its
I/O interfaces. All of these interfaces support both 1.8V and 3.3V
supplies, but only the Ethernet and XSPI interfaces support a 2.5V
supply.

Voltage selection for the XSPI interface is not yet supported, so this
leaves only the Ethernet interfaces currently supporting selection of a
2.5V supply. So we need to return an error if there is an attempt to
select a 2.5V supply for any non-Ethernet interface.

Fixes: 51996952b8b5 ("pinctrl: renesas: rzg2l: Add support to select power source for Ethernet pins")
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20240417114132.6605-1-paul.barker.ct@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 20425afc6b331..248ab71b9f9da 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -892,6 +892,8 @@ static int rzg2l_set_power_source(struct rzg2l_pinctrl *pctrl, u32 pin, u32 caps
 		val = PVDD_1800;
 		break;
 	case 2500:
+		if (!(caps & (PIN_CFG_IO_VMC_ETH0 | PIN_CFG_IO_VMC_ETH1)))
+			return -EINVAL;
 		val = PVDD_2500;
 		break;
 	case 3300:
-- 
2.43.0



