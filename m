Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4AE2F12D4;
	Fri,  9 Jan 2026 11:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959448; cv=none; b=iZTx5NJ8KjZB0LeTwhdMYQuSiKMd3DBoSJatmR1VpvMTFSRQ+3R4s97h18WnLWKmRdFPhK6hsi17T2ZnuGHzTZBsXS595kKdu60r4CMP4BQUTQGm4TAsKBfxgeoPbNPAXAwI8HXDggC1a5FvzK1zcdhEJx13ubdm3q8j98DAu08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959448; c=relaxed/simple;
	bh=FeZucVMmpMPyugL852Pd7Pd2tCE9La2N2YsvltyYrj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHjuWnvecmJWddwHHla3qLMkR1SsV/8nNQq+hnaDUaQjPqlIjC5Vd5JDBxjQbIJlKuLyORhX3k3ELxhuaPJ+lCyGrUkZPxNUY9BQQ4g635U+sc0n4rcxSHDwg7fMnXRsnChNO1Ii2czAWIktrk6xlj7GtCGebnWyjuINC9FvWE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJJvWocx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJJvWocx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4CBC4CEF1;
	Fri,  9 Jan 2026 11:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959448;
	bh=FeZucVMmpMPyugL852Pd7Pd2tCE9La2N2YsvltyYrj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJJvWocxh8IqZMpGAqtexENBUUQr5xFFacbB/XNIOYv4+JErMRrrQtRKe4VouLud1
	 IIqoDLMfMWi6OAACT92yqNQP8BBhjEqzb0gKbeSRLDWFvLz/Dmqvo2zpJLWvxGHT6Z
	 itUw/LxmuFIPBu2rJbx/zNMHAmo74Eahe5oXh6BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/737] clk: renesas: rzg2l: Use %x format specifier to print CLK_ON_R()
Date: Fri,  9 Jan 2026 12:33:14 +0100
Message-ID: <20260109112136.063407817@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit fd627207aaa782c1fd4224076b56a03a1059f516 ]

Use the %x format specifier to print CLK_ON_R().  This makes debugging
easier as the value printed will be hexadecimal like in the hardware
manual.  Along with it add "0x" in front of the printed value.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20231010132701.1658737-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: b91401af6c00 ("clk: renesas: cpg-mssr: Read back reset registers to assure values latched")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index b7fa4c7eb8016..ab71f9cd250b0 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -987,7 +987,7 @@ static int rzg2l_mod_clock_endisable(struct clk_hw *hw, bool enable)
 		return 0;
 	}
 
-	dev_dbg(dev, "CLK_ON %u/%pC %s\n", CLK_ON_R(reg), hw->clk,
+	dev_dbg(dev, "CLK_ON 0x%x/%pC %s\n", CLK_ON_R(reg), hw->clk,
 		enable ? "ON" : "OFF");
 
 	value = bitmask << 16;
-- 
2.51.0



