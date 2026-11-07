Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064854;
	b=yNeNVm112ugt3SF3lv6b/vLndsBJgjIUVa/VzJlAZet0T0g9PyxoSut1Rbxnoe4q2orl
	 iE85AQureSdy9l9GjJ7/NYYlRP6rtRwTyRB4xd30n3xt6J+51Y5mmEcDhojjvGZC0heWk
	 i5jIA035bAFlzl+VJbffNpO9jsOqobBqd3nRyffFBX0Ihj1yjtVWxvFfaN2Jqdup0bVGu
	 jHvF75nN+jKc7EjK3ChXaee258hW74Gy3P2Kymj33rA1sK6r1QbqXDtLfyleyASkpUK5M
	 UctLUSF62Td2S6FLmA4ltnSx1t8ucyxMl5kUq9yaA3AXhlr9HzfPHXW0lqLKyuzFCnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OXt86sbzdgGNYwotsPURaUrl/dQclxWXqDcy30WESfE=;
	b=hbxRhDtjqtrWH9UR1rTydPfNedg6M2xFu6PWFOxtf6Te49G9wrypct8r6EMjKuVWSAYY
	 9H1w7Jmu+K/6gSM3uLFLtlq0ylDyw09i6VPkt1xiVQyVyMc0jLVkohkyA5587NTc4x40f
	 tF87BSRmzWlYJvMHBKtfsvUU6EmgZoia26e0X0fMjywEdPsRkSaGUSdb/NaYkMC5vCMs5
	 6PpcxiveiOKx2ae3LTpjJzMW0Lu9pjd3225JJrKDyq5DcVNgkq68NYZKBvMtjtO5hoXcG
	 mS9Y4zEbn2w0h64tmdkQ5udD4Gh7vC1WSe3e+SogKhpOwFxmBvKwXL0LNH93S2sy5pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R71HIHLq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15A3606A335;
	Sat,  7 Nov 2026 15:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R71HIHLq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E601F008A2;
	Sat,  7 Nov 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064853;
	bh=OXt86sbzdgGNYwotsPURaUrl/dQclxWXqDcy30WESfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R71HIHLqGBwqoow1WLkS5pJQUZDt9EF4KAQyzGpdxPDXne865Jgy35e2z5icd2nqC
	 lk9Ti6yiLfXrGwCoyCi0hu0g1nsUJHpW4pnMYJFvW7ygLskcWSVVa9nZnOjEINVGmE
	 nCvU14l4whrJ/mtzTolGqTKmeliQA8uFK/7atEcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0776/1257] Bluetooth: L2CAP: Reject mode changes on connected channels
Date: Sat,  7 Nov 2026 08:51:12 -0500
Message-ID: <20261107135000.740415196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d87d2dfbce684..a8de785cc45ac 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3802,7 +3802,11 @@ static int l2cap_parse_conf_rsp(struct l2cap_chan *chan, void *rsp, int len,
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



