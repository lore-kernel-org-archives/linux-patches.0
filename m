Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18D2B65C;
	Thu, 18 Jan 2024 10:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575062; cv=none; b=FkmQWXNiF0OPyVqZzIQU3pRAJ8PVOIKvg0z4xMg9/Zt0o/1Kn6i0aWiAg3NXUb8gAH9okeGSf0kn1IGANnUG1yIFCOLtBbh3wKbvV0VzkBIfe0VkiTwxyH3yEFqo2sWxoiZrMj4oX7avPsLWmqjpZ0eFGKMo2JC/fRAwWjSpMOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575062; c=relaxed/simple;
	bh=bFm5Q9eYQIJNbWqSPpYSyryD1E1Rudy3gIHe3AvY7rI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=U6i0Gh/Fti9GLB6oSe4ZkHbQofNCfmIqGadEZ9EPvT48mVRW8/4a0RtG2tX2o9HNTCEVfF57CaLRWRpFwoMEMLDvjdkZ35kEyQW78DgtkY/3RWN/2TXgVYjRv6yB0dSLy8YXT8aOBKdwRSYJqQyjbOV0KOGm4JARuYu9sSSO3rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBxxLmQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBxxLmQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B17C433C7;
	Thu, 18 Jan 2024 10:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575062;
	bh=bFm5Q9eYQIJNbWqSPpYSyryD1E1Rudy3gIHe3AvY7rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBxxLmQXuTpxp5Ay7VK1Iq7IIF5bYpltaflJRzYWy+rRK+ecNbl15ko0G2CsvBu9h
	 vFddH33du43Bg6FvddfuPQClrKRj3Lwpol8p1c24LWQ6a0ZtNXFWNwRSu3ClVf6QVV
	 f3HrkdIKelRJt9O1lT72cfUyLHsBtON0PiLOAxmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.7 27/28] docs: kernel_feat.py: fix potential command injection
Date: Thu, 18 Jan 2024 11:49:17 +0100
Message-ID: <20240118104302.147275313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vegard Nossum <vegard.nossum@oracle.com>

commit c48a7c44a1d02516309015b6134c9bb982e17008 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/features.rst                       |    2 
 Documentation/arch/arc/features.rst                          |    2 
 Documentation/arch/arm/features.rst                          |    2 
 Documentation/arch/arm64/features.rst                        |    2 
 Documentation/arch/loongarch/features.rst                    |    2 
 Documentation/arch/m68k/features.rst                         |    2 
 Documentation/arch/mips/features.rst                         |    2 
 Documentation/arch/nios2/features.rst                        |    2 
 Documentation/arch/openrisc/features.rst                     |    2 
 Documentation/arch/parisc/features.rst                       |    2 
 Documentation/arch/powerpc/features.rst                      |    2 
 Documentation/arch/riscv/features.rst                        |    2 
 Documentation/arch/s390/features.rst                         |    2 
 Documentation/arch/sh/features.rst                           |    2 
 Documentation/arch/sparc/features.rst                        |    2 
 Documentation/arch/x86/features.rst                          |    2 
 Documentation/arch/xtensa/features.rst                       |    2 
 Documentation/sphinx/kernel_feat.py                          |   55 ++---------
 Documentation/translations/zh_CN/arch/loongarch/features.rst |    2 
 Documentation/translations/zh_CN/arch/mips/features.rst      |    2 
 Documentation/translations/zh_TW/arch/loongarch/features.rst |    2 
 Documentation/translations/zh_TW/arch/mips/features.rst      |    2 
 22 files changed, 32 insertions(+), 65 deletions(-)

--- a/Documentation/admin-guide/features.rst
+++ b/Documentation/admin-guide/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features
+.. kernel-feat:: features
--- a/Documentation/arch/arc/features.rst
+++ b/Documentation/arch/arc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features arc
+.. kernel-feat:: features arc
--- a/Documentation/arch/arm/features.rst
+++ b/Documentation/arch/arm/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features arm
+.. kernel-feat:: features arm
--- a/Documentation/arch/arm64/features.rst
+++ b/Documentation/arch/arm64/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features arm64
+.. kernel-feat:: features arm64
--- a/Documentation/arch/loongarch/features.rst
+++ b/Documentation/arch/loongarch/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features loongarch
+.. kernel-feat:: features loongarch
--- a/Documentation/arch/m68k/features.rst
+++ b/Documentation/arch/m68k/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features m68k
+.. kernel-feat:: features m68k
--- a/Documentation/arch/mips/features.rst
+++ b/Documentation/arch/mips/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features mips
+.. kernel-feat:: features mips
--- a/Documentation/arch/nios2/features.rst
+++ b/Documentation/arch/nios2/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features nios2
+.. kernel-feat:: features nios2
--- a/Documentation/arch/openrisc/features.rst
+++ b/Documentation/arch/openrisc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features openrisc
+.. kernel-feat:: features openrisc
--- a/Documentation/arch/parisc/features.rst
+++ b/Documentation/arch/parisc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features parisc
+.. kernel-feat:: features parisc
--- a/Documentation/arch/powerpc/features.rst
+++ b/Documentation/arch/powerpc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features powerpc
+.. kernel-feat:: features powerpc
--- a/Documentation/arch/riscv/features.rst
+++ b/Documentation/arch/riscv/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features riscv
+.. kernel-feat:: features riscv
--- a/Documentation/arch/s390/features.rst
+++ b/Documentation/arch/s390/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features s390
+.. kernel-feat:: features s390
--- a/Documentation/arch/sh/features.rst
+++ b/Documentation/arch/sh/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features sh
+.. kernel-feat:: features sh
--- a/Documentation/arch/sparc/features.rst
+++ b/Documentation/arch/sparc/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features sparc
+.. kernel-feat:: features sparc
--- a/Documentation/arch/x86/features.rst
+++ b/Documentation/arch/x86/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features x86
+.. kernel-feat:: features x86
--- a/Documentation/arch/xtensa/features.rst
+++ b/Documentation/arch/xtensa/features.rst
@@ -1,3 +1,3 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-.. kernel-feat:: $srctree/Documentation/features xtensa
+.. kernel-feat:: features xtensa
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
 
         line_regex = re.compile(r"^\.\. FILE (\S+)$")
 
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
--- a/Documentation/translations/zh_CN/arch/loongarch/features.rst
+++ b/Documentation/translations/zh_CN/arch/loongarch/features.rst
@@ -5,4 +5,4 @@
 :Original: Documentation/arch/loongarch/features.rst
 :Translator: Huacai Chen <chenhuacai@loongson.cn>
 
-.. kernel-feat:: $srctree/Documentation/features loongarch
+.. kernel-feat:: features loongarch
--- a/Documentation/translations/zh_CN/arch/mips/features.rst
+++ b/Documentation/translations/zh_CN/arch/mips/features.rst
@@ -10,4 +10,4 @@
 
 .. _cn_features:
 
-.. kernel-feat:: $srctree/Documentation/features mips
+.. kernel-feat:: features mips
--- a/Documentation/translations/zh_TW/arch/loongarch/features.rst
+++ b/Documentation/translations/zh_TW/arch/loongarch/features.rst
@@ -5,5 +5,5 @@
 :Original: Documentation/arch/loongarch/features.rst
 :Translator: Huacai Chen <chenhuacai@loongson.cn>
 
-.. kernel-feat:: $srctree/Documentation/features loongarch
+.. kernel-feat:: features loongarch
 
--- a/Documentation/translations/zh_TW/arch/mips/features.rst
+++ b/Documentation/translations/zh_TW/arch/mips/features.rst
@@ -10,5 +10,5 @@
 
 .. _tw_features:
 
-.. kernel-feat:: $srctree/Documentation/features mips
+.. kernel-feat:: features mips
 


