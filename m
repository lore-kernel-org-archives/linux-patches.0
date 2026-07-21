Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDB024A078;
	Tue, 21 Jul 2026 20:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664592; cv=none; b=XVGr75prMN1ClUtpoCkXTr5yMWpNqayWzgnNPolBsDcf0omA+5MB+zxOAT58F5bbUzQ9/NLY5PK88eMZ3l6jH7SH/uyL0FB+HrIgv7azTI5bx0AKOHSIH08XONyKpiWCD6Non7rYfBqV+Kq4SvJx3Uh8yYAlTjbBPvVO2k9NNFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664592; c=relaxed/simple;
	bh=IlWl67JBGD6kz/mHopju1eub8LVyarTZuD9tgi+2sYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVCq48XZv20omn6UMpQPmWJRQdAV0AJ4kpzkjSJchruJAKbrKLJ28lyZ8++LFr5hdc0gjETHmdb6ZU/VhOOAI6xygRek1aQI0o7oc/vUMhvFPsHx4KOlejjESUcMhSwBXC+Y2dEvh9F0ADad0n6L2rn5sRGdfKne/GgVtxPul1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVwjkHnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVwjkHnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE931F000E9;
	Tue, 21 Jul 2026 20:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664590;
	bh=OjQ/GGbFxhFotARcJ2VqoJ8Ju3TONwG6BlmakdwcqDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVwjkHnxc2J+eMqh4MkJQJnFB1xqc//yk21sSGHLeAq8cposYE9gMvIghdeWwW6aa
	 z21tQS51upawjGBscxynuvugr5msApdKxqxWSlBc2NuTPB8RJmROnzMhE3f4hQytla
	 qUT7toT5z81ZZF+LnGVOq8PtfRnAcgjwfd/hKMEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.12 1259/1276] perf libunwind arm64: Fix missing close parens in an if statement
Date: Tue, 21 Jul 2026 17:28:22 +0200
Message-ID: <20260721152514.266602439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@kernel.org>

commit 1293dacbbd43ab9848ac4655f6f2ba1dcc5a96ad upstream.

While testing building with libunwind (using LIBUNWIND=1) in various
arches I noticed a problem on arm64, on an rpi5 system, a missing close
parens in a change related to dso__data_get_fd() usage, fix it.

Fixes: 5ac22c35aa8519f1 ("perf dso: Use lock annotations to fix asan deadlock")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/Z_Z3o8KvB2i5c6ab@x1
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/unwind-libunwind-local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/unwind-libunwind-local.c
+++ b/tools/perf/util/unwind-libunwind-local.c
@@ -371,7 +371,7 @@ static int read_unwind_spec_debug_frame(
 	 *    has to be pointed by symsrc_filename
 	 */
 	if (ofs == 0) {
-		if (dso__data_get_fd(dso, machine, &fd) {
+		if (dso__data_get_fd(dso, machine, &fd)) {
 			ofs = elf_section_offset(fd, ".debug_frame");
 			dso__data_put_fd(dso);
 		}


