Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620782;
	b=XuHk0gGKAyeTtgJ3vY/42G9Ul9ovb7dv1/MESBxQ82Q26pTqa41RDpwmVB+gw5/SddxG
	 hXryUyUQHgy8pd1IaNAtxqPvz2wfQofbK3ZKrOrTUBjYnkEi9KXqnUCh5BYXTd5lljutb
	 /H9JNUpKkdl0LyLnI5FDABIE9fpk95nGT/O/iqatHXNszGosMkKamH86XsiXdG8TJxyJi
	 rQh2UkcSXtpTXjnEVUh1gClSLJMUjnT+6bCAZHgcQvYj2+ND4aTuKSbbOCWL1drqz67U3
	 V18ui+p74V4FijrAVhQPegc1myOKZyq8pbrBnFTUYDxeMVwELlxFyyBdwhACsS/Ps1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hkDVFD8OzSAHPa9wPSHMmvgGfDJG14QVZvTTjSDcEGw=;
	b=V8iU8kAwxmRhAZEJJxgqmDx8q3GCQiAhf3kbJrJTbOnATUsvnY/LNoqlSgaWpVN8fdz1
	 ZIcC9l6oJK2N/CS/O45SpQ38fcXWYhqP2ATvc065P+vyLalG2lYwqB23w3NAN3D+H4X9V
	 rl6cPa+WdHCVtt0DqF35dpubIb+d8/Ge8Z0wyQDRoqF8Vnrefd7sVDJo0FpDGN+Rzp6C2
	 ym4EGnN8gr1uQQdxV0iK5E4SrBcxHC31+vjDe54rembjZTTZ5NGxHcbYFdP6XJI56v8Sn
	 LbnVJARfQ+hvVRpVG1AQhpd//4ggJXcNDmXq98HCwAO3PMmY7zGAOm3s3tEAFYIbqMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjdaCgil;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92510606A329;
	Wed, 25 Nov 2026 15:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjdaCgil
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4621F000C0;
	Wed, 25 Nov 2026 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620781;
	bh=hkDVFD8OzSAHPa9wPSHMmvgGfDJG14QVZvTTjSDcEGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjdaCgil5wLqbRPLkbyEZSu7EBFVrvTm13YTsChdgXbZP49dIqu9C+DtE5uEycHPW
	 S46Ijl0SyrFnsNnTHbNTGeZC1mOdhWsZL90uY4qf/KiRXR98EiM+sCM7PeQDkuq35M
	 WIbs4HYkDkdcVyYeXsQ7YrjEoFL8zzcbiuUOGF5k=
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
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/990] bpf: Reject NULL data/sig in bpf_verify_pkcs7_signature
Date: Wed, 25 Nov 2026 15:22:50 +0100
Message-ID: <20261125143822.161164022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c                                        | 5 +++++
 tools/testing/selftests/bpf/prog_tests/kfunc_dynptr_param.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 31afbb74a0523..89cb7e38be764 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3915,8 +3915,13 @@ __bpf_kfunc int bpf_verify_pkcs7_signature(struct bpf_dynptr *data_p,
 
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



