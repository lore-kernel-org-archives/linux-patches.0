Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2153B0591
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 15:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785337957; cv=none; b=W1eJDxmPxNI4ro99o4lr2jF1tOmes+WLEimvAyf9cP5xYW2qIS/D+ReSNW/omrnnf5hphbgtN7dKIrjrznTR+F0NDThEVGDj5iD34nHGhigQwqGqUQ3dd2KFuWScoSPmHZCCXrvMSA7xuq1bVK3AvD4Ikv6yMgWN0Yz8Uz9JB4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785337957; c=relaxed/simple;
	bh=GcEDxDp6slVuFh2pmvm2AEsvTEGURrkovVjDgj0eAIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QzdAF5XIgHlJ74A5d2P6putxkmMYd34P+JRtIfd2A2Wl/RXAFIR8ENDH2PS3eciBo7X6TMVOhOn2Jx9JjNpwwbVyupxcjNVUsj8H4zGQJarIFlmXtj9PvIbF5fhK2dJ5Ja4049e3ztu6micSoviFgdiTDdQ/UMTgp3qZIASfWBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Hoj0pKg9; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Hoj0pKg9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785337922;
	bh=P/fIXLskanWs6kH9duIS/7KIdhQyN0wEgI7p81+xflE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Hoj0pKg96hMkYO/sE5mSZTxHMDg4+lhOEPBAOAsUxvQWW0B/uIZvWJDslgnvIO81Q
	 XzzbFknJ6uoUs+x7DKJyqTAnq3frFhiHHjWLbrAA4Ew5OUTg2Mm4REkzZm03gkdF21
	 vi1msI5A4WttB1w2pLCbnoWyYVEEpJk9FvdQHxd4=
X-QQ-mid: zesmtpgz5t1785337915tf7fbfa8c
X-QQ-Originating-IP: rUWNejuX26U7v14AHwkaCDb5SEexKPdzkXwiatyzzMY=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 29 Jul 2026 23:11:53 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14402103827723616478
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
Subject: [PATCH 6.1.y] bpf: drop bpf_lsm_getselfattr from hook list
Date: Wed, 29 Jul 2026 23:11:51 +0800
Message-Id: <20260729151151.2069645-1-guanwentao@uniontech.com>
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
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NvIr6BtGSx+/S0s4k6wnsgQILDoUswjc74C2BhfPS2H+23LO9m/wTLii
	fc03X3imW22E85MvAIr+5xL1zTX/IkaoIlTt4YNOVWFBPKa1uZ5kIob2LzB/YJDj3cil0nj
	CaSDNt7GxG91Tw0Wq6IGRmCSt3tRueDuptQ865/eL+MAtbvQYqm8+gbudOBeR8NoLu1E9Z/
	5iVzvov9UkzMKZwzm/e0OAQchvbzqdyfnqJM/z9fNit3Vqubqx4hrfQURJ90ZlQ2u+V3wAy
	U6gK641pk/C1VeT6Lpcbusc1bz9oK4jmMrkFfdLBjZw6CHJ9xmTrfgkvKo4Km03fQTH7NYY
	OoDSOdLZXnPDcCp0UNPXNYfACsrxbmfwDFaTk6qXR3Y7WT6NCV0Eai1BcrJUjheIA4mpwzI
	ezvBr/28sdFMjpWtXuTBBopxyYhzkom/yKG/9sEOUSsosgp0C2Jy8xp7NhL+CevyxPexFSC
	X5srTfoZ66wdRc7CyPI1bIfUb8rRtdKJEmu5EVBqT2nYkAYIw9NvkYMDY6cmFe1qrnaCkBV
	6EzhOOvVBmeWYzTiPSgmgQzG+buQxjpge5W3HTKFGSxNL2N9davnCbRVd/O8qbA8RSlAXL0
	E5IVhvurXEj75OWBC2C9fkx0/NKL90Uxhey4jxZ5hSjRWAYEgpNcBnBqs+raADOB2/dJqs8
	pEstEY8lKU2q9udymyveb9kAr3R8/44svcxUUPky1olg5MrpAHh0y8JOtWafbdUuqqo/jca
	EDLCrMkoFD9ecPjzvFKCKZ2sOMcaJQ5Q1lWTblQnQ6zL/KvlE7OL4hLFrQQqSjUc0o7F1Gx
	qzAkQVfc6TntvglqtLOrKTEXmo1n6/DqGH4HYydImLKx/TszmRV0cjEukqpguUR28VRpva2
	LodLGN5J6aEB4UtmOTONjapNvFB8ug3ynPvAZMZleicprk6N6ElyamWp8SYvW82lwO44XKt
	1Y094gvqK8gVnKAjj3PgXYUDDUi49hxPVSmEuSlgKG8w+KKUJbLdo+0sY2c4tNyaHLzBNOb
	fa5lDFd5/gNNlnCR6pvBs5dTNdzSiCGVEa27Y2InEHxIT1TIYSaLDe/bB/cV5SB5XjeigSp
	ftldIRteZE0mVrI/Ty5Ef4UwailkrVsu5b/yqSYTqEvjSguFQnqwTIlRIdqG1R6qeQgQOh2
	ipclE64VuNat2pZux4A0bUC363oTYlSao+dbMO2peMC56xSsk8LD0yE+HA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

Backport ("bpf, lsm: Add disabled BPF LSM hook list") for v6.1.y bring the
warning "WARN: resolve_btfids: unresolved symbol bpf_lsm_getselfattr".

The lsm_getselfattr from commit a04a1198088a
("LSM: syscalls for current process attributes"), no need to backport
the huge patch, simply drop the entry to fix the noise.

This is a fix for stable v6.1.178 backport commit, so no upstream commit.

Fixes: 0562ae02a6c4 ("bpf, lsm: Add disabled BPF LSM hook list")
Link: https://lore.kernel.org/stable/20260728225520.stable-0003@kernel.org/
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 kernel/bpf/bpf_lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 4bb8c363c0bfd..61e93253b6b5e 100644
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

