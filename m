Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9002FD1CE;
	Tue, 12 Aug 2025 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020680; cv=none; b=o5X0WJ3KeVWKFjbWFbbhs6yf/OpAN56txroTi4oi+q70KHx3IrVtqZq2yVizz63X4EwAByqiI6B4nEb6/m4/+zdQpohYQ3GEk7psfkoOa/SQUeaWr4uCHqqP/fedWKHKxBZ2vlloRGjbner+/C7zMVHSj+JZNRWcozCYgGI6ZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020680; c=relaxed/simple;
	bh=1U+OmkFcTQVYKRkwlvESBRjDAsDNbcukpudv++YZJXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RttaMk+Hde/BO7wotyRY4x7x3ELwDKH4Sbpdu6Ji3cEUb3egkcnF6oZJtxd9GctQtvGUvbse7Wizk/qGlKtNpokFMspkGzmaGsoLFXQlCCpld8hS3oSf60rtybtvUNSlSPCJaXFXvRilKxom9Pi0t5N9Fqi42OsneBDbCDYJJT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVZjLdmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVZjLdmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF654C4CEF0;
	Tue, 12 Aug 2025 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020680;
	bh=1U+OmkFcTQVYKRkwlvESBRjDAsDNbcukpudv++YZJXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVZjLdmZMtThSE4zqDL/dRvQQOlMFIIDjFjS1JVKfQJNlWcXk6DC+/Zh/ETCBlayV
	 T41G9KnMqSwdjjS0VNOy4tI+Urf7QYQXN8XrKz1utyEnn4J5HJwFmxdbo2WbehOo+M
	 Sph8ppwg5ub62HYqx6vdqx0LJI+oijQS8Ygqz3xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/253] clk: clk-axi-clkgen: fix fpfd_max frequency for zynq
Date: Tue, 12 Aug 2025 19:28:59 +0200
Message-ID: <20250812172955.135511346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



