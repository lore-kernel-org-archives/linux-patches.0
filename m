Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE90346EF77;
	Sat, 12 Sep 2026 11:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212589; cv=none; b=Qqvw2aB4ft5pxxnqoktdRh85EiqXVkzwc1GrVrIAk0uW54GnL9ZbQPqoFoMKVPucbhs9OU7U697Gsj2TB/L8P6LMaddgI+iMG26JdfokBBap/nX05Wc7W5qbzV29vKOk4brDeHh4B+W+Y3BEs2MDY3bhOOfaTC8aycKo/lu22KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212589; c=relaxed/simple;
	bh=atZjl5O1UthSX9HIhQ8AJqem44do4QN0uGG0aSHTY58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahf/kXEizGLdDgQcDd1NDsUHg7etNzpUnZuDC0bpKaYys7seJq3EP/jMy91l80JfwbKnmhOBxlYXJ2XAkJs2fMAFuVK9/yTEc8SVr+9W5uBdPxv86bSzCiRp5rkFUr3UBqfoeb664ITnf8LzPKlIgCHBZpH/u0mYkW5v5KUvbNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fh3p3+Oa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fh3p3+Oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BD61F000FF;
	Sat, 12 Sep 2026 11:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212587;
	bh=U/fW50v+cl8EE4Z0XLScSvlIFBrDxoUtLxiq+YORdy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fh3p3+OaY65X0JCRfiGwZDaiy7MhyZTpMppRcPSUNvzcYARFlp0hN5IqhParbfgqP
	 eWCcUfQvAvvmSsVWDsI1Csc2BfzJ6IBT74KuMOTSGOqiwnfRQD/a+UAwLKgd6043AJ
	 3Wniys0a0gcukh2mPItFGOWDV2M9WtWJYCQsoAXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1465/1518] perf tests kvm: Avoid leaving perf.data.guest file around
Date: Sat, 12 Sep 2026 09:00:34 +0200
Message-ID: <20260912065656.695756269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit b3d1dcd02c8cc1da723c1e9a6b74849ed94b6d30 ]

Ensure the perf.data output when checking permissions is written to
/dev/null so that it isn't left in the directory the test is run.

Fixes: b58261584d2f ("perf test kvm: Add some basic perf kvm test coverage")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/kvm.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/kvm.sh b/tools/perf/tests/shell/kvm.sh
index 85089f8c2d48b..5244c3ddfb1cf 100755
--- a/tools/perf/tests/shell/kvm.sh
+++ b/tools/perf/tests/shell/kvm.sh
@@ -133,7 +133,7 @@ setup_qemu() {
 		skip "/dev/kvm not accessible"
 	fi
 
-	if ! perf kvm stat record -a sleep 0.01 >/dev/null 2>&1; then
+	if ! perf kvm stat record -o /dev/null -a sleep 0.01 >/dev/null 2>&1; then
 		skip "No permission to record kvm events"
 	fi
 
-- 
2.53.0



