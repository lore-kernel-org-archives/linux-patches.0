Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5845A1D0403;
	Wed,  2 Oct 2024 13:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875713; cv=none; b=Dxsf7XgllJq7DeOc6yR+RW9QbLLNKzlev0A/GZyGEFh5NeGJDJqRFJexQxB1W6RSOCZ85FUBtAxeCuN3lASqkB90/HCN8On/4tq2ANM0dhqtz8g+O72qk1zYTx/OZz5dEBluI49UyHyEWDs1e/Uf0XaJd7htG9+HkJ25bUte+oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875713; c=relaxed/simple;
	bh=naa7/c2iezFPHihrbHcKVAotbBbSLebAkliqL24oWLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HitQl73t+OyrPbZYI6rHZ7dExtO++fWiIyrfOKWGBL7NmXaK8wQuOzqgnuUODqpUE/dIA8KhucD67FOEoSyZydt1y65ECJveOL9b9csCWIpOx3oDPbcSIyp3iLaUg267+/D7/rt8NmvE+teV90JHrMIiq1YUMEA3cUMfVKkTJyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQTFlg1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQTFlg1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D454CC4CEC5;
	Wed,  2 Oct 2024 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875713;
	bh=naa7/c2iezFPHihrbHcKVAotbBbSLebAkliqL24oWLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQTFlg1OtnqYjk786JG+UrzlWSQuQxWSL/Ok1Qrvc3sbv+w26nALj0k6uFJqKFHGo
	 jioUcF+id2vj6m4slPrfIsKyRPVKmqQCBrnukQwf43VGnD1WdxKiaQwFKXasPobu6Y
	 Xd+EVQsICXgniddxUcbBFg4nkR+aCJDAxDftHxEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 196/695] pmdomain: core: Harden inter-column space in debug summary
Date: Wed,  2 Oct 2024 14:53:14 +0200
Message-ID: <20241002125830.289998530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 7a61aa88c0614..6691b42eae476 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -3226,7 +3226,7 @@ static int genpd_summary_one(struct seq_file *s,
 	else
 		snprintf(state, sizeof(state), "%s",
 			 status_lookup[genpd->status]);
-	seq_printf(s, "%-30s  %-50s %u", genpd->name, state, genpd->performance_state);
+	seq_printf(s, "%-30s  %-49s  %u", genpd->name, state, genpd->performance_state);
 
 	/*
 	 * Modifications on the list require holding locks on both
-- 
2.43.0



