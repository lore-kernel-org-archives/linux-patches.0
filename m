Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032520;
	b=xNOoEOQ6wF/H8pGel50X3FB8U8pU51y8mTfcGoeyi3GvdXImPO66Avsg3kQmg6zcBkRy
	 6SVvYNQG/Uxzqi4YJGDzof/DeAIfkFWRz818q/hBCZkthmX2uUb0KgokiALdjGJfDcyzB
	 GV04ICC/VLp39ptisYn+Ri7MbY2kigWcLnzjaODGLlnG4Oi2GIdl25m8jzpaFI1JiURS3
	 2yowyr+Dkkv9BNKl8PMSHSxg+ciPsI3oNNkYLn/jAmMlokUKZXTW0tpnpeX+eIuzHPBQ5
	 ScCeaDCltyq0cukTF7sliL2Nj7Y1ap8RUakzt9Ifs+tYBnfoGMMyufv2Ovr2ct2aNEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=42xw/Y4M09n5i7lTmpnIrW4A2Zwu/hzFbwgyCZ+wsPY=;
	b=nD7Cld7egE0n4QdDQ1rJLb7FWB+2ntE4MaJPgtQND1Bjtk/LRzDIAhrAnK6ZLMDXXuOC
	 wsTB8r7vRYmkvN/U2aih5wnEKvJKOHfkpnEBTD/BJP9pPXYWSZP8GyFED4HQW4Har6LNW
	 Uy8xRtaBCEzV0Ui/fhGvvro/xocrNzx+wKseFVonUL39mrdHiHtRSsTrlisOgLxT4/OdQ
	 rzCTyBFF/O43YWeENZ+Iq4eYTm4XgTJMmdC86ZSyAKCQsXsT+pw/PemIfnUr+XOBPQNuj
	 0q69N+SlSC7K4AWwldfQracAw1fxHPwuTNAiyfmeUIU0GdUAUkbBPUN8aiw0vR47baA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XPoH9m+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C084A606A320;
	Wed, 18 Nov 2026 20:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XPoH9m+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D351F000C4;
	Wed, 18 Nov 2026 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032520;
	bh=42xw/Y4M09n5i7lTmpnIrW4A2Zwu/hzFbwgyCZ+wsPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPoH9m+LKyi4f+nSsalIT7monZpzLJtmB46+Cs3dlhyBayJGcVcHc5B/mSJ7nByoX
	 M/gA4HOD7TivptwUuxn9FoCnRLU9biZMqsDEAsMf78A/hNr6KjKjqNrA7X6MGlujkp
	 vD3qQfLL5CHIPXH2gNu2zyC4NF7ECledUHyJF/mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Virdi <avirdi@redhat.com>,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1441/1756] net: qede: initialize extack in qede_flow_spec_to_rule()
Date: Wed, 18 Nov 2026 15:59:28 +0100
Message-ID: <20261118150106.508651499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Virdi <avirdi@redhat.com>

[ Upstream commit 106e562966a02f61917c2e0b83909aa2b088447f ]

qede_flow_spec_to_rule() declares a netlink_ext_ack on the stack
without initializing it. qede_parse_flow_attr() and
qede_flow_spec_validate() only set extack._msg on error paths via
NL_SET_ERR_MSG_MOD(), so on a successful parse the err_out block
reads an uninitialized pointer. If that garbage happens to be
non-NULL, DP_NOTICE("%s", extack._msg) dereferences it inside
vsnprintf, causing a page fault and kernel panic.

This manifests when configuring ethtool ntuple flow rules (ethtool -U
flow-type tcp4/udp4) on kernels built with CONFIG_INIT_STACK_NONE=y.
With CONFIG_INIT_STACK_ALL_ZERO=y the bug is masked because the
compiler zero-initializes extack, making _msg NULL.

Reproduced on RHEL 9.8 (kernel-5.14.0-687.47.1.el9_8) and mainline
(v7.3-rc6) with the following reproducer:

  IFACE=ens2f0
  ip link set $IFACE up
  ethtool -K $IFACE ntuple on
  for i in $(seq 1 100); do
    ethtool -U $IFACE flow-type udp4 src-ip 192.168.2.$i action -1
  done

The loop panics reliably after 10-15 iterations with:

  BUG: unable to handle page fault
  RIP: string+0x49/0xd0
  Call Trace:
   vsnprintf
   qede_flow_spec_to_rule+0x2b6/0x4b0 [qede]
   qede_add_cls_rule
   ethtool_set_rxnfc

Zero-initialize extack so _msg is NULL unless explicitly set by an
error path.

Fixes: eb705d734525 ("net: qede: use faked extack in qede_flow_spec_to_rule()")
Signed-off-by: Anirudh Virdi <avirdi@redhat.com>
Reviewed-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261013105451.201211-1-avirdi@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 7e341e026489c..7808b0c918e64 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1991,8 +1991,8 @@ static int qede_flow_spec_to_rule(struct qede_dev *edev,
 				  struct ethtool_rx_flow_spec *fs)
 {
 	struct ethtool_rx_flow_spec_input input = {};
+	struct netlink_ext_ack extack = {};
 	struct ethtool_rx_flow_rule *flow;
-	struct netlink_ext_ack extack;
 	__be16 proto;
 	int err;
 
-- 
2.53.0



