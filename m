Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9122676E1;
	Tue,  8 Apr 2025 11:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113215; cv=none; b=jseTw6e+W+MwW369ooln/wSyIvGaUReWXw/jfmWpxCiLZOLU17+EKdCaIfNCX1OBhUfGEeRTg1CN65QDQiQnmBHzRwqTRYeEJaaoUBmB7vN2tnCogivpFtE7mFmHXDIsevUgFqHBOk5cKbDHT6FBBWZ39P73O2GEsD6nf/Qobj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113215; c=relaxed/simple;
	bh=GQbbKPfu1Mck0RNg2OujGt9wF9zzqLi75Do5Jygeh3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPYPNAIYIErF8xWQIvP0rN9oxWUahMVEQ9k6swNKoaPm87aZMwtHOOgVRA/fO77PW92T1PwmU0Za8v5YRIFQ/ib8kSLMaLxSI/7ZYYp6iWYezbJAo5LduOc3tbQW3phi+njpRJpF5lO8uEXgyoBkBQYpD+DjK9vynHs+oypQetw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiqEzfUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiqEzfUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D95C4CEE5;
	Tue,  8 Apr 2025 11:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113215;
	bh=GQbbKPfu1Mck0RNg2OujGt9wF9zzqLi75Do5Jygeh3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiqEzfUoGxkDttrsBPXOApW0qThYG9rIx6RONwuokF7dRWS7Hav1YzjM7ziVn+iiU
	 9pcwH8BL+TzkCRxkgvYIk0Gcpz8sqntBo+SGxNjS/tbfXDJfRoyRPelTuRLWZ/7s3n
	 f3PMWN5hcbgrHIfJUR7z/oaK3jLA3BELZySKKOTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/268] pinctrl: renesas: rza2: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:48:08 +0200
Message-ID: <20250408104830.573557622@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 990b96d459671..c5d733216508e 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -253,6 +253,8 @@ static int rza2_gpio_register(struct rza2_pinctrl_priv *priv)
 		return ret;
 	}
 
+	of_node_put(of_args.np);
+
 	if ((of_args.args[0] != 0) ||
 	    (of_args.args[1] != 0) ||
 	    (of_args.args[2] != priv->npins)) {
-- 
2.39.5



