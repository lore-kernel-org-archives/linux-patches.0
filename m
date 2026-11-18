Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052652;
	b=gaS5nrXUmkALffKfCoPBuMPXZoUpZzxUE52YNLru0KRBsN4tLPg+BiA0aH6L5zZZGArj
	 pnn2ql1TdcqxuiemAKYtdAAhYR0cv3TujbXn+ceHdFysv96G+Z64vuneUCJ7txyzGW3fp
	 iMCQav5Z7Lim9J/8ZwNcjGv6ty4PU2/xghycrQuyHCytcHoRBATFOLo2+wh4aN3IM8qOD
	 ZitlC6kfKx3bJ6kp0vZDFFHF7CQTQdc6OtcB6MBSk2AT86iFEWtLk8vN7iraVw49026/m
	 lc0XGcAloJdndOF3/kwT37k7Clx8ixkGOprw0usuad5OSuonU1fP7VBYx/zsJG5fwPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+fP9v4+8T7t3z6jZhQysdAX8zGzg4IcVPbfkV4F3kNs=;
	b=l5tppdcwYOm1eBKOEb4k1QyjjU/TPODdWt2SoKldwY+C2C99rCk9YCu+B1Re2IdHBvKw
	 uPRHaFMvGD/GtQhqp9FrTp6pCuPtgK88mhPU+k9Bk3TSOh9cuq6kTs4H0cNYOV4Mh2iBK
	 lg33O7rhRq3QJ0zOHTOyTL6yO/BxYoAubAdkXBEz+QkJMgWYT8BAJK4rV6OuJEF0shDvY
	 SkKcEJU0gvkRRbs5WbCNMA/DjH97XDn9HNiqiXEvZasJ2wt1nrAmh55xDZ1tiTSpinIqD
	 +l1bBsYGFjLIm24eZq8B04RwSsht1mcoXsr0yxSmfwvEvUjS3eOxGXtjaIv0c/c8bSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDEeujF+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F44606A32A;
	Thu, 19 Nov 2026 01:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDEeujF+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7C61F000C4;
	Thu, 19 Nov 2026 01:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052652;
	bh=+fP9v4+8T7t3z6jZhQysdAX8zGzg4IcVPbfkV4F3kNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDEeujF+PZwV67hKp5Bs/o8iRMF1JAZEh7qqFbCj/9n24f6RSHDHm8RzQxwtf5L9T
	 nZZafukEpyfPKjHxVYtmm1ZpEKaz/Vn3m07G2e80ywbimFMvT06vYdQJ0s8c/4yEbn
	 bQ30BkoVRxrYDWIWOf10r261wBfx856GfGwAfQS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0641/2214] Bluetooth: L2CAP: Reject mode changes on connected channels
Date: Wed, 18 Nov 2026 15:38:37 +0100
Message-ID: <20261118150036.980834153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

[ Upstream commit c1398cf11b31a94c27ed810ba69515e0df5ce379 ]

A peer can send a configuration response with an RFC
option for another mode to a connected channel, for
example to switch it from Streaming to ERTM mode.
l2cap_parse_conf_rsp() then changes chan->mode, but
l2cap_ertm_init() is not called again, so the ERTM
sequence lists are never allocated. The next
out-of-sequence I-frame makes l2cap_seq_list_clear()
write through the NULL srej_list.list.

Refuse the channel when a response tries to change
the mode of a connected channel.

Fixes: f2fcfcd67025 ("Bluetooth: Add configuration support for ERTM and Streaming mode")
Cc: stable@vger.kernel.org
Closes: https://sashiko.dev/#/patchset/20261007144717.3832330-1-oss%40fourdim.xyz
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index b127882cc02f3..5c3a60d3b0ed2 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3941,7 +3941,11 @@ static int l2cap_parse_conf_rsp(struct l2cap_chan *chan, void *rsp, int len,
 		}
 	}
 
-	if (chan->mode == L2CAP_MODE_BASIC && chan->mode != rfc.mode)
+	/* A connected channel cannot change its mode, as the new mode would
+	 * not be initialized.
+	 */
+	if (chan->mode != rfc.mode &&
+	    (chan->mode == L2CAP_MODE_BASIC || chan->state == BT_CONNECTED))
 		return -ECONNREFUSED;
 
 	chan->mode = rfc.mode;
-- 
2.53.0



