Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368F62676E1;
	Tue,  8 Apr 2025 11:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112727; cv=none; b=dPKMduNU0R5VeFzXVURi4gIKzs6BTG1mA2gK4y9nJl9R3MyKzpGgtsWp1XMmIGMfKqeb0ibk6iIk0c+FbEyiYX48DfxssTHbMTebFA4YBrEK8AGWhJvVtWT2ovMOZK8i0jBPHYC+64u8drL39SX94w/1kpotJWYn1va+eSuhIUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112727; c=relaxed/simple;
	bh=oJx+GP3CyVtvxXX9e8oh98tWBv/JafvQUskiiHf3y3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SarRjr+0BoVA/mhrt7rQxXsaL9DArS/1OZfAJdcBUxpYffq69sA3QzKUiIUlW7yBeiuwg5pwUjDHTz60uWOBJan7dxlTUrK/s7AcBLko25z+BKw8nF+b2GRtojkfSXKaWaKxNfxBfs+McV+IUSP3zGQE6/8ipfDm3ekXncbCurA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znrgyFVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znrgyFVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5857EC4CEE5;
	Tue,  8 Apr 2025 11:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112726;
	bh=oJx+GP3CyVtvxXX9e8oh98tWBv/JafvQUskiiHf3y3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znrgyFVTWElcEPIIuczStzxX/YIeN7j1RnQw4ba5o9uqGQ7OtzQYNc66hhdHmcvQQ
	 aITFNS5kS/XabzRAiLS8tLJ6WgLDfPjQMmD7Ij6eIfs9vkLF9rHojDl+s8GCZvVrph
	 I0PfHts4YaURya44Sw2ySCwpwu4SO20cN+YP080w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/279] pinctrl: renesas: rza2: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:49:19 +0200
Message-ID: <20250408104831.081083830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ddd8ee6b604ef..1fd3191d9f8d9 100644
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



