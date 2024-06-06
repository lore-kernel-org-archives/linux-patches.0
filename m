Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E061F19D06F;
	Thu,  6 Jun 2024 14:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683084; cv=none; b=f8iu/bHbq8D3srvRSXA0AIbkKEpjnms4iZgu59P1awVBmL9rIZXsFJusTfEpVKPTaUOLJFAP98sbCuZIOrPcluCkyZ5N+47//ltA5IM7N3hANxNWfyr9LUxSgtx44aBz3i33bIJqnekLrSrkTPdAG1sfY4nlmDDDeZko1rV/Azs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683084; c=relaxed/simple;
	bh=UxMQZRuHUGihoerQk1eOO5Wn2wxLO8fu5clwDqTrF3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALbvYjZT7Vymjv/nbrjPCFt7dYJzeyjGPs69dgh2kGxnBitWOx4FhI9wZ7HZKLer1p+qyscjq13/qVNIlGmU/Xt+RHgYPAMtasXTcg7XHbsZ4HdbhgJV52TKk1fLNCIdIZ9DqWP2ZjlNYJTZYNWIjqdyfnaNIF9j+HvHoeWbTZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBOsSwOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBOsSwOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2D8C32782;
	Thu,  6 Jun 2024 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683083;
	bh=UxMQZRuHUGihoerQk1eOO5Wn2wxLO8fu5clwDqTrF3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBOsSwOwo7TBonM3Zv6i43L56bXtZ99ALu6CaX9a9EQc3eCjz41QJ0yUMvm1mWpmp
	 PDAMgfEuT+FyXaT54JPaMnm/exugxbsYJFysoo3V/s6MkWtkZ7frl46No7bv2Smq7n
	 2/28SaAXV0ywEqmNfhTk7AeaeSEcjOM51Z8uxCcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 356/374] powerpc/pseries/lparcfg: drop error message from guest name lookup
Date: Thu,  6 Jun 2024 16:05:35 +0200
Message-ID: <20240606131703.801440307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 12870ae3818e39ea65bf710f645972277b634f72 ]

It's not an error or exceptional situation when the hosting
environment does not expose a name for the LP/guest via RTAS or the
device tree. This happens with qemu when run without the '-name'
option. The message also lacks a newline. Remove it.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: eddaa9a40275 ("powerpc/pseries: read the lpar name from the firmware")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240524-lparcfg-updates-v2-1-62e2e9d28724@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index fb0189af2dea1..0ed56e56271fe 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -361,8 +361,8 @@ static int read_dt_lpar_name(struct seq_file *m)
 
 static void read_lpar_name(struct seq_file *m)
 {
-	if (read_rtas_lpar_name(m) && read_dt_lpar_name(m))
-		pr_err_once("Error can't get the LPAR name");
+	if (read_rtas_lpar_name(m))
+		read_dt_lpar_name(m);
 }
 
 #define SPLPAR_MAXLENGTH 1026*(sizeof(char))
-- 
2.43.0



