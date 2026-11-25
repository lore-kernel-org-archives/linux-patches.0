Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623881;
	b=hG8+witM73gJY+IMReQ0ra36CHcTIO9xaHJutjqw0OFMp6pZDol7e8Tk0n//ng1XD8Fz
	 oLS4Gqt9xC8dun8NJ4xy3lX7vBSzluWsYhN2RtxvvWuMPpM90wITqMTcY3VYUO+KP4xng
	 3CAmP5FoV4E3bDft2txssP7BcoBpnwCZzOLz7KoPtTLNlxtCD7sBE9z39Y3+x7V39gq4o
	 NuzHB8jO29fdO9wJ9vHK6DNBhirTjdm4WyXVv0qA+PUlzGFlS8p7bVQBnOYmb88IISQDR
	 LjsarF4THvZFQjFmlURJOdeiQWbQhJ+uYGKTY7AGLvcT8lM+QBd5FSN4gCIdKRNSzHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PKHXsGcYE+q24dJtoA1kgj6MeEvVpViUK9v3VoxMSY0=;
	b=yVfBxKQP9T66utiRkKrLfG8nInTMllctIbKp4SeFvusJwU+4e8+EK5M29Kyh9OYINI0Q
	 YqO9WzmbmaIdYgRyGlo0iG+kDFcYMusRoRulMZL2D0Knf1gqzkO+joxJ8w5P3PDEVkFYw
	 dJRPhEcHjixRA2KX/XEsoaeOoPqAX6dcL+7OwN2rv4eUis+IvQos26oE1kfZpyLv0rMsf
	 TmP+wrjLY94FnN3vOKEPFhN8NPp6jQDg0VmxwjrZIRwkC6DtUdJGcnsOrAOIAIsIAP44Y
	 WbJVWj2rgQROs7vb4/l/uKWLUjfXQ88y/ROL+9jKUyLjRq371TwhHTNxT7QdRrCg8RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/uhe15w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE26606A326;
	Wed, 25 Nov 2026 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/uhe15w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350FD1F000C0;
	Wed, 25 Nov 2026 16:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623880;
	bh=PKHXsGcYE+q24dJtoA1kgj6MeEvVpViUK9v3VoxMSY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/uhe15wdejeXGRRsXOkQW7jFUHc6yy3z7eXbEEEVZxHrmRO2dMUt4KQFntMe45q0
	 +fct0xR6jXL3lhlQL5PJ/qDcr4seFF21QpveHEAZeLfc6LfMqHj8yYCui27FBbOyK9
	 GPnuMWjVadL7DcVyEH9XNReHIuws55ZkSsD3VZq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianrui Dong <dongxianrui1@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Song Liu <song@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Yingke Xiao <inkxiao12@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/816] bpf: Reject NULL data/sig in bpf_verify_pkcs7_signature
Date: Wed, 25 Nov 2026 15:26:03 +0100
Message-ID: <20261125143849.569943682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KP Singh <kpsingh@kernel.org>

[ Upstream commit 49b18315be4eecfc36b75f4aecb4d40a87d68a20 ]

__bpf_dynptr_data() can return NULL (FILE dynptrs, any non-contiguous
backing). bpf_verify_pkcs7_signature() forwards the pointer to
verify_pkcs7_signature() unchecked, causing a NULL deref in
asn1_ber_decoder() reachable from a sleepable BPF LSM at lsm.s/bpf.

NULL-check both pointers and reject with -EINVAL. Mirrors the guards
already in kernel/bpf/crypto.c.

Fixes: 865b0566d8f1 ("bpf: Add bpf_verify_pkcs7_signature() kfunc")
Reported-by: Xianrui Dong <dongxianrui1@gmail.com>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260520024059.313468-1-kpsingh@kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
[ In 6.12.y, bpf_verify_pkcs7_signature() lives in kernel/trace/bpf_trace.c
  instead of kernel/bpf/helpers.c. Adapt to kernel/trace/bpf_trace.c. ]
Signed-off-by: Yingke Xiao <inkxiao12@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c                                    | 5 +++++
 tools/testing/selftests/bpf/prog_tests/kfunc_dynptr_param.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1d6709e261b8c..a174d4b27d662 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1408,8 +1408,13 @@ __bpf_kfunc int bpf_verify_pkcs7_signature(struct bpf_dynptr *data_p,
 
 	data_len = __bpf_dynptr_size(data_ptr);
 	data = __bpf_dynptr_data(data_ptr, data_len);
+	if (!data)
+		return -EINVAL;
+
 	sig_len = __bpf_dynptr_size(sig_ptr);
 	sig = __bpf_dynptr_data(sig_ptr, sig_len);
+	if (!sig)
+		return -EINVAL;
 
 	return verify_pkcs7_signature(data, data_len, sig, sig_len,
 				      trusted_keyring->key,
diff --git a/tools/testing/selftests/bpf/prog_tests/kfunc_dynptr_param.c b/tools/testing/selftests/bpf/prog_tests/kfunc_dynptr_param.c
index 8cd298b78e44a..04aaf4c9cf5ee 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfunc_dynptr_param.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfunc_dynptr_param.c
@@ -14,7 +14,7 @@ static struct {
 	const char *prog_name;
 	int expected_runtime_err;
 } kfunc_dynptr_tests[] = {
-	{"dynptr_data_null", -EBADMSG},
+	{"dynptr_data_null", -EINVAL},
 };
 
 static bool kfunc_not_supported;
-- 
2.53.0



