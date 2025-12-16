Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3A53451A6;
	Tue, 16 Dec 2025 12:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887608; cv=none; b=bx6vHXaJKTOxtH8TYUH28epR42bLm6aFYH6GO/W8h5NSrXRGpJzv8WIzqb/4ZKp/tFWywd/TMIwbVzqUmKN9GGV/tNbmartHyQ2wqoaQVErCeTzeIyybqR673nAPRGwyeJwcSlhpP0++2RjHUJFjZWPGgCh1VToPXPloQ9Hn7YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887608; c=relaxed/simple;
	bh=TTqM87pbxhjFfonaX+gPN9yPqY/54TwdT/dXypFbkYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIa11EOFAqMXMaa2J8/OTqlmqWcw8ZR10afsLnYJMwDcxsQeIIASsWnXc5fZAEeeoMLXXz2IQiWHIcGaqjYxywv1NXu6RbcfD0T0SQ4ud4VkyOf8cToAUyhtJ1/bawqIsZSUruOE5W+QfCCWC5uB1yjHqgudhMRI7O/8K+QcVQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBXT+6y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBXT+6y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C09C4CEF1;
	Tue, 16 Dec 2025 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887607;
	bh=TTqM87pbxhjFfonaX+gPN9yPqY/54TwdT/dXypFbkYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBXT+6y+oXMPNsjxdHHuagn65sFMkMyOuT/gfx4r9sjDmzoSvGIIow/+/X4se3ghJ
	 s6BbdQML2tB+m4H6ljg0OKVp9Xgqc95LM+ty9UlqrFNgEd9YDknYO59K1Hp5BP4t2D
	 COQ3lvBV5OAFPtqtkblj6Z69l5QyfTf6LvgWoLP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/614] soc: renesas: r9a09g056-sys: Populate max_register
Date: Tue, 16 Dec 2025 12:10:42 +0100
Message-ID: <20251216111411.338609952@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 4ff787433ba6d564b00334b4bfd6350f5b6f4bb3 ]

Populate max_register to avoid external aborts.

Fixes: 2da2740fb9c8 ("soc: renesas: rz-sysc: Add syscon/regmap support")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251105070526.264445-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r9a09g056-sys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/renesas/r9a09g056-sys.c b/drivers/soc/renesas/r9a09g056-sys.c
index 3ad1422eba36e..16b4e433c3373 100644
--- a/drivers/soc/renesas/r9a09g056-sys.c
+++ b/drivers/soc/renesas/r9a09g056-sys.c
@@ -72,4 +72,5 @@ static const struct rz_sysc_soc_id_init_data rzv2n_sys_soc_id_init_data __initco
 
 const struct rz_sysc_init_data rzv2n_sys_init_data = {
 	.soc_id_init_data = &rzv2n_sys_soc_id_init_data,
+	.max_register = 0x170c,
 };
-- 
2.51.0



