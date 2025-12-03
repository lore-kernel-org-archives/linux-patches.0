Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B83446C2;
	Wed,  3 Dec 2025 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777490; cv=none; b=OVMsO2CnwhqceEO4fW650Nx6NSgqR2cWqoxZsXjxmjsak94gFFg+ncsx3C4y6aWTp8iSpVGYjmF0Ycw9Cjp0bi0MlDIKAV0S2v7XrDU74ja0Wh1diX410/2yAMxBlnHnEt3iTDdPg41J8xGiWMNzfbJq255gdNOaElq8JhpMebg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777490; c=relaxed/simple;
	bh=3bCHBRcQ9VtmTpy1uPQS2hG1idUj27KMjQDnVN3Cv1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZb64oTao7rzgLfM6GtQz6FUt8PVxgCmkwr77IlNq1hKGKSwYsbpQqWlW2bPu3lI6WDw3h7sg4/BPlXwiYzmZo6jVVByDDPb8KcRtjylnU3NJ06O8F1B6brMaYe8yhgZgfWzLfPswk3hxoV3zhTnooDtaitHTTcukE6jzgF7wfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7zXC+61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7zXC+61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E273EC4CEF5;
	Wed,  3 Dec 2025 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777490;
	bh=3bCHBRcQ9VtmTpy1uPQS2hG1idUj27KMjQDnVN3Cv1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7zXC+61bPlDdCqBev8mPY9x5w2jToP1mRvzsi4WCmj7s/KodPc2mkacB6FELzg6r
	 3OG+hEBNdODhCrBmLik2k17MU+AEqkzwEwuT3YXEKuOmLRh+B17Hxw6SSkmTbgFrVI
	 WGrslDDCAnUAg90hctw1jPCwNxExfsxlHKkNa9kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/392] soc: aspeed: socinfo: Add AST27xx silicon IDs
Date: Wed,  3 Dec 2025 16:23:23 +0100
Message-ID: <20251203152416.065716812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



