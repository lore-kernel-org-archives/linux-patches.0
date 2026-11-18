Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021126;
	b=YbobaUdA/5nxhxRMruxEp5BjTHsByVX0pEn6p1MXvg7LWAYYQrWGsYmPiAe8hQFSLPNY
	 xRgvJ5bBdzqycmQuzzQTf0mrJr9+yXaKoIEa39mj0BeHcUpjG32FGX7nmknnF2CUilNxy
	 i596Ma/YIAf+zhxpTUd7Sak9eUR7cP1roEnXPM2kgF5RCdSiTYlc5ld44bhMCWCgnVafL
	 9OOZ2gTUBEGn5cx9A+2oXlnVrXN6G1FtHikHj6ZOEVGTbVZLY+pG8XNSEnoB8/C1TxaID
	 aYUG4UJXMybX4xAYfFxjvXAa0bdqvjUbSIlsMuWekoOulCIXMGG44dP+knMA0tsoPWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6aTncyi4HPUf4AQgO6Dt3hV3WDtUZ2r309QXSOza1E0=;
	b=Zu/sPGM7usQvoBvp94MExlDx/Rps0qknKJ3v+ZvdCWkqSLdPUqDGVbVwRRSeopyEveUr
	 p4c62yCbBDI5ohG23/vx4qnipVsWu5rUDrKQ3YT/5R5P894KykBjDvEurH6ezblRn1+5Y
	 jVmHS+zgCgGm0zg0OtTOGh/B0cn1nRwLnECn837lOWA8YkT92ln8D5gPmjU1okCq5Ak9a
	 CbTdgQKWYGyjCWGoFuxyywrdaMcs9aS9n4ueV5OfNRVYbrddYaArXJH8ShkxTCFF4bBuF
	 AwNFufrkultTfOoqPLs5Vbyug+izmEbALWKFCeH/+Tr3sZva1ky9IIhc7xp2ufotTTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4tIEudB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2458606A325;
	Wed, 18 Nov 2026 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J4tIEudB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EBA1F000C9;
	Wed, 18 Nov 2026 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021126;
	bh=6aTncyi4HPUf4AQgO6Dt3hV3WDtUZ2r309QXSOza1E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4tIEudBnK+ma8ZRN5Mz8Ro+9Xi+d4zaD1pg2l0SJ9t56y32ig0Mub6DwqGE5yy5l
	 Cz0yiZcMxIG3vBq/3njS8jM2OkA+dJ9AZq13DJbU6yS5A/wuQS2IAQMFc6C66tJhIT
	 t3yt0hDkiVGAu2hE7x/3hWANFwAOAv6wMX0O6yUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2197/2651] mptcp: options: mpc: avoid printing uninit data
Date: Wed, 18 Nov 2026 15:57:17 +0100
Message-ID: <20261118150404.812539952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit a234ee8eb9a20d1a272f0d2ceabdb35165071778 ]

When parsing the MP_CAPABLE suboption, this pr_debug() might read and
print uninitialised values.

That's mostly harmless, but that's also confusing. Fixing that also
avoids some tools to complain about accessing uninit data.

So read these fields only if they have been set.

Note: this was initially reported by Clashiko as an existing issue. The
code has been analysed by a human and confirmed. This is a non-urgent
fix.

Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according to v1 spec")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-next-mptcp-misc-feat-7-4-part2-v1-1-1181e5d2fda4@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ce0de02f5a3a1..564d10cdb7d12 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -126,8 +126,11 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			ptr += 2;
 		}
 		pr_debug("MP_CAPABLE version=%x, flags=%x, optlen=%d sndr=%llu, rcvr=%llu len=%d csum=%u\n",
-			 version, flags, opsize, mp_opt->sndr_key,
-			 mp_opt->rcvr_key, mp_opt->data_len, mp_opt->csum);
+			 version, flags, opsize,
+			 opsize >= TCPOLEN_MPTCP_MPC_SYNACK ? mp_opt->sndr_key : 0,
+			 opsize >= TCPOLEN_MPTCP_MPC_ACK ? mp_opt->rcvr_key : 0,
+			 opsize >= TCPOLEN_MPTCP_MPC_ACK_DATA ? mp_opt->data_len : 0,
+			 opsize == TCPOLEN_MPTCP_MPC_ACK_DATA_CSUM ? mp_opt->csum : 0);
 		break;
 
 	case MPTCPOPT_MP_JOIN:
-- 
2.53.0



