Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5AC26B951;
	Tue,  8 Apr 2025 12:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116477; cv=none; b=LqOen64gAWL+UWgiJ8E5tNPymN4qQny+Aht2lFLQ+8RM6l6jhD3DDvtkUgbzzNuMyzZV8pY89vVWWaQpCPilu0P8pmFaj/NtgCQ0zgP5EyFhlW10zk9idKq6YDu+3Tk7hAx9jYr3pBWngXl/bdFQSLiOwgig3JcYHWLk4bKdVpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116477; c=relaxed/simple;
	bh=83xSSv4DhIP559pKo/5xwSrfKGfbAQWZ1KYiEybk/Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK1xVr/Zy2eyb/D8Z5KnSlAcBvAJK6C2pJBBi7a/jcUPgH1W4whQ6IYA38iJbBHj22R8ed/2fc2KJBtpKwchN4T2kV3LiX8vUTxtqiSIib3Zy5+W9khZ4j/RoazXxcv8aZ9UxAA5BIk7p6OmEM/FX/mI3lSX05KcXDYnshMiEgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6dKKE5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6dKKE5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D895EC4CEE5;
	Tue,  8 Apr 2025 12:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116477;
	bh=83xSSv4DhIP559pKo/5xwSrfKGfbAQWZ1KYiEybk/Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6dKKE5uo17t/Nju7TKDrGh6JR+c5odUcfPOqeIj4ZabQbdmsACLer7MT4UNQzVP2
	 xjP/5IcAsn7ujpi9mW2iA5QwhPniB8+EvDKVnDuNEmRnDP2I8EjY+L2EtQevvO2uSR
	 R+chi9rpWCt63zEAmY0As+She7qjPLn/LGOmpYFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/423] pinctrl: renesas: rzv2m: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:48:00 +0200
Message-ID: <20250408104849.324701082@linuxfoundation.org>
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



