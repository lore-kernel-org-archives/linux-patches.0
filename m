Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F55323ABBE;
	Wed, 30 Sep 2026 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794553; cv=none; b=oFD2PuyzY61nG04Al+e99haKlVTUwniP+feg9WjWwCCgfjEgPgZZ0rFfMuZKgwwMf2QJ6a61xsJYtzP2CCdFtTzQz88Sqq5pNJ8BMBVYgeOoLAQUHttX61Gdk89mhhxD8Lyb6k/+AaaBqWn/K0XcT8TIWEHp0w9FlPVekrqQvuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794553; c=relaxed/simple;
	bh=p2uyutO9ggvaEkvDxrmvv6PN0zTV3Q20eSkE9fBDeB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgaP0sLY1YNpIycHEkwhmgSiw3QiRhfjT5zNHiqHl1RQ3xVC8ghtSsqOJaAMhmpRIAPWKIYLL0sDjiJd+EyFINj4mmNRtuBNZkqzWpx6nHSFE4NlAjlyZC1licWrE9jc6rc/GEOG/w5/2mBTn/VjfzXUyNi2kvwExFyUcdnrkMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQaeqekM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQaeqekM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8874D1F000FF;
	Wed, 30 Sep 2026 18:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794552;
	bh=GeQ7I13l21TkEY2WUDk3h+1XUTNwourzg4XCZRqkU3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQaeqekMa5H3EDg3Qu9y8C0z/GCnAopJj8jesm9lm77y9iZwqT1DsFUCQqQH+cTYi
	 TYv7oQs1in+DXqKK8B+sZmTokAPcVxaMm4VDtvzZ7EtIGcm/1oCWyvjzA5xpPU85yw
	 imrARGo1L/go+U1Ho7YZ4j0gLSQPQU4mftDAReeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Huang <tommy_huang@aspeedtech.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0251/1193] rtc: aspeed: add AST2700 compatible
Date: Wed, 30 Sep 2026 17:15:35 +0200
Message-ID: <20260930152439.760672136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Tommy Huang <tommy_huang@aspeedtech.com>

[ Upstream commit 3319cfeeb8c4047026f84df045c438f7bbd338a6 ]

Add support for matching the RTC controller on ASPEED AST2700 SoCs.

The AST2700 RTC controller is compatible with the existing ASPEED
RTC driver implementation.

Signed-off-by: Tommy Huang <tommy_huang@aspeedtech.com>
Link: https://patch.msgid.link/20260601-ast2700-rtc-v1-2-15d4ca46500a@aspeedtech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-aspeed.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-aspeed.c b/drivers/rtc/rtc-aspeed.c
index 880b015eebaf7..361bf972a18d4 100644
--- a/drivers/rtc/rtc-aspeed.c
+++ b/drivers/rtc/rtc-aspeed.c
@@ -111,6 +111,7 @@ static const struct of_device_id aspeed_rtc_match[] = {
 	{ .compatible = "aspeed,ast2400-rtc", },
 	{ .compatible = "aspeed,ast2500-rtc", },
 	{ .compatible = "aspeed,ast2600-rtc", },
+	{ .compatible = "aspeed,ast2700-rtc", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, aspeed_rtc_match);
-- 
2.53.0



