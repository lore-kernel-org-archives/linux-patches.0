Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA7D383C7C;
	Mon, 23 Mar 2026 14:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277961; cv=none; b=UrnQeUObbDeASJQOb1qp272M7vcqFuJe+Rw0JzOq5KjGDuQ+z/qHA/l7T53A3JY0obwm/iP4JqIjimlOm55bZnibb1kxT5J09j1Rk2IAhzRpLbEXgRG3exLXt9yyXxQORJG9XSVFPyH07rv9fVIwQix7g0OWYeRvk0052KgdqNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277961; c=relaxed/simple;
	bh=d86DSoqnQg/UahUzA/e10RtoEO+Crc07JrhD3ZcwYVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVVmHLi+ues8Q86sIPW8V8Xxpyg2YE/HpGHuBwW3+qKDW5XhcVUt7hAFVkQMS73XsKIaXWOkc8vSIsprpBQLANtxZ0vP14PN9IKh8pL+LjX9it4cN7KpVbCSx8QvggNfRtV4NzQOtMIJXkvV0HyRB+Is8JYAhuX5ZGJULakrtes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IRX+ddU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IRX+ddU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F0BC4CEF7;
	Mon, 23 Mar 2026 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277961;
	bh=d86DSoqnQg/UahUzA/e10RtoEO+Crc07JrhD3ZcwYVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IRX+ddUiiq0SY/eKg/kXMtxmEi3CCX0d6AJdt72OvEA6hHgWZaIMqqJZrv/AVxZU
	 6V3Oc2gNk98hUxokK675Sf0cuENmj5ZAJBjeF4BFlo75pAxOUCIDN9KHj2GJpPtvHD
	 8KO2eU8A3PAxetSRHCf+3Rd4waMIysoFuZWm+V4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kui-Feng Lee <thinker.li@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/567] bpf: export bpf_link_inc_not_zero.
Date: Mon, 23 Mar 2026 14:41:18 +0100
Message-ID: <20260323134537.733188947@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0af6b2a5273ad..1021156886272 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2231,6 +2231,7 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer);
 int bpf_link_settle(struct bpf_link_primer *primer);
 void bpf_link_cleanup(struct bpf_link_primer *primer);
 void bpf_link_inc(struct bpf_link *link);
+struct bpf_link *bpf_link_inc_not_zero(struct bpf_link *link);
 void bpf_link_put(struct bpf_link *link);
 int bpf_link_new_fd(struct bpf_link *link);
 struct bpf_link *bpf_link_get_from_fd(u32 ufd);
@@ -2586,6 +2587,11 @@ static inline void bpf_link_inc(struct bpf_link *link)
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
index 63cf5a221081b..2207f9e7a5674 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5219,10 +5219,11 @@ static int link_detach(union bpf_attr *attr)
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



