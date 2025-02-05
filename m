Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C9014EC77;
	Wed,  5 Feb 2025 13:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763849; cv=none; b=AL9UcfHmh+In+cM29R4YtGehA7Ld70/9WqXwjDkwjn0Hai06a29URCPStikdNtncchFOkpBQgS/zghgGOJTt7KkVZKS8HEOt6lTZa6sGSTc5jQ9qTyJPhckxulbVpHP7tmg4nVKrsWkFcGFsKJ7pPu2QOpHV6gnybKORIQI6q3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763849; c=relaxed/simple;
	bh=J+h/7B90OWCYmcrcllyq9BAwaEf90ajkO0INP3P+Ds0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpSwoIQwvW+RAglqrjiWpGmH79JJVZxOX4xF+a3A2eo1ijGPLU3pmdKd7GxgJMAxv05sm/8y6QA4dc9I4Bcfx8aWRXLjJiwQy3MgfICrQG7LDHJFH+x65onqM/k3MUyy9lYwuifUGd1GXmpxoj9bXvN5krDpmbnZyNUXV/L0nJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mb75YXPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mb75YXPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FB3C4CED6;
	Wed,  5 Feb 2025 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763849;
	bh=J+h/7B90OWCYmcrcllyq9BAwaEf90ajkO0INP3P+Ds0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mb75YXPSLymoSmQx57jB1vpEZBLwNgqjtjAY+a9UPdL4f/vGMSzhCGZJGUXkIF5AF
	 riwQ9lvblq4SCI8ZxbUDDFJ0ksuy3gQHaogTT4WdFd3GfVrRiTO+L1ftAurBrzQGHR
	 rsHhjhd2PefkP4P9zTFIoj0f3bq6oAAlTQ1WdXWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/393] clk: ralink: mtmips: remove duplicated xtal clock for Ralink SoC RT3883
Date: Wed,  5 Feb 2025 14:40:32 +0100
Message-ID: <20250205134424.617232942@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 830d8062d25581cf0beaa334486eea06834044da ]

Ralink SoC RT3883 has already 'xtal' defined as a base clock so there is no
need to redefine it again in fixed clocks section. Hence, remove the duplicate
one from there.

Fixes: d34db686a3d7 ("clk: ralink: mtmips: fix clocks probe order in oldest ralink SoCs")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20250108093636.265033-1-sergio.paracuellos@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ralink/clk-mtmips.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/ralink/clk-mtmips.c b/drivers/clk/ralink/clk-mtmips.c
index 76285fbbdeaa2..4b5d8b741e4e1 100644
--- a/drivers/clk/ralink/clk-mtmips.c
+++ b/drivers/clk/ralink/clk-mtmips.c
@@ -264,7 +264,6 @@ static int mtmips_register_pherip_clocks(struct device_node *np,
 	}
 
 static struct mtmips_clk_fixed rt3883_fixed_clocks[] = {
-	CLK_FIXED("xtal", NULL, 40000000),
 	CLK_FIXED("periph", "xtal", 40000000)
 };
 
-- 
2.39.5



