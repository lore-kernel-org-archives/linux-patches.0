Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020894;
	b=l6Leb5RCBoi+TjLWOoY8eyXMbth0JgXISaUteiPX2NomA6b0kGhVL79uPI95f5mMZP5/
	 ygdY8olpzdxmazpYbatxUmvLkUKbPsYXnRGuWpHSECseQx5qHZS3mW42TpQwO04FoePZ9
	 q6JIIj4VIEcJ8Z4OZAE86gwKkGKbQkzEvbShyXshUyzj72DZOVEeS75kpAlcl6G35IYaC
	 /VNyGCG/DHemBbB9E1QWgkum3qcQ04dOfi+EImXW7ScNfU++cIN8fgWN9nINVjn7ab0om
	 YQl5agvJodiplHCYXlueNQIqmss98UBQMTI6J/FeM1nkkhM5uQIYaeMPJ5QhuQcUvmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B5RJ3MM7NsWDIURMJiP4g9j6/nl3VRIBXuTbgjt/89E=;
	b=SpkKpNaIJGIUq4KR07L6t4L18ZTll/LdiSx0a+vWhBusZb2VbC/oWv9+ayy2HkGKUnov
	 o3tMzDRRKTCuXXwTFuqMfX/jBJn/IS8WhojW3ReQJaZPOVL4C6vuh4CD04C6Robt+LPlS
	 e+jbq+v3tkR/Ax1mXWK42bvr/K82yj4rC/iehx0lrCIduFkwfVRizknCEGoHUHpRXpXIl
	 eBZlOMOEn+/fj3it/QHv+HwwSOvFaaWgJ+kSNCpvzrIkN321fU8wlmrj1mfH8+dzX62wa
	 Is2qcn4zPYyNiaS8Au6XTGMXmPSJMHHln8akoNsufG6IQBk1zILgmPe4ZDvtuA3IJ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bL4Izs0e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDF1606A325;
	Wed, 18 Nov 2026 16:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bL4Izs0e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5701F000C4;
	Wed, 18 Nov 2026 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020894;
	bh=B5RJ3MM7NsWDIURMJiP4g9j6/nl3VRIBXuTbgjt/89E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bL4Izs0eSWdVNsynELQZF/Zkcaw0qcxib5o8BQC/cNhA3ZOLWiOyTYnkrqWVXaRDQ
	 cNs3KHuFEqffolLkMfP+OCcEFj0gq5FDkc94mKbgGh1sUXeOYjk1aKPSwLNXkhGeZ1
	 y+1zMpaVYS7SGEspG0K4hHL+XMqBRikqfZghgkhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2115/2651] bpf: Dont take an extension for a writable raw tracepoint program
Date: Wed, 18 Nov 2026 15:55:55 +0100
Message-ID: <20261118150402.080046373@linuxfoundation.org>
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
index 90fedae1bd3cd..090576a79d9fa 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -20364,6 +20364,15 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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



