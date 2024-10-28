Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D51118E368;
	Mon, 28 Oct 2024 06:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098413; cv=none; b=gS+tRrgho7oeerYkoe/0utZx7MZTU8oSefoXfl2QV9XDhXSBQW1wZKNUKpeFhpsfH8zEFL+HAqPlPTpvWYzajiblSjtOPIMW59dh6dT6eqSRN+fyIGxpjQeXwugrKGfA6im1pmvksay+7waGgsilgU5sWRgaaobPLaqPepHkAro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098413; c=relaxed/simple;
	bh=UWeaIFBhrfTWww6R6OQg/bzI2Jc63iGINTDckm2UD2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV7B5Q42Hva1yJmLfPqJmYdtM8YOlO61voOp8vvS1zdnD95DpDzKuu3HgSdp9K/w+CLnromdtAOfrzw2RubvDlj4D/HDIMWDZBMzRm8AVsLLw9DLzSwOnrpzszJATQ0ti+oMa6oaUhuXOTPY2pF+/4EMIMsxllhH5EMmNPSvvzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2inBFvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2inBFvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C40C4CEC3;
	Mon, 28 Oct 2024 06:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098412;
	bh=UWeaIFBhrfTWww6R6OQg/bzI2Jc63iGINTDckm2UD2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2inBFvGxe1amNaR72dTAQyw6o1Z9jTYqOlSSiUWHXQdktbesWCSIhSxhIM8yUB29
	 OTH5dfjKWuNG1FK2Je5VyTd2yBYqQco5pT5AFF04xP6cq4QfppOxd0KT2UK/Dly2qw
	 P/oMzsBuvxHR9LFk+zKDBOPmdCp2a33M1RKe3uCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 180/261] bpf: Add the missing BPF_LINK_TYPE invocation for sockmap
Date: Mon, 28 Oct 2024 07:25:22 +0100
Message-ID: <20241028062316.517508516@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit c2f803052bc7a7feb2e03befccc8e49b6ff1f5f5 ]

There is an out-of-bounds read in bpf_link_show_fdinfo() for the sockmap
link fd. Fix it by adding the missing BPF_LINK_TYPE invocation for
sockmap link

Also add comments for bpf_link_type to prevent missing updates in the
future.

Fixes: 699c23f02c65 ("bpf: Add bpf_link support for sk_msg and sk_skb progs")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241024013558.1135167-2-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_types.h      | 1 +
 include/uapi/linux/bpf.h       | 3 +++
 tools/include/uapi/linux/bpf.h | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 9f2a6b83b49e1..fa78f49d4a9a6 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -146,6 +146,7 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
 BPF_LINK_TYPE(BPF_LINK_TYPE_NETFILTER, netfilter)
 BPF_LINK_TYPE(BPF_LINK_TYPE_TCX, tcx)
 BPF_LINK_TYPE(BPF_LINK_TYPE_NETKIT, netkit)
+BPF_LINK_TYPE(BPF_LINK_TYPE_SOCKMAP, sockmap)
 #endif
 #ifdef CONFIG_PERF_EVENTS
 BPF_LINK_TYPE(BPF_LINK_TYPE_PERF_EVENT, perf)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fea4bca4066c1..b44b3b6c6a8f4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1121,6 +1121,9 @@ enum bpf_attach_type {
 
 #define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
 
+/* Add BPF_LINK_TYPE(type, name) in bpf_types.h to keep bpf_link_type_strs[]
+ * in sync with the definitions below.
+ */
 enum bpf_link_type {
 	BPF_LINK_TYPE_UNSPEC = 0,
 	BPF_LINK_TYPE_RAW_TRACEPOINT = 1,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 35bcf52dbc652..cf9b43b872f9d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1121,6 +1121,9 @@ enum bpf_attach_type {
 
 #define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
 
+/* Add BPF_LINK_TYPE(type, name) in bpf_types.h to keep bpf_link_type_strs[]
+ * in sync with the definitions below.
+ */
 enum bpf_link_type {
 	BPF_LINK_TYPE_UNSPEC = 0,
 	BPF_LINK_TYPE_RAW_TRACEPOINT = 1,
-- 
2.43.0



