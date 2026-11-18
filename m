Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032400;
	b=jG8yUukQJwTqdpeQxici3lWSI6zMzUYwSQXpvfT3e4+ZsiRzoBtX5FArXJCsP2O4ynzF
	 SUl7kUAfyemDi+F1vWGm+8owjELJaL7ZzEnn17uMji+uiKaxi/iYVWrV2KDwnhV/DT6OG
	 FrAf0+othZJ1z5YPOOQQluQtkQ/GEQBLkTvfO9Uk3VSu03eb11HjSsDvHxvzzKlDuuv0M
	 NfAn2+24XPggvi3UCy6cS7991HnsVLdL3jzLC4SG6c1D89ikW0UGj54cExt0IPtv5YU19
	 EomASicAfnkTLO/YgBKIUCqHMHD72CHwAjRgizWVglf63zM4IBDljmDjlGhAkLY6VSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gy+RyF3gEC06X3OtHvJWE6yN6UWYuC8hsXVokqage/Q=;
	b=dH7rZo9uCQHR/YU2REgRncQRqudSCai1cBTEAZqD2KBUH/Rblq/dMy8xHXny1zZh1m0x
	 Qfo0qdZpjyvuxLjcx//+F/Trm0NuUj8OUbybxSciQzTdaCn9qXQfiyk4gzJYrDDZ7xjnm
	 u5ZTAS2RNkbfm8Oznaj2u+4TzziE183pC7nMto4UR7dSrgsYBTIOYIEm2LAx4LWbQbh9E
	 Axpby7GiW++Tr8qfLn1y/93SuDyO+jCNOmyWSgB7NiRqmaNtojALv4/cffK2OoCKePMIm
	 ovujIjrMwMMHEhro4vWWWL+HASrCq4iXnKpNObLFGLmJAIkSnBnONu2W+ubfO8gKnDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKeghH7b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3912606A325;
	Wed, 18 Nov 2026 20:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKeghH7b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2195E1F000C4;
	Wed, 18 Nov 2026 20:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032400;
	bh=Gy+RyF3gEC06X3OtHvJWE6yN6UWYuC8hsXVokqage/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKeghH7bJpzR9yrWRz8oHnR1BSQhNOEmbjdR14N7PXy67Z/wnKkobz8s7db1DZQ0A
	 DqMzDcrs8ei+oHxyqE5rimrVrNVw6i2jLVTzudfreGr2WRe35OiqL0k4sGPF/t/xm1
	 PpAY642TrBWbwDE82rxsbQ/H554r7IP6mhytfK5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1372/1756] bpf: Dont take an extension for an iterator program
Date: Wed, 18 Nov 2026 15:58:19 +0100
Message-ID: <20261118150103.846048864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7cc639dc45c5d3b69acb2a2fc834e9eec51e0214 ]

An extension inherits the expected_attach_type of the program it extends.
If that is BPF_TRACE_ITER, check_attach_btf_id() hands the extension to
bpf_iter_prog_supported(), which goes by the name of the attach function.
For an extension that is the name of the subprogram it replaces, so the
load fails with -EINVAL, unless that subprogram is called like the function
of a target, bpf_iter_bpf_map_elem for example.

Then the extension gets the context of that target.  If the subprogram
has as many arguments, it can use the key and the value as buffers, but
how far it reaches is noted in the extension, where the test of the
iterator link does not look: it reads and writes behind the elements of
the map.  And the id of the subprogram in the BTF of the program is cached
as the id of the target, so that programs of that target which are loaded
already cannot be attached.

Refuse all extensions here.

Fixes: 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-27-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_iter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index f5df115059bde..96c0b3fb0926c 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -352,6 +352,13 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 	const char *prefix = BPF_ITER_FUNC_PREFIX;
 	int prefix_len = strlen(prefix);
 
+	/*
+	 * The attach function of an extension is a subprogram of the iterator
+	 * program that it extends, whatever its name is.
+	 */
+	if (prog->type == BPF_PROG_TYPE_EXT)
+		return -EINVAL;
+
 	if (strncmp(attach_fname, prefix, prefix_len))
 		return false;
 
-- 
2.53.0



