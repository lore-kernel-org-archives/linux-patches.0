Received: from bg5.exmail.qq.com (bg5.exmail.qq.com [43.155.80.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3684ADDAE
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 14:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.155.80.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336782; cv=none; b=dBF/K36yu9QhinJzJwJqf/wNZ0kjOnCgL/JIGuDH1d8la3mgLJO/Cf+jfJ4oavLfM2wEsWqqALe/XORIG6EiAyo1YEVkBzKn/MfY1DZjOE0/e8XRIX365JwJuTGir+MuZWxcNSIxt6OUzZv6KgqH6rHM//wPH+0tSQK7tzV2f7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336782; c=relaxed/simple;
	bh=fmId3A+vbNouxAm1WBOyAM8a3dwwOc3CAoO8LskLOUo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gLNGwsgbXbkUhwn+4sN0N9WGG3GvGMcdFU9ZIknTGH9Hdm3KR/ZuVCqdLNtGtyUqb9CCzv4lsuzIBHgMraHqzE3JCowNGshEQnCvWhcpUYfwMRxItB5t7Fifp+g7jfuUE/K6+q0AdJGNqzLEBB9+33WlEnRR4iyfCrAC52upuAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=jt6HIV8y; arc=none smtp.client-ip=43.155.80.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="jt6HIV8y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785336728;
	bh=DXAJPscoB2zLOiCsnCwrT5qLcfUxpcEX2BBTbrDPvR4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=jt6HIV8yQgBVXFdi4UiN4ixfkhkflln92CF53LY7AzCcv3Oi2mUOwgq6PrQU9/O+o
	 rZNOkyIrAPOjmoEPzMmntOdJxqhVCON1KG1ch0jCLJOjYwmEFlJ0Aj7NSGgVTZv/MG
	 5EnuZBsq2238OD0eEAjW7tAjncF6wkFnP+qHj82Y=
X-QQ-mid: esmtpgz12t1785336722t213ac178
X-QQ-Originating-IP: x71DZbKtd5Es3UfvGpXOz592NwnqJiClUK1mJaGg9qw=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 29 Jul 2026 22:52:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5242705765587433280
EX-QQ-RecipientCnt: 9
From: Wentao Guan <guanwentao@uniontech.com>
To: sashal@kernel.org
Cc: andrii@kernel.org,
	ast@kernel.org,
	gregkh@linuxfoundation.org,
	guanwentao@uniontech.com,
	kpsingh@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	xukuohai@huawei.com
Subject: [PATCH 6.6.y] bpf: drop bpf_lsm_getselfattr from hook list
Date: Wed, 29 Jul 2026 22:51:57 +0800
Message-Id: <20260729145157.2065278-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260728225520.stable-0003@kernel.org>
References: <20260728225520.stable-0003@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NrLS4o1naR9Iq6P8tBv47F4Q2HNUNEYdu0ZNQuTjm2w56kv3wYxYUoUk
	OiiDHy9WmLPv2q0c/TuRYZZeE4HeXvnP9iHnfMgdY+8UCnHacP95VRVLkxfpu75UozU4ZiV
	asuf5ydflqQavwoNFJTyIo4Qcf6Ro96oJ3Nepvw2wGASFTAhumN3THlll0p3A7ClBrubnBL
	+Se6siEVd7o6Ek50oVyNe1/PmQgZZj7ulqzGsdsF4ANNlbT4fXg/19Hxrnnk3/UPNn4u3zF
	qpClSIvWCjNZLc8YcG6dXjvGuiXl34Wtt6mUv6Gw7qYPp7ITMlx+SVXxQ58Y/0hnDv5D3ZD
	nV2QAd6O17h+HC8+ICZRVHaKluCX9qBTdPbYavZenQQSvpFBoibbjHDQpfBsx5gP1k6djnO
	QT6ALMOHQKfXChvr4N3hnsjdAJtYH7eHuOK7vRNG9obxMsnhC5RQlhTlVfrWbkaTdkAP54g
	DQYGRf+UfbY3alIJCU4VMRB22Hxg4motMuSLXmnmLJGpRb56NJa4CTpMnJ5PSH09+qoRRVJ
	Gx6YjWPceAZBPG1SF0TQgvfmLXqkTxRvnBLT8jpp9JoW+IcCZP4aToheajHD/02mnPsRR1f
	QqWRdz/8C54PV8MzV02lQCMnlpRzCc+MYtJ77Mt6d6j0uaUllZZehGM7Leja2lvHhKT9rWA
	0ov54uoDC5yeHmLbxPB0VYbtYdBe2PKziaKID/G3WWvqw/yzkJemJ0v/cni1Wf9xeSZ+NRr
	ZuakZnw+OKr3+zdBqI+9KLm5zGjxklruGlKyzOaGknd1aZas223sEcqLuaw7dYvo80FDyNN
	yzs/QIM0co7iGMtJVvTXVwqHmCopqQxhmDFnV7VlGjBoE2wR07TsATmjfdD6qisv1EnIW6r
	4Zwqhc5G3CIfQYbS9zTuYNNQKrjyOL4+RYMwA5l4R4xRzUINWyVJnKkaMKbvMD2Whahf1pY
	ZAyKZwDhZv3lNo/Zc00bg4/l1/39/3usB/EXCxcjkhy53yAPU0frJU2Zx/uTAuSd02XxHHJ
	eySnRjCZUrPRH86OpLZ2v/T5GSkcjyRQ2jkZcZhuoFQc3o7Ctxqy7fY67k94Xfplnsh7L94
	l/NvWpj9vvbhesmc2PFZGxmYqN0a336Zg==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Backport ("bpf, lsm: Add disabled BPF LSM hook list") for v6.6.y bring the
warning "WARN: resolve_btfids: unresolved symbol bpf_lsm_getselfattr".

The lsm_getselfattr from commit a04a1198088a
("LSM: syscalls for current process attributes"), no need to backport
the huge patch, simply drop the entry to fix the noise.

This is a fix for stable v6.6.145 backport commit, so no upstream commit.

Fixes: b3b4719429d5 ("bpf, lsm: Add disabled BPF LSM hook list")
Link: https://lore.kernel.org/stable/20260728225520.stable-0003@kernel.org/
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 kernel/bpf/bpf_lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 147c3a8ad4e8e..984e944a0221d 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -42,7 +42,6 @@ BTF_ID(func, bpf_lsm_inode_need_killpriv)
 BTF_ID(func, bpf_lsm_inode_getsecurity)
 BTF_ID(func, bpf_lsm_inode_listsecurity)
 BTF_ID(func, bpf_lsm_inode_copy_up_xattr)
-BTF_ID(func, bpf_lsm_getselfattr)
 BTF_ID(func, bpf_lsm_getprocattr)
 BTF_ID(func, bpf_lsm_setprocattr)
 #ifdef CONFIG_KEYS
-- 
2.30.2

