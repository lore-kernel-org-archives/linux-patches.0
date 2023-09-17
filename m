Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28278746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54489C433C9;
	Sun, 17 Sep 2023 20:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982977;
	bh=TnoWbkCoHTnrv3zurFweO+Q//jb2J0gbQXHxJBn8mU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8YOrvrKfbOFDYXNDYSrYc0TNE477qGiCk1+7sE0SkCi7w8lFo6lU7xPkJCe9QWk2
	 PqK6HKXPbyclAbs+KAe6r+VgooRNkErmc62R9ZDFThbB5GzP80PESjBhqIpQ7wo3oi
	 L8P2Bm00FxLRrHkHH0XBqwOEE1w+2Y5a2EuVEHgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 407/511] kbuild: do not run depmod for make modules_sign
Date: Sun, 17 Sep 2023 21:13:54 +0200
Message-ID: <20230917191123.616355821@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 2429742e506a2b5939a62c629c4a46d91df0ada8 ]

Commit 961ab4a3cd66 ("kbuild: merge scripts/Makefile.modsign to
scripts/Makefile.modinst") started to run depmod at the end of
'make modules_sign'.

Move the depmod rule to scripts/Makefile.modinst and run it only when
$(modules_sign_only) is empty.

Fixes: 961ab4a3cd66 ("kbuild: merge scripts/Makefile.modsign to scripts/Makefile.modinst")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 1f537b7286b5f..52baf426dcea5 100644
--- a/Makefile
+++ b/Makefile
@@ -1835,7 +1835,9 @@ quiet_cmd_depmod = DEPMOD  $(MODLIB)
 
 modules_install:
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
+ifndef modules_sign_only
 	$(call cmd,depmod)
+endif
 
 else # CONFIG_MODULES
 
-- 
2.40.1



