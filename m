Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D34230C372;
	Mon, 13 Oct 2025 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368933; cv=none; b=MYgxMPCNia1u9lCypprnxvLjDOEpabYYW+z3tWJp99kgt+gjiLPg+TXdX/AAnWqToeH4J7JGcMcTqldHElxRVriPEzKhnjy5NiG/MGn4vAThnF1Zq8xo8SZK2ohuZWEok1c5/1tFfoXVSBGrqng3oA7JFkNL3lnjS2XXVZVi5vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368933; c=relaxed/simple;
	bh=oYxUhQUUcjNiwjXApbcV3NRTY+h28YZfPAV7xwlEg8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3/iV6DylHhXxuVy9GDOdVV7+9BQ77LoKCiOryhIh9fkv1zjaQ8QRaRgJfKbPvpM2vljkQ1j2N3HGbxjztVWto32GO7EMPjXojWUdV8Htln8LsDPeafA5MVNCagXuz5wxf3UD+hQoS17nOvZMuW7TBQxOI61qqQWs90Ot9xvzXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9lq5CzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9lq5CzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7748C4CEE7;
	Mon, 13 Oct 2025 15:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368933;
	bh=oYxUhQUUcjNiwjXApbcV3NRTY+h28YZfPAV7xwlEg8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9lq5CzCwoREft6g9XBA8uhXMlQAjdU64bYwfBYTUOZjrbHsEszNl0Z7yxdt/wWLg
	 5cC0Xfof0pyNp7l5l+maDk7sCur30NO9GcPcBCpBE9TPy43z4nkzcNki7uHlDQGYlh
	 RUsvglEuvycRjPCO2z/GI62bGT9hMzzyyg7tROWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Daniel Gomez <da.gomez@samsung.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 070/563] scripts/misc-check: update export checks for EXPORT_SYMBOL_FOR_MODULES()
Date: Mon, 13 Oct 2025 16:38:51 +0200
Message-ID: <20251013144413.828516814@linuxfoundation.org>
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

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit 0354e81b7bd629f9c3379c9524e988ebc504fa25 ]

The module export checks are looking for EXPORT_SYMBOL_GPL_FOR_MODULES()
which was renamed to EXPORT_SYMBOL_FOR_MODULES(). Update the checks.

Fixes: 6d3c3ca4c77e ("module: Rename EXPORT_SYMBOL_GPL_FOR_MODULES to EXPORT_SYMBOL_FOR_MODULES")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://lore.kernel.org/r/20250825-export_modules_fix-v1-1-5c331e949538@suse.cz
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/misc-check | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/misc-check b/scripts/misc-check
index 84f08da17b2c0..40e5a4b01ff47 100755
--- a/scripts/misc-check
+++ b/scripts/misc-check
@@ -45,7 +45,7 @@ check_tracked_ignored_files () {
 # does not automatically fix it.
 check_missing_include_linux_export_h () {
 
-	git -C "${srctree:-.}" grep --files-with-matches -E 'EXPORT_SYMBOL((_NS)?(_GPL)?|_GPL_FOR_MODULES)\(.*\)' \
+	git -C "${srctree:-.}" grep --files-with-matches -E 'EXPORT_SYMBOL((_NS)?(_GPL)?|_FOR_MODULES)\(.*\)' \
 	    -- '*.[ch]' :^tools/ :^include/linux/export.h |
 	xargs -r git -C "${srctree:-.}" grep --files-without-match '#include[[:space:]]*<linux/export\.h>' |
 	xargs -r printf "%s: warning: EXPORT_SYMBOL() is used, but #include <linux/export.h> is missing\n" >&2
@@ -58,7 +58,7 @@ check_unnecessary_include_linux_export_h () {
 
 	git -C "${srctree:-.}" grep --files-with-matches '#include[[:space:]]*<linux/export\.h>' \
 	    -- '*.[c]' :^tools/ |
-	xargs -r git -C "${srctree:-.}" grep --files-without-match -E 'EXPORT_SYMBOL((_NS)?(_GPL)?|_GPL_FOR_MODULES)\(.*\)' |
+	xargs -r git -C "${srctree:-.}" grep --files-without-match -E 'EXPORT_SYMBOL((_NS)?(_GPL)?|_FOR_MODULES)\(.*\)' |
 	xargs -r printf "%s: warning: EXPORT_SYMBOL() is not used, but #include <linux/export.h> is present\n" >&2
 }
 
-- 
2.51.0



