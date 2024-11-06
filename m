Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173B1DED58;
	Wed,  6 Nov 2024 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895957; cv=none; b=QjA7KGDeKK9knWqHmayE7kXGNVoHpW4g9UBIDL3osvJbEqfWwbcYXk2nQEKUBv1k4KVO5hES2NQszPwz52lN3FLKHMmDJZ2OYL1+g/FazYik/P22/GSC5/2lY9kpjzvTw+Aoa7FMwr3r4hepMQ5GsfSFg4logyCd9G//WPMr+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895957; c=relaxed/simple;
	bh=zHUjsY9f+bVuymnLtzpYTllfKiglAG4CcvU612ToRKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyFk1el+4ZdW9qjn9YJlXHNrOhq2LbLvTQ2Joy8f2WvsOWzz0hROOWGL9eEX127BAulj3JKY9KtaQD8N4c6SRJ2pztP1RG/RiHhil/L7JlnEY6qqhzXCzQWJoGT99fXUIyQq3NLnNFljE7HmqQ+NAnzKWREbC40xdSp30i76O1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLV/N/aH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLV/N/aH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6897BC4CECD;
	Wed,  6 Nov 2024 12:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895956;
	bh=zHUjsY9f+bVuymnLtzpYTllfKiglAG4CcvU612ToRKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLV/N/aHSRaDCRzndnKHikWL2BIONilKPT4eUoqVyRCB//aBVYEtH7vhmydlXpnP/
	 i+os+EsWrw/EemxCZXz0sN5cfF6bIH9D/TX+SZfDlNOaz3BWewZF27bKn8JNmJs4ZB
	 V1MA08aWf2O6VbWDBu38z+2GOM05s+Rbt3yh1Jjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Chu <howardchu95@gmail.com>,
	jslaby@suse.cz,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 006/245] perf trace: Fix non-listed archs in the syscalltbl routines
Date: Wed,  6 Nov 2024 13:00:59 +0100
Message-ID: <20241106120319.401530518@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 5d35634ecc2d2c3938bd7dc23df0ad046da1b303 ]

This fixes a build breakage on 32-bit arm, where the
syscalltbl__id_at_idx() function was missing.

Committer notes:

Generating a proper syscall table from a copy of
arch/arm/tools/syscall.tbl ends up being too big a patch for this rc
stage, I started doing it but while testing noticed some other problems
with using BPF to collect pointer args on arm7 (32-bit) will maybe
continue trying to make it work on the next cycle...

Fixes: 7a2fb5619cc1fb53 ("perf trace: Fix iteration of syscall ids in syscalltbl->entries")
Suggested-by: Howard Chu <howardchu95@gmail.com>
Signed-off-by: <jslaby@suse.cz>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/lkml/3a592835-a14f-40be-8961-c0cee7720a94@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/syscalltbl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/syscalltbl.c b/tools/perf/util/syscalltbl.c
index 0dd26b991b3fb..351da249f1cc6 100644
--- a/tools/perf/util/syscalltbl.c
+++ b/tools/perf/util/syscalltbl.c
@@ -42,6 +42,11 @@ static const char *const *syscalltbl_native = syscalltbl_mips_n64;
 #include <asm/syscalls.c>
 const int syscalltbl_native_max_id = SYSCALLTBL_LOONGARCH_MAX_ID;
 static const char *const *syscalltbl_native = syscalltbl_loongarch;
+#else
+const int syscalltbl_native_max_id = 0;
+static const char *const syscalltbl_native[] = {
+	[0] = "unknown",
+};
 #endif
 
 struct syscall {
@@ -178,6 +183,11 @@ int syscalltbl__id(struct syscalltbl *tbl, const char *name)
 	return audit_name_to_syscall(name, tbl->audit_machine);
 }
 
+int syscalltbl__id_at_idx(struct syscalltbl *tbl __maybe_unused, int idx)
+{
+	return idx;
+}
+
 int syscalltbl__strglobmatch_next(struct syscalltbl *tbl __maybe_unused,
 				  const char *syscall_glob __maybe_unused, int *idx __maybe_unused)
 {
-- 
2.43.0



