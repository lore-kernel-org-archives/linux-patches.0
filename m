Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A5034EEF6;
	Wed,  3 Dec 2025 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778792; cv=none; b=GCXlpHtikqK0qdH2kubDBi1z8vzQg65SIxW0r+LhrdzuEK2fi4rs3LLS+pERv95yPInOPU3Ta2rzZgUtABgT+NqTJMd6GeywoQ/03zsb3IelJLBum5wpvtnSHwEZwhkzcL8ta8tXL/3bnXeOUr6YbcyeiOzxydFsuYzZEG7N9kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778792; c=relaxed/simple;
	bh=bVvGPP6PHSgW3l4mFmqkaOLo6ABFPhT2AjY90VrCncE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWFJ+kqjRthWf1l9f9ZTNHn11VA1kIBzRx6raiof6aGi8OYNX6/3y3o/c5bW3LJ5w+sA7FB9K+igx5f1jUIKkjUGmefxR16nzrP7B4vzOZAzS185flgeI67B3d86b6COqBH+GlNYWY43uzEp3dN2HIQ3TSKFTNfnJ9fV/5kSjmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7k+zzcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7k+zzcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058DCC4CEF5;
	Wed,  3 Dec 2025 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778792;
	bh=bVvGPP6PHSgW3l4mFmqkaOLo6ABFPhT2AjY90VrCncE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7k+zzcXwq+NdjfpHIgfQfGfW3NLWTl9yO8x5Nfzz5gmgI7PuOyqIwVNdDyae0FEo
	 8mn5dDkwb/HIauCCMmfBz8zBGqJqsqg8eS6kaH5NddnZmrX1ODxbSSQvPpeAKHDFeD
	 cTxkQHbk1+L5Uug/Y8rKcsuDxLZOa/Gvnvg7TtZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 033/568] mptcp: restore window probe
Date: Wed,  3 Dec 2025 16:20:35 +0100
Message-ID: <20251203152441.884615959@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit a824084b98d8a1dbd6e85d0842a8eb5e73467f59 upstream.

Since commit 72377ab2d671 ("mptcp: more conservative check for zero
probes") the MPTCP-level zero window probe check is always disabled, as
the TCP-level write queue always contains at least the newly allocated
skb.

Refine the relevant check tacking in account that the above condition
and that such skb can have zero length.

Fixes: 72377ab2d671 ("mptcp: more conservative check for zero probes")
Cc: stable@vger.kernel.org
Reported-by: Geliang Tang <geliang@kernel.org>
Closes: https://lore.kernel.org/d0a814c364e744ca6b836ccd5b6e9146882e8d42.camel@kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251028-net-mptcp-send-timeout-v1-3-38ffff5a9ec8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1391,7 +1391,12 @@ alloc_skb:
 	if (copy == 0) {
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
-		if (snd_una != msk->snd_nxt || tcp_write_queue_tail(ssk)) {
+		/* No need for zero probe if there are any data pending
+		 * either at the msk or ssk level; skb is the current write
+		 * queue tail and can be empty at this point.
+		 */
+		if (snd_una != msk->snd_nxt || skb->len ||
+		    skb != tcp_send_head(ssk)) {
 			tcp_remove_empty_skb(ssk);
 			return 0;
 		}


