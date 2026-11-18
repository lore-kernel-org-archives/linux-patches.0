Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026292;
	b=aqMzjaokW9iG5nzgLu6W4Qtjg1HjKyhmJgxpPhpWFsD6X0gLpVsISgePDr8wbawvSQRk
	 SNtLBVhoE93oHn5byf+c0Lr+vGvdTiXbzc7cE2IlQCncP4OGT86hfm/TmpAXr1HA6Fn0O
	 MG0ZT5VqLARiib42aZG0yadLn3g3xVFPcPIemNbx6VifR4xH5+qSwETIV0jESVngpOwpb
	 JhvenrOB5uBMcLOxLkwukrWWI34+30pa1+gy8UDfVNOAHHncThvrHPJJOFRb5dd0MPRmz
	 13v5DHZXyg3yl9yoaCEpwxRiV4nRMYsACCJctmx/DTDYTbscqSVaq7PJiHZwntH8BQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gg4zJBhkZID6dcRwaR7VDVQ8QXHt4Dvi4NvD7ORARS8=;
	b=OSbH6mZWZcEIMJD3Wl0L9wGKCCLNS2atnzUQsagzhDfUX3zLUbvSsUentcuV00LHC69d
	 NVCTRmu//RTGqAjIPqKBpEK7mvnTHJQb+HCdFeRnADBUiA5pJ8yYZB8Efmu7KcomiIuJl
	 76QxTVQ+VGYY5iuZP7VMqjsi4xdSwmU3xPLDn+vCbyxQjs/9ad7wu5HOrJUwm4nYFiRQo
	 CcYhtdvfPopEycq6deCl9F7NVeZ4SfoRV5KeHuzQZR74xysvdZH9Gox3WQHrODCuLAaTT
	 fYYmpiW3dR3VfLaFtaLUl7UI5xL8xKSsj8mQyazrMj+bMeyVwcFdTc26unwR8vsS+MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyUqVaus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8632606A325;
	Wed, 18 Nov 2026 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyUqVaus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2718B1F000CA;
	Wed, 18 Nov 2026 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026291;
	bh=Gg4zJBhkZID6dcRwaR7VDVQ8QXHt4Dvi4NvD7ORARS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyUqVaus1ALgpSRL3N8e5DwVry25fXVrLG7o9lHCJidCL0pR0s9+FE6MQiu85Jpuv
	 DJ9rjrV4mQB9qowfIkHoMyH0nkEmHLs4s+OsZ/Ikfcew8kYuA6iRcSiCGGo46Jdscz
	 N2XL7B+ic4xFuF83mOUSg0ZEwhVWwRLZTLI1ITVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1376/2151] selftests/damon: stop kdamond on error exits of no-op commit test
Date: Wed, 18 Nov 2026 15:51:51 +0100
Message-ID: <20261118150212.139579640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

[ Upstream commit 65c7e923ed1afa7329f8b910327ebf6ae10a5fb6 ]

Patch series "mm/damon: misc improvements in tests and documents".

Add various improvements to DAMON tests and documents.

Patch 1 and 2 from Zenghui Yu (Huawei) let DAMON selftest to clean up its
state and output after running the tests.  Patch 3 from Eva Kurchatova
makes a few selftest be able to run with Python's safe path mode.  Patch 4
from Kunwu Chan improves coverage of DAMON kunit tests.  Finally, patches
5 and 6 from Liew Rui Yan clarify and fix typos on documents for DAMOS
quota behaviors.

Below are notes that can be removed in the final commit message.

This is a batched repost of DAMON patches that were individually posted.
Please refer to each patch for changelog.

This patch (of 6):

The sysfs_no_op_commit_break test starts a kdamond via sysfs, but its
error paths (e.g., drgn not installed) exit without stopping it.  The
leaked kdamond then makes subsequent tests, e.g.  lru_sort.sh and
reclaim.sh, skip with "Another kdamond is running".

Wrap the post-start logic in try-finally so that kdamonds.stop() is
executed on every exit path.

Link: https://lore.kernel.org/20260914141952.91465-1-sj@kernel.org
Link: https://lore.kernel.org/20260914141952.91465-2-sj@kernel.org
Fixes: 10725cd2b09a ("selftests/damon: test no-op commit broke DAMON status")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: GLM-5.3 OpenCode
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../damon/sysfs_no_op_commit_break.py         | 35 ++++++++++---------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
index 2c65cffe6b545..81774ddc55ac4 100755
--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -47,26 +47,27 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    before_commit_status, err = \
-        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print('before-commit status dump failed: %s' % err)
-        exit(1)
+    try:
+        before_commit_status, err = \
+            dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+        if err is not None:
+            print('before-commit status dump failed: %s' % err)
+            exit(1)
 
-    kdamonds.kdamonds[0].commit()
+        kdamonds.kdamonds[0].commit()
 
-    after_commit_status, err = \
-        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print('after-commit status dump failed: %s' % err)
-        exit(1)
-
-    if before_commit_status != after_commit_status:
-        print(f'before: {json.dumps(before_commit_status, indent=2)}')
-        print(f'after: {json.dumps(after_commit_status, indent=2)}')
-        exit(1)
+        after_commit_status, err = \
+            dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+        if err is not None:
+            print('after-commit status dump failed: %s' % err)
+            exit(1)
 
-    kdamonds.stop()
+        if before_commit_status != after_commit_status:
+            print(f'before: {json.dumps(before_commit_status, indent=2)}')
+            print(f'after: {json.dumps(after_commit_status, indent=2)}')
+            exit(1)
+    finally:
+        kdamonds.stop()
 
 if __name__ == '__main__':
     main()
-- 
2.53.0



