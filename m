Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E042F32BF5D;
	Thu, 28 May 2026 19:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998105; cv=none; b=ot+xsyIhLaxkuexTyxZSHSk+3V8bX2y0Yvzu5XHT+RhhTOtJSW+S46HtGGp8uO3XcInVhZOUucETWOIGgr/+mjfczGlJsRjewGrUEyvMHP7sFjUmO01/gMNmcKkcrltL01WMibR5FSyzC6e9Tl+yfeipC4GrnJl6HSLMgc67hEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998105; c=relaxed/simple;
	bh=h8cqBhw/USkWzqHOfOwBXhZTqQNtkpjqLpvFfzuRasg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjjgLrd+FIHJrILFm/FFvF95Qw0yEYY7fHDBORUYckcJOMqDL4qZxA/ir/Mq0ngasT63ITqoNrxWkK7ovqBWTMdny0V29eqIp33tR9EfRWxjLe/zQPsGMmXBkH81Z0jEYuX+Gu1+O+ANtKbtFc6JvpHkSTjmS4HAIgnqHntX0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVwojp7y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVwojp7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D331F000E9;
	Thu, 28 May 2026 19:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998104;
	bh=YfSMMGky1z41ITmj83anOuFOV5fATzRijczZ6pvQcNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVwojp7yujYtuJ8mpjPE/weLz1nvaJ+4fxZwhtiB07GJxdxMW9v9GQRWYvo2gUnOK
	 UJL1niKXDMbVF8AefedP/gQjSkDOuA+7Pc6OqSugLTR/DNN/kITlQrZw5T/oU8Shrg
	 O22dxnxuMUTy7T0t+BNntg2YzDbx71jsFbyGWMCk=
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
Subject: [PATCH 7.0 038/461] selftests/mm: run_vmtests.sh: fix destructive tests invocation
Date: Thu, 28 May 2026 21:42:47 +0200
Message-ID: <20260528194648.000757235@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -103,7 +103,7 @@ RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
-while getopts "aht:n" OPT; do
+while getopts "aht:nd" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
 		"h") usage ;;


