Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D504C97;
	Tue, 11 Nov 2025 00:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822698; cv=none; b=NHImtFuK8WodDtRT0KdEcUjvlcmanWYyizzNpC0An5XRtulpHqaEWCcJTH2khRwJOV+e+qngv3nzU/K33tardfQ01MphfpZnjNk1ye06As9EJZuEi59kJTPirbSv0AjeTEm7Si4Ji5mMA+LIZhYXfeCMwuvVpAdS79gYh2xFJgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822698; c=relaxed/simple;
	bh=IFnm84dQs5BWuwb0TO4mdJTcothIXyi6JAxjDxhc5Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGB/NL7nOYv6xSGMFKzbTKmA1Y5Ij9fHVV9iwBUPec663JrSN+uwYizAzz+8eBYOYZ0b9vEZ3sNS6FM6hkaUy7fd6wNOjcg44q/NHx+ZGEv8xuqJcGLtt+0ZjLo0dIgCCSuigk8yGyBAd2ZcVfssjqJSi0N3a/7lMWvWx1hYTZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nY6OvaxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nY6OvaxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62025C19422;
	Tue, 11 Nov 2025 00:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822698;
	bh=IFnm84dQs5BWuwb0TO4mdJTcothIXyi6JAxjDxhc5Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nY6OvaxLWtBJsfYrM7kR5ZqKg+lV4b8f/+/WPj1IldXDX5cCsD7ix0PdvMzYDaT6V
	 alVoBTS0AUC7RKqIrKpMgK8g700KEKt4ig6S93lCESbJcCgFGb2/djRtbJpOVxZ0ob
	 7C/AyuAnsNG3WCTHfbdxlVvdpm3rEOkvcdJ7WIFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/565] soc: aspeed: socinfo: Add AST27xx silicon IDs
Date: Tue, 11 Nov 2025 09:39:04 +0900
Message-ID: <20251111004528.949944768@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Ryan Chen <ryan_chen@aspeedtech.com>

[ Upstream commit c30dcfd4b5a0f0e3fe7138bf287f6de6b1b00278 ]

Extend the ASPEED SoC info driver to support AST27XX silicon IDs.

Signed-off-by: Ryan Chen <ryan_chen@aspeedtech.com>
Link: https://patch.msgid.link/20250807005208.3517283-1-ryan_chen@aspeedtech.com
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-socinfo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soc/aspeed/aspeed-socinfo.c b/drivers/soc/aspeed/aspeed-socinfo.c
index 3f759121dc00a..67e9ac3d08ecc 100644
--- a/drivers/soc/aspeed/aspeed-socinfo.c
+++ b/drivers/soc/aspeed/aspeed-socinfo.c
@@ -27,6 +27,10 @@ static struct {
 	{ "AST2620", 0x05010203 },
 	{ "AST2605", 0x05030103 },
 	{ "AST2625", 0x05030403 },
+	/* AST2700 */
+	{ "AST2750", 0x06000003 },
+	{ "AST2700", 0x06000103 },
+	{ "AST2720", 0x06000203 },
 };
 
 static const char *siliconid_to_name(u32 siliconid)
-- 
2.51.0



