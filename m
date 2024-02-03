Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9BB13AE8;
	Sat,  3 Feb 2024 04:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933483; cv=none; b=r22PrBXbiJbL+yveZ7sPo8xzTpzHCHfrn8z+G9tni5BsZKMe9eYnoikiv1/wTUIF6w0gE2xo71/2tfRvSfIAj6cBAbWWrMa7BeaJEDl99XkOwkcdq2HjF5ZHVJl6FDLFQWkXxgayZdB9RhA62y7QCwmwl0r1zwpWeNAJRRdjhg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933483; c=relaxed/simple;
	bh=LZWmPjdllbRUaio46aLGFfveNLpMoyBKVBc25h0h5GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtneFodsaTB1aJtYQwEfozlLq8SMaOGm6L8XnMA2OukdY14x0Ana+289lvDn/3TcAe+HcrVZukEOunW1z4SzyNygScj9OmGLyTh5N2A8bWR5R7HPN9VYY49F75dR3LErUL+XPc+rRmo/MCZQPXJKBV8cfxZtl5FM4TX9ctM0fqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBJN4myq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBJN4myq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7D2C43609;
	Sat,  3 Feb 2024 04:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933483;
	bh=LZWmPjdllbRUaio46aLGFfveNLpMoyBKVBc25h0h5GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBJN4myq34fqFQxuaaNxMmYo60Fjx4+ecD0ForFnSbNzdmuSQM+u/Zelj+68bhKm6
	 pMBLxCp5BC+9WEp2MSPHwDMZ+U1z4UJcwqbEbP6SJirQkGu7znjf3SGjTA1OU4LNAM
	 Ktkco5vfGLGT+6NTeXrH500hKVrVOxNTU5gM2M88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Forbes <jforbes@fedoraproject.org>
Subject: [PATCH 6.6 001/322] Documentation/sphinx: fix Python string escapes
Date: Fri,  2 Feb 2024 20:01:38 -0800
Message-ID: <20240203035359.094891332@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Benjamin Gray <bgray@linux.ibm.com>

commit 86a0adc029d338f0da8989e7bb453c1114d51960 upstream.

Python 3.6 introduced a DeprecationWarning for invalid escape sequences.
This is upgraded to a SyntaxWarning in Python 3.12, and will eventually
be a syntax error.

Fix these now to get ahead of it before it's an error.

Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Message-ID: <20230912060801.95533-3-bgray@linux.ibm.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Forbes <jforbes@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/cdomain.py             |    2 +-
 Documentation/sphinx/kernel_abi.py          |    2 +-
 Documentation/sphinx/kernel_feat.py         |    2 +-
 Documentation/sphinx/kerneldoc.py           |    2 +-
 Documentation/sphinx/maintainers_include.py |    8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

--- a/Documentation/sphinx/cdomain.py
+++ b/Documentation/sphinx/cdomain.py
@@ -93,7 +93,7 @@ def markup_ctype_refs(match):
 #
 RE_expr = re.compile(r':c:(expr|texpr):`([^\`]+)`')
 def markup_c_expr(match):
-    return '\ ``' + match.group(2) + '``\ '
+    return '\\ ``' + match.group(2) + '``\\ '
 
 #
 # Parse Sphinx 3.x C markups, replacing them by backward-compatible ones
--- a/Documentation/sphinx/kernel_abi.py
+++ b/Documentation/sphinx/kernel_abi.py
@@ -102,7 +102,7 @@ class KernelCmd(Directive):
                 code_block += "\n    " + l
             lines = code_block + "\n\n"
 
-        line_regex = re.compile("^\.\. LINENO (\S+)\#([0-9]+)$")
+        line_regex = re.compile(r"^\.\. LINENO (\S+)\#([0-9]+)$")
         ln = 0
         n = 0
         f = fname
--- a/Documentation/sphinx/kernel_feat.py
+++ b/Documentation/sphinx/kernel_feat.py
@@ -95,7 +95,7 @@ class KernelFeat(Directive):
 
         lines = subprocess.check_output(args, cwd=os.path.dirname(doc.current_source)).decode('utf-8')
 
-        line_regex = re.compile("^\.\. FILE (\S+)$")
+        line_regex = re.compile(r"^\.\. FILE (\S+)$")
 
         out_lines = ""
 
--- a/Documentation/sphinx/kerneldoc.py
+++ b/Documentation/sphinx/kerneldoc.py
@@ -130,7 +130,7 @@ class KernelDocDirective(Directive):
             result = ViewList()
 
             lineoffset = 0;
-            line_regex = re.compile("^\.\. LINENO ([0-9]+)$")
+            line_regex = re.compile(r"^\.\. LINENO ([0-9]+)$")
             for line in lines:
                 match = line_regex.search(line)
                 if match:
--- a/Documentation/sphinx/maintainers_include.py
+++ b/Documentation/sphinx/maintainers_include.py
@@ -77,7 +77,7 @@ class MaintainersInclude(Include):
             line = line.rstrip()
 
             # Linkify all non-wildcard refs to ReST files in Documentation/.
-            pat = '(Documentation/([^\s\?\*]*)\.rst)'
+            pat = r'(Documentation/([^\s\?\*]*)\.rst)'
             m = re.search(pat, line)
             if m:
                 # maintainers.rst is in a subdirectory, so include "../".
@@ -90,11 +90,11 @@ class MaintainersInclude(Include):
                 output = "| %s" % (line.replace("\\", "\\\\"))
                 # Look for and record field letter to field name mappings:
                 #   R: Designated *reviewer*: FullName <address@domain>
-                m = re.search("\s(\S):\s", line)
+                m = re.search(r"\s(\S):\s", line)
                 if m:
                     field_letter = m.group(1)
                 if field_letter and not field_letter in fields:
-                    m = re.search("\*([^\*]+)\*", line)
+                    m = re.search(r"\*([^\*]+)\*", line)
                     if m:
                         fields[field_letter] = m.group(1)
             elif subsystems:
@@ -112,7 +112,7 @@ class MaintainersInclude(Include):
                     field_content = ""
 
                     # Collapse whitespace in subsystem name.
-                    heading = re.sub("\s+", " ", line)
+                    heading = re.sub(r"\s+", " ", line)
                     output = output + "%s\n%s" % (heading, "~" * len(heading))
                     field_prev = ""
                 else:


