Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027276;
	b=Djuqw5ouXX/cc3hcHjk+NdIWLj1DBR4bZNdry/qh78AAe30Legu1jM0Jx2dkhcNpPima
	 jf3T5DKRrBx8Nyx0lDypGQ9hT7LLKyPKaaxIcUe+Vyl97w/goQkNDwAgWwjvb9LwtsG6Y
	 WA5DRBkprolYt4nWtjzaDPGfdYt9EuYjqiA6DXhicxLG1u2uxGjdOM1pP5cuL4cqV9YuP
	 vyQwH4LypFjUOEN1fXpJuW9KkX8WG8jae4yzWLQrSFtTq7YV3TgHGXjIty+vQRnaDCrSV
	 R/bM+7IxeNkAhbvaQ2u5/781fVpbSfycfEO3JRoznz+zp3JjKAg8R8i0dZc0TqRoQ2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fu0w3UyckuPlljoJY6RU3cD7rpykmJNfcyr8xcXoi3Y=;
	b=bIFH49iOoYfnzLlZgg+Kjp1EydlZrQWp8gZ+M0MfZwQrBRxoHtqplrIwVSCEGe42QCQX
	 rUVKsZfHJWcf1QUy1Fcws6JyMIleTgIT+AbpdwHfsy19006MIo9pVEnBk6ZiELwbtzbae
	 wkAGZUhKAA/leDFiyxd8gcFvbZ46I8BWJBIkSV4+KN9G43/uhXMjIBb72T33/qj+S0wyJ
	 bgIBKlu+irSCKAlRuAAdiPw5m5vYiTwrokpn6m0loVt95OJd/vd4FBm0Srpr2t5TxVR9O
	 7Itvrty7lIFLn/m0RH5gK+io23vssUKKbM3be6m0q+qMZKSETdQzz438+1rCaxzeriQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLN97xZi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F441606A339;
	Wed, 18 Nov 2026 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLN97xZi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17501F000C4;
	Wed, 18 Nov 2026 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027276;
	bh=Fu0w3UyckuPlljoJY6RU3cD7rpykmJNfcyr8xcXoi3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLN97xZioKAkDEMAE6iVgO5kYJY2DeZj3NgX44SPxdOd/c9EBjt1QhzYVSK8U9E0H
	 VqnpgIqqnTfetvL0zk1CmgSLm+rO7byMilXuEXgb3QCKcpvZLrVLmA1hGJxCGKIp+r
	 w9oATuA7BXx2nBPW1XudlZbgHFD+M+CGhGD/HuII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1730/2151] bpf: Dont take an extension for an iterator program
Date: Wed, 18 Nov 2026 15:57:45 +0100
Message-ID: <20261118150224.882269700@linuxfoundation.org>
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
index c31fe8775e720..1bb5fe0783a97 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -351,6 +351,13 @@ int bpf_iter_prog_supported(struct bpf_prog *prog)
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
 		return -EINVAL;
 
-- 
2.53.0



