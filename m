Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C07F2192EC;
	Mon, 23 Jun 2025 22:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717499; cv=none; b=tRA59KiOQ9PyJ5MuLHzbYtdYpI+CyfNnXSbr1HjYcqZpfirmo1pcZvz0LMB+tX4jVjQpUIOSzECfgvfF+rPshILl3xtDEw8cxJWmEeOcvegsjaxUm7jC/UmempOGANqoQOl2oWJU7ZgBw6rWQ6GtVQwtJn9CmWWfI8h6MDPsPwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717499; c=relaxed/simple;
	bh=/cjzVSyt2rp4FEeyAuEIlnFm8aZPWs0c6A4EOEPE8KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbolrlysjFZgTjmWb9jnV8UtIXgajcNZ/hYYDFAClPoJHaM8YTiZFT/oAXIoTrlOaVWQhoTWtNuWMTJaD+mYac+yTtRVsWHKFWN3Nq7kHn2+xjlAZUqz5mVvwcwHBmZ4xH168x4mECCfXlFsl/E90Sf5Y8yrLDQ9J4SFPbCZ5oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/5/qaWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/5/qaWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E74C4CEEA;
	Mon, 23 Jun 2025 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717499;
	bh=/cjzVSyt2rp4FEeyAuEIlnFm8aZPWs0c6A4EOEPE8KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/5/qaWaghkaIuvn6t3NpTt5qI/gCSAiEgBSwbk1zZzbW52nJY1MuPCdhU3oo4KQk
	 YwDGB5YMEgd6NwUkGDHgvuCbWk/DORGtaQrzovN8Udh0Vnc81eXPhgciDm8qKaz2xl
	 /E+ikIHCNPGWOM/dvbvNqK47vGZYp5EwBItilFJA=
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
Subject: [PATCH 6.1 441/508] Revert "x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2" on v6.6 and older
Date: Mon, 23 Jun 2025 15:08:06 +0200
Message-ID: <20250623130656.013077168@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

This reverts commit 594dbf0a19d607f106ed552332b9b8fecd2b64a3 which is
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
@@ -5780,8 +5780,6 @@
 
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


