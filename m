Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E791A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjQO+/xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F847C433C7;
	Mon,  9 Oct 2023 13:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857556;
	bh=cmTthydeuR5Z+BEtfEjQpswvt661le9/5Cqn2ShugOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjQO+/xqZsz1Ffq+Xn8DoWsnTeELXv6Of1EQa4Od+kTEH9rSDzN6OV8hF5Muhv+ss
	 UBUuCbIwsa4JaonVbLCU7V58TgYZ0GC8JZVdhFK9aIWUroo9CMX6XDtzt/At/lXqP1
	 dYSfqhQH9iTwTCqRRFglCASIbziJ3oa2YCnzTW8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Leon Hwang <hffilwlqm@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/162] bpf: Fix tr dereferencing
Date: Mon,  9 Oct 2023 15:01:05 +0200
Message-ID: <20231009130125.235637808@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Leon Hwang <hffilwlqm@gmail.com>

[ Upstream commit b724a6418f1f853bcb39c8923bf14a50c7bdbd07 ]

Fix 'tr' dereferencing bug when CONFIG_BPF_JIT is turned off.

When CONFIG_BPF_JIT is turned off, 'bpf_trampoline_get()' returns NULL,
which is same as the cases when CONFIG_BPF_JIT is turned on.

Closes: https://lore.kernel.org/r/202309131936.5Nc8eUD0-lkp@intel.com/
Fixes: f7b12b6fea00 ("bpf: verifier: refactor check_attach_btf_id()")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Leon Hwang <hffilwlqm@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230917153846.88732-1-hffilwlqm@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1ed2ec035e779..1fba826f0acef 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1065,7 +1065,7 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link,
 static inline struct bpf_trampoline *bpf_trampoline_get(u64 key,
 							struct bpf_attach_target_info *tgt_info)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return NULL;
 }
 static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
 #define DEFINE_BPF_DISPATCHER(name)
-- 
2.40.1



