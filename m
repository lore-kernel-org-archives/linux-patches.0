Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771E6322DCB;
	Mon, 27 Oct 2025 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591099; cv=none; b=YOwCVV475+slhBHL2307f6Ikc7nGJDd6NOFIisLGaGEZoPRXG1jWlXtE8QeEddcOV6YTCzoC9Czwsc5LCWe5eGP2kjFQiUpbpC5eD2qG1QpY78wA9tqsHnLjd/F3pVhO4WZPQNa7Gyn0qP/sN0952xwYjDufCnC/8qhz4bhmS7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591099; c=relaxed/simple;
	bh=djqmfSqphhVgWHkKh3JA3XrDQ9Oqy+Z3N4VR5jj9TZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdptnYNpewiOMh7ZPTYXn+U3BHs9EukGlc9Fm9ZHNtc3UJem525U9L89Gk8cOhj5Ws0fyCe+xzhScC5zXDx2bffF8As4ovo7TzqjD6faEa/WQBIQ1uzpxAftrfv2f+r8fsCj7ncpV/gYoguMHLQM9ogQxPjbxJe7zjAlQo+neqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7o2B2RW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7o2B2RW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9DAC4CEF1;
	Mon, 27 Oct 2025 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591099;
	bh=djqmfSqphhVgWHkKh3JA3XrDQ9Oqy+Z3N4VR5jj9TZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7o2B2RWyCPGRf+ajKiJO1h3YK4s2k8eJedfNZe1v8lJRzoJCr9/s29wpmLCKovn3
	 dKg679ztr4zmVwNPKnuFu/AFiKOSGCRyCkXFh+buxW2DgyOdOAa0/UoDSW8bABEmJa
	 z5YF8iCXPnVeU4HHueHRSDJkRcRUrG4lKTndYSfE=
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
Subject: [PATCH 5.10 066/332] Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram
Date: Mon, 27 Oct 2025 19:31:59 +0100
Message-ID: <20251027183526.361041035@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



