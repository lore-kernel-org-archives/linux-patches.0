Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623295;
	b=yOF5Le3vL5GgvvKG4E0aHAU/Mw438pDKyNvBnPgWPH6J1i9VRpN8m23/JgyrjotZLtif
	 0ACTcR/0vLZgq3mAev7PcBiQU5K+Bx2dz+c3xv1wVP0xSZbdMtaKZ7jIIdspeCYL6nzIx
	 nOn2E1u8X9Yvrg4TKCFii1jnGd2E59EXJXIfQwutqpjFe1g1hL35AZa6CbwLbIN+J5Lsf
	 zzqE87dyNwUoipElnoEtuVIsksMNe5P/iXP/il3B+nO7WW5u+hA/IfosHlQ+hfmyIkvRl
	 JKvEUiU1XJKvYOknpUNob0KcTZWV9ReStY00HTNjMoMHGPi7+CaYlZS0Lp/cIum3fwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wnY4PtuWatHbQ80+ohk1D+xPkidBVjWkpfaHRx/seJw=;
	b=AUeEEWEGd0SEu6h/IOAJTGYaCQb/9GVkcPZOfi0+Rw1p2tcf2FY6SnfEJto8QBj/RFdZ
	 k6D7NUCswqBuLBcNKU90vUbyqd4dLf6D8ssq+b9TuP28+F3pES+/6jHYkr4dVkS8Vb/Za
	 6NkdiwyOrRlUZZlm9nF7sc1NkdJd+COz6Nydsjnx6C7mzGTcn3SSE7yCsJ1m6gMS/nVNV
	 gheQYXvwyhONUxGnmfpA2ELB+N0Q71v/OQ8aSLC5xU+r07Xnxv7nqI5oxexxHlPB0DeIQ
	 1yyf/7/d2ab2UPJN+0Gko2YqvNPZugpkmqyww+6fs2qm/FL4CbKChsFHtuaFzQG1fyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yNkTYU/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78643606A321;
	Wed, 25 Nov 2026 16:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNkTYU/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BE91F000C0;
	Wed, 25 Nov 2026 16:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623294;
	bh=wnY4PtuWatHbQ80+ohk1D+xPkidBVjWkpfaHRx/seJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNkTYU/c+dvPvEpeONBS/6VKmXRz7KG1QT6KGoWHLVKrAymdxpZaZXd8003tg8Dj0
	 zoynlGgK6qCEG6kx3IbUPXFWGlcj79P+ByRX8p5wz/9e6hj5nFLuE+j23QTUJLe3iG
	 ++lSCyx4KNl94KPy8niHZCpxQN0hw/hUyAQnJy0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 812/990] wifi: cfg80211: preserve mesh A-MSDU lengths when adding mesh headers
Date: Wed, 25 Nov 2026 15:36:19 +0100
Message-ID: <20261125143841.064308386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 9083da9dd3223068237395432323b407012aec1f upstream.

A malformed mesh A-MSDU subframe with a declared payload length near
65535 bytes can pass validation against a much shorter aggregate.

ieee80211_amsdu_subframe_length() adds the mesh control length to the
declared length in a u16, and ieee80211_is_valid_amsdu() stores the
result in a u16 local. The sum therefore wraps before either walker
compares it with the remaining aggregate length. The decomposer then
splits and delivers the malformed aggregate instead of rejecting it.

Keep the computed length in unsigned int in both the helper and the
validator so oversized subframes cannot wrap.

LLM assistance was used to find the bug and review.

Fixes: 6e4c0d0460bd ("wifi: mac80211: add a workaround for receiving non-standard mesh A-MSDU")
Fixes: fe4a6d2db3ba ("wifi: mac80211: implement support for yet another mesh A-MSDU format")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142149.13834-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -745,12 +745,12 @@ __ieee80211_amsdu_copy(struct sk_buff *s
 	return frame;
 }
 
-static u16
+static unsigned int
 ieee80211_amsdu_subframe_length(void *field, u8 mesh_flags, u8 hdr_type)
 {
 	__le16 *field_le = field;
 	__be16 *field_be = field;
-	u16 len;
+	unsigned int len;
 
 	if (hdr_type >= 2)
 		len = le16_to_cpu(*field_le);
@@ -772,7 +772,7 @@ bool ieee80211_is_valid_amsdu(struct sk_
 		    __be16 len;
 		    u8 mesh_flags;
 		} hdr;
-		u16 len;
+		unsigned int len;
 
 		if (sizeof(hdr) > remaining)
 			return false;


