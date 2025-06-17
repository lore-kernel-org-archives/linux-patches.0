Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9DA2DFF09;
	Tue, 17 Jun 2025 16:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176967; cv=none; b=lkmk900qg6V2uz9qyBWHzbSF3eqrojfQvH3+uz06xZ+IzCyptAvMZP5lw5x4PMnxs9dC86SzpzwnCxkFPBkoq5rgUSLTaFkHF9wmV45rwVZK3HL5SKMKIBQE+TttymsSSVDvZ4JWL9IgvgoEMnY6VgMuBBP92V+SLKCbckFYGUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176967; c=relaxed/simple;
	bh=7BgNIIZ9t5UCRHw4BhzAhGP9OxOO4hGzmRPgiIc8wd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCs0XyzMp0GRTA8qfBUAkb6jo4ifQV/uPHcIwUwzOEgSQGPbPAoI8y+1zJh8R1LJds3sZgWZrZ1pmSEfDPFYayZUyXDxblIE+kn7Rs/fyQLA8LGBjKguWV3LlBfz0FaHs7N1Mxl9gPZGddPiZh2zgljRh6X/lI6m98ZO5hy/tXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjrxJkaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjrxJkaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA20C4CEE3;
	Tue, 17 Jun 2025 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176966;
	bh=7BgNIIZ9t5UCRHw4BhzAhGP9OxOO4hGzmRPgiIc8wd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjrxJkaH/1QEwuX1/2V2ADnWbyaNEKFy+wjqiAqIy4KUQ+ZuCXhYz7C28SRMv1hNv
	 eGFdis63JupXVvejj6ecK2atu8BXlhyfn5eCfXc9vaj2/RDT9urAZbQFU5juv8DLRt
	 sQuQi9dX6rAOmD0TBAtzRsMxvH1s09Ncme5Q7fBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Petlan <mpetlan@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/512] perf tests: Fix perf report tests installation
Date: Tue, 17 Jun 2025 17:24:10 +0200
Message-ID: <20250617152431.101141766@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit 4bfe27140edf8dd1322326c79f5ae8d29ff7e43d ]

There was a copy-paste mistake in the installation commands.

Also, we need to install stderr-whitelist.txt file, which contains
allowed messages that are printed on stderr and should not cause test
fail.

Fixes: 097fe67df1aa9cc7 ("perf testsuite: Install perf-report tests in the 'make install-tests -C tools/perf' target")
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20250113182605.130719-6-vmolnaro@redhat.com
Signed-off-by: Veronika Molnarova <vmolnaro@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 8ee59ecb14110..b61c355fbdeed 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -1143,7 +1143,8 @@ install-tests: all install-gtk
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/shell/base_probe'; \
 		$(INSTALL) tests/shell/base_probe/*.sh '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/shell/base_probe'; \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/shell/base_report'; \
-		$(INSTALL) tests/shell/base_probe/*.sh '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/shell/base_report'; \
+		$(INSTALL) tests/shell/base_report/*.sh '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/shell/base_report'; \
+		$(INSTALL) tests/shell/base_report/*.txt '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/shell/base_report'; \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/shell/coresight' ; \
 		$(INSTALL) tests/shell/coresight/*.sh '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/shell/coresight'
 	$(Q)$(MAKE) -C tests/shell/coresight install-tests
-- 
2.39.5



