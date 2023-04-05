Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6568B79CC;
	Wed,  5 Apr 2023 20:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F30CC433EF;
	Wed,  5 Apr 2023 20:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680727481;
	bh=HM42jy9mV3T5mKNjxd6eAXa1sP1hyHMBCh9v69nIN2o=;
	h=From:Date:Subject:To:Cc:From;
	b=j2D5zuYKWtCpeuSPAei2jXjEslYrj3lg/aswR2lOlTM6Z2kDVMLJVyQvuDEFEP3Qj
	 WqdAUqMvoHdyyoiOXv7DszWJY2GFqv8yokJCKKXOgTQCydbGXzV5ptb11xjrnAM3/j
	 8dFPWrsbPxU9jeiOBVbJuPUtKsCECYu5tu4S6nVv30ZHntN8m/H8PNrhiCRBSIRdh/
	 uYeENdBK0vRBBivPCAOBWpaeZkUkOtgStMqXdJvPatVP0i3kbj4L8c6kDr6hthYjev
	 KxCwU6cL8WnxJPFt0Z2/pFiW7hM14DgIXCMhLpTrC7Dsq3osoqdLGhjXJ/GOAK5d9L
	 83gOGGqwwT8kw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 05 Apr 2023 13:44:28 -0700
Subject: [PATCH] Documentation/llvm: Add a note about prebuilt kernel.org
 toolchains
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-korg-llvm-tc-docs-v1-1-420849b2e025@kernel.org>
X-B4-Tracking: v=1; b=H4sIAKvdLWQC/x2NywqDMBAAf0X23IX4gtBfKT0k61aXalJ2RQTx3
 409DsMwBxirsMGzOkB5E5OcCtSPCmgKaWSUoTA0rmld53r8Zh1xnrcFV8Ihk6HvimHv60g9lC4
 GY4waEk13uQRbWW/xU/7I/p+93ud5AXmHlOd8AAAA
To: ndesaulniers@google.com, masahiroy@kernel.org, corbet@lwn.net
Cc: arnd@arndb.de, keescook@chromium.org, trix@redhat.com, 
 nicolas@fjasle.eu, llvm@lists.linux.dev, patches@lists.linux.dev, 
 linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310; i=nathan@kernel.org;
 h=from:subject:message-id; bh=HM42jy9mV3T5mKNjxd6eAXa1sP1hyHMBCh9v69nIN2o=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCm6d3dYvz4csqOw7/VmxV3L/3T11B4TXONVE6ixyCX3/
 rdHHEEMHaUsDGIcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAibDWMDK+LP29i87qio3L3
 R9KshWE/ws3ePN1wujNId1rnmq1/tu1hZGiQO7IsS/zBROcLhVZTVbM2h5yyS+64JXiB9+olQQb
 nMn4A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

I recently started uploading prebuilt stable versions of LLVM to
kernel.org, which should make building the kernel with LLVM more
accessible to maintainers and developers. Link them in the LLVM
documentation to make this more visible.

Link: https://lore.kernel.org/20230319235619.GA18547@dev-arch.thelio-3990X/
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 Documentation/kbuild/llvm.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/kbuild/llvm.rst b/Documentation/kbuild/llvm.rst
index bfb51685073c..3e1f67b05ca6 100644
--- a/Documentation/kbuild/llvm.rst
+++ b/Documentation/kbuild/llvm.rst
@@ -171,6 +171,10 @@ Getting Help
 Getting LLVM
 -------------
 
+We provide prebuilt stable versions of LLVM on `kernel.org <https://kernel.org/pub/tools/llvm/>`_.
+Below are links that may be useful for building LLVM from source or procurring
+it through a distribution's package manager.
+
 - https://releases.llvm.org/download.html
 - https://github.com/llvm/llvm-project
 - https://llvm.org/docs/GettingStarted.html

---
base-commit: 7e364e56293bb98cae1b55fd835f5991c4e96e7d
change-id: 20230405-korg-llvm-tc-docs-84304e881bc5

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

