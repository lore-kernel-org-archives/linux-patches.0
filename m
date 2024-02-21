Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC523C2F;
	Wed, 21 Feb 2024 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522448; cv=none; b=H6lD445i9HAJyrmLK0BTbahfU12rjXnebph12y/ynRw12/fD3qBwXBYaDm3QYleCU2qfcUBA4HNZvTvWQEXPrNHaV9C+ER/Wt6veEdfDH3eQEkksYTHjPf961aqQG5JOztjmfMmiJ8XTWV32MDvV8dPVH3Re9/ugLYIsIa1521U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522448; c=relaxed/simple;
	bh=F80pyubpp5/A8a8CbqkH4WVTHVMH3bCIfpiH6uWJNGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLTC/ZhyRDDXKsN4A6I9HvWWZDZT2wxJnWIbeVlSqyb9GRxpxyNVudjoiwRyYtpU2UAgS8QTX4UTu2xj3hoSni2VTbgc31M/ZE7VE59JdwQB6BmCqVbK2UtNOb+VZusRnfcHXVVl0pNFiHx5qkUuJtZNyBPyAjJaIHZDEe+nkpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RR8amo+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RR8amo+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820E8C433F1;
	Wed, 21 Feb 2024 13:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522448;
	bh=F80pyubpp5/A8a8CbqkH4WVTHVMH3bCIfpiH6uWJNGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RR8amo+rbqH794CmJWZijLr6GPjqy9uOjjl7V463SVv40aKr4TwcuIhKTJvB2Fyhx
	 /vKB4A/Lx1MPFO1d/tup+7rRRDSYeCxrRpb06W8AakOWz5BBwyXPKCTKPQ8gwWNfbA
	 qo9f6KT0HZuZX3KsyHZQTUoz78USC7DZCpy/9fSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/476] selftests/bpf: satisfy compiler by having explicit return in btf test
Date: Wed, 21 Feb 2024 14:03:37 +0100
Message-ID: <20240221130014.071411306@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit f4c7e887324f5776eef6e6e47a90e0ac8058a7a8 ]

Some compilers complain about get_pprint_mapv_size() not returning value
in some code paths. Fix with explicit return.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231102033759.2541186-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 2a04dbec510d..92080f64b5cc 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -4766,6 +4766,7 @@ static size_t get_pprint_mapv_size(enum pprint_mapv_kind_t mapv_kind)
 #endif
 
 	assert(0);
+	return 0;
 }
 
 static void set_pprint_mapv(enum pprint_mapv_kind_t mapv_kind,
-- 
2.43.0



