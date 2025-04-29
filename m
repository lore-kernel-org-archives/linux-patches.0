Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4963FFD;
	Tue, 29 Apr 2025 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949694; cv=none; b=bHba+3cfB8jDpcck5QzRlT5LF5PCNl28K/9AgYIyOK/uzs8LNWP/3f+IIBOw4IJR1N8mGj4SPLlZe2VK6g6IASZaaFUGDwUNi2fuiVnTOub573zSz9QThM5iNUFNaBf0PgkaMBOqRXrkf+l1dUcpWJna1YzdLKceFEOICvBz1e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949694; c=relaxed/simple;
	bh=3QU60RNjYQLL71xhhLo8V9dtU/I0aEQVhIB7Uu7VMgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKY9uen4XhSL+iUIdjS9AssSzU2iNki/RkadpFZh6ZQd7cp4q0fV65N08SK6Ojz3PmrqtnH19lxFIgUCWbBh3mWeLVbosh4enOWBJRfMV73UfXJID9NCT3fMEGEPq3OtJ+1QcistY9Coh29TXSNRVixS4Ooh9zQeQQS6SQOPclI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHscK7Hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHscK7Hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0768C4CEEE;
	Tue, 29 Apr 2025 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949694;
	bh=3QU60RNjYQLL71xhhLo8V9dtU/I0aEQVhIB7Uu7VMgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHscK7Hp+Csx3FYsv+ziVEar+4Ei8H6Tf6AdP2tZeEtwYasTQZ5PhZnk/ub0afSA/
	 w2RfUlXUu0HwQc9JE1QTzJjLo71zwgje3HR7/4Poa1USBiYBtDHophc5ZfHQ6fyaLg
	 uxUJ2eKn814nBYon43oM/HeBF21JN/5Cas5BB1DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/167] tracing: Fix cpumask() example typo
Date: Tue, 29 Apr 2025 18:41:52 +0200
Message-ID: <20250429161051.926853805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit eb9d58947d40699d93e5e69e1ddc54e41da7e132 ]

The sample code for using cpumask used the wrong field for the
__get_cpumask() helper. It used "cpus" which is the bitmask (but would
still give a proper example) instead of the "cpum" that was there to be
used.

Although it produces the same output, fix it, because it's an example and
is confusing in how to properly use the cpumask() macro.

Link: https://lore.kernel.org/linux-trace-kernel/20221213221227.56560374@gandalf.local.home

Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: ea8d7647f9dd ("tracing: Verify event formats that have "%*p.."")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/trace_events/trace-events-sample.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index fb4548a44153c..1c6b843b8c4ee 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -359,7 +359,7 @@ TRACE_EVENT(foo_bar,
 		  __print_array(__get_dynamic_array(list),
 				__get_dynamic_array_len(list) / sizeof(int),
 				sizeof(int)),
-		  __get_str(str), __get_bitmask(cpus), __get_cpumask(cpus),
+		  __get_str(str), __get_bitmask(cpus), __get_cpumask(cpum),
 		  __get_str(vstr))
 );
 
-- 
2.39.5



