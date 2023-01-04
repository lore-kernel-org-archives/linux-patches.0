Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7C2AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BC3C433D2;
	Wed,  4 Jan 2023 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848868;
	bh=CUwc3TW7fPW6dLhAhrnG5WSaRE9Ls/lIViyVbBw5HFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBt4Oe1jPuzXocX/GUT27Xltb+06Eud+tYTpa8Hcm/5U79jS5uY2DmlKrIiwECFqo
	 wUIVYjxueKcTNgHm+MCMS2iUEMi+h96MtEfWr7tXuLIHvd5JcuuWEot/CpD+7Dldde
	 UCe6KxdMKMguI1ck+vYi1NWMDbge8T9rf30phwc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.0 027/177] selftests: Use optional USERCFLAGS and USERLDFLAGS
Date: Wed,  4 Jan 2023 17:05:18 +0100
Message-Id: <20230104160508.488464558@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -123,6 +123,11 @@ endef
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


