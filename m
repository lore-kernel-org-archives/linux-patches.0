Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2995A7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D8CC433C7;
	Sun, 17 Sep 2023 20:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981202;
	bh=QetLoVC385ghN+/3EMSjnvyeY1CFQLcCKZTt7xQT69I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrRgyjCOHaUkE7KRfxeE9tmslUcv0GLspyu0+TGVpEOAUxSgZQHU/UaUYKfuy+ZZf
	 7LusWE2Jj9BvEea79mEQyIVtkkhY2UxOkfKeHudzo+JwRyCZ5AazqrEfRX/mrY7K7K
	 P04YYtZiEYmpojvBkTkA6PfNGmFQRlPcPUUwsES0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/219] kbuild: do not run depmod for make modules_sign
Date: Sun, 17 Sep 2023 21:13:04 +0200
Message-ID: <20230917191043.073374017@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 35fc0d62898dc..f23edaa0e8139 100644
--- a/Makefile
+++ b/Makefile
@@ -1939,7 +1939,9 @@ quiet_cmd_depmod = DEPMOD  $(MODLIB)
 
 modules_install:
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
+ifndef modules_sign_only
 	$(call cmd,depmod)
+endif
 
 else # CONFIG_MODULES
 
-- 
2.40.1



