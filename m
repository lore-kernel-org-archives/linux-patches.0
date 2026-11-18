Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050114;
	b=AO33geXFROTQsXcgixqNOQ1IJfq+2ozA2aVgeke91yFOPdrY0HddskPThEqB5KGsX2VS
	 MpiKXVDR62Pjhfy9onlZT01Zrt3NYpikYPs8oUCsHzmKEmlIKIjYZQgfGqOFJcjypLpf5
	 ixkEl1aZqdxBokm3PAw2IOGNqB2BY/cnbKcVOkGcfjtnd3P3m/XBhJRy8pCpBurT7uwQa
	 g5IHDo67OmY8O6/i3RTiNusnybpCnRDp/IlXbM9BMw/5WZelNIskEww7MbC2YJvz9+g10
	 U+jzQA3yzCBnjAk1GVMUCmBAE165OBu2E9CDN2/NWUG4bewbQH1mF+NuiSkemN20Mlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V/wVvPbPnN1Z9rm/SHWNVpvSNEJ37G4CXscq3gyIqbw=;
	b=xWbz+YyAPNtsgSEXtUR2ytK1iKmNzajl8xsFSXbbmxD93T3nzTV4KcURC0mvz+vPqVaQ
	 0+XjHlXnMgdx2yBL+DCjIs0qrVQKl376daok31R9pZ7P1fHsDoak/zQRl2BcOn2kcbIbZ
	 suJCpjogk2mb2hrOgrQyvegaubPMGB4lANk/oof6O0Y+f0HBOaEfngfoZHyoz0rT7IpsJ
	 US0JUDEv8LSATmB7R6NqGkrikAi/s/0ajkymyf2FDzRZNCyYH5ZvFqRFiOeI29ScdwvVM
	 4lg4KSL7udy6ce5LqfnztJsvQBmJdET/A6wgFnkos6z5+80PlhNownF05ycgxsgdcGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wfp5rPLG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB7F60A2600;
	Thu, 19 Nov 2026 01:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wfp5rPLG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574701F000C4;
	Thu, 19 Nov 2026 01:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050113;
	bh=V/wVvPbPnN1Z9rm/SHWNVpvSNEJ37G4CXscq3gyIqbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wfp5rPLGQgtxujL48VRjQGZIbp0EWT3P0x3uiGg7qXWaNOKctOtwl7q4yungc4zyI
	 l0VDmmOp4dqBpfopjUDBzs58BuXwEcM3QfkZxjZyqX/eeym7NTTgFm2/x7jOU9EzED
	 qq0YhNWP2R3Tq7KMsxrf++gYsWFEYp3VUVSBO6QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2593/2857] bpf: Dont take an extension for an iterator program
Date: Wed, 18 Nov 2026 16:00:27 +0100
Message-ID: <20261118150334.899587566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5dc307bdeaebc..cdc270ec82151 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -344,6 +344,13 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
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



