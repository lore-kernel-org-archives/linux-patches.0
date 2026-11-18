Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045519;
	b=H1lwocGw5EGQ6CIC9mEbTNFZ0WpbTw91m/T6yZk5sAzPzsfKmZEpxYXDX2Zzya/jvGvP
	 7E4LLq7TKi30vqrs84UnUBQz3N/xP848pWgI5Tv0eD7smZVkkeCyqfYoNlPPg5KazBaAd
	 HOYzUGQsi/IbvT2wzjNWMo99EY0EK2F/rKjNchqhP8CF2hCxxUzEL9Cv5LIfXfV9p1wiW
	 c7QI2iGTGIFR1wDGgfIDJJg1qm0I/DVROG0WYG5dPLcPliLz1jJ4bb6s/t4u6zbMH0XiZ
	 HM84VH/UeKphiIWgHqoYqNgmfmdlpJ7s9FI1ctdHmBLTli3ZTkpcMTnHzqsHMxkyGXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q/NkDaEsNPUOwW9+FPc+Z6QyFGPohuXs3qjS9WN2G1M=;
	b=U4F6TTOzf2+n9Du065aNvfzfnir0g2TQTli8+lbt/kCzZM+hjFjm5JGm3EoxMlgsj1Kw
	 IKg8P4zBT80Gn8sFkR1C8FLXLPq8XD8GUUj8p8ymPE1P/nbs85HV8ljxfc5P9FlQPCSGh
	 NgWamisMz3UuaK6pnatU3kmRQ5dmn1CKbiD2rKpffGK8QROWojxbJ3BwJQCnJPCNH0nOO
	 u9W/QLNxpVdo7Og/yRhA2evcbBIRJxCEOvcA2DXfA0aspWRAsI+NqoXQOSH++mK72HoON
	 w3u47YvTt2JSBPJ/EflV+nm+f+JPi+3LX+j+NQGUIxz79wmqXywu9PXVl5HgVo0AU3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ex0PtuNG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0F606A31C;
	Wed, 18 Nov 2026 23:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ex0PtuNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F6E1F000C4;
	Wed, 18 Nov 2026 23:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045519;
	bh=Q/NkDaEsNPUOwW9+FPc+Z6QyFGPohuXs3qjS9WN2G1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ex0PtuNGs5UwITnxmATaHOTAbyoNaMnxMSddL0F8opagjgJlgfmmuSTARSQMEmJtp
	 233LKaEmYJQU28dCSFmJMGth6Je/cJi+wh5uX+ABbrS0TzGZigHLOtpHuh2qcKSO7s
	 Vc8XRmVr9B6MkTGW6UFmNWKEMWlsSk/o9xzwtGdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0953/2857] Bluetooth: L2CAP: Reject mode changes on connected channels
Date: Wed, 18 Nov 2026 15:33:07 +0100
Message-ID: <20261118150235.920086050@linuxfoundation.org>
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
index ea41bf1efc6da..975d771747aa3 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3780,7 +3780,11 @@ static int l2cap_parse_conf_rsp(struct l2cap_chan *chan, void *rsp, int len,
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



