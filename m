Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1047B12CDA5;
	Mon, 23 Mar 2026 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282358; cv=none; b=nVa0TUcCiEsaq0yez2356nAOqOMagHhuhze5umJG4K6LHGaOb1rrpxuaLhiZ5sIxHqMGnnDJqYg+dQztij8CS09xAdMAm+UwVS+PCwDlShdOwitWvddphIZVNyzApdRuHPa2axTir2GpGpLz4R2eXzbIdWYDRUa/N4a2Xqt2RVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282358; c=relaxed/simple;
	bh=vTiKB06/JsN4HvP0zTam/9qz5jo8J5+6fAiNhwUB1kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCtUt92C7yBT2xJNmVLW4Qz8BUFHxK0AdHBjjoB6JUiEs6gqBSCQ1I4NnnPW11i0s1yePaYZHQsq/n46ff7ccyBANGTJMk0yT8aQC/BHwUxj+1aW4h0nQbxoxKe3DQcfu1tCEsRhYuQb87AoYhwTe9HAStBX5tmKVuNUQ+ttQd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjhRzTkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjhRzTkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBA8C4CEF7;
	Mon, 23 Mar 2026 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282357;
	bh=vTiKB06/JsN4HvP0zTam/9qz5jo8J5+6fAiNhwUB1kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjhRzTkHEmxDsxWPtz/zr6hBc36r4kiKIJULn9vg6eu+ChogZWesXk6U8Q1bTRfLZ
	 kk942klGTU1S7Xp+/mFRaHDgc2mQAp0NHHpUj4CiAjf4YWfrjQwS3evd4Et3hRpTFE
	 vsQUg6eHMwyTv40xlvlyoNrm0LCncJ6XmoZnyRu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kui-Feng Lee <thinker.li@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/481] bpf: export bpf_link_inc_not_zero.
Date: Mon, 23 Mar 2026 14:41:48 +0100
Message-ID: <20260323134528.348325269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kui-Feng Lee <thinker.li@gmail.com>

[ Upstream commit 67c3e8353f45c27800eecc46e00e8272f063f7d1 ]

bpf_link_inc_not_zero() will be used by kernel modules.  We will use it in
bpf_testmod.c later.

Signed-off-by: Kui-Feng Lee <thinker.li@gmail.com>
Link: https://lore.kernel.org/r/20240530065946.979330-5-thinker.li@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: 56145d237385 ("bpf: Fix a UAF issue in bpf_trampoline_link_cgroup_shim")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  | 6 ++++++
 kernel/bpf/syscall.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 142a21f019ff8..3045de8e3f660 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1907,6 +1907,7 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer);
 int bpf_link_settle(struct bpf_link_primer *primer);
 void bpf_link_cleanup(struct bpf_link_primer *primer);
 void bpf_link_inc(struct bpf_link *link);
+struct bpf_link *bpf_link_inc_not_zero(struct bpf_link *link);
 void bpf_link_put(struct bpf_link *link);
 int bpf_link_new_fd(struct bpf_link *link);
 struct file *bpf_link_new_file(struct bpf_link *link, int *reserved_fd);
@@ -2254,6 +2255,11 @@ static inline void bpf_link_inc(struct bpf_link *link)
 {
 }
 
+static inline struct bpf_link *bpf_link_inc_not_zero(struct bpf_link *link)
+{
+	return NULL;
+}
+
 static inline void bpf_link_put(struct bpf_link *link)
 {
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b559d99e5959a..ed8f55bdc1370 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4763,10 +4763,11 @@ static int link_detach(union bpf_attr *attr)
 	return ret;
 }
 
-static struct bpf_link *bpf_link_inc_not_zero(struct bpf_link *link)
+struct bpf_link *bpf_link_inc_not_zero(struct bpf_link *link)
 {
 	return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? link : ERR_PTR(-ENOENT);
 }
+EXPORT_SYMBOL(bpf_link_inc_not_zero);
 
 struct bpf_link *bpf_link_by_id(u32 id)
 {
-- 
2.51.0



