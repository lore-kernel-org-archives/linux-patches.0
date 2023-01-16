Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03376FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388A4C433D2;
	Mon, 16 Jan 2023 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889192;
	bh=6s2Tb3eHH6LLYT7Fut/hhoaprggUaScGwRqF1wzu1jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNAicm7W151WRjk4BADUGgHbAnAhsplYnsDarJVP41g1HL1WtICHZX8eGnpgdNp/O
	 3PoX6Kob04oxWVNYnjO7AviK0MrHCDWS4ngaTfje0IJV9fEyhcS2BjQWEzdd1Yq53l
	 hceKWzdwrxi4yd+k+Cgec1w/lNNQ+0JE2fWHg08Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 4.14 276/338] selftests: Use optional USERCFLAGS and USERLDFLAGS
Date: Mon, 16 Jan 2023 16:52:29 +0100
Message-Id: <20230116154833.111828948@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
@@ -103,6 +103,11 @@ endef
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


