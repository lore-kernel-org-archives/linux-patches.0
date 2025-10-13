Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F1530C36D;
	Mon, 13 Oct 2025 14:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367225; cv=none; b=T5O6E3WaggCUXBeIJLbeiBNztPKQdPd3YbHQtGByJgBcWnMqplLRulUmkoeqPu3g1fyIJuYb/8IMP6kceX348ahed7j//S9VfR5GgwJu46MduEeatLqT0S4U7Xp4eouzLAPLCsgimr0nDuKvfalOcoL1O6SFgDgckr3mYv3bMfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367225; c=relaxed/simple;
	bh=XLod/wEImOpU2+WBFKVVb8koN125XEiUX2EmpskuoRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xddfl553VtrCYmTOe+Wij6Icz5tlr6t7Zq5X8gWqIwvfUnh0ptuxRSvqqhGTyFKUdplR5Y3aboHPhKMMqeN8VTrlFVL9OJ70QP6k7EPh9ShxJ67BTPCILz/7rt/IZz2RamB0og9+89f90kTuCo1P1TuFfggfiPYVnyfBGZgXJO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z33mjSup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z33mjSup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5C0C113D0;
	Mon, 13 Oct 2025 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367224;
	bh=XLod/wEImOpU2+WBFKVVb8koN125XEiUX2EmpskuoRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z33mjSupi5GHKxWMx2Oavc5o2EjybL6RbqlLP6jJI7f/gIoDWVclix+3ok2g0B976
	 HTQKRiHw5THv3ZF4eQRsJ3cZKnhGODUoPl8c1hIF4aVVUbBYYrpQ8FYy6zpps0LfdU
	 j9Adck6NNBFGOAFNoUmZulXtQgwNqGcR6HY9pUPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/196] Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram
Date: Mon, 13 Oct 2025 16:45:09 +0200
Message-ID: <20251013144319.613502730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit 8c716e87ea33519920811338100d6d8a7fb32456 ]

Section heading for sched_waking histogram is shown as normal paragraph
instead due to codeblock marker for the following diagram being in the
same line as the section underline. Separate them.

Fixes: daceabf1b494 ("tracing/doc: Fix ascii-art in histogram-design.rst")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20250916054202.582074-5-bagasdotme@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/histogram-design.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/histogram-design.rst b/Documentation/trace/histogram-design.rst
index 088c8cce738ba..6e0d1a48bd505 100644
--- a/Documentation/trace/histogram-design.rst
+++ b/Documentation/trace/histogram-design.rst
@@ -380,7 +380,9 @@ entry, ts0, corresponding to the ts0 variable in the sched_waking
 trigger above.
 
 sched_waking histogram
-----------------------::
+----------------------
+
+.. code-block::
 
   +------------------+
   | hist_data        |<-------------------------------------------------------+
-- 
2.51.0



