Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6348F1B81DC;
	Mon,  2 Jun 2025 14:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874751; cv=none; b=f8NjT/fZU4RZWCK70OjwLioWnuEYt0UM/pUJtd+BKzljYUpxYMm3dnAxyS4OHefrfLquD5bq8/E7pOdUkjQq59qWYROLonBmMMNtlAq2/KFWWVHEB4HqUAE2LdzFokxdPGwP5LsWZ3IAjpDv0TIgHV/OuEi0o8XHZuJmmMdqQhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874751; c=relaxed/simple;
	bh=BT+4XXyfhdTgyDliQ8NOrC5M+VVxwuDK9mbrh14bO8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+CPfRlRoO6pBRUTezRSNK8D9CxtzPK6jA4MbXmoMZ+O59wlPTuokEjUqjapSfbe81E+iuK8kKAmA4i0YbKjzae0J8M+UxkGbxgSJ3xX1m9uT1i+K2/J/0Ay4NDGmIZocr6CDkE/8M2WFHhqznAuyRtv+s3SnNaZOuZvMTZrpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXINV/0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXINV/0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282ADC4CEEB;
	Mon,  2 Jun 2025 14:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874750;
	bh=BT+4XXyfhdTgyDliQ8NOrC5M+VVxwuDK9mbrh14bO8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXINV/0xlQ0TZNTz83J7/aHQtTU10FtMycJiQvzNCxC5VisdAWncPAO7GESbaCR+J
	 0Wcyo93jfrOyH1GahbKZjeGbyN747Jf45V8sBOnu+UsDQNxt4kHX5f/Gi3J7TOGINf
	 qSFW5jtA7yM6gE5XRTZ9f+vMDNIIdaNduM9mczeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ingo Molnar <mingo@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	David Kaplan <David.Kaplan@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/204] x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2
Date: Mon,  2 Jun 2025 15:47:37 +0200
Message-ID: <20250602134300.520704883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 98fdaeb296f51ef08e727a7cc72e5b5c864c4f4d ]

Change the default value of spectre v2 in user mode to respect the
CONFIG_MITIGATION_SPECTRE_V2 config option.

Currently, user mode spectre v2 is set to auto
(SPECTRE_V2_USER_CMD_AUTO) by default, even if
CONFIG_MITIGATION_SPECTRE_V2 is disabled.

Set the spectre_v2 value to auto (SPECTRE_V2_USER_CMD_AUTO) if the
Spectre v2 config (CONFIG_MITIGATION_SPECTRE_V2) is enabled, otherwise
set the value to none (SPECTRE_V2_USER_CMD_NONE).

Important to say the command line argument "spectre_v2_user" overwrites
the default value in both cases.

When CONFIG_MITIGATION_SPECTRE_V2 is not set, users have the flexibility
to opt-in for specific mitigations independently. In this scenario,
setting spectre_v2= will not enable spectre_v2_user=, and command line
options spectre_v2_user and spectre_v2 are independent when
CONFIG_MITIGATION_SPECTRE_V2=n.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Kaplan <David.Kaplan@amd.com>
Link: https://lore.kernel.org/r/20241031-x86_bugs_last_v2-v2-2-b7ff1dab840e@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  2 ++
 arch/x86/kernel/cpu/bugs.c                      | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9975dcab99c35..6d9acc3f977b3 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4600,6 +4600,8 @@
 
 			Selecting 'on' will also enable the mitigation
 			against user space to user space task attacks.
+			Selecting specific mitigation does not force enable
+			user mitigations.
 
 			Selecting 'off' will disable both the kernel and
 			the user space protections.
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4f803aed2ef0e..0f523ebfbabf6 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1050,9 +1050,13 @@ static __ro_after_init enum spectre_v2_mitigation_cmd spectre_v2_cmd;
 static enum spectre_v2_user_cmd __init
 spectre_v2_parse_user_cmdline(void)
 {
+	enum spectre_v2_user_cmd mode;
 	char arg[20];
 	int ret, i;
 
+	mode = IS_ENABLED(CONFIG_MITIGATION_SPECTRE_V2) ?
+		SPECTRE_V2_USER_CMD_AUTO : SPECTRE_V2_USER_CMD_NONE;
+
 	switch (spectre_v2_cmd) {
 	case SPECTRE_V2_CMD_NONE:
 		return SPECTRE_V2_USER_CMD_NONE;
@@ -1065,7 +1069,7 @@ spectre_v2_parse_user_cmdline(void)
 	ret = cmdline_find_option(boot_command_line, "spectre_v2_user",
 				  arg, sizeof(arg));
 	if (ret < 0)
-		return SPECTRE_V2_USER_CMD_AUTO;
+		return mode;
 
 	for (i = 0; i < ARRAY_SIZE(v2_user_options); i++) {
 		if (match_option(arg, ret, v2_user_options[i].option)) {
@@ -1075,8 +1079,8 @@ spectre_v2_parse_user_cmdline(void)
 		}
 	}
 
-	pr_err("Unknown user space protection option (%s). Switching to AUTO select\n", arg);
-	return SPECTRE_V2_USER_CMD_AUTO;
+	pr_err("Unknown user space protection option (%s). Switching to default\n", arg);
+	return mode;
 }
 
 static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
-- 
2.39.5



