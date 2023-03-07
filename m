Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD354BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A08C433EF;
	Tue,  7 Mar 2023 18:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213097;
	bh=I46RAPOT1C6yO8uEpNetw6qOsclVEkCPFiZUDGa4KBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vtqtwOS+GWVWWSe33Qrfg/BW7BPG/RrHYxQraTDVoPeIHDGvMKbmbBKKNA3nNGnd
	 ERvTNOE6mnvh6mH2PlDMFstf/pli+CAKqM2X0GJkZQAH+z71azgY1J/ejpyS1bMdE1
	 AJ99yqkSVr8eiH4mtQf7/UYLJhJ56whnoyQaEqmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	David Laight <David.Laight@ACULAB.COM>,
	Guillaume Tucker <guillaume.tucker@collabora.com>,
	Guenter Roeck <groeck@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 397/885] selftests: use printf instead of echo -ne
Date: Tue,  7 Mar 2023 17:55:31 +0100
Message-Id: <20230307170019.644662732@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Tucker <guillaume.tucker@collabora.com>

[ Upstream commit 9e34fad00fc889abbb99d751a4c22cf2bded10df ]

Rather than trying to guess which implementation of "echo" to run with
support for "-ne" options, use "printf" instead of "echo -ne".  It
handles escape characters as a standard feature and it is widespread
among modern shells.

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Fixes: 3297a4df805d ("kselftests: Enable the echo command to print newlines in Makefile")
Fixes: 79c16b1120fe ("selftests: find echo binary to use -ne options")
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 253596a1cb69c..aae64eb2ae737 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -231,11 +231,10 @@ ifdef INSTALL_PATH
 	@# While building kselftest-list.text skip also non-existent TARGET dirs:
 	@# they could be the result of a build failure and should NOT be
 	@# included in the generated runlist.
-	ECHO=`which echo`; \
 	for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
-		[ ! -d $(INSTALL_PATH)/$$TARGET ] && $$ECHO "Skipping non-existent dir: $$TARGET" && continue; \
-		$$ECHO -ne "Emit Tests for $$TARGET\n"; \
+		[ ! -d $(INSTALL_PATH)/$$TARGET ] && printf "Skipping non-existent dir: $$TARGET\n" && continue; \
+		printf "Emit Tests for $$TARGET\n"; \
 		$(MAKE) -s --no-print-directory OUTPUT=$$BUILD_TARGET COLLECTION=$$TARGET \
 			-C $$TARGET emit_tests >> $(TEST_LIST); \
 	done;
-- 
2.39.2



