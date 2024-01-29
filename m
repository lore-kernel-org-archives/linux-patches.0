Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5731115956B;
	Mon, 29 Jan 2024 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548426; cv=none; b=a02xVtDr2n02VkBjWX9j+wQeW+e4LW+HcFni4zvoE2k/sfZkJsX+MdnS/hUMvv3hfYrpkYxWtYeoV2AQ5pvSD55w3bRDL5/gj+mt802ccwK+4idTMXRnYpNx1/GpWz0c2A+01s17iGsy2YAiNJw8t4MFKYaZlMbKTLVwmRCZZng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548426; c=relaxed/simple;
	bh=RjD7y2An6aAy9zLU9VL0JuXLbSCMMk28Ury3AfzeLd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzTkW1ma7jN7ZpMKhsrw2dbzocTTBYdKZRM1vOXz3alWUSZUvc9wd1gBoAGfTYSBKluzRYEy3HKjMrS0+qLgph+XrFr9DV6143Mlw50fWtTYA/t+mPlkXgrrYVivgqjnbffabHtQvn1IPoWs4ZvQufsSKWo+P99Og62BaOTSWh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIF7xxfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIF7xxfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B5CC43390;
	Mon, 29 Jan 2024 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548426;
	bh=RjD7y2An6aAy9zLU9VL0JuXLbSCMMk28Ury3AfzeLd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIF7xxfs6PKPQOhkV3emDq76l1nIAX3n4w4G5A9+UgLu/PZWQXVaZn1wAnkF0HD4E
	 5ApHe0H0XRnimTVgH8ABN7GFICdvUwrKPB9Qu7dQsfm+ivb0WcePiRC53bFlcokSPx
	 ys58S0rcLOQ/4pzT3W/cPZawyDhNQ4Hv18UnX2zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command injection
Date: Mon, 29 Jan 2024 09:01:07 -0800
Message-ID: <20240129170015.067909940@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vegard Nossum <vegard.nossum@oracle.com>

[ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]

The kernel-feat directive passes its argument straight to the shell.
This is unfortunate and unnecessary.

Let's always use paths relative to $srctree/Documentation/ and use
subprocess.check_call() instead of subprocess.Popen(shell=True).

This also makes the code shorter.

This is analogous to commit 3231dd586277 ("docs: kernel_abi.py: fix
command injection") where we did exactly the same thing for
kernel_abi.py, somehow I completely missed this one.

Link: https://fosstodon.org/@jani/111676532203641247
Reported-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20240110174758.3680506-1-vegard.nossum@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/features.rst        |  2 +-
 Documentation/arch/arc/features.rst           |  2 +-
 Documentation/arch/arm/features.rst           |  2 +-
 Documentation/arch/arm64/features.rst         |  2 +-
 Documentation/arch/loongarch/features.rst     |  2 +-
 Documentation/arch/m68k/features.rst          |  2 +-
 Documentation/arch/mips/features.rst          |  2 +-
 Documentation/arch/nios2/features.rst         |  2 +-
 Documentation/arch/openrisc/features.rst      |  2 +-
 Documentation/arch/parisc/features.rst        |  2 +-
 Documentation/arch/s390/features.rst          |  2 +-
 Documentation/arch/sh/features.rst            |  2 +-
 Documentation/arch/sparc/features.rst         |  2 +-
 Documentation/arch/x86/features.rst           |  2 +-
 Documentation/arch/xtensa/features.rst        |  2 +-
 Documentation/powerpc/features.rst            |  2 +-
 Documentation/riscv/features.rst              |  2 +-
 Documentation/sphinx/kernel_feat.py           | 55 ++++---------------
 .../zh_CN/arch/loongarch/features.rst         |  2 +-
 .../translations/zh_CN/arch/mips/features.rst |  2 +-
 20 files changed, 30 insertions(+), 63 deletions(-)

diff --git a/Documentation/admin-guide/features.rst b/Documentation/admin-guide/features.rst
index 8c167082a84f..7651eca38227 100644
--- a/Documentation/admin-guide/features.rst
+++ b/Documentation/admin-guide/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features
+.. kernel-feat:: features
diff --git a/Documentation/arch/arc/features.rst b/Documentation/arch/arc/features.rst
index b793583d688a..49ff446ff744 100644
--- a/Documentation/arch/arc/features.rst
+++ b/Documentation/arch/arc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features arc
+.. kernel-feat:: features arc
diff --git a/Documentation/arch/arm/features.rst b/Documentation/arch/arm/features.rst
index 7414ec03dd15..0e76aaf68eca 100644
--- a/Documentation/arch/arm/features.rst
+++ b/Documentation/arch/arm/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features arm
+.. kernel-feat:: features arm
diff --git a/Documentation/arch/arm64/features.rst b/Documentation/arch/arm64/features.rst
index dfa4cb3cd3ef..03321f4309d0 100644
--- a/Documentation/arch/arm64/features.rst
+++ b/Documentation/arch/arm64/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features arm64
+.. kernel-feat:: features arm64
diff --git a/Documentation/arch/loongarch/features.rst b/Documentation/arch/loongarch/features.rst
index ebacade3ea45..009f44c7951f 100644
--- a/Documentation/arch/loongarch/features.rst
+++ b/Documentation/arch/loongarch/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features loongarch
+.. kernel-feat:: features loongarch
diff --git a/Documentation/arch/m68k/features.rst b/Documentation/arch/m68k/features.rst
index 5107a2119472..de7f0ccf7fc8 100644
--- a/Documentation/arch/m68k/features.rst
+++ b/Documentation/arch/m68k/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features m68k
+.. kernel-feat:: features m68k
diff --git a/Documentation/arch/mips/features.rst b/Documentation/arch/mips/features.rst
index 1973d729b29a..6e0ffe3e7354 100644
--- a/Documentation/arch/mips/features.rst
+++ b/Documentation/arch/mips/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features mips
+.. kernel-feat:: features mips
diff --git a/Documentation/arch/nios2/features.rst b/Documentation/arch/nios2/features.rst
index 8449e63f69b2..89913810ccb5 100644
--- a/Documentation/arch/nios2/features.rst
+++ b/Documentation/arch/nios2/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features nios2
+.. kernel-feat:: features nios2
diff --git a/Documentation/arch/openrisc/features.rst b/Documentation/arch/openrisc/features.rst
index 3f7c40d219f2..bae2e25adfd6 100644
--- a/Documentation/arch/openrisc/features.rst
+++ b/Documentation/arch/openrisc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features openrisc
+.. kernel-feat:: features openrisc
diff --git a/Documentation/arch/parisc/features.rst b/Documentation/arch/parisc/features.rst
index 501d7c450037..b3aa4d243b93 100644
--- a/Documentation/arch/parisc/features.rst
+++ b/Documentation/arch/parisc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features parisc
+.. kernel-feat:: features parisc
diff --git a/Documentation/arch/s390/features.rst b/Documentation/arch/s390/features.rst
index 57c296a9d8f3..2883dc950681 100644
--- a/Documentation/arch/s390/features.rst
+++ b/Documentation/arch/s390/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features s390
+.. kernel-feat:: features s390
diff --git a/Documentation/arch/sh/features.rst b/Documentation/arch/sh/features.rst
index f722af3b6c99..fae48fe81e9b 100644
--- a/Documentation/arch/sh/features.rst
+++ b/Documentation/arch/sh/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features sh
+.. kernel-feat:: features sh
diff --git a/Documentation/arch/sparc/features.rst b/Documentation/arch/sparc/features.rst
index c0c92468b0fe..96835b6d598a 100644
--- a/Documentation/arch/sparc/features.rst
+++ b/Documentation/arch/sparc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features sparc
+.. kernel-feat:: features sparc
diff --git a/Documentation/arch/x86/features.rst b/Documentation/arch/x86/features.rst
index b663f15053ce..a33616346a38 100644
--- a/Documentation/arch/x86/features.rst
+++ b/Documentation/arch/x86/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features x86
+.. kernel-feat:: features x86
diff --git a/Documentation/arch/xtensa/features.rst b/Documentation/arch/xtensa/features.rst
index 6b92c7bfa19d..28dcce1759be 100644
--- a/Documentation/arch/xtensa/features.rst
+++ b/Documentation/arch/xtensa/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features xtensa
+.. kernel-feat:: features xtensa
diff --git a/Documentation/powerpc/features.rst b/Documentation/powerpc/features.rst
index aeae73df86b0..ee4b95e04202 100644
--- a/Documentation/powerpc/features.rst
+++ b/Documentation/powerpc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features powerpc
+.. kernel-feat:: features powerpc
diff --git a/Documentation/riscv/features.rst b/Documentation/riscv/features.rst
index c70ef6ac2368..36e90144adab 100644
--- a/Documentation/riscv/features.rst
+++ b/Documentation/riscv/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features riscv
+.. kernel-feat:: features riscv
diff --git a/Documentation/sphinx/kernel_feat.py b/Documentation/sphinx/kernel_feat.py
index 27b701ed3681..bdfaa3e4b202 100644
--- a/Documentation/sphinx/kernel_feat.py
+++ b/Documentation/sphinx/kernel_feat.py
@@ -37,8 +37,6 @@ import re
 import subprocess
 import sys
 
-from os import path
-
 from docutils import nodes, statemachine
 from docutils.statemachine import ViewList
 from docutils.parsers.rst import directives, Directive
@@ -76,33 +74,26 @@ class KernelFeat(Directive):
         self.state.document.settings.env.app.warn(message, prefix="")
 
     def run(self):
-
         doc = self.state.document
         if not doc.settings.file_insertion_enabled:
             raise self.warning("docutils: file insertion disabled")
 
         env = doc.settings.env
-        cwd = path.dirname(doc.current_source)
-        cmd = "get_feat.pl rest --enable-fname --dir "
-        cmd += self.arguments[0]
-
-        if len(self.arguments) > 1:
-            cmd += " --arch " + self.arguments[1]
 
-        srctree = path.abspath(os.environ["srctree"])
+        srctree = os.path.abspath(os.environ["srctree"])
 
-        fname = cmd
+        args = [
+            os.path.join(srctree, 'scripts/get_feat.pl'),
+            'rest',
+            '--enable-fname',
+            '--dir',
+            os.path.join(srctree, 'Documentation', self.arguments[0]),
+        ]
 
-        # extend PATH with $(srctree)/scripts
-        path_env = os.pathsep.join([
-            srctree + os.sep + "scripts",
-            os.environ["PATH"]
-        ])
-        shell_env = os.environ.copy()
-        shell_env["PATH"]    = path_env
-        shell_env["srctree"] = srctree
+        if len(self.arguments) > 1:
+            args.extend(['--arch', self.arguments[1]])
 
-        lines = self.runCmd(cmd, shell=True, cwd=cwd, env=shell_env)
+        lines = subprocess.check_output(args, cwd=os.path.dirname(doc.current_source)).decode('utf-8')
 
         line_regex = re.compile("^\.\. FILE (\S+)$")
 
@@ -121,30 +112,6 @@ class KernelFeat(Directive):
         nodeList = self.nestedParse(out_lines, fname)
         return nodeList
 
-    def runCmd(self, cmd, **kwargs):
-        u"""Run command ``cmd`` and return its stdout as unicode."""
-
-        try:
-            proc = subprocess.Popen(
-                cmd
-                , stdout = subprocess.PIPE
-                , stderr = subprocess.PIPE
-                , **kwargs
-            )
-            out, err = proc.communicate()
-
-            out, err = codecs.decode(out, 'utf-8'), codecs.decode(err, 'utf-8')
-
-            if proc.returncode != 0:
-                raise self.severe(
-                    u"command '%s' failed with return code %d"
-                    % (cmd, proc.returncode)
-                )
-        except OSError as exc:
-            raise self.severe(u"problems with '%s' directive: %s."
-                              % (self.name, ErrorString(exc)))
-        return out
-
     def nestedParse(self, lines, fname):
         content = ViewList()
         node    = nodes.section()
diff --git a/Documentation/translations/zh_CN/arch/loongarch/features.rst b/Documentation/translations/zh_CN/arch/loongarch/features.rst
index 82bfac180bdc..cec38dda8298 100644
--- a/Documentation/translations/zh_CN/arch/loongarch/features.rst
+++ b/Documentation/translations/zh_CN/arch/loongarch/features.rst
@@ -5,4 +5,4 @@
 :Original: Documentation/arch/loongarch/features.rst
 :Translator: Huacai Chen <chenhuacai@loongson.cn>
 
-.. kernel-feat:: $srctree/Documentation/features loongarch
+.. kernel-feat:: features loongarch
diff --git a/Documentation/translations/zh_CN/arch/mips/features.rst b/Documentation/translations/zh_CN/arch/mips/features.rst
index da1b956e4a40..0d6df97db069 100644
--- a/Documentation/translations/zh_CN/arch/mips/features.rst
+++ b/Documentation/translations/zh_CN/arch/mips/features.rst
@@ -10,4 +10,4 @@
 
 .. _cn_features:
 
-.. kernel-feat:: $srctree/Documentation/features mips
+.. kernel-feat:: features mips
-- 
2.43.0



