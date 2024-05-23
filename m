Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6CC1D545;
	Thu, 23 May 2024 13:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470835; cv=none; b=OWWLxB5AdBXAa8a6pNg0mNWkz1F9d3C/lS+3KnpUAjz88321sZcBgkje4CmoRd1du4vVAXWKyaxJXRFOhpIb4I2RYDebk/Nm0Gq02NXrU8WXWNVE6OEyu0bbhxbanhdSBbSQYPrVc6a+YGolr6CNvKiqaWrROgyDrDx8+VAwt4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470835; c=relaxed/simple;
	bh=TzHjm9mpznG7gAwdiWZXqYvnQZ5oLgZKPsrWINg3OYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlEIHEmh7SnELJG+Hh5n3heC5zaJkaf+94youMbdAwIOZu2SQjsMrptdAv4xIXLw1AHsgd7WoPupH6Va/hfRsG0DB21ITvIyXJUWgBKWtjhb6/C5zg11XhCJ9Sepavekcf23+L4fkE7xe+JsdAxrFxK60qmDhGcAH91I55ruUZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZbxqWV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZbxqWV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BF6C2BD10;
	Thu, 23 May 2024 13:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470835;
	bh=TzHjm9mpznG7gAwdiWZXqYvnQZ5oLgZKPsrWINg3OYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZbxqWV5eWX2LUIfCr2fyzkkhW7jCZRG8UVH2HTYlp17AgojY0ujyv629fAimYp4j
	 glKl3Xma4j7ZUfu2O5XFyI0sPJqgIYeJsVBdCyMg472sPdZCEH8/wQ2ojeP54Qx7Xf
	 V9NpWHjoRsW+6S0Vu6F6E1ZYUb1855GQa++KIgeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH 6.6 086/102] bpf: Add missing BPF_LINK_TYPE invocations
Date: Thu, 23 May 2024 15:13:51 +0200
Message-ID: <20240523130345.712073611@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 117211aa739a926e6555cfea883be84bee6f1695 upstream.

Pengfei Xu reported [1] Syzkaller/KASAN issue found in bpf_link_show_fdinfo.

The reason is missing BPF_LINK_TYPE invocation for uprobe multi
link and for several other links, adding that.

[1] https://lore.kernel.org/bpf/ZXptoKRSLspnk2ie@xpf.sh.intel.com/

Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Fixes: e420bed02507 ("bpf: Add fd-based tcx multi-prog infra with link support")
Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER programs")
Fixes: 35dfaad7188c ("netkit, bpf: Add bpf programmable net device")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Acked-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/bpf/20231215230502.2769743-1-jolsa@kernel.org
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_types.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -142,9 +142,12 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
 #ifdef CONFIG_NET
 BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
 BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
+BPF_LINK_TYPE(BPF_LINK_TYPE_NETFILTER, netfilter)
+BPF_LINK_TYPE(BPF_LINK_TYPE_TCX, tcx)
 #endif
 #ifdef CONFIG_PERF_EVENTS
 BPF_LINK_TYPE(BPF_LINK_TYPE_PERF_EVENT, perf)
 #endif
 BPF_LINK_TYPE(BPF_LINK_TYPE_KPROBE_MULTI, kprobe_multi)
 BPF_LINK_TYPE(BPF_LINK_TYPE_STRUCT_OPS, struct_ops)
+BPF_LINK_TYPE(BPF_LINK_TYPE_UPROBE_MULTI, uprobe_multi)


