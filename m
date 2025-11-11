Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CEC4086A;
	Tue, 11 Nov 2025 00:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822491; cv=none; b=UjSEB1rGecZ/yBCiI7MtB7kVp9MhAIN8lpMcuMo5TnS3/Y6p2o6ZLBqA/O+kW4rcYArDnSR+zEylkDNcG1R260tRTcb0iIKAJg4+QZlrmYgoHPGyk2qVM9U7NZV8wUMmpTuVutPM+vTYZP6aDFeGGdUQkJtC5uJLs7rCGTm/Nck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822491; c=relaxed/simple;
	bh=EV5wQ0mCyPLEunE/u3vabNQNPDiUJmn5KwDtU6Gl5Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIiKfEYnQ8O5la+5FkOmo14Q6KYgBTvhgAP1eHHmFjr3mmfYD56jJbolwoL6taRcMaLAuaA6YBN8bE6cd1PMEZm4qB9Jw2CBqm98AkboCM8EiVywZF9OqGM4xViwRvBQFm8v/dGPArGnjDcuo8BlFwGN01bvElzE1fz+xrndTvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DM1EaTu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DM1EaTu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94973C116B1;
	Tue, 11 Nov 2025 00:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822490;
	bh=EV5wQ0mCyPLEunE/u3vabNQNPDiUJmn5KwDtU6Gl5Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM1EaTu9IgNwE+qg4yKQfNaE0+mDZyHaFxXY4SmJqe4yEew5C7nFsp/C+lV8Ai32n
	 rDkGyE01bB4FFJ4rmiTXgAthgAKahztkEI25CWcoe/noykJ68YBU45EtiRhe460biJ
	 YE3rgqqRgOXOOf+d6GK2YRthZtXP/v4FCnqBRTig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 118/849] soc: aspeed: socinfo: Add AST27xx silicon IDs
Date: Tue, 11 Nov 2025 09:34:48 +0900
Message-ID: <20251111004539.250161312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



