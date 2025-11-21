Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C728B342526;
	Fri, 21 Nov 2025 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732381; cv=none; b=Ygx/i7c87/hC3h9lgYNdrCvecsrYc+KLn7+rPmrf7SOiWbFKZEnGHNf4K51y+PX+3MzKVoRrAQ7jIq4RELKHA8XiHLY2V6sxRwfzZ6xyQCWkKAOpCRO3Jpp4zWRD9wMvrP/cQY6+IUE2hrL30f8cU8tVJ+zNXHG+so+mBoL5Hac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732381; c=relaxed/simple;
	bh=u9RPXrGwafFzLpV+fFy4UiSBaXeza1THOgKQEbG4sQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEFBy6UGgBmb2J2j4kHF0pXbQw+dR1Z996ld4cwzE/nKfqlG3X5597uOTP8UCsjUuAESIpYhT1QBSH2xU2MmLZJ0gmiUGsX2YpCXCKGgnIm3L3EG+veZXKvoqnzdom7vB3gdEBrXFeeiqOHOIcIMvceWkC9Q3uQJQxMrNEE5Yhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s10daJmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s10daJmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB2EC4CEF1;
	Fri, 21 Nov 2025 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732381;
	bh=u9RPXrGwafFzLpV+fFy4UiSBaXeza1THOgKQEbG4sQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s10daJmQtM6X+hhqVPatzA3VvMrvarQXXNn4s/oIxrmY/NL2NVwfAEV7xlnK8SaUx
	 4iLSulaeU8jDhR8S8g7IrD9W42/R715sUk90Rt5S7AA8XgyRGXhM7GzDzkys5wt6lu
	 buMT9rJCI8smapGWQ8QVk8x6aiBPzUdQtYYnKwHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/529] soc: aspeed: socinfo: Add AST27xx silicon IDs
Date: Fri, 21 Nov 2025 14:05:57 +0100
Message-ID: <20251121130233.084179669@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



