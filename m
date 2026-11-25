Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619970;
	b=5qMCSWqSV+I6sTLtwiTLSHpLP6hdnZuUKQhEbOi4ij0vFPYPp/0EFJp7EOF0RO1Gp1+U
	 Y8gVEWWpR0qOjNz5EPbfoUCLRrj2fHspUhNPtqHIcsMSSFwENLce8sPFHVuUTTbf0GljU
	 oPlvtDNOHf+BihGlk9lOV4aps5Y951xcwthYy8eRmqLfA4dUHvParKwFmc7BNYBgGEYn1
	 lvsWrI6SsS6INMsriQo5nEgl8toqwsgYk6/RX9//P4FIepw2tx58YJln7N94ByecETtK/
	 XJ1QD76jAegFfT2L6DLXimrrOaNCqyMj5PSxlZtfZRmnjCaHDQTv1S6WYCWuSv2R+TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HgqFU8IWt61fyTfH4DI3L5vUBySyCD/vcY3MccpZl9E=;
	b=dOR2cFljO1BtpmCyHgbwAGcJEP1671Zkkr0VOE0mt/LuMwgNc5+t/EiP8saD7qbZ1zAS
	 MDJOAF48BqVvfkQ5WyDV4mE6b6dJM8c7ICRL3FnLupsl15TitLbXd3VjmIoujox2TFWhC
	 GuLwCFrje/JhdXSthZM//jLa7KHyZWbKPicledZVNDv1LbAukR7Zm/f/4Y8N30AV6L9CD
	 3MMTfbkpHe3qFFfjQ8BqPZgbD8TGroCv6jeVsmH0wrTphG7kD+RqZ5q9OQPffHuKfqNkS
	 kxQqibLNAi81SwvRxzVQgoQ5QpC8BoPu0h1WtBqWsnES3N0VW8CCDyoKoJo9vw7780w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WlV0T4s6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD8C606A321;
	Wed, 25 Nov 2026 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WlV0T4s6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEDE1F000C6;
	Wed, 25 Nov 2026 15:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619970;
	bh=HgqFU8IWt61fyTfH4DI3L5vUBySyCD/vcY3MccpZl9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlV0T4s6PRTcAGtoDPlfxW1opPYHml7BqaUvALBoJlyPt/Ytl2Icf23heaxNHfJ7A
	 D+9AuqLWpr4ZcmD4lIfawAhQUlYF0ZPl0S4amJhpWNcA0oFNXQ2d8Www79l9nbaCgm
	 Kr211Kon9NGkBODpdxgW+nXTBD4wCgw1oV/CSB/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 7.3 0766/1005] sctp: fix ASCONF address change on single-homed hosts
Date: Wed, 25 Nov 2026 15:35:04 +0100
Message-ID: <20261125143839.690306488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Andrey Misiurov <andrey.misyrov@gmail.com>

commit 5175b2fb34c77cf2cd56a290affa45412cb3a228 upstream.

Commit 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in
DEL-IP processing") refuses a DEL-IP of the transport the ASCONF was
located by, so that a later wildcard DEL-IP cannot use it after free.

This also breaks the single-homed address change (RFC 5061 5.3.2). The
host sends [Address Parameter L] [ADD-IP S] [DEL-IP L], the association
is located by L, and DEL-IP L is now refused. The sender never gets an
all-success ASCONF-ACK, keeps src_out_of_asoc_ok set and stops sending
data, so the association stalls.

Fix the wildcard DEL-IP instead: look up the transport of the packet
source rather than reusing asconf->transport. Both DEL-IP paths can
now free asconf->transport, and chunks bundled after the ASCONF still
use it, so point it at a surviving transport: the packet source for the
wildcard delete, the primary path for a plain one.

Found by manual code inspection while reviewing a backport of commit
9b2854f86f0b; reproduced on a two-namespace single-homed renumber.

Fixes: 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in DEL-IP processing")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3160,9 +3160,12 @@ static __be16 sctp_process_asconf_param(
 		 * packet MUST be deleted.
 		 */
 		if (af->is_any(&addr)) {
-			sctp_assoc_set_primary(asoc, asconf->transport);
-			sctp_assoc_del_nonprimary_peers(asoc,
-							asconf->transport);
+			peer = sctp_assoc_lookup_paddr(asoc, &asconf->source);
+			if (!peer)
+				return SCTP_ERROR_REQ_REFUSED;
+			sctp_assoc_set_primary(asoc, peer);
+			sctp_assoc_del_nonprimary_peers(asoc, peer);
+			asconf->transport = peer;
 			return SCTP_ERROR_NO_ERROR;
 		}
 
@@ -3175,13 +3178,9 @@ static __be16 sctp_process_asconf_param(
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;
 
-		/* Don't free asconf->transport; a later wildcard DEL-IP
-		 * parameter reuses it.
-		 */
-		if (peer == asconf->transport)
-			return SCTP_ERROR_REQ_REFUSED;
-
 		sctp_assoc_rm_peer(asoc, peer);
+		if (asconf->transport == peer)
+			asconf->transport = asoc->peer.primary_path;
 		break;
 	case SCTP_PARAM_SET_PRIMARY:
 		/* ADDIP Section 4.2.4


