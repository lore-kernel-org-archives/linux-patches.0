Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0043596FC;
	Wed,  3 Dec 2025 16:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778878; cv=none; b=Nv3MWDccIvE39SQjoI5Z9+fQUOpr11qL1EiKRyFjjMFmZFL1ggeTpmR4Ra4G86KW3DC6Ex+G9BbAMBG2D0NWFOTIWiK8pL6cGdwVhFwqwJwoKCGAfbRSRfsNbx6L8Tl7J9lS463PNl9jhjl7vomoFkCYmt9vT2GdVnlIUrAU1D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778878; c=relaxed/simple;
	bh=b5rpSnLeDbLG2U2fFAE8m1fsJqznvhTwpg3qgARGIDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHlDksWFHkXcoBCq7aKlS8PPMjjmmTIUEZVMyoEo6ASZSR79IGe81s1gjV5MHmXAoUzVxOv5T8ltsJVYrA7/1nGawz70qHyi1yNxZ3NAVhG29+iAF8N+6STzR4qf185ufYIQGDWqeLKwEoTtrZ6MFWjzKyY9SR9aTcpcoGMR0Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shcS+z46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shcS+z46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6812C4CEF5;
	Wed,  3 Dec 2025 16:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778878;
	bh=b5rpSnLeDbLG2U2fFAE8m1fsJqznvhTwpg3qgARGIDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shcS+z46n9mSEjhgUY8xZNYA9l4DO1I7UexOcrDCP2HbqSYw8+9WSkhKlXDYDisWb
	 w2Thdc8AF0pQaX66tywL9tE+MGD8t0kTRov2AzVZEvwy6YXwlwAZ4pJKbQo9lbZhKw
	 6eacdB602dP5mRhKxUUzSF0WZabOfHx0ocQ0aRW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/568] soc: aspeed: socinfo: Add AST27xx silicon IDs
Date: Wed,  3 Dec 2025 16:21:29 +0100
Message-ID: <20251203152443.924761779@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



