Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078662BAF7;
	Tue, 26 Aug 2025 13:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213270; cv=none; b=DOFLndp91/CAR+q09x5aXTYXW64fTs5NhHOiLlG+tvRWMNxbSbE24kLifPeEtekAlOYxeNdvCVLKO9UhLVvRoO8/JfqJAbhnoA7yRCo4vJwKPYpl9nt0HgZsMcf2JV8HUOBjjuDYWmrlBG0d0Aug+Oxqm9e1hwUOzs2eutwCXHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213270; c=relaxed/simple;
	bh=JBK6yYvuXIl44SfHvJtqL8BgeTUWe3L2fZzvAZ0JpW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlD/FT7atAekHq8rB+s58lQF/T8Mkce1XUk4A8tud7VsJsKwqrIGed0tXh7bdIKGpwpvhQLF8V6D6FAQjkxMoZGlmZrdi7Y0PzAvX93MWa8zl1wPnF6Mt4N0kwpJKVN4TBReZqKN7cRJtDpKByCGYT2jkty4wV53VIqwr76q3LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ltjfsj1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ltjfsj1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492B2C4CEF1;
	Tue, 26 Aug 2025 13:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213269;
	bh=JBK6yYvuXIl44SfHvJtqL8BgeTUWe3L2fZzvAZ0JpW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ltjfsj1NcLtnVQzPmfYf23kyPSaeF9hpnwUc58hlZxiksk/y7QWJHyaamwZxDwSfv
	 Mj7f5U5Tzr8LilAiQvDT96QQSf+eg08Ci4XBhdpcTdINaXLZ7YdUH33wH4/KetdOgL
	 wI+cdXTQyeNoWCk8Sf7m+tR4Aiwhq0Qhu2biHLyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	Peter Korsgaard <peter@korsgaard.com>,
	Cherniaev Andrei <dungeonlords789@naver.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/587] kconfig: lxdialog: fix space to (de)select options
Date: Tue, 26 Aug 2025 13:07:13 +0200
Message-ID: <20250826111000.155036251@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Yann E. MORIN <yann.morin.1998@free.fr>

[ Upstream commit 694174f94ebeeb5ec5cc0e9de9b40c82057e1d95 ]

In case a menu has comment without letters/numbers (eg. characters
matching the regexp '^[^[:alpha:][:digit:]]+$', for example - or *),
hitting space will cycle through those comments, rather than
selecting/deselecting the currently-highlighted option.

This is the behaviour of hitting any letter/digit: jump to the next
option which prompt starts with that letter. The only letters that
do not behave as such are 'y' 'm' and 'n'. Prompts that start with
one of those three letters are instead matched on the first letter
that is not 'y', 'm' or 'n'.

Fix that by treating 'space' as we treat y/m/n, ie. as an action key,
not as shortcut to jump to  prompt.

Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: Cherniaev Andrei <dungeonlords789@naver.com>
[masahiro: took from Buildroot, adjusted the commit subject]
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/lxdialog/menubox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
index 0e333284e947..6bb8a320a4cb 100644
--- a/scripts/kconfig/lxdialog/menubox.c
+++ b/scripts/kconfig/lxdialog/menubox.c
@@ -264,7 +264,7 @@ int dialog_menu(const char *title, const char *prompt,
 		if (key < 256 && isalpha(key))
 			key = tolower(key);
 
-		if (strchr("ynmh", key))
+		if (strchr("ynmh ", key))
 			i = max_choice;
 		else {
 			for (i = choice + 1; i < max_choice; i++) {
-- 
2.39.5



