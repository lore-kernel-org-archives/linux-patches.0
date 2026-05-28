Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7082E92BA;
	Thu, 28 May 2026 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000480; cv=none; b=rGpYHb2tzuuDCqJ9a7/H7G+vncCTuk1Weaf6EFob/Ka8qtEi9K0w/dF0f//zBWds0onAbuDPTJXlVOTXYnITpcF45YkeTEBXvLo7QwPjjiR4zTeuSJuGt5KCgqIRZiboSCh8zBNoZhBAgch83jebiufxj83jpAr3lYj9hCoSebY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000480; c=relaxed/simple;
	bh=h86aWZTm/nq5vxl6sN70vgdkWZ4UzRTZfv0mBIdZJaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0IrZ3NcuImS+7F3DxiSPC1i8HkLAhQ4VxypIiD5jB9pyEuhMLwdcCuNK/kPE1etmnXSIYpgPVbwP4Lbe9zh8CtaVeaRbcWLJEfQbC6Y/bu0cw5Yd2oo5BniasLvmR7BX0dOOtEVQbP1dJ5Zr6dOgCRteq61PLtMGS1/pbvGoZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJSdPtho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJSdPtho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62281F000E9;
	Thu, 28 May 2026 20:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000479;
	bh=RxtpDCpNFN0+Lhsachb4c+wMg2k2vU/y36Q+EPqs3ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJSdPthodi+WlVXgFtPNVLNmp+yyY57V50InNp0Q+6HkiP64R77Oh8Zdp+6lCD8r/
	 gouH+DPv0rzUkD4RgQGwcvPQi3JOSNtVh11vMSBxlR8vj7Q57dbT57TLmKv61qNp1c
	 xwVJhbvcIAvMMADvCwNGlcEJjduVlUy6NamCTois=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Capitulino <luizcap@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 060/272] selftests/mm: run_vmtests.sh: fix destructive tests invocation
Date: Thu, 28 May 2026 21:47:14 +0200
Message-ID: <20260528194631.059408249@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Luiz Capitulino <luizcap@redhat.com>

commit 3432cbb291aabf85f8af4b9d1ec37179168ff999 upstream.

Destructive tests should be invoked with -d command-line option, but this
won't work today since 'd' is missing in getopts command-line.  This
commit fixes it.

Link: https://lore.kernel.org/214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com
Fixes: f16ff3b692ad ("selftests/mm: run_vmtests.sh: add missing tests")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -85,7 +85,7 @@ RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
-while getopts "aht:n" OPT; do
+while getopts "aht:nd" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
 		"h") usage ;;


