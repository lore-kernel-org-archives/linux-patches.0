Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FCC15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uekdYFac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C3CC433C9;
	Mon, 23 Oct 2023 11:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061112;
	bh=P9VR7M285L92vfg2YR4QMp28rh+tasBmgiGMIMJfAYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uekdYFacAPxHH/PK2Dtknmn1gEKPNDXRz0tw6DfWFoP56CufvlCoYxwmJfFYXiw1F
	 LZsSKNl7QfF1+5GZpnwRpILqa+QqU5JX65BWyKkrAVttwIvCcFKtLCjg7+VRI2m+2m
	 YjAQ/Rm9DtfHxLRzeQ3tN+fSMscnbo4r84BADDOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juntong Deng <juntong.deng@outlook.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/137] selftests/mm: fix awk usage in charge_reserved_hugetlb.sh and hugetlb_reparenting_test.sh that may cause error
Date: Mon, 23 Oct 2023 12:56:46 +0200
Message-ID: <20231023104822.667002718@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juntong Deng <juntong.deng@outlook.com>

[ Upstream commit bbe246f875d064ecfb872fe4f66152e743dfd22d ]

According to the awk manual, the -e option does not need to be specified
in front of 'program' (unless you need to mix program-file).

The redundant -e option can cause error when users use awk tools other
than gawk (for example, mawk does not support the -e option).

Error Example:
awk: not an option: -e

Link: https://lkml.kernel.org/r/VI1P193MB075228810591AF2FDD7D42C599C3A@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/charge_reserved_hugetlb.sh  | 4 ++--
 tools/testing/selftests/vm/hugetlb_reparenting_test.sh | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
index a5cb4b09a46c4..0899019a7fcb4 100644
--- a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
@@ -25,7 +25,7 @@ if [[ "$1" == "-cgroup-v2" ]]; then
 fi
 
 if [[ $cgroup2 ]]; then
-  cgroup_path=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  cgroup_path=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
     cgroup_path=/dev/cgroup/memory
     mount -t cgroup2 none $cgroup_path
@@ -33,7 +33,7 @@ if [[ $cgroup2 ]]; then
   fi
   echo "+hugetlb" >$cgroup_path/cgroup.subtree_control
 else
-  cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  cgroup_path=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
   if [[ -z "$cgroup_path" ]]; then
     cgroup_path=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $cgroup_path
diff --git a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
index bf2d2a684edfd..14d26075c8635 100644
--- a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
@@ -20,7 +20,7 @@ fi
 
 
 if [[ $cgroup2 ]]; then
-  CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk -e '{print $3}')
+  CGROUP_ROOT=$(mount -t cgroup2 | head -1 | awk '{print $3}')
   if [[ -z "$CGROUP_ROOT" ]]; then
     CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup2 none $CGROUP_ROOT
@@ -28,7 +28,7 @@ if [[ $cgroup2 ]]; then
   fi
   echo "+hugetlb +memory" >$CGROUP_ROOT/cgroup.subtree_control
 else
-  CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk -e '{print $3}')
+  CGROUP_ROOT=$(mount -t cgroup | grep ",hugetlb" | awk '{print $3}')
   if [[ -z "$CGROUP_ROOT" ]]; then
     CGROUP_ROOT=/dev/cgroup/memory
     mount -t cgroup memory,hugetlb $CGROUP_ROOT
-- 
2.40.1



