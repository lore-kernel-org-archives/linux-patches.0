Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9381514CE;
	Fri,  6 Dec 2024 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498437; cv=none; b=EBw3G3+xXGEdpc/FHyZmy9XqWc+oal+8JlrVTgI7PKCezdHA8KgUp1Jnu0lsHhPbqMZ85y8Zw6knARDK4CpYsQgLWvYoy6IeWXeTWQpEUyDtzzDp1XJgJtKV1r0lDdGuiUyqDNPUXQpcwRZPEEUrlq+UbxYEPJq0PJriyzd0Qcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498437; c=relaxed/simple;
	bh=PckasZsL335+wHIfuJ+/bJON0uyhIX+E1ckCteFMpiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e18w+D0skaw0giqaobHVA2qTrEV+KvR8dHulfbIxzjAUY66tMqMLbaFVoUHK1JizC2EVWJfkrsN8SeU2TeY7Cq5jWFkyJtBFr53Ocr7xhXW2+dScgrXT6RVhnq9ZjUm2GPPDTXyBt477YoORKvlHbppZi2Z+rr0fwPewicpqI+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlBcTJNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlBcTJNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D243C4CEDC;
	Fri,  6 Dec 2024 15:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498436;
	bh=PckasZsL335+wHIfuJ+/bJON0uyhIX+E1ckCteFMpiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlBcTJNARtWNZCOlq/BdZCpyprkLBRdoYxumtoHRAZLpF6kxglqNmSnGA263gdxEf
	 qobk37GgzDw1SGq7jNHJjuiXhihhMDiQGCMrvaTcdCvMz0uuYVYq0Pif3oyge72p5I
	 4+7yh8SNd7jeuSpj0WrzNRydOjwZNgnR+b52CLNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 583/676] modpost: remove EXIT_SECTIONS macro
Date: Fri,  6 Dec 2024 15:36:42 +0100
Message-ID: <20241206143716.141153290@linuxfoundation.org>
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

[ Upstream commit 48cd8df7afd1eef22cf7b125697a6d7c3d168c5c ]

ALL_EXIT_SECTIONS and EXIT_SECTIONS are the same. Remove the latter.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: bb43a59944f4 ("Rename .data.unlikely to .data..unlikely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index e43862cd002e2..0426c1bf3a69c 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -808,7 +808,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_XXXINIT_SECTIONS ".meminit.*"
 
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
-#define ALL_EXIT_SECTIONS EXIT_SECTIONS
+#define ALL_EXIT_SECTIONS ".exit.*"
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.*", ".sched.text", \
@@ -820,8 +820,6 @@ static void check_section(const char *modname, struct elf_info *elf,
 
 #define INIT_SECTIONS      ".init.*"
 
-#define EXIT_SECTIONS      ".exit.*"
-
 #define ALL_TEXT_SECTIONS  ALL_INIT_TEXT_SECTIONS, ALL_EXIT_TEXT_SECTIONS, \
 		TEXT_SECTIONS, OTHER_TEXT_SECTIONS
 
@@ -1013,7 +1011,7 @@ static int secref_whitelist(const char *fromsec, const char *fromsym,
 	 */
 	if (!extra_warn &&
 	    match(fromsec, PATTERNS(DATA_SECTIONS)) &&
-	    match(tosec, PATTERNS(EXIT_SECTIONS)) &&
+	    match(tosec, PATTERNS(ALL_EXIT_SECTIONS)) &&
 	    match(fromsym, PATTERNS("*driver")))
 		return 0;
 
@@ -1181,7 +1179,7 @@ static void check_export_symbol(struct module *mod, struct elf_info *elf,
 	if (match(secname, PATTERNS(INIT_SECTIONS)))
 		warn("%s: %s: EXPORT_SYMBOL used for init symbol. Remove __init or EXPORT_SYMBOL.\n",
 		     mod->name, name);
-	else if (match(secname, PATTERNS(EXIT_SECTIONS)))
+	else if (match(secname, PATTERNS(ALL_EXIT_SECTIONS)))
 		warn("%s: %s: EXPORT_SYMBOL used for exit symbol. Remove __exit or EXPORT_SYMBOL.\n",
 		     mod->name, name);
 }
-- 
2.43.0



