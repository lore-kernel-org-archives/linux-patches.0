Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443CF227BA4;
	Tue,  8 Apr 2025 12:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114578; cv=none; b=FBqWvdzOQ8DUrzjHRtBTaqP5+c7QyKZaLQAJoudmfgCn6+/502mjp/o/4/XVBZFzs77sYAnAx7NHSRLiUb33eOntt7aIjNNLoeiMPpVhiut/jt+5TEHZI+KaJ2FiVW4KapjS/QsTbon4lQKPAFThrVhG7PXJUb2SEUKKqGieFpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114578; c=relaxed/simple;
	bh=2TLCz+X38qIqxhQzgUeIsosZSyxn7io+Oe9Yko7CxPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0RwFOv/Uwm8O39UaOP5BB4Ro9RdHSE4P4ry3auZQGVtQbg4vLflmYULyYQOuCKwUg+uMX1+Kt9M8xdwCOgV+vY5qM8jyRCNQwGYVv0GEPjlFRwH5SYiY2V0NXXrgpJ0mCIliVO1l8nHRIKP6Moupzgn9ZmsdkqBD4VuRmIk5Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7kTeSyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7kTeSyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FAFC4CEE5;
	Tue,  8 Apr 2025 12:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114578;
	bh=2TLCz+X38qIqxhQzgUeIsosZSyxn7io+Oe9Yko7CxPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7kTeSyfPijxxf8OjOLw0ghx41zuD0+6ZeJje+oFkE5G4S8AgccBti5S6zfgTSRzd
	 2MOTyB5b/A3RQqLtlDMqfs8HS6dUMfOSYT3lSeSdkLX7NWe9beVryuGZDuPNmAoRjJ
	 fYBx4NbByemc2BOfAgR4aCXdwHQwOCuBxmTRhipU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 157/499] pinctrl: renesas: rza2: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:46:09 +0200
Message-ID: <20250408104855.097881037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index dd1f8c29d3e75..8b36161c7c502 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza2.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza2.c
@@ -256,6 +256,8 @@ static int rza2_gpio_register(struct rza2_pinctrl_priv *priv)
 		return ret;
 	}
 
+	of_node_put(of_args.np);
+
 	if ((of_args.args[0] != 0) ||
 	    (of_args.args[1] != 0) ||
 	    (of_args.args[2] != priv->npins)) {
-- 
2.39.5



