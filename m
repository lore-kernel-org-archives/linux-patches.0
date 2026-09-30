Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA663B3BE1;
	Wed, 30 Sep 2026 19:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795050; cv=none; b=BOcALianeeoCb6UdaFdkQ9c1d+Frl/2I3l+0pAM1Ytte3PzAevR359l5tOEkiHIgtXFf411rmLCdNQ+Jqxwjx47XxWvy3nOW2zriOkhWXyz9JQINUuemn7QEt+uX03Q7CXDc+uozC+bQ/+VtBfBqQDU7EA4m+3XiEKHieGD3OCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795050; c=relaxed/simple;
	bh=n+/MLqT4kEZaOgafNzz7FHcOXvTRL7EUdI2j77r5BdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BxP+uBDMRjLVe/ZfDXddxiSUpBRP07PdFKoYgZ3mprbAR5btoZahxfKdG3DKaIDfelN60I3D3R4NLw/JUxytOmnO1J/Kaprw+sE3INqSkfFijLOhhzQOVlrKs9YZNEonBXVam3+9xdkjoI5TCjSLj1x1SokOTcWAwFeNisEBbTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+eYfHKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+eYfHKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3066E1F000FF;
	Wed, 30 Sep 2026 19:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795048;
	bh=JwZ3+eLM3cQBqLOF/EgxIsVNSb2qKN1ZIv1R4wTQca0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+eYfHKV9vLVCKuAS4GHPwR1GGeJA4j59KRr6bT0mVDshyelj7oc13KtNwQRfCXu6
	 g0PWERcXU3Bgc4mBZOrPZ1b8cN2IoK2a2CG4ZNpw4UnuPvA87z7yQRCrWtyRZc6Y6L
	 JijTLL3uRrG6/b4vv4dAXWNSVMxr4S+zQFjaOfwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0380/1193] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Wed, 30 Sep 2026 17:17:44 +0200
Message-ID: <20260930152442.626527742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit a8c6daab4b0e276508b7ffdd66c60fd3020a9178 ]

cg_run_in_subcgroups() discards its arg and always passes NULL to cg_run(),
turning the (void *)100 from test_kmem_dead_cgroups() into NULL so no
allocation occurs.

This makes test_kmem_dead_cgroups() falsely pass without exercising the
"dying cgroup with charged slab" scenario it intends to test.

Pass the arg through to cg_run() to fix this.

Fixes: 933dc80ec262 ("kselftests: cgroup: add kernel memory accounting tests")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 137506db03127..753e2e0ce28f1 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -144,7 +144,7 @@ static int cg_run_in_subcgroups(const char *parent,
 			return -1;
 		}
 
-		if (cg_run(child, fn, NULL)) {
+		if (cg_run(child, fn, arg)) {
 			cg_destroy(child);
 			free(child);
 			return -1;
-- 
2.53.0



