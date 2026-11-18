Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020889;
	b=fCIvBKKMklD8UhNCS043WELbl1VHAnHQSde4+zIiZ0FN3Q+t2NmLyVSZuw6GwStI30Pe
	 Q9xzZaQIRKABcnuUfhdyLSH0JeTu7ptntEMKPeeXz5rCLv4wpetHGWy1m/MHsgE/hf/IC
	 facI3Kl3MROXCPFnrmTHnacXic/PU86K23oa7QGQaxpM+5I42iRPNcST2nPokddihLsG7
	 5khecdpTQHywjU4evppIJ+GicakP+cxO0hpr10KlXrZRn7mEU4ey6dCNIvFYyXjwb2XKH
	 rLGZJl1rb7vBKXkNFG7XVT84vd0c8GTOUbke0z7AafyN2Vsmq5iq0b4skSgnKiurQMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xu8Q8o+GwA8yMvUGltdVTwksN71t19Vt+tfyTVNlc7w=;
	b=TgbfNF1T7opS2LvoqHtJa/aTLy/Eisl0jfBTgY2zXrzPnAhcgTW0bkBeOKMaBGs8fuux
	 eqvkn2kHI/mYvTcbxOP9dOK5JSJyZM8H9nT56ACBx/9i4kaf8Ola6tk7joyhDfyum2CBT
	 lTlV99Sg8ZDTdkdaYNUszIMIi/Ytst2PtV5SUNLrMK0sLM1wz7/MT0e1lLupXwf9XVptK
	 LYjlSUA9xt7kIYgmTUU6dsIhPTNJo66lKb3VNteA+qkcvYF1hEfLiuWMObGbxjkr+5WFs
	 QHbUMw8SpRZXg9t6C0s8U/Kep320VxrbR5Fl9drmuiptSY8vXN7l0sHPZPV7DtQjL5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4emeC7x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D71760A2607;
	Wed, 18 Nov 2026 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4emeC7x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B668D1F000C4;
	Wed, 18 Nov 2026 16:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020889;
	bh=Xu8Q8o+GwA8yMvUGltdVTwksN71t19Vt+tfyTVNlc7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4emeC7xpUx16AC9aAm1yG302GZ5sUSaiNn6Fn6vyyE/0iSZ/muFgRm7itM4SPcjS
	 oDxNAvMCVg+rm5daPloK0o8IjMLkRHlrNKwrOAzlh3bxt3GabRPBo3TrE0ulsjEwIb
	 S+5JJMWlewpxydgxnZPZCM0cDzN9Z1VaryZCCs3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2113/2651] bpf: Dont take an extension for an iterator program
Date: Wed, 18 Nov 2026 15:55:53 +0100
Message-ID: <20261118150402.012705581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index fc3a75684ef7f..05d8b30bc4f7c 100644
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



