Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CE23F8707;
	Wed, 20 May 2026 18:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300721; cv=none; b=TV/S5HeGgKjRXuUmYim6K2t3e6NvjjJbThg0JwloXziDJgYFN5CQn+kyD0OvhyxHi5DTnBx/g1bcZ6qwcWSl/t22axhBJr0JY72kwXMaqwAzgy/gYUSz+sj3h+6dL+D7joZVEYjhejrlBrY/b92SUZHc/ZfTiT9MDOQUTe4Gc4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300721; c=relaxed/simple;
	bh=OSHpTPLFvicpeMkHhA/vd23uPy6epF4FB9KhIm3SAPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6cpcCqPpqoHT1Rgl01odU+ATDNMvJCsR/RnHB1oRyMurjQyKv89DKLTOlS+n5cQT776P/eQ/xR+ztLWYAZkzscHweshWr6y1FrEtl6smHKFzqT6QNTtknEBt/op6wi44AoC+QX48pHUbLldvqkOEVJHmW2keLvwtG5Azh6MxZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iq9Bo6s5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iq9Bo6s5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CC21F000E9;
	Wed, 20 May 2026 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300719;
	bh=UEqvJnXY67gjs7Bfh+nROpMjHoD/C1zOf2XzBb3YlbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iq9Bo6s57KwYZLsqkmqFfeOCaA4qO0IGfeqIc34ySlS9iNoqFRxsZUIIAqR8nkv8v
	 3ue+UwM15qcufDgDIfbIndqtL+B1cBda7XfWBuuuisAs++Xpele7kBSMQAcXYdPBEj
	 m/s04sL+z70sV4rCyi2fLjMSqilTIs7v1uL0hqsY=
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
Subject: [PATCH 6.12 255/666] ktest: Avoid undef warning when WARNINGS_FILE is unset
Date: Wed, 20 May 2026 18:17:46 +0200
Message-ID: <20260520162116.743459086@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3242a216af9e7..b18ea351c8b16 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2483,7 +2483,7 @@ sub check_buildlog {
     my $save_no_reboot = $no_reboot;
     $no_reboot = 1;
 
-    if (-f $warnings_file) {
+    if (defined($warnings_file) && -f $warnings_file) {
 	open(IN, $warnings_file) or
 	    dodie "Error opening $warnings_file";
 
-- 
2.53.0



