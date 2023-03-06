Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658746FC5
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 19:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE2CC433D2;
	Mon,  6 Mar 2023 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678130242;
	bh=olF9iig+Tpza7YeougL8cnA1Y7s1DLREILbJ3Du94yo=;
	h=From:To:Cc:Subject:Date:From;
	b=r77Ongm6OktSZOy/HZAQKKcEEa2lo7ZzYUO0sDrbYFjsurv2KCBRMD2/oaMycATbF
	 sAdSaEv6FM7P3RW6Yfk7B8+4qR/92XzVB5GjVGLXG6ar3u7Rx2y8P6ptpxedTTmNXw
	 /KqhyCW4up7XqROrhUFqjNJ05gwKQXXobpn1PXxJP5utsF0anaP5u4Jn3pT0SUqF3a
	 YlsVDyq4QE8cHlF0XSLfrMvq8uGbn246PN6cmhM59wYUdlcIKK/R6YOYU8g26CMccA
	 0SrvEZajzXzIPmMIaaTsVMJ5aBc6gMTjLcDIvJMxmn/jKYcZML85uatTyxL5oegUx8
	 QWplAtyeQAVOw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 1/2] docs: programming-language: remove mention of the Intel compiler
Date: Mon,  6 Mar 2023 20:17:11 +0100
Message-Id: <20230306191712.230658-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Intel compiler support has been removed in commit 95207db8166a
("Remove Intel compiler support").

Thus remove its mention in the Documentation too.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/process/programming-language.rst | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/process/programming-language.rst b/Documentation/process/programming-language.rst
index 5fc9160ca1fa..10dc772671d8 100644
--- a/Documentation/process/programming-language.rst
+++ b/Documentation/process/programming-language.rst
@@ -12,10 +12,6 @@ under ``-std=gnu11`` [gcc-c-dialect-options]_: the GNU dialect of ISO C11.
 This dialect contains many extensions to the language [gnu-extensions]_,
 and many of them are used within the kernel as a matter of course.
 
-There is some support for compiling the kernel with ``icc`` [icc]_ for several
-of the architectures, although at the time of writing it is not completed,
-requiring third-party patches.
-
 Attributes
 ----------
 
@@ -38,7 +34,6 @@ Please refer to ``include/linux/compiler_attributes.h`` for more information.
 .. [c-language] http://www.open-std.org/jtc1/sc22/wg14/www/standards
 .. [gcc] https://gcc.gnu.org
 .. [clang] https://clang.llvm.org
-.. [icc] https://software.intel.com/en-us/c-compilers
 .. [gcc-c-dialect-options] https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html
 .. [gnu-extensions] https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
 .. [gcc-attribute-syntax] https://gcc.gnu.org/onlinedocs/gcc/Attribute-Syntax.html

base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
-- 
2.39.2

