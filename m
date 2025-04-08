Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ADE268684;
	Tue,  8 Apr 2025 12:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116407; cv=none; b=ku09+8JaaRfZyUPcJGHaJtcgXLeyGbF+9LoLtvxjXDTEWcBd8qQr3fgEpc7y+C8wR/0ewqvbDXAYUTAgNoIkLQQ0gCV1bjSOKvg+1FzUMl6212W2T4SGN1PY0i5ENQLsKuaE+OVq70UeR3VAX1Q8S3Z75pZHUryBK8rHk2p8QIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116407; c=relaxed/simple;
	bh=TnHLQZCbrUho6gNuaa+d2oMR6VL9l4EtXovnfGeWthI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVx6OzSTMqU/sok4Kh6iInSE9NZfvElRYqlyw0POz7elW9AefMGS/arKgqGkNjW2MdL61LO1uHcbRrj/h2mSXs/GjOW+JTkEHNhEZGJAeF9DHyC15BlODAJF3bmzbDwXX8vhmHT60FENHRn4SuHn7lkDi70azTK02V1hSc1egeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwJLTQ6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwJLTQ6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B22CC4CEE5;
	Tue,  8 Apr 2025 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116407;
	bh=TnHLQZCbrUho6gNuaa+d2oMR6VL9l4EtXovnfGeWthI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwJLTQ6qZbnFPmjD28s9oCo1bzS3cWSwtuJHoEfVC1n8gKKjJHKcsDsnOlI/H98mI
	 SlHbd+VhA1a3uqvxEhg9H68Icg3chHkyEIDLZ8kwFs2BdLFN6nbyshMm3E/9TK+OQS
	 0Tj8o2eVoxCQwUUH9tXLPu5ZXpdispLB4BMqh+S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/423] pinctrl: renesas: rzg2l: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:47:34 +0200
Message-ID: <20250408104848.708039506@linuxfoundation.org>
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
index 47e6552c3751d..d90685cfe2e1a 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2583,6 +2583,8 @@ static int rzg2l_gpio_register(struct rzg2l_pinctrl *pctrl)
 	if (ret)
 		return dev_err_probe(pctrl->dev, ret, "Unable to parse gpio-ranges\n");
 
+	of_node_put(of_args.np);
+
 	if (of_args.args[0] != 0 || of_args.args[1] != 0 ||
 	    of_args.args[2] != pctrl->data->n_port_pins)
 		return dev_err_probe(pctrl->dev, -EINVAL,
-- 
2.39.5



