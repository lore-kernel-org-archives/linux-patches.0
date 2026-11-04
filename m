Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829147;
	b=C/aZdOowhPxzsT+cy5OW9exaniHk7LyPcYL4NEp/SA4kVOiUHUaGUvHT2FQAuIxI3ElB
	 DV5Xfb5nWe/juYKAoyNQFdJjoAeR2s9gOC+57HQiuiT8Z1ag1lPBKAZblP2hu4Acv22Qk
	 XyQ4zMf+YDAG0sSoeXPrPvaJx7k7/mAjc8kGAqgs4yZKZUp1K1Di6hPpO6JQLHUC5hDC0
	 MLavSL1iItKqh6gmg+4kU0ZfRX+vsj3gvKQK0DHsiYjp1BuoD9Vi3cJlZpxIHmGhIgEjk
	 2lMNgH7QfoTyWTHdCMJjJJf95Izt20jGEH+pPjbyQRo47Xj0K9rsfwzWN6uVDNsZQFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ypY8E9EhDrWQ8bXfkd0lTNA2i3i0fJlSnWZiecoNvFM=;
	b=hYkBwejHBOWLzlvNRbRHovlTcijDTXBzp0/U6AR7KZNf/x/spZQ6yie/Q2DumTUznK/9
	 uRA42IDEnmyaNwXRP72+AcUKEPaUe//UHaFGgOmz2WdSU7lypAFK8GzyzKaQ3pUd2e1Au
	 Z92I/lGooTzJk0CoYh3JZ+2g7A8RKnyU5wk+ezkcH2yg0JSMOrjz90nK1BmF2YCQqkn0D
	 0WsN2KpqywhME46VDw56OolXlsEaTYC+p8zcA/RHEj06q/C0LLTQRXBi2QYbp22tt/y6r
	 IUpdVp46al0+zh4c8CHJSEGo/rWS6NlC35ZembyHmSjlobJVDNVPxtaHvG6G2o1oKaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DM4npxUY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02713607031A;
	Wed,  4 Nov 2026 21:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DM4npxUY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9F01F00919;
	Wed,  4 Nov 2026 21:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829146;
	bh=ypY8E9EhDrWQ8bXfkd0lTNA2i3i0fJlSnWZiecoNvFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DM4npxUYpupP2ENFnQbc24or1WDV9Ci86L4lZfnfwVp7iLdA3/qHOZXvaFduzJEHc
	 qFP7evQqM57W/4oKqSCeAcKLZrQxW024F+9R4iTykNZo5KfeQ3oEwV+ykoldGdiPLt
	 psOwu//u3ZCoD0bDwmtXuKgUpSMZMojMhOUdpvbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 437/547] sunrpc: honor the netlink unix_gid NEGATIVE flag
Date: Wed,  4 Nov 2026 16:10:21 -0500
Message-ID: <20261104211050.764905811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Ameer Hamza <ameer.hamza@truenas.com>

commit 7bc856dfaa104bf2bc26abd40b53dbf857c2d5bc upstream.

The unix_gid netlink upcall protocol has an explicit
SUNRPC_A_UNIX_GID_NEGATIVE attribute for failed group lookups, and
mountd sends it, but sunrpc_nl_parse_one_unix_gid() only allocates
an empty group list for a flagged reply without propagating the
flag into the entry, so it installs a valid positive entry with
zero groups. Such an entry strips the uid of all supplementary
groups until it is refreshed or expires: the same defect the
previous patch fixes on the classic channel, on a transport that
can say "lookup failed" explicitly.

Set CACHE_NEGATIVE for flagged replies, as the netlink ip_map
path already does for its negative flag. An empty GIDS list
without the flag remains a positive entry.

Fixes: 0850e8603cd7 ("sunrpc: add netlink upcall for the auth.unix.gid cache")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Ameer Hamza <ameer.hamza@truenas.com>
Link: https://patch.msgid.link/20260814221953.108837-3-ameer.hamza@truenas.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcauth_unix.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -730,6 +730,8 @@ static int sunrpc_nl_parse_one_unix_gid(
 			   boot.tv_sec;
 
 	if (tb[SUNRPC_A_UNIX_GID_NEGATIVE]) {
+		/* failed lookup: keep the credential's own groups */
+		set_bit(CACHE_NEGATIVE, &ug.h.flags);
 		ug.gi = groups_alloc(0);
 		if (!ug.gi)
 			return -ENOMEM;


