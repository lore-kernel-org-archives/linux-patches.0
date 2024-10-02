Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474FA1D07B2;
	Wed,  2 Oct 2024 14:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877739; cv=none; b=j0jQREkHM7TC/hJGvzM8s0WI23HdnKT8asmFIZmhws/0KVs1q5xvHj7irWZffxKQK70YvsR9OuXJ6/c1piH+BgzYu140j7Isw6fnzk4BMXKS8yRu4xlzcvMrW8xKZzTZad96PqNwtpnKf4w9uXs2456NQiFFf2np/HM5zg/LXck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877739; c=relaxed/simple;
	bh=SAZQH7FGBljM0x0aFUkX13TEUafD7ffuQIiudzpjBuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p98A1l7Sncbf1hTxtZvNnTt9V6LtQZSXq1YKxVr3s9blZuNcp1+CmnCEMT5wrSPBeslzPLEDD63tP+Rc3HKft3hIO98W5eogjLMGhs6XVFBPY2aSMjJA9nEeISW7n3J6j1AhUGvUSIWLtLe+2I/wUlW8aMyDRldtc1/Wp3ZrkAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7KAttIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7KAttIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC23C4CED5;
	Wed,  2 Oct 2024 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877738;
	bh=SAZQH7FGBljM0x0aFUkX13TEUafD7ffuQIiudzpjBuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7KAttIjfULJPZ06SOt4YIu/fRTt3YHEaT6aF40duga/3TmJbSvssHerbKfksBh+y
	 ky9Nn4Hqr84Z0yne/OLImBMJTPnTW16SlQlQsOaOqCjAx1qken7l+6nbazbZxgR+4r
	 AZPdPMbHVzKLP5YfICFo6WKlbCNfxq7mbDgumrGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 178/634] pmdomain: core: Harden inter-column space in debug summary
Date: Wed,  2 Oct 2024 14:54:38 +0200
Message-ID: <20241002125818.134367789@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 692c20c4d075bd452acfbbc68200fc226c7c9496 ]

The inter-column space in the debug summary is two spaces.  However, in
one case, the extra space is handled implicitly in a field width
specifier.  Make inter-column space explicit to ease future maintenance.

Fixes: 45fbc464b047 ("PM: domains: Add "performance" column to debug summary")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/ae61eb363621b981edde878e1e74d701702a579f.1725459707.git.geert+renesas@glider.be
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index 623d15b68707e..0ab6008e863e8 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -3153,7 +3153,7 @@ static int genpd_summary_one(struct seq_file *s,
 	else
 		snprintf(state, sizeof(state), "%s",
 			 status_lookup[genpd->status]);
-	seq_printf(s, "%-30s  %-50s %u", genpd->name, state, genpd->performance_state);
+	seq_printf(s, "%-30s  %-49s  %u", genpd->name, state, genpd->performance_state);
 
 	/*
 	 * Modifications on the list require holding locks on both
-- 
2.43.0



