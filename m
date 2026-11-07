Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064959;
	b=nINVzZdgOMg6iPSgQhKOC2f+1Adbkpnlv1GNgzZ1dYrN8DGZwHPEP/0/DS+2D0hoJwmH
	 HYnqttmZ80eofxkyHpLop2Ln9JtJb1hzSx7WmROcLivUsWZ5Km8MRPeEV6fMZg4qrQBhf
	 o8liynJtrXLTlF1d7hZEeCfPbk5X0TNL6QsgKlHrnlLMHyFl0UfVwNg+cQ+XztuXyootE
	 C0qB32AQf77N2xfZ+DHPOy2XLvNJf2iR4AyG13Ww+Ad50+FIZVHLc31MHiYnZUASdSPAq
	 tEa5bQceYjvi8+17ui94dKQ0vv+G+TCOljM4NvQzO9UQxxKiOXLzSju2cIzZ00surig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xwWYyLmJACdd7UF7ZG7BklGfHS2asKGa2S+ksWzLrXM=;
	b=nXzG5iv0ir9/rgDYF+5ajeO1qrF3denqW8m5Ea/4KHBAMeDWAHeUuKrin4kVFozOvq/J
	 JAduFsxomGHRr0U6gAa1w0RptptktnvkUrI966J6XmP46fYg3T82z9bQdwbicFm0hwxfB
	 UZBdLM3QjoVdmL1+BL3suVakKSZRQ5MGTsRlmtxrsATN/hSGZMvm5AziNgWETGi6OgFh/
	 f8e1z2+B5fVwBcfFGxraGsLUYMLXKynCX6V61KGwNen+57eZ7mYpZoI3Ql6KYeXZpornC
	 u73+/A09QVCI/ji7zwWQ7NPNAk6kON3isjmAK/yJIZkZOqX+TImvg4WNgGsIWldjVBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aASLy7zy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B2A606A9D9;
	Sat,  7 Nov 2026 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aASLy7zy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8B21F0089F;
	Sat,  7 Nov 2026 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064959;
	bh=xwWYyLmJACdd7UF7ZG7BklGfHS2asKGa2S+ksWzLrXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aASLy7zymZpqfTfcZZs7PaURXwAsaA46X+FEGCN3y9uOeombFoeddO4Jdme4nzVY0
	 UaTpZC5ANyB19TnNqlZV66sWhwwSlFRG50YtfPDeEiPXosA1p/1pFlbdD2EjRn1E49
	 2E1jUI9Vae48XG7Pcn4BytjYRFRE1/fhBX6xVxYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanye Yang <quanyeyang@proton.me>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0844/1257] mptcp: reset msk state on early connect failure
Date: Sat,  7 Nov 2026 08:52:20 -0500
Message-ID: <20261107135002.635508995@linuxfoundation.org>
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

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit 29afe67082b2d33ab2e90c56c337235d725f023f ]

mptcp_connect() can fall back before the subflow SYN is sent, for
example when the netns is in an MPTCP blackhole, token allocation fails,
or MD5SIG is in use. If the subsequent subflow connect() fails
immediately (EAFNOSUPPORT, ENETUNREACH, ...), __inet_stream_connect()
returns while the socket is still SS_UNCONNECTED and never calls
->disconnect(). This was reported by Clashiko [1].

The error path only dropped the token and moved the msk back to
TCP_CLOSE. MPTCP_FALLBACK_DONE, allow_subflows and
request_mptcp were left as after early fallback, so a later
connect() on the same fd stayed TCP-only.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/633 [1]
Fixes: 0235d075a592 ("mptcp: mark as fallback even early ones")
Cc: stable@vger.kernel.org
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-mptcp-misc-fixes-7-3-rc8-v1-1-932c9b182fc7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b902e24acd68b..05c38564e8fdf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -4233,9 +4233,16 @@ static int mptcp_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 	 * subflow_finish_connect()
 	 */
 	if (unlikely(err)) {
-		/* avoid leaving a dangling token in an unconnected socket */
 		mptcp_token_destroy(msk);
 		mptcp_set_state(sk, TCP_CLOSE);
+
+		spin_lock_bh(&msk->fallback_lock);
+		msk->allow_subflows = true;
+		msk->allow_infinite_fallback = true;
+		clear_bit(MPTCP_FALLBACK_DONE, &msk->flags);
+		spin_unlock_bh(&msk->fallback_lock);
+
+		mptcp_subflow_ctx_reset(mptcp_subflow_ctx(ssk));
 		return err;
 	}
 
-- 
2.53.0



