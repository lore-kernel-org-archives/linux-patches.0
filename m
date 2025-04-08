Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17BC266EFC;
	Tue,  8 Apr 2025 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111317; cv=none; b=KNoeN7o8nrg4TfITx4I6l9U2XSSznjR2wXZY3XDFBktsdJYjiYgWE2k00LmUqke+pyzk9tvU/rXj+zcR+jX3+F54fnNny6rTWm+Nlr8Xv/LzRSmMA4j1e50nLePgwscMTVACceahHQferj1kLeklaOn4f+EMKXy+wLYFeSN2eaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111317; c=relaxed/simple;
	bh=NvDu2CnUQOUPRaiTzJm7h7P36s1+nXElPQDLzl6YPmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4XZ3upEpALO+Sj/uf74nTKQJTwmMpmWcMBPR4Z2yNtnCFSh35ml2vr8dgLJFyE7Q3XjxOydb3cK9t/IIYNwCQqhjNK7mcs7J37K6PKzS8vnYC1RzWrqn6sHytC3ZFwie7NhKW47vxKwi35+C6t7PV0YwpMFZrdp8A5ceVFncbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8n862LE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8n862LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BFFC4CEE5;
	Tue,  8 Apr 2025 11:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111317;
	bh=NvDu2CnUQOUPRaiTzJm7h7P36s1+nXElPQDLzl6YPmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8n862LErqHHr7wkPZD2IDLLGWAz14m0FvWk6BBsNisW1MsNi9sRUg1QXZ9VFFfQv
	 Dhn6Br0sqFodf25ahNFSOxW6VC6r8V/L8/oErupLoIc9AxGt1Gfq5vTzmgU4Fuki19
	 0Wg4Wel45gftnlmpnh3s07jwm9TxlGtpi6TAxJRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 389/731] pinctrl: renesas: rzg2l: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:44:46 +0200
Message-ID: <20250408104923.324749234@linuxfoundation.org>
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
index 5f006a059d9c2..d1da7f53fc600 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2756,6 +2756,8 @@ static int rzg2l_gpio_register(struct rzg2l_pinctrl *pctrl)
 	if (ret)
 		return dev_err_probe(pctrl->dev, ret, "Unable to parse gpio-ranges\n");
 
+	of_node_put(of_args.np);
+
 	if (of_args.args[0] != 0 || of_args.args[1] != 0 ||
 	    of_args.args[2] != pctrl->data->n_port_pins)
 		return dev_err_probe(pctrl->dev, -EINVAL,
-- 
2.39.5



