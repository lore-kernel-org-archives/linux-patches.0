Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116633451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301772; cv=none; b=lOkqmKk0+usjJuBy0pHbbrlaxAdhleU8t1wmxl/Vvwlnk92q9Q/W6zc0NXcSpp4WTprrjK8ko1UsfAixbQe1NOjd1ygkzkVqFVpV/I9GoYE0S4Y38/oOD+UI57XTfhKoo7Stg7grDh65xcwVXMD/GxNETZY+zJULN8npEzsohrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301772; c=relaxed/simple;
	bh=klVkUGNCwKITA5Jo7hMsk9ebh3NWaOPrKbp2EMYT4qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNhMBNCUejKlHXRV0zMPKjOs7Cl+67vfw/WPf6xVrOBw19PdUxgHwFUBNKpW59R+uL97IwxK2Kglsc/T2VrYJI0dIaQLXf2DUXXB/JDItBZrFvkIGwiS7iS3FCqDZhLCgPOj0ebM3aIv/WL1eI6mOtpWtbAUlYj6455RXagTu9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SINedd5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SINedd5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D11EC19423;
	Sat, 28 Feb 2026 18:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301771;
	bh=klVkUGNCwKITA5Jo7hMsk9ebh3NWaOPrKbp2EMYT4qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SINedd5UEduWtA2c7ZTFjJGjjgWqe93IFGuawfoMQkuFRaIZGy/f2AJh1ZvfCLxxk
	 IPn2RtpKvovX4FjnltNGAPW60IoVFcA8CKRqjAN6NXAmLz/89Z4fHmoGKhAy14+qJ+
	 4AOKz7cBSsdnIeKj0VJxS4sgTvgTVSNNsl6lZZXqY5/vWkiKNJQfFRodOCSRQ/Y7iS
	 Hrtf7s6ONUDsBXCVo3pC16/47XYu3hAV8lYqnNJkbl2woSSkRAq51kIwyJ7upfHjSX
	 0ieQEQf5bZ9YwV32L+Pyb2lerUbNtuVMcsb3gvqypLNokBzNVdB6Z/s/nDhS42m5t/
	 cbjkwnBD/mf/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Purva Yeshi <purvayeshi550@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/385] Documentation: trace: Refactor toctree
Date: Sat, 28 Feb 2026 12:56:41 -0500
Message-ID: <20260228180011.1568201-179-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

