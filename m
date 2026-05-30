Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3C629B78B;
	Sat, 30 May 2026 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164179; cv=none; b=JoQ84vRssVvv9DR2wZmFNOMIruO10oXhQnYrH0v5OFW1wdwarYn2O37Fc8vEeHtZYbobgwqiGjM1RPp2iLlnUgK6Bbh6WFQ+rDJxFcx850/6go6zCyzgo4qEY4+k9cqXte7MlzuirCQ/ZfzPG6GeLLwhxsljxlzpi421wcnvmfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164179; c=relaxed/simple;
	bh=wsVAeuoZgGb0WklMAJxbhwun34U5nIZfsU720N/eRqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q51yWmkzalj1Ge8EliMJuqavfrM8KjtoiiFc1RCxc0IQiiZHUi5qobN+R/mLi/xA2DKehUqDxoUu/2aR+uIZQyeElQ13BZ6/S12RB12xJQ2DclsV8a7eNcEWaahBi+fCee3ZT6TIuYMq0pOoe9yUZ5eUclCjXbKm3fRwBCihj/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMACfXqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMACfXqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6961F00893;
	Sat, 30 May 2026 18:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164178;
	bh=rpvhktbKREc8xnV+/GCd1mYZPtP9y2Uj49fQSiBakAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMACfXqxiMY7xBjsEhTPT6Z0vFk/azynzg5w2RHH2UylNX0+tWbkQSw6HsfFXKaKI
	 g/MJrBGpsRjWAemPjGasWdsAwfbIgW3BSB4codCzViWi0pUOJ6caJZiYIvcaBaf5/I
	 MR/eFIioWgMRbzuTvndzSDNt1NOnhhyALjOd6Loc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	Andrea Righi <arighi@nvidia.com>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pedro Falcato <pfalcato@suse.de>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 478/776] ktest: Avoid undef warning when WARNINGS_FILE is unset
Date: Sat, 30 May 2026 18:03:12 +0200
Message-ID: <20260530160252.693721788@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 057854f8a595160656fe77ed7bf0d2403724b915 ]

check_buildlog() probes $warnings_file with -f even when WARNINGS_FILE is
not configured. Perl warns about the uninitialized value and adds noise to
the test log, which can hide the output we actually care about.

Check that WARNINGS_FILE is defined before testing whether the file exists.

Cc: John Hawley <warthog9@eaglescrag.net>
Cc: Andrea Righi <arighi@nvidia.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Link: https://patch.msgid.link/20260307-ktest-fixes-v1-1-565d412f4925@suse.com
Fixes: 4283b169abfb ("ktest: Add make_warnings_file and process full warnings")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index b1bd8be3cf666..d752c4bd0d8b3 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2465,7 +2465,7 @@ sub check_buildlog {
     my $save_no_reboot = $no_reboot;
     $no_reboot = 1;
 
-    if (-f $warnings_file) {
+    if (defined($warnings_file) && -f $warnings_file) {
 	open(IN, $warnings_file) or
 	    dodie "Error opening $warnings_file";
 
-- 
2.53.0



