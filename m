Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88FA70838;
	Mon, 23 Jun 2025 21:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713067; cv=none; b=HZLJrMNb4iSAkD8S0ez1Cxc3MkFiWJ3qu5ZgzZlt8ICkH1aE0AZhWEfogO+jF19Jl3INjRiYnmmCW9HAFon0PLYRD0adLkkLjTFQIWTQf9I2hA/+ysA3KSs3HmmuK9Edh/I31cPFR1LLvhxU7+Zgh3gBKC3BGx6X5ux/36eScys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713067; c=relaxed/simple;
	bh=ysnfIRYWTRJ/f198VDn/eIf6JjWN9AFPm4w1WEdMhtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTGBImp/HppmSwvLuSGVWynWIXI5f7iUXF2ByF4UliBSSCznnLV+OzNguPkmAj6KMGHbLMwDa06NZ4QGK11QMr8sTmb7CPEA4OVzhSV4lbDlFxQySzRJ+kpTfL9Wxo0pIlub7L/VSUfAd/VzefoGbnHvKzei1w8B/CNvOdmXLQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbcqU3en; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbcqU3en"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8028FC4CEEA;
	Mon, 23 Jun 2025 21:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713066;
	bh=ysnfIRYWTRJ/f198VDn/eIf6JjWN9AFPm4w1WEdMhtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbcqU3ennCIp/Vt16w9FWubVQbUFJmgjB3ClNfl9w80ekcpVDtO0K45GAGejNpIrm
	 RkOELQA7CRocWzPQFB9pHUrO3QTPPH7aEtKw3wuyc7KswMmLIlI7YVPZ0SHJfyLGHS
	 jk121QC5K5iMSJf213MdfSrnV5XbmgyJPywauPYw=
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
Subject: [PATCH 5.4 186/222] Revert "x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2" on v6.6 and older
Date: Mon, 23 Jun 2025 15:08:41 +0200
Message-ID: <20250623130617.764643710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

This reverts commit a8c22ec36cdd99c1002d7152f859798fef7c4d58 which is
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
@@ -4600,8 +4600,6 @@
 
 			Selecting 'on' will also enable the mitigation
 			against user space to user space task attacks.
-			Selecting specific mitigation does not force enable
-			user mitigations.
 
 			Selecting 'off' will disable both the kernel and
 			the user space protections.
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1050,13 +1050,9 @@ static __ro_after_init enum spectre_v2_m
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
@@ -1069,7 +1065,7 @@ spectre_v2_parse_user_cmdline(void)
 	ret = cmdline_find_option(boot_command_line, "spectre_v2_user",
 				  arg, sizeof(arg));
 	if (ret < 0)
-		return mode;
+		return SPECTRE_V2_USER_CMD_AUTO;
 
 	for (i = 0; i < ARRAY_SIZE(v2_user_options); i++) {
 		if (match_option(arg, ret, v2_user_options[i].option)) {
@@ -1079,8 +1075,8 @@ spectre_v2_parse_user_cmdline(void)
 		}
 	}
 
-	pr_err("Unknown user space protection option (%s). Switching to default\n", arg);
-	return mode;
+	pr_err("Unknown user space protection option (%s). Switching to AUTO select\n", arg);
+	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
 static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)


