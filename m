Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07F11E7C3C;
	Tue, 15 Oct 2024 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992582; cv=none; b=DOtu1mjLWu/331BjSa+JPWgLLevgZDFQNqbElHO/DRS7qVUT9gaxoRtcpdgdBcXgqmEWC3Aebn+9PjLkjeMTZ6O3Aff5pEaXlgJ0VQUQ1AeyrqNxeRJHJx6uv4BGnR6FLbTeo5PPDZhKvzXVQrD3ZM5XklivTRS7pGe11FUgf/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992582; c=relaxed/simple;
	bh=BRFOLSoD/qQiy8bFrgS42PC0BXI1b/QLecX9FsYj29o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/pYHSEoLzxcS8Q1qvht3gM0dbbi7IV134RRPwRl+NGlnAwZdpRtzCIRO0SrSk963Vr6byJXSzbXB7ZPe+F+DaHz1gA8l4/ERLtPJO1H7BBm7F7vch0fkvHhYY5UI0+lSR3IhwfeXJdXEElVA9wm1ctxQY9FGNnrYltYO1gkk6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiBd5Xm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiBd5Xm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3112BC4CEC6;
	Tue, 15 Oct 2024 11:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992582;
	bh=BRFOLSoD/qQiy8bFrgS42PC0BXI1b/QLecX9FsYj29o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiBd5Xm7RYEkqX+e4N5g0/s4vAIRkBvYPqqPCa7/riM1IT7hh3JFyv8QDknMjyDVR
	 3qtuCAptmS4EtqBBe9SMRREWtV67umxiarlhb9niJFvkFjqvKONg9o3dh7w5CIjBDm
	 2Fm8vssTkf14Z15vlTxkCb4aD2PTxIGfe+EOJoRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/691] pmdomain: core: Harden inter-column space in debug summary
Date: Tue, 15 Oct 2024 13:21:47 +0200
Message-ID: <20241015112446.672276656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aaf6c297c63d2..fda0a5e50a2d9 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -3053,7 +3053,7 @@ static int genpd_summary_one(struct seq_file *s,
 	else
 		snprintf(state, sizeof(state), "%s",
 			 status_lookup[genpd->status]);
-	seq_printf(s, "%-30s  %-50s %u", genpd->name, state, genpd->performance_state);
+	seq_printf(s, "%-30s  %-49s  %u", genpd->name, state, genpd->performance_state);
 
 	/*
 	 * Modifications on the list require holding locks on both
-- 
2.43.0



