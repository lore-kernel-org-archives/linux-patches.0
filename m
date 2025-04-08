Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E2926B2D1;
	Tue,  8 Apr 2025 12:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115680; cv=none; b=HT51qNddeEzatz7ByBEG4hUqwPIAI7SNgo8EAh0lXh3cUHF2yfudSzqYWhvzOr1yvkNOUPP2hU/O7UL83pICDBoo9Am2XyxzVYhLVAicXoaTuZqEdEfWPuIPKcAMZgwW8DiZtXryTVcoF4PVfwrlRcnscHlK1Qfsx3fVanWikFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115680; c=relaxed/simple;
	bh=0gAjv5MJC2QvVlSR83h5xCPKlqsWIrcrPSrIR2wmp30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joh/WpPuWEPip3UDK7zYCujSKgZ3q7q9dF2cM7pAsK1V0IsuXbLrxijFAnFRYgPICOQEYC+a2MsksdFxzFQcKcNJLGagCEu7xRK0lxRji+pTVLGL5Eh03jUHHqJXow93w6Ng6v/dVdooER8n1ACq1v20fs1O2b7Lo20aLrxYrCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR+7jdxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR+7jdxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157A2C4CEE5;
	Tue,  8 Apr 2025 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115680;
	bh=0gAjv5MJC2QvVlSR83h5xCPKlqsWIrcrPSrIR2wmp30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR+7jdxdPFnh7FaNX0wTRlteUrSMVoscAGWJ2AcaTC2+z93USvitrYLs7gqhTNU+T
	 TG8rE3OGgUDOwu3xn9YCfujWlOkDuAi6BDJbH6WNceB/7YdXdZnU/rEv+U+1iXLvhY
	 S9ame7NqVJUwY+I9DT/RFrWn+rI+w2uhmPd9eTmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/204] pinctrl: renesas: rza2: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:49:53 +0200
Message-ID: <20250408104822.206969248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit abcdeb4e299a11ecb5a3ea0cce00e68e8f540375 ]

of_parse_phandle_with_fixed_args() requires its caller to
call into of_node_put() on the node pointer from the output
structure, but such a call is currently missing.

Call into of_node_put() to rectify that.

Fixes: b59d0e782706 ("pinctrl: Add RZ/A2 pin and gpio controller")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250305163753.34913-5-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rza2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rza2.c b/drivers/pinctrl/renesas/pinctrl-rza2.c
index 12126e30dc20f..2d6072e9f5a87 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -252,6 +252,8 @@ static int rza2_gpio_register(struct rza2_pinctrl_priv *priv)
 		return ret;
 	}
 
+	of_node_put(of_args.np);
+
 	if ((of_args.args[0] != 0) ||
 	    (of_args.args[1] != 0) ||
 	    (of_args.args[2] != priv->npins)) {
-- 
2.39.5



