Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4727331E105;
	Mon, 18 Aug 2025 13:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522561; cv=none; b=BOaQ7SMExw8c7/dCLx8CzTqT5NUC1FpZWkrJP9sRp7FHH/xmSfRVEqw3sVQexvIfKmK1G+jH5zELGzYGloFIqGIdwWgqXTHc2mnW/TI12Ni86D0EU7KgZkuCbMglLdDPwaWswJedCwd51pAFNVeaMy4gL5Iy4QXgzMbyovg8mDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522561; c=relaxed/simple;
	bh=37VEBKwsaaymO7I/fDHC7vW+5/0ycd7sZoCbxSsatqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1odEoAW7+xehz2NuEnr/TCmgYOcUXbEzkcW+i88fr54s5df+f3xz+D7uiCW+fA6IAe1SG3n12pAvVJIYoRxd2Qi1hyqiZ1pvol8p0gptmjI+Ub+N3W8RcTuX1QhFIjWgJNTqZ5+bSvu43z86k6rb8FpLETBvUX7EkhHqnSuAdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tWwSnNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tWwSnNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB27CC4CEEB;
	Mon, 18 Aug 2025 13:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522561;
	bh=37VEBKwsaaymO7I/fDHC7vW+5/0ycd7sZoCbxSsatqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tWwSnNCddwiBX5JFZ+4mqFtvvU5MbLs3m4xYrSktAkKjY3jbUWHIhzKaivmFbtaY
	 0HUBMv225XIxnk9HL3JX06sWUt1A5/czbQZGJgUyBxOrBB9cL2af+67xMzWxjhltpQ
	 +4QNX8mI2LFPEJwbZA2N57D7n0+rd6uZFHkDUoFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	Peter Korsgaard <peter@korsgaard.com>,
	Cherniaev Andrei <dungeonlords789@naver.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/444] kconfig: lxdialog: fix space to (de)select options
Date: Mon, 18 Aug 2025 14:46:18 +0200
Message-ID: <20250818124502.116629905@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6e6244df0c56..d4c19b7beebb 100644
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



