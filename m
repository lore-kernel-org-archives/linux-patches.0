Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032478;
	b=cn24u9K2ZSQu8WaJ/aJN9ZkKZXHQrhtA772HdbouKxtqVPme/5pX0zXUBCgJ/uq/mvL7
	 pU4c3CQ9gszm/75OVSEeS/BAINonIu+Klmq5iVQ6p9msQpS2I/eHxjrsURzSGE1FOXHp8
	 t03lr7ZAA0RgADZW2ENvjYgVgoSkRGCoYnHtAaiZNqwZd4OA3wqbwx1bOdZ/lxqGWkwRt
	 YuLHAhLBCzFXQwkbVbJHMV/eGgUXYE7Rb06keLwd3DCBMuV8JVAYE8II1TNkXtGG8zudT
	 bNH2ZZ9vx/hRUy/d+5M2PGzfosozvD0XO8Ts5Zs905WqeuZjXvsjzxnmPzivqatXb2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r1OncuvwsSnIEIfvAnQPGGxL6k4UK7qUCLftKnfJsng=;
	b=omQDfHZvsgpR0eGN/fArVLv2X+AKvp8kP3fxJB3WSK3gkWp3se0+Uyo9BOadg+RNGVSe
	 cM4ArcvF++dmwOD/alxq3WSAqJRbOgpWY7w0rfwbXdwo2ZkcnFW2qe5xfyJj7xIHBGFhV
	 uaUJr/jpPbrO5HkjPemd1aAi2WQsSxNGiUqAJEJeoqbuG1Nv74yUnrKMrWODJ2U6RmrdV
	 SSTyPKykvOGrACvuVjIK8HjDe/K0ktQ4cUlJ/hyoqHNnrpUk+OZ1+GnQLWSdmdPHXQUfz
	 t7ladw5wzqvVIH9LszJtPC8Ju2vHuPeR7395TAkTrfk/bQbZ94LT8AwchjhNXC8AmEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmQsvn1O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B38606A32C;
	Wed, 18 Nov 2026 20:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmQsvn1O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30361F000C6;
	Wed, 18 Nov 2026 20:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032478;
	bh=r1OncuvwsSnIEIfvAnQPGGxL6k4UK7qUCLftKnfJsng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmQsvn1O6Bs0XNSSQrJqk3c0WTNcKY2KHGiSOJqctzvFeYbDIMDoTeil2Y9qwlCq9
	 ZjdRXphUfwpne92RiG7Y4YhqltFhgyHDBjDbRztCK4W5rTyFc40M/ZdPxRPD5H82g+
	 Gb9qQP9DmZN9bAzRAOCt8dpUye1lPIDEshskOP3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1427/1756] mptcp: options: dss: avoid printing uninit csum
Date: Wed, 18 Nov 2026 15:59:14 +0100
Message-ID: <20261118150106.022013122@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 00e2690c9dad0e09cd2a4435b98de6d8efd5fbc2 ]

When parsing the DSS suboption, this pr_debug() might read and print
uninitialised checksum value.

That's mostly harmless, but that's also confusing. Fixing that also
avoids some tools to complain about accessing uninit data.

So read this csum field only if it has been set.

Note: this was initially reported by Clashiko as an existing issue. The
code has been analysed by a human and confirmed. This is a non-urgent
fix.

Fixes: 390b95a5fb84 ("mptcp: receive checksum for DSS")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-next-mptcp-misc-feat-7-4-part2-v1-2-1181e5d2fda4@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 0fdb7900dac2f..d42d8cc1cbb85 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -259,7 +259,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			pr_debug("data_seq=%llu subflow_seq=%u data_len=%u csum=%d:%u\n",
 				 mp_opt->data_seq, mp_opt->subflow_seq,
 				 mp_opt->data_len, !!(mp_opt->suboptions & OPTION_MPTCP_CSUMREQD),
-				 mp_opt->csum);
+				 (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD) ? mp_opt->csum : 0);
 		}
 
 		break;
-- 
2.53.0



