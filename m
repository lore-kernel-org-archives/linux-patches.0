Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6783C140F;
	Sat, 12 Sep 2026 07:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197003; cv=none; b=R6Ie2G+pfsOxrxJpqh5MxYnQzZnub9jOZPxVyVZ7113xd3yUPjvfG5BZ/LTOE3tFcYBMJq3026pjbEA1s+VGkcFN9VKs3h0IgBRVdljFPK4opV24w+aSKLGWMVDSIGkJPLfSmahUEqWfdx3bPCn8ZTmZldfgXEVRbJBX/QPO05E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197003; c=relaxed/simple;
	bh=5iWBlns3Lmluh/BanVZHAv6DcBX7LvJVn3WS4ZsG99U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lipib8AFcnwSxP+1xJ7M/tFQC9QV+54MdK9UO4uccY49MHKZGWIAt5Ej/ar71+YEbj56Jd2JW670o7Zz8QCF5h69PvfBXk8aOXAH5Yqbv2Nh07s7hPrCDY6dtNYOZZZafn/yw3uyj0vbG90wS025dKecBIH6m07Moisrb0Qpxt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm1g8jbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm1g8jbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F2C1F000FF;
	Sat, 12 Sep 2026 07:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197002;
	bh=4f2Z9JQS9GNU/97gd65/vzRDoYToWiirqVV8F3ojawk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xm1g8jbwDCNwpFrY+oJ6kEt9LPL8IyXMJx+jc89fqvl+2sIcIiAWQOnvUoN/YBP4y
	 E7UcOYcBvjJ471IOIU7cr33yt22xoJ7zosWs1f2FETIdzYziziYsO04MXOoEUODvia
	 7Uz41/1QHWs5+cfjkS19c8gsuYToTF0gMn5UejFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuyang Dong <dongxuyang@eswincomputing.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0080/1815] clk: eswin: Add CLK_IGNORE_UNUSED to NoC clock
Date: Sat, 12 Sep 2026 08:30:30 +0200
Message-ID: <20260912065650.888998218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuyang Dong <dongxuyang@eswincomputing.com>

[ Upstream commit 22109b7329f9b3bf2fee73087c73ce46e9bf3751 ]

The gate_noc_nsp_clk provides the essential clock source for NPU,
DSP, and PCIe subsystems. During kernel init, the clock framework
attempts to disable unused clocks when clk_ignore_unused kernel
parameter is not set.
However, gate_noc_nsp_clk is required to remain enabled for these
critical subsystems to function properly, causing PCIe boot failures
when auto-disabled.

Add CLK_IGNORE_UNUSED flag to gate_noc_nsp_clk to ensure it stays
enabled even when clk_ignore_unused is not specified in kernel
command line.

Fixes: cd44f127c1d4 ("clk: eswin: Add eic7700 clock driver")
Signed-off-by: Xuyang Dong <dongxuyang@eswincomputing.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/eswin/clk-eic7700.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/eswin/clk-eic7700.c b/drivers/clk/eswin/clk-eic7700.c
index be81d74192dae..43a47fe16ab14 100644
--- a/drivers/clk/eswin/clk-eic7700.c
+++ b/drivers/clk/eswin/clk-eic7700.c
@@ -791,7 +791,8 @@ static struct eswin_clk_info eic7700_clks[] = {
 			EIC7700_CLK_MUX_CPU_ROOT_3MUX1_GFREE,
 			CLK_SET_RATE_PARENT, EIC7700_REG_OFFSET_U84, 27, 0),
 	ESWIN_GATE_TYPE(EIC7700_CLK_GATE_NOC_NSP_CLK, "gate_noc_nsp_clk",
-			EIC7700_CLK_DIV_NOC_NSP_DYNM, CLK_SET_RATE_PARENT,
+			EIC7700_CLK_DIV_NOC_NSP_DYNM,
+			CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED,
 			EIC7700_REG_OFFSET_NOC, 31, 0),
 	ESWIN_GATE_TYPE(EIC7700_CLK_GATE_BOOTSPI, "gate_clk_bootspi",
 			EIC7700_CLK_MUX_BOOTSPI_CLK_2MUX1_GFREE,
-- 
2.53.0



