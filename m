Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056636;
	b=HznMpeGMK06mLZjPga6sMyU0nB6QgCfHw56iiEgZ1Z7+LUr++J7XZFaSWGjEA03XKa3S
	 oS8OvaezRqVoe1Dh1vpetjSqv4mXzrNmKgn/KhXu2VsEUc8I2o4c66sh1i58WyrGwWaWx
	 BykNzHk8VWaMfrzxiiSu5SucaksDCaj/CEBxucctPoQ4/Xc5QeRP+o4zkgyXj5PzGId7Z
	 3Rx/EUpoNn3N/OKCu601d/oGZmVmdvWyCR6o1zzJmGkeJEVRxYaqCyHC1yyLmhcjiLJi1
	 u/nt/nOnWXvPEqu0CABvyL05J/ikMonKqhSadoWTWKZ8QkMuCmWubAhvaWX879mFtfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NvFgdxEbyeKGl0NLUzdWApyLHRJe8TfiHzhn38l3FcU=;
	b=UBbdflhxrFIAMY53Opq9q+dUpq/pTGWkISzL7IZMta6+dRaoDqD/iB7TsikpUo02VAzz
	 5Yy8+KchImIlX96nVHElaoMtzdxWgVvt+Ikazv+buq0E3q8XIGC5LtAxBuylooO42lQLv
	 afbm7Oy3hoxD86UTwX8Ap0p8MLEwv9Bmw527CeTZJfhamMVVnNKlxVJO4YZ6IHk2Sa4kg
	 VOIcZn7QZTTsqV6PruWbMIJQ5g+rQzdKii9AzKK+NuB2kv6RoDiDEOAtwERDx5VzFGn8h
	 fGVVKZUEpnzK9Cl6Btj4ddXu2h6gRb1I43mYWT/GpTLGVtlZnaZv2SBcbVQOVv+Bsbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIgFN2CL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C565606A32A;
	Thu, 19 Nov 2026 02:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIgFN2CL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945401F000C4;
	Thu, 19 Nov 2026 02:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056636;
	bh=NvFgdxEbyeKGl0NLUzdWApyLHRJe8TfiHzhn38l3FcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIgFN2CLMfPMvVYoE4P25weFzCTM0DZeGh4j+uwYAJGqZP/rTWs7Rwg6OYjuGdbFE
	 P4zhRf/GQiWZ4KrECEvzyCWx3lt69rJDPn06sKP2738F5UIqAQ1lqB+TCBtohW7SSO
	 Dcz4d7vxKrz6HOEIFbtKSPKxXAWoo9S4ssLw/9Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2058/2214] mptcp: options: mpc: avoid printing uninit data
Date: Wed, 18 Nov 2026 16:02:14 +0100
Message-ID: <20261118150133.005064361@linuxfoundation.org>
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
index 7f4dba42e756d..0dc5de6569fb4 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -121,8 +121,11 @@ static void mptcp_parse_option(const struct sk_buff *skb,
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



