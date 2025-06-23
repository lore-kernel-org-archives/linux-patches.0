Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32CD2248B5;
	Mon, 23 Jun 2025 22:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716618; cv=none; b=Xg3AKe4KeGu1pzGeXOHj/v6gi3pCDRumPdfbpWRj9JuPDkDXZx9Ubajf/u6FX5dhK3i1Y+/e8P/cRc7e+XXu8zPgxJyOx2ot52wEeT0+HdpOdftxgn5bYtSbZxlTvfMkPi42Q//5LxRDNfCfrth4VIacZsLXk2iP43QtHmTIrb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716618; c=relaxed/simple;
	bh=DaMm2dNahzbWe8RjJo3yg5MY6qwHl77uROC0G1BAqJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQwXpRuWl5q4SvXPUSKOYxWzbEkc2nMZP3zhrp+/deI/Fjp/kzs3FCUfUIBg363QSOvheS3Z5JRf8g1OBNGW7wCYrf5Q1ipjbEhQAfBHHW9GFka5dCKgVD8IoTGJOzFpNv6EGHDxKqzML/KfDHgjzFNF6fsTr/6ksCwn/HTYijo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVNCeclN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVNCeclN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E368C4CEEA;
	Mon, 23 Jun 2025 22:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716617;
	bh=DaMm2dNahzbWe8RjJo3yg5MY6qwHl77uROC0G1BAqJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVNCeclNnoQ3cekMCFP23r/FzJX28AcZ0fOYCXaV0l/Mai+TJuHzZwPQSZsLTpYwZ
	 HwT9L9u/ZL+e2CziiYQ3zvsgJ38R9FkkQio4Dyio1VWDshu1RCsfa8JpPldLynuzK0
	 M5VN7kfs2/6M5hVeXCcpTPFi0ZSVAlsKHoSdbaNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David.Kaplan@amd.com,
	peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com,
	mingo@kernel.org,
	brad.spengler@opensrcsec.com,
	Salvatore Bonaccorso <carnil@debian.org>,
	Breno Leitao <leitao@debian.org>
Subject: [PATCH 5.15 345/411] Revert "x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2" on v6.6 and older
Date: Mon, 23 Jun 2025 15:08:09 +0200
Message-ID: <20250623130642.332564164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

This reverts commit 4fc2d289b3cc4cf23ccabe59cf936d1dc49aeda8 which is
commit 98fdaeb296f51ef08e727a7cc72e5b5c864c4f4d upstream.

commit 7adb96687ce8 ("x86/bugs: Make spectre user default depend on
MITIGATION_SPECTRE_V2") depends on commit 72c70f480a70 ("x86/bugs: Add
a separate config for Spectre V2"), which introduced
MITIGATION_SPECTRE_V2.

commit 72c70f480a70 ("x86/bugs: Add a separate config for Spectre V2")
never landed in stable tree, thus, stable tree doesn't have
MITIGATION_SPECTRE_V2, that said, commit 7adb96687ce8 ("x86/bugs: Make
spectre user default depend on MITIGATION_SPECTRE_V2") has no value if
the dependecy was not applied.

Revert commit 7adb96687ce8 ("x86/bugs: Make spectre user default
depend on MITIGATION_SPECTRE_V2")  in stable kernel which landed in in
5.4.294, 5.10.238, 5.15.185, 6.1.141 and 6.6.93 stable versions.

Cc: David.Kaplan@amd.com
Cc: peterz@infradead.org
Cc: pawan.kumar.gupta@linux.intel.com
Cc: mingo@kernel.org
Cc: brad.spengler@opensrcsec.com
Cc: stable@vger.kernel.org # 6.6 6.1 5.15 5.10 5.4
Reported-by: Brad Spengler <brad.spengler@opensrcsec.com>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    2 --
 arch/x86/kernel/cpu/bugs.c                      |   10 +++-------
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5445,8 +5445,6 @@
 
 			Selecting 'on' will also enable the mitigation
 			against user space to user space task attacks.
-			Selecting specific mitigation does not force enable
-			user mitigations.
 
 			Selecting 'off' will disable both the kernel and
 			the user space protections.
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1382,13 +1382,9 @@ static __ro_after_init enum spectre_v2_m
 static enum spectre_v2_user_cmd __init
 spectre_v2_parse_user_cmdline(void)
 {
-	enum spectre_v2_user_cmd mode;
 	char arg[20];
 	int ret, i;
 
-	mode = IS_ENABLED(CONFIG_MITIGATION_SPECTRE_V2) ?
-		SPECTRE_V2_USER_CMD_AUTO : SPECTRE_V2_USER_CMD_NONE;
-
 	switch (spectre_v2_cmd) {
 	case SPECTRE_V2_CMD_NONE:
 		return SPECTRE_V2_USER_CMD_NONE;
@@ -1401,7 +1397,7 @@ spectre_v2_parse_user_cmdline(void)
 	ret = cmdline_find_option(boot_command_line, "spectre_v2_user",
 				  arg, sizeof(arg));
 	if (ret < 0)
-		return mode;
+		return SPECTRE_V2_USER_CMD_AUTO;
 
 	for (i = 0; i < ARRAY_SIZE(v2_user_options); i++) {
 		if (match_option(arg, ret, v2_user_options[i].option)) {
@@ -1411,8 +1407,8 @@ spectre_v2_parse_user_cmdline(void)
 		}
 	}
 
-	pr_err("Unknown user space protection option (%s). Switching to default\n", arg);
-	return mode;
+	pr_err("Unknown user space protection option (%s). Switching to AUTO select\n", arg);
+	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
 static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)


