Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBCE10A22;
	Sat,  3 Feb 2024 04:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933365; cv=none; b=QqHm4sp3vzM4Qiveij6SB2ETt5Q7YzKaSDpVKM3sBOFRKUAHvQBMXjGD4x8E91IvaviUawAcIv8eCRehYW2S6+Bwfo5TyGmhrjFXP1N8I0ekuuCxbWokqqXUEsVNf5jDyzgQfByqgrC6dCtGo5qt2AME/WNbHe5CAjYSeVeTsYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933365; c=relaxed/simple;
	bh=F5z7kZC+dungTs3Fsh2M4450FpADiKLpEIEGpG10dac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP6VYpCU7fZ1klKysbv/W4ttrERVSIBmdv83F3PyUxzsCmwO1SpqiYgxYxFAQi5h68NO4WfK4FD+nYfc2TRVMpefaLmpAcFoD7ESstj1sQAK2qc77lyiba/AzX0Stuwy5hsMABPfW9oDDHLxvzvwSiq2lrWjVEa9kU3V96/YcNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCYO+Tmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCYO+Tmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071D1C43394;
	Sat,  3 Feb 2024 04:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933365;
	bh=F5z7kZC+dungTs3Fsh2M4450FpADiKLpEIEGpG10dac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCYO+TmpEZlzKhX0q1G880cbKLdzSjMObV+Nvy5qy34DP942YFY7+axRLp9IWQDQ9
	 Ey6CmuDDSyaxNZ0fix9U1O6X5mpZsPtryxFWK4lDNjO05zd3HZRplxJntAQdF1y69G
	 cP9Mhi7OapK6ygFzoUhHUa9duQiiEtnjtPGyWhU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/219] selftests/bpf: satisfy compiler by having explicit return in btf test
Date: Fri,  2 Feb 2024 20:03:39 -0800
Message-ID: <20240203035323.121351768@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d711f4bea98e..47cb753ef1e3 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -5211,6 +5211,7 @@ static size_t get_pprint_mapv_size(enum pprint_mapv_kind_t mapv_kind)
 #endif
 
 	assert(0);
+	return 0;
 }
 
 static void set_pprint_mapv(enum pprint_mapv_kind_t mapv_kind,
-- 
2.43.0



