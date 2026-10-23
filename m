Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774895;
	b=5WrZXHLIk21xJQ9k/Cegvfcj6QhcddCQF9cjTqq/yXINBH6VoL6XcIUgwwutWaEGTeQ0
	 fjGjr/udh8NaHM3ZS7SSySXjYen+VkPSNcHorcrOg4gJgc0xFHIBllaE8LNf2pZdynl0M
	 fL2FwOd2v8/zkrFtsBLJMFAneh4dtAJ5wVgnEKigGRArU/ddTRaCFB6CsyXvCf549lXtw
	 g5E5h4kYrZ+Q6ZAbXPF6+wu6l713xyreR/Zmu9AO8lH+oA1cJYcd1ZtKjTAClBFYQC4XP
	 42xtPq0p6JQ2SnsfHxB+lRTxHRQ1zD+UzxiuIVXk31gkOuR8XQIWJGYoe6FljQUrhFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=sSRFEhZrk35la6Kxo95VCfyEVWc7kaWIWiYOIIGa4Fo=;
	b=eNkJ60UryIRgL4rbv9gOGB9p4fLnt7VFr0O1xgr8uN14FZTADRkuTkYXmRybRQjxyTTP
	 TwmTAZhPJMti9YI9dO9n/4CBJ6+DHEm3rDVb74HHyvOkiNpUTUjWrcidKfc4uUdQbVs1C
	 zmJBxQZ0C4lAZmqmfljJYnPxWHJJgPE96kysPx3uKH2tbXDPKUB5mxQb7iR9NImrn9wlb
	 hMPB8wfaOHnFUoG2CBkrSY9vijKyiL6nZVM+kFaP9kCxZuLqIW0AAMBjiDHPcTh8su6t+
	 NA64wlGI3n7aOBOXXdlZfTHXwy5l0XIPUpWrD7FiZA3ITEZf4BGRFCeG6TwdpjUP0Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FE7+CLVb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82998606A31A;
	Fri, 23 Oct 2026 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FE7+CLVb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55171F01825;
	Fri, 23 Oct 2026 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774895;
	bh=sSRFEhZrk35la6Kxo95VCfyEVWc7kaWIWiYOIIGa4Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FE7+CLVbiC5cLWgwUKWBkw+7rwamFWrWqZBHl3ytLWByAjaO6VqSH223V1AWckXAN
	 pExRbTHd6v0DnEXYmWGC3eF9GS8iYPUafrLVi84KRrALvTvj6qFN2HolKj9vn7gwD1
	 l2tW4ABKeEqJQbb/NBWIEkmhXsX49u9FYZOAkmBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 194/242] netlink: specs: add missing mask attributes for conntrack dump
Date: Fri, 23 Oct 2026 18:40:36 +0200
Message-ID: <20261023163718.381669458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit 8b348496cbec0d5ca24a99f668096e2e16e8fbeb upstream.

'mark-mask' and 'status-mask' are defined and supported by the
conntrack dump, but missing from the list of arguments.

While at it, the order of the arguments should follow the order of
their definition in the enum ctattr_type.  That appears to be a common
convention for other spec files.

Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Link: https://patch.msgid.link/20260826220444.4054714-3-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/netlink/specs/conntrack.yaml |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -604,10 +604,12 @@ operations:
           attributes:
             - tuple-orig
             - tuple-reply
-            - mark
-            - filter
             - status
+            - mark
             - zone
+            - mark-mask
+            - filter
+            - status-mask
         reply:
           value: 0x100
           attributes:


