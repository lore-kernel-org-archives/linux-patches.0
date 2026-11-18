Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041977;
	b=3IQnMdgXU5Wx3YB8kyZJSOP8mlhw5qm7zUGXDNMbwUFBl2C8nncu6j5Zx/YUBvewJ3aU
	 haQBnUzJNHon9vP1InyOLwHqiavKZrBFj7Ujxi8B7H4BhY0irvv4Wg0JUZBrwr6eXl4AJ
	 j9Bhvkvm/n/sZ/O0GsveMhQ2Jy3RVS/qzbXXf2H329kDhrVcFAo7l+V3JsXHbr9tmL5sw
	 U/6cE7jPQHJeOrL9l+dVeOB415OnN7d62WllKWJj4nkSkrek4C+5SSIWMmbJ+YJeKkvVe
	 XXs7wi+pC6OVch3+Tpmc4C7yQ5JJKc0q4ONcZiw4I4wm12F8Y7UlFUfbjX0aluz91tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9D0Hu/nJh0PpKAhh7cTo0PRF6OxsWoqc3w4Bha4UeiY=;
	b=UJ+khmu2CPtmxwdouh7Urge8SQD8eTOX479G+8qQj7IxyNYae7iiNZizDOu5ICIxDsYR
	 5RwkTB1LrgLvM5zlsbzeNLiLx9ixzkYn99axe0rKju7HF3nbljiHV0LdM5zVtHwpN8GT8
	 OdFc3ExNVdhg8CX4e/CmnQqaa/iJnA0c8CjpzeccVhroFawavbf5R28jBRcqzSO5+3aN0
	 JnLtBa20OOXPaPgoQ1XQmS+mDf2QPeZ9mLH3li2msApHjfUCECUwjN9c0gVMDTNMYufR0
	 mZkB5eVsUoXPhmZ/cyPW/rgpCtDYrUqglnohOFha8c3Y2aHhIEKyACngZnpu1/Gw1Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFyduNRl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B4C606A325;
	Wed, 18 Nov 2026 22:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFyduNRl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB45D1F000C4;
	Wed, 18 Nov 2026 22:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041977;
	bh=9D0Hu/nJh0PpKAhh7cTo0PRF6OxsWoqc3w4Bha4UeiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFyduNRlXQyDO4lTfPLftNWE2dzRkTAS3FhRWq4xvz/ZgNfRn8XuQ3rFBeYmfLqw6
	 vPDffQ9eGfNDZap7DMh3EKxV3MKJREgg/44E4b5aKbxNJQG9Irt4UuygDIUSknLL3b
	 X7vIGPESRIgnov8032tMHpQMOIWBe3XHocOCu7fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3006/3318] bpf: Dont take an extension for a writable raw tracepoint program
Date: Wed, 18 Nov 2026 16:00:28 +0100
Message-ID: <20261118150450.428257157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 7fe348f18b37b3f4c8beb981ef3f84564047380a ]

bpf_probe_register() compares max_tp_access of the program that is
attached with the size of the buffer that the tracepoint lets programs
write to.  An extension of that program, or of one of its global
functions, gets the same context and the same pointer to the buffer.  What
it accesses is noted in its own max_tp_access, which nobody looks at.  So
it reads and writes behind the buffer, of a tracepoint that may have none:

  BUG: KASAN: stack-out-of-bounds in bpf_prog_5843f2b820eb4929_tr26_ext_far+0xf4/0x10c
  Write of size 4 at addr ffffc90000d8f894 by task wext/103

Refuse such extensions.

Fixes: be8704ff07d2 ("bpf: Introduce dynamic program extensions")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-29-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d020de1301858..cf54ebba430d8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20365,6 +20365,15 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
+			/*
+			 * How much of the buffer of the tracepoint is used
+			 * is checked for the program that is attached to it.
+			 */
+			if (tgt_prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
+				bpf_log(log,
+					"Cannot extend a writable raw tracepoint program\n");
+				return -EINVAL;
+			}
 			tgt_changes_pkt_data = aux->func
 					       ? aux->func[subprog]->aux->changes_pkt_data
 					       : aux->changes_pkt_data;
-- 
2.53.0



