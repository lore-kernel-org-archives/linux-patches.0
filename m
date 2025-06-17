Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2976D8F54;
	Tue, 17 Jun 2025 16:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178328; cv=none; b=kmjD8OxP41n3MiOVkJ6TLc9YAC37+Lhn2a+3eOV8U9U/MmpmzXiy2JbIxq1U7EuPxIGPgGXFcOArZhgJGiCyzZ+vECaRIq/mpF+Ssh3k6HlAYw0RxH+ztmrCR1wsAB5BVWgBQItawWWCxRJP9O1h1Mtkyt0xwfePFyFk2bE0kZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178328; c=relaxed/simple;
	bh=l6H+MxUwxkf+np03lsdtkPFIwWm000kfO10wx30QTD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhmPChRe/CB5MGkRnWMcesz5TDerHzx7GtHySTBczPoTj4BmHr4y3RbuxQJAaw9Qrzzm3NsqArHgB9z+GCpERtRdLrNP+5UD6K6YRI6iAMeAo1d1ix717LqTUGINznucdBOY5imraxRf3cJYZwia1bmpqr2TeHBJB6QN8vXYjCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qlby7CG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qlby7CG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DD6C4CEE3;
	Tue, 17 Jun 2025 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178327;
	bh=l6H+MxUwxkf+np03lsdtkPFIwWm000kfO10wx30QTD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qlby7CG+c+kj0+IItiT4WdvBZUj68oMKWARLMZH7XTFrEZ+/Aq+U9vUK4o4HObqe1
	 NQpwFuMTayqP4scYBf9qKQxMTJnawWV/lU+0H5cSXzxxlzk2/72BTo8Zv64b29swZE
	 x3LidOjFzoLsTY6FRwx+8N8fh23yuzyLG6eBMWvs=
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
Subject: [PATCH 6.15 444/780] perf tests: Fix perf report tests installation
Date: Tue, 17 Jun 2025 17:22:32 +0200
Message-ID: <20250617152509.536035645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 979d4691221a0..a7ae5637dadee 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -1147,7 +1147,8 @@ install-tests: all install-gtk
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



