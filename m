Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5B82698AE;
	Tue,  8 Apr 2025 12:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114581; cv=none; b=U9w/NsjobBF3IWolYij6wlEndSily/ZSKoL0WPY9YpMuv7knX/8SqYqKiNaUAVcwawE2oIArfm4BjkM9JJuCeo5p+8cQZ6vpHNNSHkEaRjYUdn1D9n+z+WBdvbX3t55WyMbZSbgAglK0HJK0sBzpsQoy6FWnp0GJ2QYL6ipdl2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114581; c=relaxed/simple;
	bh=w5A2lNu3kvZ5FAYCEvCFQxQzAwIlyh4jXWz6AtKfX0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/YnsFirMEyz1wSp7pvIgZ49Vp809kZyKVR+iHyruSvjAMrdcgzUdmpzEbKxcgUJnZyUtSDHE8xVc1DoCU//hTJgEF99tC3ZrLDHaOQwTQYeSk351lTC3hQ4s+JG28RkZR+t6GrH8X0mtUuwvKDjBNkSCr/TismHRqhDWOIczFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNM01KgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNM01KgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FFFC4CEE5;
	Tue,  8 Apr 2025 12:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114580;
	bh=w5A2lNu3kvZ5FAYCEvCFQxQzAwIlyh4jXWz6AtKfX0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNM01KgU2zb+yXbur4dh1SUoAmmdq6ybWeaUMDIl6jB090PBeQy8QdDXXjVNHDFe5
	 Tl+7y8RcQOMFsemy9/d9B9bweDB6mxEe4CmjFCs3sKhgqQcyH5Isdd4W/EXEdG6Jgb
	 1nrlHRRUyUX7GGz+KCsMzWC/sMEJGUiY5oSNAirM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 158/499] pinctrl: renesas: rzg2l: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:46:10 +0200
Message-ID: <20250408104855.123351671@linuxfoundation.org>
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

[ Upstream commit a5779e625e2b377f16a6675c432aaf299ce5028c ]

of_parse_phandle_with_fixed_args() requires its caller to
call into of_node_put() on the node pointer from the output
structure, but such a call is currently missing.

Call into of_node_put() to rectify that.

Fixes: c4c4637eb57f ("pinctrl: renesas: Add RZ/G2L pin and gpio controller driver")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250305163753.34913-3-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 3501535f5818f..247fb4a00243b 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2610,6 +2610,8 @@ static int rzg2l_gpio_register(struct rzg2l_pinctrl *pctrl)
 	if (ret)
 		return dev_err_probe(pctrl->dev, ret, "Unable to parse gpio-ranges\n");
 
+	of_node_put(of_args.np);
+
 	if (of_args.args[0] != 0 || of_args.args[1] != 0 ||
 	    of_args.args[2] != pctrl->data->n_port_pins)
 		return dev_err_probe(pctrl->dev, -EINVAL,
-- 
2.39.5



