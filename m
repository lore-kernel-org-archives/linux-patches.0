Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3C3265CD3;
	Tue,  8 Apr 2025 12:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116353; cv=none; b=EA8MxUm1/qTkBbeQGmQ289Oop2u58MXi/XnOO68/AJ0RSMYl6hA4wAXoCmzIQyGhCSszxKToYKz6tV4lN0wTEZfOnFZfzH69i3N45ga9M6w9UFFlJcvZ0snyMpSq5nnUhz4a5qe5NdV4zAg8+imHZ5sBFA7vJNBv0mhAZMWLzQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116353; c=relaxed/simple;
	bh=2uRhgucfM3i927+jXi7ByOWgAexwF8a2fNg9XWXiL4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdCAk0d/cJA/5SL/4lF1erkJt7Dtiub/8bYCNCVRMun9PVnhGKiGJueMiqzF+pLWKbizpfRYZCi49N2nR8aDsJDFw3xwFYW/H2+SX+/Hl5kOW+ulkLMOofS3zK541NB5/MXxBZNv0drjwANXARGA7tlaaFQZv2oBK/Pg346RwPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Znb3sT/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Znb3sT/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D046C4CEE5;
	Tue,  8 Apr 2025 12:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116353;
	bh=2uRhgucfM3i927+jXi7ByOWgAexwF8a2fNg9XWXiL4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Znb3sT/ED17JTrmHvuoeb1MlawCtCP3Qx/4rtpt6U9XufEWloQi73DwS397nYi8Ti
	 30kZ/frZMeac9WjtAM1KL4OGJGkBWpwKa3FLGGF+UJ1MCD0FEnkpAIsttPi5P7V5iX
	 n2i6uHIrq9iH9suVm6JuKeo3dEb6F1/86M9js0/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/423] pinctrl: renesas: rzg2l: Suppress binding attributes
Date: Tue,  8 Apr 2025 12:47:15 +0200
Message-ID: <20250408104848.271798929@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit ea4065345643f3163e812e58ed8add2c75c3ee46 ]

Suppress binding attributes for the rzg2l pinctrl driver, as it is an
essential block for Renesas SoCs.  Unbinding the driver leads to
warnings from __device_links_no_driver() and can eventually render the
system inaccessible.

Fixes: c4c4637eb57f ("pinctrl: renesas: Add RZ/G2L pin and gpio controller driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250215131235.228274-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 5081c7d8064fa..47e6552c3751d 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -3180,6 +3180,7 @@ static struct platform_driver rzg2l_pinctrl_driver = {
 		.name = DRV_NAME,
 		.of_match_table = of_match_ptr(rzg2l_pinctrl_of_table),
 		.pm = pm_sleep_ptr(&rzg2l_pinctrl_pm_ops),
+		.suppress_bind_attrs = true,
 	},
 	.probe = rzg2l_pinctrl_probe,
 };
-- 
2.39.5



