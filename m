Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940AB263C78;
	Tue,  8 Apr 2025 11:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111437; cv=none; b=id1tOqVIRJQeeWTwgsRfRjy4jtUK8AYQjnyYvNTyYkXTXuCbT539rv8Tz4aToyAVgzrlohs6lTfBUDmNdq2JxA1CtSk+XaPpP0xBRTLiuNCjbmEJOLquGUoapRgrvrXMiopJpN5hs1dsASpzj8gMJvYoBdf9GYd6+fizHNPFOOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111437; c=relaxed/simple;
	bh=vmEU6FrcHS8jEK+kWkLoaUkbSDTwy4ABUeLs2JKFnik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBo+ST43hdmBpHrAfaGC381ah4F8PCKwAulUwOcLqZmzePbundvDS5b0OmXBKDKONVYMlZzCjLSF88Hs9yUxdC2hqlkJxVnWQrSPErmlb4kvysGngH0sECJ+q3Ac47jZsyAnZ0XYtl0iDbH55pDdo0n9zyPXt1VJUbvGbNSL+qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0c4sGIOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0c4sGIOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9ACC4CEE5;
	Tue,  8 Apr 2025 11:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111437;
	bh=vmEU6FrcHS8jEK+kWkLoaUkbSDTwy4ABUeLs2JKFnik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0c4sGIOT5Lh3pDWIWpkfM9j+fCria6XYN+TEzHC/z5/9vnzYrlL8jUYmkJndqQ+UH
	 TlNI0xDH5UJwIzCOUegVlO9vvaPV9FQs0LiwGqPKVoiAqPijnuQiqqyL2j7p5QB5DF
	 DrBrjWCMvlQyDPqCXF0AJh0fSC/T6cZNFOXB6ADg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 423/731] pinctrl: renesas: rzv2m: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:45:20 +0200
Message-ID: <20250408104924.112632232@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit 5a550b00704d3a2cd9d766a9427b0f8166da37df ]

of_parse_phandle_with_fixed_args() requires its caller to
call into of_node_put() on the node pointer from the output
structure, but such a call is currently missing.

Call into of_node_put() to rectify that.

Fixes: 92a9b8252576 ("pinctrl: renesas: Add RZ/V2M pin and gpio controller driver")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250305163753.34913-4-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzv2m.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzv2m.c b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
index 4062c56619f59..8c7169db4fcce 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -940,6 +940,8 @@ static int rzv2m_gpio_register(struct rzv2m_pinctrl *pctrl)
 		return ret;
 	}
 
+	of_node_put(of_args.np);
+
 	if (of_args.args[0] != 0 || of_args.args[1] != 0 ||
 	    of_args.args[2] != pctrl->data->n_port_pins) {
 		dev_err(pctrl->dev, "gpio-ranges does not match selected SOC\n");
-- 
2.39.5



