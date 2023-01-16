Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BEA46B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE256C433EF;
	Mon, 16 Jan 2023 16:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886670;
	bh=W5NGfxoJwuCFZ8PaPL+/+vrjZDBNkqfoseKUAUk97wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOxtuuKyEJKBIfrxQIC8p4rI4EnC+UPuv3H77rHxe3HYBZdmZwgu2VkCuuMztj5ux
	 30917nba6QomlIt/Gi87jt+ZHdAuFVVIgIM1/7Qr/K4hERKB9rccEDNAM19FNwY8sT
	 ItSyYf/loEZ/m6Ob4NyUKYnLelGkvGVvB8iNfRmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.4 487/658] selftests: Use optional USERCFLAGS and USERLDFLAGS
Date: Mon, 16 Jan 2023 16:49:35 +0100
Message-Id: <20230116154931.801269901@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mickaël Salaün <mic@digikod.net>

commit de3ee3f63400a23954e7c1ad1cb8c20f29ab6fe3 upstream.

This change enables to extend CFLAGS and LDFLAGS from command line, e.g.
to extend compiler checks: make USERCFLAGS=-Werror USERLDFLAGS=-static

USERCFLAGS and USERLDFLAGS are documented in
Documentation/kbuild/makefiles.rst and Documentation/kbuild/kbuild.rst

This should be backported (down to 5.10) to improve previous kernel
versions testing as well.

Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20220909103901.1503436-1-mic@digikod.net
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/lib.mk |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -130,6 +130,11 @@ endef
 clean:
 	$(CLEAN)
 
+# Enables to extend CFLAGS and LDFLAGS from command line, e.g.
+# make USERCFLAGS=-Werror USERLDFLAGS=-static
+CFLAGS += $(USERCFLAGS)
+LDFLAGS += $(USERLDFLAGS)
+
 # When make O= with kselftest target from main level
 # the following aren't defined.
 #


