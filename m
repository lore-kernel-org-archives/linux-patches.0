Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AAE383C8B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302117; cv=none; b=W1OXHWtt7UMKv0ZfuTQAYaGDTPhhVL2d2qk+p1WS+KfyZkh7YSIWNVke4Icruve08cmN0L4vTgjiLJIEpwKarIiaGeMOTBEaq5xRYpjdpM2M2d+3joKGZ0WBfRNfAVVpy++WvmCgERCBgX3WGgyr3m7KbfTEPIkaP/P0wYxP5d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302117; c=relaxed/simple;
	bh=klVkUGNCwKITA5Jo7hMsk9ebh3NWaOPrKbp2EMYT4qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtSVzmH4P3jogeRdlMn5fuZ8ptVhHbDUFRKRMw9XMaM5C0msmK9bYoF9ronJAQRIncKl5UuyPfxDMY6Ikvy01jXmUUSg+Jw0qayc7Wx4SzVR5DrgV2xocMETZW1sDwDKpMAUKkcQIZgyJXq6FXd/dDm+q9CBJfkDgbDSL6OnmPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLP94YBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLP94YBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBC6C19425;
	Sat, 28 Feb 2026 18:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302117;
	bh=klVkUGNCwKITA5Jo7hMsk9ebh3NWaOPrKbp2EMYT4qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLP94YBglLwxeX1ejcHDMRPcAjsi2K4Z1WWqutBXnlCf3IauhQ7Echjfryrux8fd8
	 bj4ymNDezQyQPApCYFi5FCT99v4HM6g6X9qwXagOLbpHUYmtD0wlHCRwZLH52ancOh
	 ajJFyUKahQY6A4JtV3jf50HLs8xgKKJ997u3/pvH9obTdz4KOaBT6EXZvkPPyGdZsc
	 CEBNURfjAVbKmVj27+jHgo1XLPUME3GhiIIlVen6xt8YCpGLCunge+c/VqRF85/MDk
	 BITHpoJKvOxjf/f/U5HJUUoCCkE1Mk9wV/zAMuGhNTNSspfG5nrXIz764tXM+th13L
	 ZE98/lw9BJMqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Purva Yeshi <purvayeshi550@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/283] Documentation: trace: Refactor toctree
Date: Sat, 28 Feb 2026 13:04:09 -0500
Message-ID: <20260228180709.1583486-107-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Purva Yeshi <purvayeshi550@gmail.com>

[ Upstream commit f0ba72e65516d1d86f40c79a49c4ba01c9555592 ]

Refactor table of contents of kernel tracing subsystem docs to improve
clarity, structure, and organization:

- Reformat sections and add appropriate headings
- Improve section grouping and refine descriptions for each group
- Add docs intro paragraph

Signed-off-by: Purva Yeshi <purvayeshi550@gmail.com>
Link: https://lore.kernel.org/r/20250318113230.24950-2-purvayeshi550@gmail.com
[Bagas: massage commit message and address reviews]
Co-developed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Stable-dep-of: 8236fc613d44 ("Documentation: tracing: Add PCI tracepoint documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/index.rst | 96 +++++++++++++++++++++++++++++------
 1 file changed, 80 insertions(+), 16 deletions(-)

diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index 2c991dc96ace6..770d3bece22c3 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -1,39 +1,103 @@
-==========================
-Linux Tracing Technologies
-==========================
+================================
+Linux Tracing Technologies Guide
+================================
+
+Tracing in the Linux kernel is a powerful mechanism that allows
+developers and system administrators to analyze and debug system
+behavior. This guide provides documentation on various tracing
+frameworks and tools available in the Linux kernel.
+
+Introduction to Tracing
+-----------------------
+
+This section provides an overview of Linux tracing mechanisms
+and debugging approaches.
 
 .. toctree::
    :maxdepth: 2
 
-   ftrace-design
+   debugging
+   tracepoints
    tracepoint-analysis
+   ring-buffer-map
+
+Core Tracing Frameworks
+-----------------------
+
+The following are the primary tracing frameworks integrated into
+the Linux kernel.
+
+.. toctree::
+   :maxdepth: 1
+
    ftrace
+   ftrace-design
    ftrace-uses
-   fprobe
    kprobes
    kprobetrace
-   uprobetracer
    fprobetrace
-   tracepoints
+   fprobe
+   ring-buffer-design
+
+Event Tracing and Analysis
+--------------------------
+
+A detailed explanation of event tracing mechanisms and their
+applications.
+
+.. toctree::
+   :maxdepth: 1
+
    events
    events-kmem
    events-power
    events-nmi
    events-msr
-   mmiotrace
+   boottime-trace
    histogram
    histogram-design
-   boottime-trace
-   debugging
-   hwlat_detector
-   osnoise-tracer
-   timerlat-tracer
+
+Hardware and Performance Tracing
+--------------------------------
+
+This section covers tracing features that monitor hardware
+interactions and system performance.
+
+.. toctree::
+   :maxdepth: 1
+
    intel_th
-   ring-buffer-design
-   ring-buffer-map
    stm
    sys-t
    coresight/index
-   user_events
    rv/index
    hisi-ptt
+   mmiotrace
+   hwlat_detector
+   osnoise-tracer
+   timerlat-tracer
+
+User-Space Tracing
+------------------
+
+These tools allow tracing user-space applications and
+interactions.
+
+.. toctree::
+   :maxdepth: 1
+
+   user_events
+   uprobetracer
+
+Additional Resources
+--------------------
+
+For more details, refer to the respective documentation of each
+tracing tool and framework.
+
+.. only:: subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
-- 
2.51.0

