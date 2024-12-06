Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70473145A16;
	Fri,  6 Dec 2024 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498468; cv=none; b=H1OGYOC2h0eWXbMhv0ySKsxsvmTAVZtzpy6rR8yv6mqQLVH/K/sIevgq+PvHpOLLql7LrF/q0aCiacP3gq97WKXn1+EZXLGbWQaJcVBY6ZNcrEq6+lME9dfLIOOQYcNLhnVtO+1Y1P7XiM8TYR7INJ5hL7KWckmubIOUHujmUGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498468; c=relaxed/simple;
	bh=jbEHoNal3vbI6oYcS+xD0dc3nkhK5dg5jsEHLfrJDUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD0DnlR6i13xDqnuWen4Qmap4OiE9itokD2pF89Xi10ExKr6Yal/gCHJC7O0Ey6tCjE+EQ+A4W6Cder3T8mP2c7WkwjQRrmkMDlbe3roLiLN6qKS124ZwhSbPgfPzcvS7jSbnIq1xL8epAVGc8zZpNooC8vQQEyYProFR+f2YXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z00ZJGPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z00ZJGPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76877C4CED1;
	Fri,  6 Dec 2024 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498466;
	bh=jbEHoNal3vbI6oYcS+xD0dc3nkhK5dg5jsEHLfrJDUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z00ZJGPeTj5uc/5mjVLrCP+TBg/w/blPsF9oviSCWTWyk05/MYLbpOi6hsByTaLV4
	 yKqW3cW+J9QFomGjm1iwJTpxXMRGIwPsNJFjQZgpfmo6ZRAxCeoyP9oibmAYXhYA5L
	 XLW1bqd1qVSpZFTgY8QibEQlmf/WEzv5HyQm3CDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 586/676] modpost: squash ALL_{INIT,EXIT}_TEXT_SECTIONS to ALL_TEXT_SECTIONS
Date: Fri,  6 Dec 2024 15:36:45 +0100
Message-ID: <20241206143716.260995481@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 34fcf231dcf94d7dea29c070228c4b93849f4850 ]

ALL_INIT_TEXT_SECTIONS and ALL_EXIT_TEXT_SECTIONS are only used in
the macro definition of ALL_TEXT_SECTIONS.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: bb43a59944f4 ("Rename .data.unlikely to .data..unlikely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 413da4c93b78e..bd559361ecd27 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -795,11 +795,6 @@ static void check_section(const char *modname, struct elf_info *elf,
 	".init.setup", ".init.rodata", ".meminit.rodata", \
 	".init.data", ".meminit.data"
 
-#define ALL_INIT_TEXT_SECTIONS \
-	".init.text", ".meminit.text"
-#define ALL_EXIT_TEXT_SECTIONS \
-	".exit.text"
-
 #define ALL_PCI_INIT_SECTIONS	\
 	".pci_fixup_early", ".pci_fixup_header", ".pci_fixup_final", \
 	".pci_fixup_enable", ".pci_fixup_resume", \
@@ -820,7 +815,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 
 #define INIT_SECTIONS      ".init.*"
 
-#define ALL_TEXT_SECTIONS  ALL_INIT_TEXT_SECTIONS, ALL_EXIT_TEXT_SECTIONS, \
+#define ALL_TEXT_SECTIONS  ".init.text", ".meminit.text", ".exit.text", \
 		TEXT_SECTIONS, OTHER_TEXT_SECTIONS
 
 enum mismatch {
-- 
2.43.0



