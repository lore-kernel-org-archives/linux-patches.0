Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024425;
	b=35FGxygeY2Jk6mrUjRw9RNysr1dQgScxSQHuUA9KdD7JxG0vo6Oh4QillmM9kD2gER6x
	 EOj8MxnWWV2hxjmxyFr62l1Lp1CKe0W9kgxlTzcXzHZx+wsY5iasm1Fd82GoiVYsyBLV1
	 VwPI9NX60dcyZdS/RrFYMbfMsLmD5/zeEO+VpSDYUNAEoIWOlieJufO4BBA6uN3ADgaKp
	 lG2plZ1YZlUeQXIdCVoo5KdKpGO4sGCpCcrgqRJuoLWjs7vYjs9K36djbYwMpS7eN/qlA
	 /C+ht50wtbtaN8S7srpn6YuphWXVhpkzCiqIw1rhtKUQAIZuIeaDuS83YW/tLv1z7jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xIuNHRDfbL1MdOhbFUk2ixcvGnqj7XJPoFHwlibCF5Q=;
	b=SbEXq2Qzv0eJxy3cQhVhbqQK5v3c8ggYkwJP8bXwX1S7D/FFOZ/BR4nl5XoURcUJZSi8
	 1CbEQPJFLanP1pAE+cve9BGUJkgWFdjpHm7816or2iEBZuY2RQj+jVvS/j1lapJlKtBDs
	 oqr4oAZv1AWthh4HUJe9nbh8CDnokekj7DL8z/s0aiXL+eH6jp6isNH7qJX4Zi1ST7QMG
	 C246OBkYxqjvCEWOp18AukM7JvO/F08l1Eorr90wdTo6+Vk9BhFiPQ9NR3imjBCNWY+LN
	 +6nGNgyoHL8lcGvht4QCBdU/d8NKevlGSMpAOm4F1aPzPiBbeLS6JxknHgBtPYOYHiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPO78i2w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858BF606A31C;
	Wed, 18 Nov 2026 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPO78i2w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88B31F000C4;
	Wed, 18 Nov 2026 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024425;
	bh=xIuNHRDfbL1MdOhbFUk2ixcvGnqj7XJPoFHwlibCF5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPO78i2wrtUYoT+T1CfsZTQzrGvv5XcVt8yYp1o7jpjdh+1ZcohOvbxiDO0E1wvTm
	 YHt61mnf623JmEmDgnR0iSqn0LaEN81ps6+cGK6rvV4BzOkmaUHwzLUiZoQrv3kKYm
	 +rc7JOfq24Gs0Q30iq6f7i1J1z1sK3pAGBZs6O+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0720/2151] sysctl: unregister tables before freeing bitmap
Date: Wed, 18 Nov 2026 15:40:55 +0100
Message-ID: <20261118150148.174086763@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit 238dfe02fb0a9f72d7fd275d74ce80f13923ef31 ]

The table registered for bitmap_0001 retains a pointer to
test_data.bitmap_0001. unregister_sysctl_table() prevents new handlers
from starting and waits for active handlers to finish.

test_sysctl_exit() currently frees the bitmap before unregistering the
table. A concurrent read during module removal can therefore enter
proc_do_large_bitmap() while the bitmap is freed. KASAN reports a
slab-use-after-free in _find_next_bit().

Unregister all tables before freeing the bitmap so the unregister rundown
provides the required lifetime boundary.

The unmodified module reproduced the use-after-free in three KASAN runs.
With this change, three runs each completed 100 load, read and unload race
rounds without a kernel diagnostic.

Fixes: 2ea622b887e7 ("tools/testing/selftests/sysctl/sysctl.sh: add proc_do_large_bitmap() test case")
Assisted-by: LLM
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_sysctl.c b/lib/test_sysctl.c
index c02aa9c868f21..74fe01de26766 100644
--- a/lib/test_sysctl.c
+++ b/lib/test_sysctl.c
@@ -321,11 +321,11 @@ module_init(test_sysctl_init);
 
 static void __exit test_sysctl_exit(void)
 {
-	kfree(test_data.bitmap_0001);
 	for (int i = 0; i < TEST_H_SIZE; i++) {
 		if (ctl_headers[i])
 			unregister_sysctl_table(ctl_headers[i]);
 	}
+	kfree(test_data.bitmap_0001);
 }
 
 module_exit(test_sysctl_exit);
-- 
2.53.0



