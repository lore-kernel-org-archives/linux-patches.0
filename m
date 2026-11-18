Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022176;
	b=eBkMC9+6suMGJ1ymJCACjyOWYzXRFj6yNxLglveY1kIQ1Uv4twpRQ9mwmW/I8sr9TVNN
	 LmTnXbnqWgDzNJ3N4KfqikttCnHYiOvoWlUwRUKFC94ShzKiilSNbTyrSgRUAMKd2yPHw
	 JtFsxLA2t3UUSbwgf96bD0q5FavII4sIKAKBWlcgKWMmHqQGjN82hGGDfkd+FB8xy4OLQ
	 eLtd5z8dzNBaeO1lpoVDmMNVDSSxnXBu5R2Wc5nGtv0c2s1n8PlMws3lRQqhUhT/gKhXk
	 hEkwjvlfgW5VttaBGR8LYYlJzZynHer7fxxwUrXloPRths4aBIcjnwO2aRVbQ5bGhRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MGM2dJfS/dx3LmdbbQKpbnbPgua4faxEUH5xFa4Cmjk=;
	b=sF5NJfeZtYLfO86TcKhWSyv7hWPm2JtDdfx6Kj3NyADsd8eFNzJ4cYwYhGi+nPrEjj0u
	 7YJAwhq5WoU8X5v3XVnBtbKH4zXg8zYEtbcpmJrkWlpKtOgCWdwTBrCOyH/HduMjmJb1S
	 uztdfOOgvks99DM3lGHonV+llu1gfh6DHcR/aKtghCVIQ4PdYm3FO69ThuOcIGY5WA7ne
	 rUJe2FNtdTL+NxNzn3s+pZZsPG8Fi98ZnXmUs332DedSiPbvWEFcQzxoClOvH1iV77nOu
	 gQP88+tKl/NIo1pEWpTZNKcXt2/+wNwe/ldXOQ7hBHtR9M6L5dvPk06UHy/aVbrKI+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNvPt6rv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA783606A335;
	Wed, 18 Nov 2026 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNvPt6rv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9211F000C5;
	Wed, 18 Nov 2026 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022176;
	bh=MGM2dJfS/dx3LmdbbQKpbnbPgua4faxEUH5xFa4Cmjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNvPt6rvHWlacyA1Bp3UM32FspipAVum7+6yoSl17eDJVzNksWTB5DwaDdK0FZAoP
	 EQQ/UJNLe9QiuT68XkrM1hsY5yqI3r24uOcgIu5YK+agWJ+nQmKJffqto8dEFAQCg0
	 EANb2YT4RJ5m9gChG9MhI50ub3VQoB4P12iRt4ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Guikun Yang <yangguikun19@qq.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2568/2651] net: mctp: free reassembly head skb when key_add fails on SOM
Date: Wed, 18 Nov 2026 16:03:28 +0100
Message-ID: <20261118150416.850827593@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit d2bfe74a8fe219a86b86c1f126e1d722a5001790 ]

When a start-of-message fragment creates a new reassembly key on the
broadcast/bind path, mctp_frag_queue() stores the skb as
key->reasm_head before the key is made observable with mctp_key_add().

If mctp_key_add() fails (a race with another SOM packet for the same
source/dest/tag, or the receiving socket going away), the error path
only drops the key reference via mctp_key_unref().  The final key
destructor frees the key itself but not key->reasm_head, and since the
key was never added to any list, neither the expiry worker nor socket
teardown can reach it to release the queued fragment.  The skb is
leaked.

Free key->reasm_head on the key_add failure path before releasing the
key.  Other teardown paths (__mctp_key_done_in(), EOM delivery) already
clear reasm_head before the final unref, so this only affects the
failure path.

Fixes: 4a992bbd3650 ("mctp: Implement message fragmentation & reassembly")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Reported-by: Guikun Yang <yangguikun19@qq.com>
Closes: https://lore.kernel.org/all/tencent_43A65D51143E18518EA968DF9323694EFD08@qq.com/
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/179287946888.17431.11219154409333681184@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index e7c95eeacb486..3d79c2031eba9 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -552,8 +552,16 @@ static int mctp_dst_input(struct mctp_dst *dst, struct sk_buff *skb)
 			 * can do is drop.
 			 */
 			rc = mctp_key_add(key, msk);
-			if (!rc)
+			if (!rc) {
 				trace_mctp_key_acquire(key);
+			} else {
+				/* key_add failed: the key is not observable by
+				 * any cleanup path, so free the fragment we
+				 * just queued on it to avoid leaking the skb.
+				 */
+				kfree_skb(key->reasm_head);
+				key->reasm_head = NULL;
+			}
 
 			/* we don't need to release key->lock on exit, so
 			 * clean up here and suppress the unlock via
-- 
2.53.0



