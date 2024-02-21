Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8D869317;
	Wed, 21 Feb 2024 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524074; cv=none; b=oM+QE4CXTc60ILdHSrZltP+XqcbfG7xsAkQk/T3FdNXm9eGhh7cit2Hxm2sIxCt/duo9Z8AFQrk0W6a3Gm0kpeaqqPJAvUfNpG2kC2Ht042grmzQ/RwxcPcRr1jVjgTr+RMDxeZ2qRlOUYSd7yARV2NWQtkvBzQ6LDg2beTfPYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524074; c=relaxed/simple;
	bh=s1ywjxsZ2JQhtCKoOKSMxxQBxE+wlirqnjIQeucf0zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhHmDcXJdZWg/UvaamMFHjEfBV+H1SphlXyg9bkGrx0jpavcfwSNDCE9vngXdzYo45tkUHsWvFbcKvidez5jncoIk6IyyRnu+kxS/VP05WXj0iHjGX3bWbW9H39NGiE57FWWk8PuUjQgLI/X23Jnmd6au82z+ouC19qZLS2k1JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wpsirc7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wpsirc7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38B1C433F1;
	Wed, 21 Feb 2024 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524074;
	bh=s1ywjxsZ2JQhtCKoOKSMxxQBxE+wlirqnjIQeucf0zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wpsirc7fOd+FzBajy9HvMs4vIBJBOawmb3XK7T+TXAHXiAN52gKrvw6eQM8/ufPSJ
	 52mytzcxLfPm9P7qnZkmXFgdDvvnhWa7ZYKBoZAG3DdRmvadKZtXU/aVYcK4Kf2QBU
	 0HlZvC8CgdgFYoDuAm/NgaTHEUTmrz0GYh2mp5sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/379] selftests/bpf: satisfy compiler by having explicit return in btf test
Date: Wed, 21 Feb 2024 14:05:17 +0100
Message-ID: <20240221125959.011349829@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 28d22265b825..cbdc2839904e 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -4611,6 +4611,7 @@ static size_t get_pprint_mapv_size(enum pprint_mapv_kind_t mapv_kind)
 #endif
 
 	assert(0);
+	return 0;
 }
 
 static void set_pprint_mapv(enum pprint_mapv_kind_t mapv_kind,
-- 
2.43.0



