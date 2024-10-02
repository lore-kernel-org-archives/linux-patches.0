Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086B51D221A;
	Wed,  2 Oct 2024 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879489; cv=none; b=dfhh4wO4YmNk0PDf0B5nwYJgIiHOsE0p8aA/spbfqr0BQlsZ3KruisyO8+2WdoNCRzrKTbtwU6u6R4d4DPMCZFVlFIYe49Jfu50jwznFDNWdw/keu2hAP4bchZpFcr4riiCNAwLcIJaqDPtkWzXU6qtUw62wFh55zwUC4Q4KYWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879489; c=relaxed/simple;
	bh=YJi8QX9h+t3TNbASavgHKUiFELtPkHkd0xnls54Hlx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgpYlx3KUg97rRF0L6YS2YSpIGyl9bdj3jsOdVr6S1+VjmiC1n8q/M0r9myiyr2i1GxPWSMtg3ZyCNVqjq4rQ2717L0gBlrwa5UDczxPji6Ra6H8QoHAHiZ0KPQtI1LLuqDE2LYfBAV43ZZ25Mgu2/eNp+dA8+d4N31TgwRSpiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMONTwtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMONTwtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8014EC4CECD;
	Wed,  2 Oct 2024 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879488;
	bh=YJi8QX9h+t3TNbASavgHKUiFELtPkHkd0xnls54Hlx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMONTwtm2NyLhTnpblzTAAiSD/V66jC/J1/f3OODUfGsbRLN9kWAIb2sRITAVfSdx
	 P45P7q6m6UWUGUj6UC74VOlIlWrrW6puCCNKvIudUr/yItTe/oBLI5LeSFyGSMf4Ue
	 9+BG5rgwWhgl0l2BIBKwjS3Wcro/tEExlYjRouXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/538] pmdomain: core: Harden inter-column space in debug summary
Date: Wed,  2 Oct 2024 14:56:16 +0200
Message-ID: <20241002125757.648957469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/base/power/domain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 84443b6bd8825..582564f8dde6f 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -3135,7 +3135,7 @@ static int genpd_summary_one(struct seq_file *s,
 	else
 		snprintf(state, sizeof(state), "%s",
 			 status_lookup[genpd->status]);
-	seq_printf(s, "%-30s  %-50s %u", genpd->name, state, genpd->performance_state);
+	seq_printf(s, "%-30s  %-49s  %u", genpd->name, state, genpd->performance_state);
 
 	/*
 	 * Modifications on the list require holding locks on both
-- 
2.43.0



