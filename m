Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041974;
	b=KG7pC1VJ7NSWenMI2+UtRoM5w4MwSVEKLvGfPDawzVp6v72vIKBbqga+fbC3rO+iUCEj
	 xldguOF9zTHtQOdQetxymegeGveLSBeAu4ChhL/r9WOf+1lu4C4UufCnes6wpCqQaaakC
	 FrO3Va3Rf09R+HdzdcdYlRdldBH2L3x+FrwW2/70YjVxlIYKEkdGTxzumLU+salh8/pHo
	 BcSIgXwlm0ohQsv85C0QT0g1TD4AqPZplofdWFNvS7R6M1KXAJTghW/SN3xrttAl7qcwI
	 erxd6trjargEMsbC4sRL1uilSc9/pGljOea4SNF6RxjiQjXaMkUV69LmWfhcF0OtE7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Num7shNbLFF2oHvvwRzE4O37SWr6oH4sGORN59jpJOk=;
	b=19Bkau7Ge2STtiS8noRlCDWF2hA+S3Yt6j+O1p4VErCasul8kSpyRuol5RB+hh6qTmZK
	 1l9ilJTlMJ4AkB/T9h+L9jIhEGtM3IA5CxyaF10q9XoFWDLNuYn7GEuTmtYrkiDpDUGbf
	 pOLFqkgEFOn4DfJa0blY5U3Mc2KdTTTmzBY9+GxSJ7C7hvV7vCWufzowFBbg1/YNS1yDL
	 UmStslkG1BdVGvIbOixCft+FVmNSF43SvggzRG8ip6ssuXSyp12NccESXDHotk2SFSACf
	 VwoG4w2vevQRd3xIGiod1q2tmay7rezCaWig/nSsOV15Q9pIZsJRugGr5zSA3hSRvAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aWWBDHCI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7111606A31C;
	Wed, 18 Nov 2026 22:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aWWBDHCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282291F000C4;
	Wed, 18 Nov 2026 22:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041974;
	bh=Num7shNbLFF2oHvvwRzE4O37SWr6oH4sGORN59jpJOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWWBDHCIRnAr7hhho/1rCm32iLAOKkyfcO0I/db6Ta+AmzMRLclOFtEMTeVPTdPLm
	 6PlfaSbF0h4oogaGFCg1USkQIq6FBL1dV3TDYONemShbw0cf4GAaDJHJhVyYm2058s
	 v/5z07jJ4DhVHilj0ZgnQJvSMyVj/cg8qjkSLP2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3005/3318] bpf: Dont take an extension for an iterator program
Date: Wed, 18 Nov 2026 16:00:27 +0100
Message-ID: <20261118150450.401245694@linuxfoundation.org>
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
index 55bc98a02c56f..ec5ef3467652e 100644
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



