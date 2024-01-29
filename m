Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF29115703E;
	Mon, 29 Jan 2024 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548243; cv=none; b=kOmTnBhuda+3tp3rYC786FwGJ5juLDRC8VFjenrkGyxyq3VdVm+e4L+VuYc1i2rvqLgoNEki9n9n3cMX4ZzjSNGv51UWpK1AxU2bBYPauvqmaOTSxtd/mZJox4Wy3xgGTlC74PxkhXeh0Pn8vCvLu9l5kcq+qabTdcGYWx4fGyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548243; c=relaxed/simple;
	bh=k0WzprU15Vn9Yy1394DQXc6kSui0yyADBOgjXCm5vO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7oR8Kc6tA2+yzZG6W/aCJwbIiXGHS7e87ciLwlG63KHVNJn3ZxwHfyCVbVY6SnZaD3Ss1UwhaWNdDwc9if5/KUboiGDWNHYzhRAxrOYi482vMKLMYju0DRHs0UOtkKlzlamsgHyQtH0rPJ5dw7Nv+gbN2Dg0BmJeynArfHB8ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKE098TZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKE098TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70A9C43390;
	Mon, 29 Jan 2024 17:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548242;
	bh=k0WzprU15Vn9Yy1394DQXc6kSui0yyADBOgjXCm5vO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKE098TZ0BblSBFyKJFaxnhnUKX6VAyMhgHt3Ey9lcXEHAMusN9b+aoZLaq/iJuWV
	 kxL7uIQKeCXF0zwAxYFRwVwb4PSYNJD9AhtaVQx/RnUbDSGKOZ2Vxqwc1Al13VakZX
	 cWfw0dd79HW/0o1HhodvEszYzjqyqkcWz1KBOyIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.1 041/185] docs: kernel_abi.py: fix command injection
Date: Mon, 29 Jan 2024 09:04:01 -0800
Message-ID: <20240129165959.902472047@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Vegard Nossum <vegard.nossum@oracle.com>

commit 3231dd5862779c2e15633c96133a53205ad660ce upstream.

The kernel-abi directive passes its argument straight to the shell.
This is unfortunate and unnecessary.

Let's always use paths relative to $srctree/Documentation/ and use
subprocess.check_call() instead of subprocess.Popen(shell=True).

This also makes the code shorter.

Link: https://fosstodon.org/@jani/111676532203641247
Reported-by: Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20231231235959.3342928-2-vegard.nossum@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/abi-obsolete.rst |    2 -
 Documentation/admin-guide/abi-removed.rst  |    2 -
 Documentation/admin-guide/abi-stable.rst   |    2 -
 Documentation/admin-guide/abi-testing.rst  |    2 -
 Documentation/sphinx/kernel_abi.py         |   56 +++++------------------------
 5 files changed, 14 insertions(+), 50 deletions(-)

--- a/Documentation/admin-guide/abi-obsolete.rst
+++ b/Documentation/admin-guide/abi-obsolete.rst
@@ -7,5 +7,5 @@ marked to be removed at some later point
 The description of the interface will document the reason why it is
 obsolete and when it can be expected to be removed.
 
-.. kernel-abi:: $srctree/Documentation/ABI/obsolete
+.. kernel-abi:: ABI/obsolete
    :rst:
--- a/Documentation/admin-guide/abi-removed.rst
+++ b/Documentation/admin-guide/abi-removed.rst
@@ -1,5 +1,5 @@
 ABI removed symbols
 ===================
 
-.. kernel-abi:: $srctree/Documentation/ABI/removed
+.. kernel-abi:: ABI/removed
    :rst:
--- a/Documentation/admin-guide/abi-stable.rst
+++ b/Documentation/admin-guide/abi-stable.rst
@@ -10,5 +10,5 @@ for at least 2 years.
 Most interfaces (like syscalls) are expected to never change and always
 be available.
 
-.. kernel-abi:: $srctree/Documentation/ABI/stable
+.. kernel-abi:: ABI/stable
    :rst:
--- a/Documentation/admin-guide/abi-testing.rst
+++ b/Documentation/admin-guide/abi-testing.rst
@@ -16,5 +16,5 @@ Programs that use these interfaces are s
 name to the description of these interfaces, so that the kernel
 developers can easily notify them if any changes occur.
 
-.. kernel-abi:: $srctree/Documentation/ABI/testing
+.. kernel-abi:: ABI/testing
    :rst:
--- a/Documentation/sphinx/kernel_abi.py
+++ b/Documentation/sphinx/kernel_abi.py
@@ -39,8 +39,6 @@ import sys
 import re
 import kernellog
 
-from os import path
-
 from docutils import nodes, statemachine
 from docutils.statemachine import ViewList
 from docutils.parsers.rst import directives, Directive
@@ -73,60 +71,26 @@ class KernelCmd(Directive):
     }
 
     def run(self):
-
         doc = self.state.document
         if not doc.settings.file_insertion_enabled:
             raise self.warning("docutils: file insertion disabled")
 
-        env = doc.settings.env
-        cwd = path.dirname(doc.current_source)
-        cmd = "get_abi.pl rest --enable-lineno --dir "
-        cmd += self.arguments[0]
-
-        if 'rst' in self.options:
-            cmd += " --rst-source"
-
-        srctree = path.abspath(os.environ["srctree"])
+        srctree = os.path.abspath(os.environ["srctree"])
 
-        fname = cmd
+        args = [
+            os.path.join(srctree, 'scripts/get_abi.pl'),
+            'rest',
+            '--enable-lineno',
+            '--dir', os.path.join(srctree, 'Documentation', self.arguments[0]),
+        ]
 
-        # extend PATH with $(srctree)/scripts
-        path_env = os.pathsep.join([
-            srctree + os.sep + "scripts",
-            os.environ["PATH"]
-        ])
-        shell_env = os.environ.copy()
-        shell_env["PATH"]    = path_env
-        shell_env["srctree"] = srctree
+        if 'rst' in self.options:
+            args.append('--rst-source')
 
-        lines = self.runCmd(cmd, shell=True, cwd=cwd, env=shell_env)
+        lines = subprocess.check_output(args, cwd=os.path.dirname(doc.current_source)).decode('utf-8')
         nodeList = self.nestedParse(lines, self.arguments[0])
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
         env = self.state.document.settings.env
         content = ViewList()


