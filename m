Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9013126AC;
	Fri, 31 Oct 2025 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919454; cv=none; b=iTnTI9Q/9KXayXokpr4Sr4VhHIusP9FXrTgmt50m2V6LZJXdHugY+SXimPlskfAfvnEgmaZ2LbBcnPWQFvBfwqlTZYOjrT1wsm9Yrwdj7lYKMnvv3QH/lP5vW/Fy1kCQsxAfzNaxUSTNC6SEx60tKWtKpRTxCQmz8Zux3BRKgIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919454; c=relaxed/simple;
	bh=uGngxyuA+e3YwxSd4Z6MPXf47/0UQGl2/qK/Vz9m+do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bp1p0ve9jISjutTqANE8jFGVipyvEqgPmZyxHLH7P4v3ke+AKuPgOsm+Ngnf3uCnPcB4OGuLTPjgPEGceMILYEG9atojfcqy1SrIgiSkAxGTLtfnluRb7lGJh/sAcLY7vfwuCK6Zi0EkXEG5QjicDhYSjHFAKEzgPvDrDCbAkbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSbeq9vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSbeq9vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A502C4CEE7;
	Fri, 31 Oct 2025 14:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919454;
	bh=uGngxyuA+e3YwxSd4Z6MPXf47/0UQGl2/qK/Vz9m+do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSbeq9vmhA/X708YmdImZcwj/X7pNlgFGBVIyXZYFmYfEj9UANaR22yOKFLVShLvt
	 hxEzGU3uUOkUpi8jHZOUg5zZDhzRWWZIvaHVlNYHa6Mk9epGJl6qdlSRD79d8fcc0r
	 5vZSh2rZ4GhlGt2XOwd2cO5R//9VEN2KOX+PGUoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhixu Liu <zhixu.liu@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andreas Radke <andreas.radke@mailbox.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 6.12 24/40] docs: kdoc: handle the obsolescensce of docutils.ErrorString()
Date: Fri, 31 Oct 2025 15:01:17 +0100
Message-ID: <20251031140044.596816599@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
  development cycle. Backport ErrorString definition as well to
  Documentation/sphinx/kernel_abi.py file for 6.12.y where it is imported
  from docutils before the faccc0ec64e1 ("docs: sphinx/kernel_abi: adjust
  coding style") change. ]
Suggested-by: Andreas Radke <andreas.radke@mailbox.org>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/kernel_abi.py          |    4 +++-
 Documentation/sphinx/kernel_feat.py         |    4 +++-
 Documentation/sphinx/kernel_include.py      |    6 ++++--
 Documentation/sphinx/maintainers_include.py |    4 +++-
 4 files changed, 13 insertions(+), 5 deletions(-)

--- a/Documentation/sphinx/kernel_abi.py
+++ b/Documentation/sphinx/kernel_abi.py
@@ -42,9 +42,11 @@ import kernellog
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
@@ -34,13 +34,15 @@ u"""
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
@@ -111,7 +113,7 @@ class KernelInclude(Include):
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


