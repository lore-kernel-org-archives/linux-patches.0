Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA856FDE1;
	Mon, 29 Jan 2024 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548482; cv=none; b=pQ0gXUgnuHM/IEq5iEG2XLM2/dWw6TwrEL8mgf/eYngypOtkawXZaVnUk+uZJvt8Yt9z6UFZ9WdMMyP4TouYtJcPntgHOW54hq8rBxTtp+w9uOpqrOlOPCV2HJ7YxDOAM6ohiKZ6e1SPiQYDwoigiyTlQFkeg4h93TtL8PjMpZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548482; c=relaxed/simple;
	bh=sC1md3EQNJkUGgesAou5tSqndH96mHrPjOg5lbOhHUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSfgMCKB842WBxgkAlgdaqKCEio9V/AfyTdQI42gxObEVTh0MMWCLw6MD62M4ZOO17CZ52WqYx0ig3o2Wr835OJqEHkncy3nsj26Xvh2VyEnYYHwMTj5miUHb2UFn7MrGse9yfaxoH9myiDPolZg5H5FEbKUZBXq/VcatR9nQrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPS2xWgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPS2xWgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1038C433F1;
	Mon, 29 Jan 2024 17:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548481;
	bh=sC1md3EQNJkUGgesAou5tSqndH96mHrPjOg5lbOhHUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPS2xWgLPbL/MWhctRJ07XeJlL5QNgHA5SKwDk0Js9oN4YZjVcO0GkoWvTXDbNihr
	 f6VulXCPbpBc69/ZVmpBBX15ffxpKC39Nll/073j4IxZI4OLQpSMeVO7y+SrEQclIL
	 Eg0ppT/yDbG6bqXMaTst2fHMrEtyyhX5iKNwyTFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.6 101/331] docs: kernel_abi.py: fix command injection
Date: Mon, 29 Jan 2024 09:02:45 -0800
Message-ID: <20240129170017.892731162@linuxfoundation.org>
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


