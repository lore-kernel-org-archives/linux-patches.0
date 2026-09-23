Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A2A53B34C;
	Wed, 23 Sep 2026 14:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172495; cv=none; b=lcarC1+W9EA4JDYG8IpbP8m13N+jzqb7GmtXBneJjBccEFwoDiwqKOOOH0KY7nFfC1M2tHei2dw4VloNoTimRzUhguyUgXQdcNoNmQTAZANabrmGfwatmswGBScs5kKjCanaDmwPX8echXymnMHPC+sKQ0ofWT6aXM7iy1jdjNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172495; c=relaxed/simple;
	bh=tLK6gwNYZFlR2PF+z3ylUaLLd//005JVuT2Y6tY4Jrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUBopekjJ9jm1G/mWuXPlcZz2LlmHINFMu1mt6542IPaf2bIO0EKkjgvJTnh9fvNp1MU3FeXQL5IcE54eXKihk4HiZb2pXpVr+QiQr329doxQS0M3DX1h4gD+6wk5YRzVIo+IENTXY1TN8B2rbptJzyiGDi0pgA4u3NiJPMmbWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnbwzY++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnbwzY++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9511F000FF;
	Wed, 23 Sep 2026 14:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172491;
	bh=NhJqp84DGt7tb4oq4cYc0YEgzwTrCzW/ED6alJ7NgRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnbwzY++Ao6ByTlSHLIklq3uFa+EdmWOXeD0MgeLi1AK141y+4jHyye8wwnCSraEX
	 ePvXpEnLHMfFAUaJg0Mc3Ro90vVSStkyewaU8YqRgv7SUzhrXdnUcPgwKJrTHZzoNX
	 Zx/3Eif8VuyEVIf3ZqlRjcjJKIUc4sS7LgMC5iHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/398] Revert "perf annotate: Fix build with NO_SLANG=1"
Date: Wed, 23 Sep 2026 16:01:15 +0200
Message-ID: <20260923140643.483993972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit e97bd4417010c648acf9b1e509cfb77fc506e09e.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index a4f244a046866..c64005278687c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -709,8 +709,6 @@ struct block_hist {
 	struct hist_entry	he;
 };
 
-#define NO_ADDR 0
-
 #ifdef HAVE_SLANG_SUPPORT
 #include "../ui/keysyms.h"
 void attr_to_script(char *buf, struct perf_event_attr *attr);
@@ -748,16 +746,14 @@ int evlist__tui_browse_hists(struct evlist *evlist __maybe_unused,
 static inline int __hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
 					     struct map_symbol *ms __maybe_unused,
 					     struct evsel *evsel __maybe_unused,
-					     struct hist_browser_timer *hbt __maybe_unused,
-					     u64 al_addr __maybe_unused)
+					     struct hist_browser_timer *hbt __maybe_unused)
 {
 	return 0;
 }
 
 static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
 					   struct evsel *evsel __maybe_unused,
-					   struct hist_browser_timer *hbt __maybe_unused,
-					   u64 al_addr __maybe_unused)
+					   struct hist_browser_timer *hbt __maybe_unused)
 {
 	return 0;
 }
-- 
2.53.0



