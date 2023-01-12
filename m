Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A60279C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF67C433EF;
	Thu, 12 Jan 2023 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533395;
	bh=buHHJ69xvIOb5YrhxJ/UygH6NyR9N8Csyq2SaINp9DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2y+iIfzVojH8Qp/lRJOw3g8SDWmqi60ZroP9rYVBEDub+DU6BworUTW5Oqrk26c+
	 mmbpvjUjqlivt0efG/9Zm4RxocHQgZeA7tSNZR2yHcvzQMJTRgPHT5bc9pSEacqxNF
	 v4XhNJ376lCOkyMs5XRGhqWl3hF5/KJaTomna1Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 437/783] kbuild: remove unneeded mkdir for external modules_install
Date: Thu, 12 Jan 2023 14:52:33 +0100
Message-Id: <20230112135544.551230621@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 4b97ec0e9cfd5995f41b9726c88566a31f4625cc ]

scripts/Makefile.modinst creates directories as needed.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: c7b98de745cf ("phy: qcom-qmp-combo: fix runtime suspend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Makefile b/Makefile
index 68f8efa0cc30..9be2a818d4d7 100644
--- a/Makefile
+++ b/Makefile
@@ -1746,10 +1746,8 @@ $(MODORDER): descend
 PHONY += modules_install
 modules_install: _emodinst_ _emodinst_post
 
-install-dir := $(if $(INSTALL_MOD_DIR),$(INSTALL_MOD_DIR),extra)
 PHONY += _emodinst_
 _emodinst_:
-	$(Q)mkdir -p $(MODLIB)/$(install-dir)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 PHONY += _emodinst_post
-- 
2.35.1



