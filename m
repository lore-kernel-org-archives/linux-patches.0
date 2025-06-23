Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E04A1F4628;
	Mon, 23 Jun 2025 21:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715391; cv=none; b=awoXoAj4QtHl/dTwBldgWF7RhIVWyDR2qeHpadYmK53eSkECEisAFd7tbHavWTawsYsbBlAn8ChYz/yH/QO06on9thzPlGFcH8Kj/9zfHwLxXGBLqbqmRZrq8U+NERY7bt2seU0B/kxVPkHE1KWC28L/AEH1nveAiT8E0arcXcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715391; c=relaxed/simple;
	bh=+9yMP2nQOarypFhMiQbFRSTRf3IFKPxfAvrdnSrfYik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoemWvTR8nQ2tlXYQzwEN4EDZ53HxCAqbeyjVfKv/jK268zGKrX2FwwdOwO9JaKo7rybIPEI2498uGqjRCTkT8fd7eFrWKryDwwEgutzl5Zq4RSABNXnU0+invRciFaUc4H/AzttQmjGf5eDWpWP4YW7942JQ38ctk3eLA5Lxr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvpcA9YV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvpcA9YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08091C4CEEA;
	Mon, 23 Jun 2025 21:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715391;
	bh=+9yMP2nQOarypFhMiQbFRSTRf3IFKPxfAvrdnSrfYik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvpcA9YVu3oPYlutMG+WDVrUmHhxdtiFf1YJB4b5S/ef6qIgT0b57sQf0POlJGzzb
	 v2rmQWDOm6Q4taZO4AuI8EEl4yClLFgG1Z/FuzW3ZyRiiEL5qs66Aj+HAZdGxfuVtq
	 wh2XdH93JVzHH9lVhsBlYZ1xKFBbC2KTN0LJUwxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Tudor <laurentiu.tudor@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/290] bus: fsl-mc: increase MC_CMD_COMPLETION_TIMEOUT_MS value
Date: Mon, 23 Jun 2025 15:07:37 +0200
Message-ID: <20250623130632.747310846@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

[ Upstream commit 23d060136841c58c2f9ee8c08ad945d1879ead4b ]

In case the MC firmware runs in debug mode with extensive prints pushed
to the console, the current timeout of 500ms is not enough.
Increase the timeout value so that we don't have any chance of wrongly
assuming that the firmware is not responding when it's just taking more
time.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250408105814.2837951-7-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/mc-sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/mc-sys.c b/drivers/bus/fsl-mc/mc-sys.c
index f2052cd0a0517..b22c59d57c8f0 100644
--- a/drivers/bus/fsl-mc/mc-sys.c
+++ b/drivers/bus/fsl-mc/mc-sys.c
@@ -19,7 +19,7 @@
 /*
  * Timeout in milliseconds to wait for the completion of an MC command
  */
-#define MC_CMD_COMPLETION_TIMEOUT_MS	500
+#define MC_CMD_COMPLETION_TIMEOUT_MS	15000
 
 /*
  * usleep_range() min and max values used to throttle down polling
-- 
2.39.5



