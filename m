Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1913219A29C;
	Thu, 25 Jul 2024 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918508; cv=none; b=ZOBTklo9bNlsARhBypkL7bf5ywKSMTNti+IMi5E09n52SgwhxU7uOSE7xP/8fP94O83SIIgyfLk9VjHv3yGMpyeMBMcsJOwUhFULxLpp0s5t1LMD0dH3EQx0RM4MPc2yKtPPIrrzIZtX6JTHjKrzXvxZhSVhnSG00CIendLkN4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918508; c=relaxed/simple;
	bh=dzVBhccvp0hU0+Ir7A9lbv+vH5/lOzD+6wiLDbQnmDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtaCd0hDUqaD+DyWZLTUXT1G48rT+kdDm0t3h8e/sCR8isa+mRE1ocOw8D/sFPVUKVpN9CoUVCxFGzbF2uIFD9RDxOxwVQz5w2recPTQhObbGEAoYmVu4xmV44PxoDZIpBBxQggi4ArXYatnASxwu0nQKQDmVp7N4ux1Gc0Jd28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moVKY3wS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moVKY3wS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3BCC116B1;
	Thu, 25 Jul 2024 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918507;
	bh=dzVBhccvp0hU0+Ir7A9lbv+vH5/lOzD+6wiLDbQnmDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moVKY3wSTVvexUDOupdj3Ic58xjzLBnY6GR1aBVJJD52T7jo8LuJT40oKgJOsHJP5
	 dXYZ35VRIK8otn+KRrPmPx234QWUNRsOlQ727nsMkW2jXqtJ0Eu10zFfaIv2eI1whu
	 lbL0a420hB8mkirG/rovoIgbdQ9V6z5IdLT5nQY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/33] kconfig: gconf: give a proper initial state to the Save button
Date: Thu, 25 Jul 2024 16:36:32 +0200
Message-ID: <20240725142728.873711772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 46edf4372e336ef3a61c3126e49518099d2e2e6d ]

Currently, the initial state of the "Save" button is always active.

If none of the CONFIG options are changed while loading the .config
file, the "Save" button should be greyed out.

This can be fixed by calling conf_read() after widget initialization.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/gconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 36f578415c4a6..5e0ea015394e9 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1485,7 +1485,6 @@ int main(int ac, char *av[])
 
 	conf_parse(name);
 	fixup_rootmenu(&rootmenu);
-	conf_read(NULL);
 
 	/* Load the interface and connect signals */
 	init_main_window(glade_file);
@@ -1493,6 +1492,8 @@ int main(int ac, char *av[])
 	init_left_tree();
 	init_right_tree();
 
+	conf_read(NULL);
+
 	switch (view_mode) {
 	case SINGLE_VIEW:
 		display_tree_part();
-- 
2.43.0



