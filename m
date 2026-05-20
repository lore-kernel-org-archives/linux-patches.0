Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77A9369D64;
	Wed, 20 May 2026 16:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294828; cv=none; b=HyC+TaX4y8HWL52oa8xd81bwVqMLUxI6z0VKydQeY1tRTKyGLjXZO1zQiiExq2sVZGZYnzy6C2x669xuoHC/eojZSook7/Myop1cjXi5A0bUJkVDbI7ndX5YwnxRd9JhEcJBmOz8BHNY8vZjDnF2Z1mvvYqrrRAlhiWt3iaFH08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294828; c=relaxed/simple;
	bh=LBnOwHsDPHBFexkxCiATzBVvc/OB3TIGhINyl0vn4H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvNMi9X5uuYkAGXnHNEE2trSbMMIpZiojL3m52EG4rt8NUmWcv7xhf4JKmVG4wp1BqgS4QgvoLggr6rncp4Bly0DGKncQcnrVV3X0tqWvie0Gju4cYWjsJlQpFCy9xrJmA2dNtb5/tCz9/vkhrLvv+kH/+TdHkNMAvYw7/l4Mxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPt/4VVH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPt/4VVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415531F000E9;
	Wed, 20 May 2026 16:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294826;
	bh=i7naAkZuYMo65msR3sCNMHrLY49XkiCHCKQ8287dfr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPt/4VVHrE9HhqcOqwDMiJ5aw61QcM1PH1J/HcpQZ66YK1kg7/u9i9d5/OnOqHM//
	 YhESvgpuSJrzAfneimNfHg1o5vivgY2O1BFjoSbgp8n7i87nlv1j1QSJ+FO7hrALj8
	 xulNx/TUzqZ2O20CZD3cYvdahUenNY2JcxR2nPnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0187/1146] selftests/bpf: fix __jited_unpriv tag name
Date: Wed, 20 May 2026 18:07:17 +0200
Message-ID: <20260520162152.508032733@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit cdd54fe98c00549264a92613af6bb0e9a5fd0d1c ]

__jited_unpriv was using "test_jited=" as its tag name, same as the
priv variant __jited. Fix by using "test_jited_unpriv=".

Fixes: 7d743e4c759c ("selftests/bpf: __jited test tag to check disassembly after jit")
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260410-selftests-global-tags-ordering-v2-1-c566ec9781bf@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_misc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_misc.h b/tools/testing/selftests/bpf/progs/bpf_misc.h
index c9bfbe1bafc12..1cd783aec11ad 100644
--- a/tools/testing/selftests/bpf/progs/bpf_misc.h
+++ b/tools/testing/selftests/bpf/progs/bpf_misc.h
@@ -140,7 +140,7 @@
 #define __msg_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_msg_unpriv=" XSTR(__COUNTER__) "=" msg)))
 #define __not_msg_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_not_msg_unpriv=" XSTR(__COUNTER__) "=" msg)))
 #define __xlated_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_xlated_unpriv=" XSTR(__COUNTER__) "=" msg)))
-#define __jited_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_jited=" XSTR(__COUNTER__) "=" msg)))
+#define __jited_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_jited_unpriv=" XSTR(__COUNTER__) "=" msg)))
 #define __failure_unpriv	__attribute__((btf_decl_tag("comment:test_expect_failure_unpriv")))
 #define __success_unpriv	__attribute__((btf_decl_tag("comment:test_expect_success_unpriv")))
 #define __log_level(lvl)	__attribute__((btf_decl_tag("comment:test_log_level="#lvl)))
-- 
2.53.0



