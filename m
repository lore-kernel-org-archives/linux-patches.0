Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA93847ACFF;
	Sat, 12 Sep 2026 12:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214508; cv=none; b=dUx1lr8sS0CuhTCFrgdRBebTryx3EjmZWJW2xPjRQlvTnTunsywPSM/tPc48xA+WPkWvfT9St/R6IHIO2pyg7BoRjAS1y4qIeQAamdirC9j2vwNCZSOdBer2zAam4MqjrQ1fyaEg5jADmOCFfPnP8wwdQQHmXNZzbAbFIiGIznM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214508; c=relaxed/simple;
	bh=JQ4Z4HOnkgcEAHhBbaze4Pd9R3ghd1QEq+Qo765uD1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+cMTYLIkwhLL4u8Hm3pM+Uy8CLlEPjXnqtIdouwMapuMPSPNHoAkbtrqpi7mM3Do9Stdvip0lkPOknnSpG8B/w2R7zEpMtZ9kBJRCSqUZY/U1enpFiDgoH4rDMnTu9hV4zd5U+n+uGZ2DO/znZ54ejOjAUaaAZ9IducEzeecPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ph+JS+C0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ph+JS+C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD731F000FF;
	Sat, 12 Sep 2026 12:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214506;
	bh=+eIhFE90mOTUX3D2E6swyUyuNXz9D5Nji8iX2qVdZS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ph+JS+C0Xzg5kOCHozRyhgtOq+L2keObrB/1RMkBduJk4qR+GNQ3EUo1lO0MNSDmG
	 +SMke5/czgkhXm8sIr4E4LZpiv0pzFYfegkLt3a3cvKA9hoB8ck812WG5oETnbELMY
	 VSaIx2Fn2zd7NYbSKPWVEEJ1mxg/08W5YPrHj5hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0341/1376] clk: imx: scu: drop redundant init.ops variable assignment
Date: Sat, 12 Sep 2026 08:46:07 +0200
Message-ID: <20260912065615.150705663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 5f2db1ce201216e81333ecc2ab51494410b2fe0d ]

The init.ops is assigned a default value, however right below it is an
if, else if, and else where all of them also assign a value to init.ops.
Drop the redundant init.ops assignment at the top.

Fixes: 3b9ea606cda53 ("clk: imx: scu: add cpu frequency scaling support")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-scu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index 75a6d91c0711c..ffbb05fb91bc7 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -483,7 +483,6 @@ struct clk_hw *__imx_clk_scu(struct device *dev, const char *name,
 	clk->clk_type = clk_type;
 
 	init.name = name;
-	init.ops = &clk_scu_ops;
 	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53 || rsrc_id == IMX_SC_R_A72)
 		init.ops = &clk_scu_cpu_ops;
 	else if (rsrc_id == IMX_SC_R_PI_0_PLL)
-- 
2.53.0



