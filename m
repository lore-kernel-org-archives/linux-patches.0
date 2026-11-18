Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023220;
	b=BGaCAWiBZ0LXIJ6qMD9ISwjCsxOBNxtHgdfhQWxZWTy9xy2S2yw2oiJnKfx0e12HpuYi
	 lNnFIz6hfXy/4by93gIVPBUjtC8aamNl0bgdZAcgRxSiTdk34Vt1GfAp/o/EdbgrkZGKo
	 QfUgVQ88F7SR+DPn31c0LDarTfbxOHVPoLiauNol962QwUeRzKJMN/hOFt4m+uvGLdf1J
	 4vb0ERyNG/CH15MTTT88cl/kTmfPIrwStbgJ/VO+Er/lKFS69AhlfDjO2U3OrWUhrrya5
	 EJJIu9Dq/ZD9S8RRlYMLbNhBhMW6WNamYj4v5lt9y70MmS6HyEoYgQUy+GDxOpGVXKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jfRcamVBPR9OOGaNCv80k6oA1WTW6EINF+jYm9oaw5o=;
	b=TF01qR/wRjpMOBLUIkDIurLSz2T5b4ZqeBAgSOIVWWjG6vg7W2zq1nzx1Zxiw0ySD+jk
	 Rg9sYfyGvGwRFjFjTNSVOZpjp01Xq/PDl7/0gMMtS7jRuxNBtj/rqeUR8TFVznRTOjiBp
	 40rNG70vPFjrwVkbNMSnw9s2LR/gfeXATaacBl2vW+HfsVk8caVhS79bG3cFf9m/OwgEy
	 UBoYgvR4yUU8l2wJaRtp1Wteb/2A/cbUvx7vY7FfmL8ZPfAsfYXWw2SwbQ0xQ8oo2ZETu
	 +/im99pb3mv/5iZ2jv00HgF/MyTN9zwUXa0U+LYd759rMIv72t6aP0xBrj8cum/5Ejw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNMjGfjv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDFB606A332;
	Wed, 18 Nov 2026 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNMjGfjv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028481F000C4;
	Wed, 18 Nov 2026 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023220;
	bh=jfRcamVBPR9OOGaNCv80k6oA1WTW6EINF+jYm9oaw5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNMjGfjvkdl0K/8BmEuv+PRoQ8yqzh8Y9XQhXLy0V9FDQ5gSJG9gYcoKpOiIlj5GW
	 mSVG8U+faz5OARNH+7HmczviXPLcM45MCArgxrkwcSgEg2wzfYHDc6uN4Do9lHx/7W
	 ebl7gDy9aKyKMhTXOfj2+638YK1+SN6tCJwIJDV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Howard Chu <howardchu95@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0289/2151] perf trace: Add upper bound checks for augmented BTF struct printing
Date: Wed, 18 Nov 2026 15:33:44 +0100
Message-ID: <20261118150132.426661073@linuxfoundation.org>
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

From: Aaron Tomlin <atomlin@atomlin.com>

[ Upstream commit 024b219744a949419b3c9e8aa23031c04428d9d6 ]

When pretty-printing augmented struct payloads using BTF via
btf_struct_scnprintf(), augmented_arg->size is currently only validated
against values <= 0.

However, several edge cases can result in size mismatches or buffer
over-reads:
    1.  If arg->augmented.size is smaller than sizeof(*augmented_arg),
        dereferencing augmented_arg->size reads past the available
        buffer.

    2.  If augmented_arg->size exceeds arg->augmented.size -
        sizeof(*augmented_arg), calculating consumed =
        sizeof(*augmented_arg) + augmented_arg->size can overflow signed
        integer limits (e.g., with crafted INT_MAX values in an
        untrusted perf.data file) or cause arg->augmented.size to
        underflow. This advances arg->augmented.args out of bounds,
        corrupting the parsing state for subsequent arguments in
        multi-argument syscalls.

    3.  If the captured payload is truncated (e.g., short reads in BPF,
        or during cross-architecture analysis such as replaying a 32-bit
        perf.data on a 64-bit host where host BTF type->size exceeds the
        32-bit target payload), passing type->size to
        btf_dump__dump_type_data() causes libbpf to read past the end of
        the payload buffer.

Enforce an upper bound on augmented_arg->size against the remaining
buffer (arg->augmented.size - sizeof(*augmented_arg)) and verify that the
captured payload contains at least type->size bytes before passing it to
btf_dump__dump_type_data().

Fixes: cb32035214b9a09d ("perf trace: Pretty print struct data")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Howard Chu <howardchu95@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b0e14dfaae1ba..da8fce7801ba5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1101,12 +1101,13 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
 	LIBBPF_OPTS(btf_dump_opts, dump_opts);
 	LIBBPF_OPTS(btf_dump_type_data_opts, dump_data_opts);
 
-	if (arg == NULL || arg->augmented.args == NULL || arg->augmented.size <= 0 ||
+	if (arg == NULL || arg->augmented.args == NULL || arg->augmented.size < (int)sizeof(*augmented_arg) ||
 	    arg->fmt == NULL || !arg->fmt->from_user)
 		return 0;
 
 	augmented_arg = arg->augmented.args;
-	if (augmented_arg->size <= 0)
+	if (augmented_arg->size <= 0 || augmented_arg->size > arg->augmented.size - (int)sizeof(*augmented_arg) ||
+	    (size_t)augmented_arg->size < type->size)
 		return 0;
 
 	dump_data_opts.compact	  = true;
-- 
2.53.0



