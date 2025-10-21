Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFBC350A0D;
	Tue, 21 Oct 2025 20:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077129; cv=none; b=DCoi2tPDayup0/AQLFYW2bpRY62cYMm6P+atmEbfKfxnLFlk20FCfUcdBRx++ctPaWh7CqLOSdkWUacxmk32yWIO3Kj/2Pjr1gh601C2pp011LHZ3vTkhr8LUqjKnp9ngBSLw+BwDc7PtxzIFR325zUx6OdQyBDix/tXQ9OkqJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077129; c=relaxed/simple;
	bh=vds5mw64kIr4o9ac3qP5ZAJMnRf0lJvjvyjlL0YB8M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpbmv/o06wdkd82ofl3jMD7lpT+1ewTmEyLFDuplQEtmYYnXG/1EOYc/XQsjqmzlj+OEOy9FS/gdbQvIZk+UlZP3ZK58ZohfYjTiv8oARLOW33nlq+vlT2PGay9JRBoEBmG376uPT1jH5rNMo1zsogikNWRYzMyaqmW+KCxOT6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuqgMDq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuqgMDq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F89C4CEF1;
	Tue, 21 Oct 2025 20:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077129;
	bh=vds5mw64kIr4o9ac3qP5ZAJMnRf0lJvjvyjlL0YB8M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuqgMDq/fFYM8XSE22DqBiORG63FciuJYXFGHG5xPRjNc674AjzOxGY1OKT/ZcNrn
	 1wUFlmQ5Pn5VYAxACWpbfvQQT/3bZHOktAGTxfTmnZdex2GKn2IFrULr+BpMK2NLOT
	 M6MXnWWkS1noatyud4PUbuY9l7pCWYczUECpr/eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhixu Liu <zhixu.liu@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.17 001/159] docs: kdoc: handle the obsolescensce of docutils.ErrorString()
Date: Tue, 21 Oct 2025 21:49:38 +0200
Message-ID: <20251021195043.219137110@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Corbet <corbet@lwn.net>

commit 00d95fcc4dee66dfb6980de6f2973b32f973a1eb upstream.

The ErrorString() and SafeString() docutils functions were helpers meant to
ease the handling of encodings during the Python 3 transition.  There is no
real need for them after Python 3.6, and docutils 0.22 removes them,
breaking the docs build

Handle this by just injecting our own one-liner version of ErrorString(),
and removing the sole SafeString() call entirely.

Reported-by: Zhixu Liu <zhixu.liu@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <87ldmnv2pi.fsf@trenco.lwn.net>
[ Salvatore Bonaccorso: Backport to v6.17.y for context changes in
  Documentation/sphinx/kernel_include.py with major refactorings for the v6.18
  development cycle ]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/kernel_feat.py         |    4 +++-
 Documentation/sphinx/kernel_include.py      |    6 ++++--
 Documentation/sphinx/maintainers_include.py |    4 +++-
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/Documentation/sphinx/kernel_feat.py
+++ b/Documentation/sphinx/kernel_feat.py
@@ -40,9 +40,11 @@ import sys
 from docutils import nodes, statemachine
 from docutils.statemachine import ViewList
 from docutils.parsers.rst import directives, Directive
-from docutils.utils.error_reporting import ErrorString
 from sphinx.util.docutils import switch_source_input
 
+def ErrorString(exc):  # Shamelessly stolen from docutils
+    return f'{exc.__class__.__name}: {exc}'
+
 __version__  = '1.0'
 
 def setup(app):
--- a/Documentation/sphinx/kernel_include.py
+++ b/Documentation/sphinx/kernel_include.py
@@ -35,13 +35,15 @@
 import os.path
 
 from docutils import io, nodes, statemachine
-from docutils.utils.error_reporting import SafeString, ErrorString
 from docutils.parsers.rst import directives
 from docutils.parsers.rst.directives.body import CodeBlock, NumberLines
 from docutils.parsers.rst.directives.misc import Include
 
 __version__  = '1.0'
 
+def ErrorString(exc):  # Shamelessly stolen from docutils
+    return f'{exc.__class__.__name}: {exc}'
+
 # ==============================================================================
 def setup(app):
 # ==============================================================================
@@ -112,7 +114,7 @@ class KernelInclude(Include):
             raise self.severe('Problems with "%s" directive path:\n'
                               'Cannot encode input file path "%s" '
                               '(wrong locale?).' %
-                              (self.name, SafeString(path)))
+                              (self.name, path))
         except IOError as error:
             raise self.severe('Problems with "%s" directive path:\n%s.' %
                       (self.name, ErrorString(error)))
--- a/Documentation/sphinx/maintainers_include.py
+++ b/Documentation/sphinx/maintainers_include.py
@@ -22,10 +22,12 @@ import re
 import os.path
 
 from docutils import statemachine
-from docutils.utils.error_reporting import ErrorString
 from docutils.parsers.rst import Directive
 from docutils.parsers.rst.directives.misc import Include
 
+def ErrorString(exc):  # Shamelessly stolen from docutils
+    return f'{exc.__class__.__name}: {exc}'
+
 __version__  = '1.0'
 
 def setup(app):


