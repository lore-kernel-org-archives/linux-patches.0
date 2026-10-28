Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215746;
	b=RcShriD/TfOA0VV8hIdqHN4hRLrabD4t0sHYqLuCtJuiTpV0jAXT9COt9n/1CChF79oY
	 ZPuASR4NG28c1C2rfudv9CnKsNaxtE8YEd2Rxs77HmDyJXLSK6ssps0vV2Kg6SoJ2I1w6
	 Cx8wl4dN3ji+Qlbmb2WuVgY7csZee8xxF5mVv03tx9DcrJvzCN9C+MHPKmariIpbiBQCa
	 my5rYM7Mi4JP2U2kPSke9vPi+5SPIHEKnnsC7MNTgZKvJQSqnwYkKn/66y0b4znMfgw6c
	 GXlejPjWI42ReraeiTr4yUVOZbo8+fhdhS1hY/5+v+0e4WTb/jQfmschrtyVwz79tiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmnG7sTuKB841G/O2Phv4Pswr+UxXI+2YO8XU+PL2nU=;
	b=sIck0SnXFJuddk/ped3QwizFe3efZQHAAvGT/izhJipxE14eetAf4+6cXP2VXGL1L+JS
	 BxYoufbQF2ZPwJL6K9RcnN1xW38UAXOzOiO9BNqLsKJraYcJqcVFL7RK94l5F4qcjWTm6
	 9+NU2OOoLyR3KD3T8Z8ukh3kQ1feC8XRqo/8CN+uogXK9ttIiAil9NUPGCRqiacAz1R5R
	 yU+R4e5HdCexgknNc1VXfOXixEFJ6MKKT+o155eILsyZoS1CWXhOCskj9bYJDUqp4g0ig
	 pgzbOWoY+W4gr4NtAce0JC0QlKH2rAbbdiPq5BTBhpLsTE/g+aR+w6orFMW2Sub2Cvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m23wHJSK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1578A606A31A;
	Wed, 28 Oct 2026 19:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m23wHJSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236901F01825;
	Wed, 28 Oct 2026 19:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215745;
	bh=kmnG7sTuKB841G/O2Phv4Pswr+UxXI+2YO8XU+PL2nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m23wHJSKyq6P3sPlV2ZYF8fbdkGdMnRVf9BgH3wT0C/bp/Cz6HPtx4U3KKG3l8n95
	 eIGK/RojzZn1zGXH0nI/tPWzV/+JlcfW4ukteAgs7YsS//JqX6jy8viWVuBTaJvIFV
	 6kEd7AffORsS/SltCuEmE2iJNQkrVaTGOCz/KXCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1316/1887] mptcp: avoid combining some incoming suboptions
Date: Wed, 28 Oct 2026 17:56:52 +0100
Message-ID: <20261028170529.375536877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit b6ee361524641f57b2e2363f7737f20e17f67827 ]

Some MPTCP suboptions are mutually exclusive according to the RFC8684,
but also because in different places, the code doesn't expect some
combinations to be present. That's specially true for suboptions that
would be present twice, but with different attributes.

The new restrictions are the same as the ones applied on the output
side, with mptcp_write_options. The same rules can be reused with a
small fix: an MP_FASTCLOSE can be used with a DSS when the sender picks
this option [1], which is not the case on Linux. Here are the rules:

  Which options can be used together?

  X: mutually exclusive
  O: often used together
  C: can be used together in some cases
  P: could be used together but we prefer not to (optimisations)

  | Opt: | MPC  | MPJ  | DSS  | ADD  |  RM  | PRIO | FAIL |  FC  |
  |------|------|------|------|------|------|------|------|------|
  | MPC  |------|------|------|------|------|------|------|------|
  | MPJ  |  X   |------|------|------|------|------|------|------|
  | DSS  |  X   |  X   |------|------|------|------|------|------|
  | ADD  |  X   |  X   |  P   |------|------|------|------|------|
  | RM   |  C   |  C   |  C   |  P   |------|------|------|------|
  | PRIO |  X   |  C   |  C   |  C   |  C   |------|------|------|
  | FAIL |  X   |  X   |  C   |  X   |  X   |  X   |------|------|
  | FC   |  X   |  X   |  P   |  X   |  X   |  X   |  X   |------|
  | RST  |  X   |  X   |  X   |  X   |  X   |  X   |  O   |  O   |
  |------|------|------|------|------|------|------|------|------|

The only difference is with the 'P': another stack could send and
ADD_ADDR with other suboptions (DSS, RM_ADDR), and this should be
allowed.

A few points of attention:

 - In theory, an MP_CAPABLE could be used with a RM_ADDR, but there is
   no reason to add it with a SYN. Note that even with a 4th ACK, it
   doesn't seem to be useful, except when IDs are known in advance via
   another channel. Better not to break that.

 - Now, combining both an MP_CAPABLE and an MP_JOIN will no longer
   result to a reject of the two options, but only the second suboption
   is ignored. That seems OK to do that for this unexpected error. At
   least now all inconsistent combinations are handled the same way.
   This could change later in next. This also means the explicit checks
   for having both MPC + MPJ in subflow.c will now be unreachable.
   That's fine, they will be removed in a follow-up patch.

 - In case of conflicting combinations, the extra suboption(s) is/are
   ignored: having such combinations either means the remote peer is
   buggy, or is evil. The simplest action is then taken in this case:
   stop processing the current suboption.

 - In mp_opt->suboptions, there is also a bit reserved to the checksum,
   which can be used in an MP_CAPABLE and a DSS. Each time a DSS option
   can be used in parallel with another option, the checksum can be set,
   so the verification is combined into a new OPTIONS_MPTCP_DSS macro.

 - An MP_CAPABLE ACK can carry a Data-Level Length, and an optional
   Checksum: they are the same as the ones found in a DSS, because a DSS
   cannot be used in parallel to an MP_CAPABLE. Similarly, even if there
   is room, a DSS cannot be used with an MP_JOIN.

Fixes: eda7acddf808 ("mptcp: Handle MPTCP TCP options")
Cc: stable@vger.kernel.org
Link: https://www.rfc-editor.org/rfc/rfc8684.html#section-3.5-5.1 [1]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-2-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c  | 70 +++++++++++++++++++++++++++++++++++++++++---
 net/mptcp/protocol.h |  1 +
 2 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 6f82517b8f6f5..79c5f731a5e12 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -26,6 +26,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 {
 	u8 subtype = *ptr >> 4;
 	int expected_opsize;
+	u16 subopt;
 	u8 version;
 	u8 flags;
 	u8 i;
@@ -38,11 +39,23 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 				expected_opsize = TCPOLEN_MPTCP_MPC_ACK_DATA;
 			else
 				expected_opsize = TCPOLEN_MPTCP_MPC_ACK;
+			subopt = OPTION_MPTCP_MPC_ACK;
 		} else {
-			if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_ACK)
+			if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_ACK) {
 				expected_opsize = TCPOLEN_MPTCP_MPC_SYNACK;
-			else
+				subopt = OPTION_MPTCP_MPC_SYNACK;
+			} else {
 				expected_opsize = TCPOLEN_MPTCP_MPC_SYN;
+				subopt = OPTION_MPTCP_MPC_SYN;
+			}
+		}
+
+		/* Only the MPC + ACK can be used with a RM_ADDR */
+		if (subopt == OPTION_MPTCP_MPC_ACK) {
+			if ((mp_opt->suboptions & ~OPTION_MPTCP_RM_ADDR) != 0)
+				break;
+		} else if (mp_opt->suboptions != 0) {
+			break;
 		}
 
 		/* Cfr RFC 8684 Section 3.3.0:
@@ -86,7 +99,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 
 		mp_opt->deny_join_id0 = !!(flags & MPTCP_CAP_DENY_JOIN_ID0);
 
-		mp_opt->suboptions |= OPTIONS_MPTCP_MPC;
+		mp_opt->suboptions |= subopt;
 		if (opsize >= TCPOLEN_MPTCP_MPC_SYNACK) {
 			mp_opt->sndr_key = get_unaligned_be64(ptr);
 			ptr += 8;
@@ -118,6 +131,11 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_MP_JOIN:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTION_MPTCP_RM_ADDR |
+					    OPTION_MPTCP_PRIO)) != 0)
+			break;
+
 		if (opsize == TCPOLEN_MPTCP_MPJ_SYN) {
 			mp_opt->suboptions |= OPTION_MPTCP_MPJ_SYN;
 			mp_opt->backup = *ptr++ & MPTCPOPT_BACKUP;
@@ -149,6 +167,14 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_DSS:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTION_MPTCP_ADD_ADDR |
+					    OPTION_MPTCP_RM_ADDR |
+					    OPTION_MPTCP_PRIO |
+					    OPTION_MPTCP_FASTCLOSE |
+					    OPTION_MPTCP_FAIL)) != 0)
+			break;
+
 		pr_debug("DSS\n");
 		ptr++;
 
@@ -236,6 +262,12 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_ADD_ADDR:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_RM_ADDR |
+					    OPTION_MPTCP_PRIO)) != 0)
+			break;
+
 		mp_opt->echo = (*ptr++) & MPTCP_ADDR_ECHO;
 		if (!mp_opt->echo) {
 			if (opsize == TCPOLEN_MPTCP_ADD_ADDR ||
@@ -295,6 +327,14 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_RM_ADDR:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTION_MPTCP_MPC_ACK |
+					    OPTIONS_MPTCP_MPJ |
+					    OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_ADD_ADDR |
+					    OPTION_MPTCP_PRIO)) != 0)
+			break;
+
 		if (opsize < TCPOLEN_MPTCP_RM_ADDR_BASE + 1 ||
 		    opsize > TCPOLEN_MPTCP_RM_ADDR_BASE + MPTCP_RM_IDS_MAX)
 			break;
@@ -309,6 +349,13 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_MP_PRIO:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_MPJ |
+					    OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_ADD_ADDR |
+					    OPTION_MPTCP_RM_ADDR)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_PRIO)
 			break;
 
@@ -318,6 +365,11 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_MP_FASTCLOSE:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_RST)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_FASTCLOSE)
 			break;
 
@@ -329,6 +381,11 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_RST:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTION_MPTCP_FAIL |
+					    OPTION_MPTCP_FASTCLOSE)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_RST)
 			break;
 
@@ -344,6 +401,11 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		break;
 
 	case MPTCPOPT_MP_FAIL:
+		/* Can be used with a restricted number of other options */
+		if ((mp_opt->suboptions & ~(OPTIONS_MPTCP_DSS |
+					    OPTION_MPTCP_RST)) != 0)
+			break;
+
 		if (opsize != TCPOLEN_MPTCP_FAIL)
 			break;
 
@@ -1416,7 +1478,7 @@ void mptcp_write_options(struct tcphdr *th, __be32 *ptr, struct tcp_sock *tp,
 	 *  RM   |  C   |  C   |  C   |  P   |------|------|------|------|
 	 *  PRIO |  X   |  C   |  C   |  C   |  C   |------|------|------|
 	 *  FAIL |  X   |  X   |  C   |  X   |  X   |  X   |------|------|
-	 *  FC   |  X   |  X   |  X   |  X   |  X   |  X   |  X   |------|
+	 *  FC   |  X   |  X   |  P   |  X   |  X   |  X   |  X   |------|
 	 *  RST  |  X   |  X   |  X   |  X   |  X   |  X   |  O   |  O   |
 	 * ------|------|------|------|------|------|------|------|------|
 	 *
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 716a6947fba74..6728f08970f2f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -36,6 +36,7 @@
 				 OPTION_MPTCP_MPC_ACK)
 #define OPTIONS_MPTCP_MPJ	(OPTION_MPTCP_MPJ_SYN | OPTION_MPTCP_MPJ_SYNACK | \
 				 OPTION_MPTCP_MPJ_ACK)
+#define OPTIONS_MPTCP_DSS	(OPTION_MPTCP_DSS | OPTION_MPTCP_CSUMREQD)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
-- 
2.53.0



