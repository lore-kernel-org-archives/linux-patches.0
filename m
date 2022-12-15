Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D315692
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 18:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886F2C433D2;
	Thu, 15 Dec 2022 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671127845;
	bh=jzLwdXzgafySvA5C/EzKSpNxurxVPP4aEZTPI3WEr+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEj01kgHW76EliRE2DsGkm/U7m/WnlpubabeCesZCOmfnsHKcCgceHKpnqiQarAMd
	 ElyuF2FUa6vHUv7JCGybwXL0gp6og87ugEVNvtUnk8a+sB8eA8H2nZkBwMeWpEPXLw
	 zW5/fqeOR2l6mgv6BJOnleUUdBtcXb2pZ3fTAxtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Colitti <lorenzo@google.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH 5.4 1/9] net: bpf: Allow TC programs to call BPF_FUNC_skb_change_head
Date: Thu, 15 Dec 2022 19:10:28 +0100
Message-Id: <20221215172905.529492378@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
References: <20221215172905.468656378@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Colitti <lorenzo@google.com>

commit 6f3f65d80dac8f2bafce2213005821fccdce194c upstream.

This allows TC eBPF programs to modify and forward (redirect) packets
from interfaces without ethernet headers (for example cellular)
to interfaces with (for example ethernet/wifi).

The lack of this appears to simply be an oversight.

Tested:
  in active use in Android R on 4.14+ devices for ipv6
  cellular to wifi tethering offload.

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6196,6 +6196,8 @@ tc_cls_act_func_proto(enum bpf_func_id f
 		return &bpf_skb_adjust_room_proto;
 	case BPF_FUNC_skb_change_tail:
 		return &bpf_skb_change_tail_proto;
+	case BPF_FUNC_skb_change_head:
+		return &bpf_skb_change_head_proto;
 	case BPF_FUNC_skb_get_tunnel_key:
 		return &bpf_skb_get_tunnel_key_proto;
 	case BPF_FUNC_skb_set_tunnel_key:


