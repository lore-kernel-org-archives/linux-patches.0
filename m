Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99928339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIXo+w3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1111BC433C8;
	Mon,  9 Oct 2023 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859067;
	bh=aVDexnKZYqR6LQ0YjYU0jP8Sm3byVMNvIlf4klZ8XkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIXo+w3TqS16C9Zk3ku89PNF+wVbdXtNiUIiuyCmGC8JpzHb2VyqyvVGafdOddCKm
	 wWBkO59u2GnlCfiotfGUn962EyvETQ0EXgCuaqVvT+oKM47x9eaAIVAnzWqSIHi7E0
	 HuICOWgd3XsDgGgJRLkGRyuWz/a7vs8vhnvrAEiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Leon Hwang <hffilwlqm@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/226] bpf: Fix tr dereferencing
Date: Mon,  9 Oct 2023 15:02:30 +0200
Message-ID: <20231009130131.553125311@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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
index b010d45a1ecd5..8f4379e93ad49 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -725,7 +725,7 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog,
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



