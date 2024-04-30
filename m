Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFE112C805;
	Tue, 30 Apr 2024 11:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476091; cv=none; b=bgnOc4Sn2pOt0RB7XvjztMGpBrZit/RIMnd19T2oXyVYJfkRLWl0dfgeTLSSX+RT9fXGLRDeFCyVmH7STN/sOe0WNDk1ruwBQJHrjJ3kV2u4yxKji2T4kldH7FgP77itI7Gj9PuLhMKPbjhlsyVCasjgAYqAKfCGHcED9lKPrWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476091; c=relaxed/simple;
	bh=U7YtRZtBioJtm9rI4wi/Qzd1baIK5F6lWsJegfQnD6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpvkJPAv0mLcMA+13cz35wc5jFqrKpgi0TgWWKhESLYoKKc4mgdSwbBj/3T6e5rR1bqdNxmgNvFQDuO0VbDFyE+Fw7eS84ZGH6RR2GwcoU2O1G1mHCOpbLywC8IZwIH+GKiAJA7MxTReR4QEm+hVqarPXw+gHma3bGGRY18mOGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGfnyRkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGfnyRkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E3BC2BBFC;
	Tue, 30 Apr 2024 11:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476091;
	bh=U7YtRZtBioJtm9rI4wi/Qzd1baIK5F6lWsJegfQnD6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGfnyRkd4rH+mFhv5TS7sRuoC2C6nBWPFr5KSr8kUB6szr+qxpd0OIecpzkZPoyLm
	 V3UGgURR7EF0TAYWr8MTH0a8u1XQIF7pJMFVQVWD8ttZYekum3mhlnUYgG4meyrF3u
	 WrfUfnZmxSWKZ5scSMpJ6EAb3aGyU2sbCI8K5uPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/107] clk: remove extra empty line
Date: Tue, 30 Apr 2024 12:39:50 +0200
Message-ID: <20240430103045.550888780@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 79806d338829b2bf903480428d8ce5aab8e2d24b ]

Remove extra empty line.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220630151205.3935560-1-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f9d89b42b8f9d..276b8a1f3c3f3 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3508,7 +3508,6 @@ static int __clk_core_init(struct clk_core *core)
 
 	clk_core_reparent_orphans_nolock();
 
-
 	kref_init(&core->ref);
 out:
 	clk_pm_runtime_put(core);
-- 
2.43.0



