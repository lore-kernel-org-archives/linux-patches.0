Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060620;
	b=On5FyzuCTOVnqr7U0X9byQFHLEPB2NdNEFJgPSUfRCd9mFyHYNyYi78fbSJcMiOeNYRl
	 oPIQWr4lm4H8ujlL/0QNQ/4opKa7R4p+SKcjRhdc5IZ9wlotoqppohcwiY/VkzTZHaLql
	 w9BogR2cus90mUt4iObvN7y3HEWPGGOSct3cDhKEcmTUGmMN4j1KpsIzPuCsk3svcbeSv
	 E+UHgPEY/S+MX6yqMi96yhSb99R48Mc1p3eSSr8PLxQRsjR/6BvhKhblHcm9edO8tqGHZ
	 pkgAn8CIMTGhuVpWq56dJqjvsNnP5e7mHCGMzE0SISQY2fR1fGfUSfvPHylL2dNNaxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eRogNeIJIatqYSEsJ54yemguGavcJ5YC55/3crxfB+4=;
	b=xOB4MWnK55sGDOoYvtPwB34u2Oil73obFDEkSQzhp3f6zAP9CK7G5WRtjtRsh44nzgbv
	 8EkPR+GSrcjJuYicBMUX6j3BRF6597BI9InyI/i0W+NcmU/dESEZbymGGtMX8Y/bHVemW
	 Q5tfnWqgi0bsz7mdiWkhCLOpqsX8QKMiX5gvSkoBvFjXyQHvdRJqmENmTVMiylE2pSx+8
	 qQOG8+iglVV7D+WJpYCaSCvXRsRXxfFQypgPaJiAqoIUBwitOe6MU6N0gaTvQl7rUQvOB
	 qkMTbSbCeLJQn2wWn/mNGjfIG45xT9uTWOxxvwGAugsH2GbW4vcMyWXtZBebRtwigrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06tl1dTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E89606A326;
	Sat,  7 Nov 2026 14:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=06tl1dTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB9A1F0089F;
	Sat,  7 Nov 2026 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060620;
	bh=eRogNeIJIatqYSEsJ54yemguGavcJ5YC55/3crxfB+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06tl1dTST9cSbw5cYjTD6wsjyUdeCAED9ticWTtX7LpX8hB98ofPUazcfjy0bH7zS
	 ySW1t3xjwWjQ2tz0m1KXDfZ0WbCZnq2+ZhxE6D2VQMXNGHx3aCGzT1w3r7ifErGEqz
	 NjwfqO4zUWprcSIxZDuGFYZy67IGbAOgWIwUv6YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0068/1536] libbpf: Skip bpf_object__probe_loading() when BPF token is in use
Date: Sat,  7 Nov 2026 08:34:44 -0500
Message-ID: <20261107134959.577022292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit d262a25d8b58b697b2a1a2fe4b0078446cc00e11 ]

bpf_object__probe_loading() tries to load trivial SOCKET_FILTER and
TRACEPOINT programs to verify the BPF environment works.  When a
BPF token is in use with restricted program type permissions, these
probe loads may fail because the token does not allow the specific
program types, even though BPF loading is perfectly functional.

Fix by skipping the probe when a token FD is present: BPF token
creation itself proves the kernel has a working BPF subsystem.
Real BPF issues will be caught during actual program and map loading.

Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260610145059.113412-2-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 214f8b48c1ea3..59ba53f1e77cd 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4993,12 +4993,8 @@ bpf_object__probe_loading(struct bpf_object *obj)
 		BPF_EXIT_INSN(),
 	};
 	int ret, insn_cnt = ARRAY_SIZE(insns);
-	LIBBPF_OPTS(bpf_prog_load_opts, opts,
-		.token_fd = obj->token_fd,
-		.prog_flags = obj->token_fd ? BPF_F_TOKEN_FD : 0,
-	);
 
-	if (obj->gen_loader)
+	if (obj->gen_loader || obj->token_fd)
 		return 0;
 
 	ret = bump_rlimit_memlock();
@@ -5006,9 +5002,9 @@ bpf_object__probe_loading(struct bpf_object *obj)
 		pr_warn("Failed to bump RLIMIT_MEMLOCK (err = %d), you might need to do it explicitly!\n", ret);
 
 	/* make sure basic loading works */
-	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, NULL, "GPL", insns, insn_cnt, &opts);
+	ret = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, NULL, "GPL", insns, insn_cnt, NULL);
 	if (ret < 0)
-		ret = bpf_prog_load(BPF_PROG_TYPE_TRACEPOINT, NULL, "GPL", insns, insn_cnt, &opts);
+		ret = bpf_prog_load(BPF_PROG_TYPE_TRACEPOINT, NULL, "GPL", insns, insn_cnt, NULL);
 	if (ret < 0) {
 		ret = errno;
 		cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
-- 
2.53.0



