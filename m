Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022708;
	b=fqLuMJK9DaGJChbVJjErzLlrIKh11cYLBRhwf9OVDZSWV5+vlMN5OMilDL5dIPc7eQ1E
	 CLKnSevV8zT3vp4rBlvCbVRs7iwLqryzmkFuqWWi3WxNoZBeTmbn3Nu4kDyX9q2DFHmTU
	 4r+naJmZsO8v9HovffDwor7+PFDbVZUHSa7tqK1Qjb4p4IX8vBUfXeSRdKqsGrTCvWx0H
	 A8XFYfMS7NeIMLe9nr8Cv9e2wMVVS04eJGk3ISYm1s55Ukbc0ISOjYkjghxI/zgO086Q+
	 pSMTjweHXz+QiZmWCkMVqfY6Z5brMozDhHnE+j9xIKe2e7oF+G6F7dYEPhpDzw0ht4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LcFu5eMkZ2EMTQjclC+qzLWM8Bdbdfpiaa5hVs/rJcQ=;
	b=iRcix56l/YQblmivdSYTxxTMqqpIVSF7LYNrK3N792Rn3DWlIQOEtzxI6uM06BeSZA2h
	 YfhvC8ovlN6uG88Bx8xEKSn/Bkr6oI/nD6w0lRINOUpKzJ5bqHhH+I/O8tqLQcDtYgM2r
	 uEDTf1MKdN4KXmpHavip+J+FofNRw3OvASvtyi3mfWQwMrp2Xde+/0z8IYa0oqVTuGBzM
	 4W9FlXyG0BtrEXvQ72Hzi23qkVLzEwcFdvM4h9VULqpxBxKUtUyG4WT6kgJMyh52U4MmC
	 NJgrxwQFJlbVQKpHrlO706RpmjV6cbLpoD6cBn6BdvLxbtvcTs17Pncqmzc1CPHgDbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zbvO3OTH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F153E606A339;
	Wed, 18 Nov 2026 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zbvO3OTH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5439F1F000C8;
	Wed, 18 Nov 2026 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022707;
	bh=LcFu5eMkZ2EMTQjclC+qzLWM8Bdbdfpiaa5hVs/rJcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zbvO3OTHW7eOdI/0edpryUcpI4PMa6EIzbadX96Iqm/bCxjZpKNpeNWz64aj9gJEW
	 s+ED7j36nxIsO7G/9fEoC4/tv/lR45tEsNSW97mMYEP9kg77nMtqxBark43wtDMDyx
	 ZreZ1EFbYggJnqEpGlRYYxRVHDtvhSlSzNVcGznQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0110/2151] rose: check the length of Restart Request and Diagnostic frames
Date: Wed, 18 Nov 2026 15:30:45 +0100
Message-ID: <20261118150125.802484771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_route_frame() only makes sure that a frame holds the three bytes
of the ROSE header before it hands the frames with LCI 0 to
rose_link_rx_restart(). There, a Restart Request has its cause read
from byte 3 to set dce_mode, and a Diagnostic has bytes 3 to 6 printed.
A peer that sends them shorter makes the kernel read past the end of
the frame, and set dce_mode, which decides from which end LCIs are
given out, from whatever lies there.

Only read the restarting cause when the frame has one, and leave
dce_mode as it was otherwise. Ignore a Diagnostic too short to hold
its diagnostic code and the three bytes it reports, as x25 does with
pskb_may_pull().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 13db36d85e64fa98f579d5ee38e416baf9fc0dec)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_link.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 912d26f1fe359..7fbdf9c97cc68 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -185,7 +185,9 @@ void rose_link_rx_restart(struct sk_buff *skb, struct rose_neigh *neigh, unsigne
 			rose_link_restarted(neigh);
 		rose_stop_t0timer(neigh);
 		neigh->restarted = 1;
-		neigh->dce_mode  = (skb->data[3] == ROSE_DTE_ORIGINATED);
+		/* The restarting cause, when present, tells if the peer is a DTE */
+		if (skb->len > ROSE_MIN_LEN)
+			neigh->dce_mode = (skb->data[3] == ROSE_DTE_ORIGINATED);
 		rose_transmit_restart_confirmation(neigh);
 		break;
 
@@ -195,6 +197,9 @@ void rose_link_rx_restart(struct sk_buff *skb, struct rose_neigh *neigh, unsigne
 		break;
 
 	case ROSE_DIAGNOSTIC:
+		/* Diagnostic code and the first three bytes of the bad packet */
+		if (skb->len < ROSE_MIN_LEN + 4)
+			break;
 		pr_warn("ROSE: received diagnostic #%d - %3ph\n", skb->data[3],
 			skb->data + 4);
 		break;
-- 
2.53.0



