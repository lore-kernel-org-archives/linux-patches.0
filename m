Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE22369D4E;
	Wed, 20 May 2026 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295514; cv=none; b=FcL6Duap3dm5NLxeHQe9lCjsV4WL0D/PNJRXQyEHVySCdXgGmXeFDXOx4zRrdxnE/Bog7R9tIadF8akO6mepeWFqV+9Jx1ST5gYz7VMT80ZNamtTR9D6b9xlT+7/Gws71ECfSvpm0aoSOEk9M+J6pH3BJsCnOEUZCGYGG1WbQtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295514; c=relaxed/simple;
	bh=9Os9toDZ6USY7j1saS0mS51c1AU5Ffwr1yM64reuoZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OfXv8wd32srE9oUhS/8PkLSnFsJFS3j4dHyAiCZ9P0MgP8yQ4850vnhbkldexsk1VyDWUxYJlRVDgUagOj3SnsbggzUbspuPtVpuH0o0lwTM2wkqAEZkg751AtJbGLuizCLuzBGfmNz/G0gxHCiu0hjBGGKDr7bhLjNuyTB7Bpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AInr8E85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AInr8E85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A051F000E9;
	Wed, 20 May 2026 16:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295513;
	bh=hm4YumpZbBT4n0L93MpQ36eRq7rJFtZAb4XbnhJsMJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AInr8E85VxrIgrZMZds8Hh37aQukcyQNnJfUhHFAFJ1gMC34em8hjIjqgNNhM/WpK
	 DHe3W8ClWSouxy9/X7Yks2k9qfMqXjkFZG03K3tpNmOy36sincq7y51AcKOWQHCgv4
	 wEd/SxadNDDulBnIp+kKj5zbkS8bgkg7N79zRPso=
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
Subject: [PATCH 7.0 0448/1146] ktest: Avoid undef warning when WARNINGS_FILE is unset
Date: Wed, 20 May 2026 18:11:38 +0200
Message-ID: <20260520162158.338195841@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 88de775097fef..28643812184bc 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2508,7 +2508,7 @@ sub check_buildlog {
     my $save_no_reboot = $no_reboot;
     $no_reboot = 1;
 
-    if (-f $warnings_file) {
+    if (defined($warnings_file) && -f $warnings_file) {
 	open(IN, $warnings_file) or
 	    dodie "Error opening $warnings_file";
 
-- 
2.53.0



