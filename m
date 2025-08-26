Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B4A1ACEDA;
	Tue, 26 Aug 2025 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215810; cv=none; b=phrt2Dtv1u5KAbc1a+gtNg4X6NWbpFNM7AnaIAGu8eelpB1yEVRA8yd+sZKgRktA9nXjHNskWbfcN4yJDBIvyF4psEY4vV8M+Hnkaqf1XbDlGaFJqx/OGYrUV5xdHcQZ6egBtLddj9vRSO6S9QOcI8kesMXw4elflHtz3GXB9lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215810; c=relaxed/simple;
	bh=tfAlqPpNPlH/notxQnvJ85FciOUA9gKpgt2pHUznglk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IPCIcJkljxZaE0r4292b4J+i39O7dLLBTtRAqxeJKiGYxxt9/LlPS4aeIGHGPAKWOzB2BTZs6oo/n9OBMafdkSo3ltKDersu1EZcQsehAA3uWTcEsbMdefxWWhm99F/Czh6lm6pCcrDCMv67zG3pTQj97qO/BfEF0c2ieGpF1dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCoi9FCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCoi9FCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DDEC4AF0E;
	Tue, 26 Aug 2025 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215810;
	bh=tfAlqPpNPlH/notxQnvJ85FciOUA9gKpgt2pHUznglk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCoi9FCic8b6v1v1APqRF9F/3gwm4/BbVVliZ77YKv9lnHr0aQn0q/K6qQEm/a6Dg
	 vknvyeHFojEACNG4L34BeZGLgLsBFpxBvZRhDw2nO7E0CBcyvClhwgS3pLLCkQT0/j
	 oozcnDunr/IIh1oMiVxjQDkne2dSkRwCxA6V3Fqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/644] clk: clk-axi-clkgen: fix fpfd_max frequency for zynq
Date: Tue, 26 Aug 2025 13:04:26 +0200
Message-ID: <20250826110950.807914120@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit ce8a9096699500e2c5bca09dde27b16edda5f636 ]

The fpfd_max frequency should be set to 450 MHz instead of 300 MHz.
Well, it actually depends on the platform speed grade but we are being
conservative for ultrascale so let's be consistent. In a following
change we will set these limits at runtime.

Fixes: 0e646c52cf0e ("clk: Add axi-clkgen driver")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20250519-dev-axi-clkgen-limits-v6-1-bc4b3b61d1d4@analog.com
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-axi-clkgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index bb5cd9d38993..df9a4c778351 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -118,7 +118,7 @@ static const struct axi_clkgen_limits axi_clkgen_zynqmp_default_limits = {
 
 static const struct axi_clkgen_limits axi_clkgen_zynq_default_limits = {
 	.fpfd_min = 10000,
-	.fpfd_max = 300000,
+	.fpfd_max = 450000,
 	.fvco_min = 600000,
 	.fvco_max = 1200000,
 };
-- 
2.39.5



