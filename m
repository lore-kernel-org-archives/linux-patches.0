Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED6730C63F;
	Mon, 13 Oct 2025 15:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369842; cv=none; b=eWZQrhOXbR9ymC2volZowLnzR7pawexTyNydxVpeXRQjTi5LFTkrfAhGIBELxu/+G+j44eLjmmqHdeQLTgoJEfP2/IOr8NpPHVMmZY5PdaAJqXljRhIJE6cFrzAqdckWIPhDxMH1BjxccWy/gz9B3jcoNLEGsJxZbK+Cdl5DtNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369842; c=relaxed/simple;
	bh=ncUkvZP3E8DSw+FLXDPhmUBSlHj7m8km6qzNpNmx9bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roo0q1RbFUOAvqmX+pR41VAstpqjiOXNZ+5tVDl2/uJlnSJ+M8jLl/ambs5OahQgLghC0Orby/aAwramGtfmJHLk7nNIdgNN0SjTaSIbRuJ74QJ39TYc3B0cqSQqkPEZbYSlA3ySLsLVzDkGDXncYdSEB/C1Qn52eHqunhF7pjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0wMkhQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0wMkhQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC69C4CEE7;
	Mon, 13 Oct 2025 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369841;
	bh=ncUkvZP3E8DSw+FLXDPhmUBSlHj7m8km6qzNpNmx9bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0wMkhQbwLcCKbM5O5XCIcd55wz8r9ibe0hqmBJkrVxmHICn+MUnXvfRf9Ysq01rS
	 qGqaXja//GL6b1PvXl9E9KIp+7RRHZIe3PxNR3rkBtJ97qp2L+xVOswmVtZMEjWPlM
	 9GBFEcxUFKIhbWoS6AzUkMxLhzUvKfFgKKQOmdyI=
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
Subject: [PATCH 6.17 388/563] Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram
Date: Mon, 13 Oct 2025 16:44:09 +0200
Message-ID: <20251013144425.330118064@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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
index 5765eb3e9efa7..a30f4bed11b4e 100644
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



