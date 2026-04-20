Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B894175A63;
	Mon, 20 Apr 2026 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776698490; cv=none; b=IYUg7YMHIzdJHOU/LgT9+hVulATXzXpQJuaJYLrlRCDzJmjpWTdQZ7d43infuTG/xQqHhs1eLFwH/ZESgU3a4blLeF8AFdthnoaN6RAJ8bTqGcHBpcilrb33++S5wmfmek0fclqBiLlzKZgdBOpLbIw2qDWT7kbxeDrBNiP3HNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776698490; c=relaxed/simple;
	bh=UeqWxFCxJWIrKJ4Os0GUnCwXyxhP/NkPtle1op1eeUw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=bE3q7F7TF4x5NKswT/l4iLLvVBkuVXyRyH7WJzWZUw0mIsfgyNR1+B5sIU96LzE6saeFGj0c7WPA+xBt97s/G4EPcWzi+1388vc9hUGMa5Mv4F6BZMZMdJyAa47JrczUMUBEKSwe0g8rfk/YI9FC+cSeQp4r+oD8KE2UuCH5esQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWU34Bxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWU34Bxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D502EC19425;
	Mon, 20 Apr 2026 15:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776698490;
	bh=UeqWxFCxJWIrKJ4Os0GUnCwXyxhP/NkPtle1op1eeUw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=YWU34Bxlg9qDY/FPvN+w4RxHfQsJEucanU7iKIOxNzN/r/zrTbGcGVxwQEW5jgAwv
	 ZinVgUgPcK4fXxIG99gnQfoD6Vrm8N6/CSvUgHAFreFfS1Ej4CXDR2VJ411MrZqmRh
	 2/8EvoHw+oqmXAJrQge4HXu5ttkbkq5dvPapEMf4=
Subject: Patch "ipv6: add NULL checks for idev in SRv6 paths" has been added to the 6.12-stable tree
To: 1468888505@139.com,andrea.mayer@uniroma2.it,davem@davemloft.net,david.lebrun@uclouvain.be,dsahern@kernel.org,edumazet@google.com,gregkh@linuxfoundation.org,heminhong@kylinos.cn,horms@kernel.org,kuba@kernel.org,pabeni@redhat.com,patches@lists.linux.dev
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 20 Apr 2026 17:21:27 +0200
In-Reply-To: <20260420054241.3043646-1-1468888505@139.com>
Message-ID: <2026042027-whoops-imperfect-180a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ipv6: add NULL checks for idev in SRv6 paths

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ipv6-add-null-checks-for-idev-in-srv6-paths.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-238692-greg=kroah.com@vger.kernel.org Mon Apr 20 07:43:16 2026
From: Li hongliang <1468888505@139.com>
Date: Mon, 20 Apr 2026 13:42:41 +0800
Subject: ipv6: add NULL checks for idev in SRv6 paths
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, heminhong@kylinos.cn
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, david.lebrun@uclouvain.be, netdev@vger.kernel.org, andrea.mayer@uniroma2.it
Message-ID: <20260420054241.3043646-1-1468888505@139.com>

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit 06413793526251870e20402c39930804f14d59c0 ]

__in6_dev_get() can return NULL when the device has no IPv6 configuration
(e.g. MTU < IPV6_MIN_MTU or after NETDEV_UNREGISTER).

Add NULL checks for idev returned by __in6_dev_get() in both
seg6_hmac_validate_skb() and ipv6_srh_rcv() to prevent potential NULL
pointer dereferences.

Fixes: 1ababeba4a21 ("ipv6: implement dataplane support for rthdr type 4 (Segment Routing Header)")
Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260316073301.106643-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c   |    4 ++++
 net/ipv6/seg6_hmac.c |    2 ++
 2 files changed, 6 insertions(+)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -379,6 +379,10 @@ static int ipv6_srh_rcv(struct sk_buff *
 	hdr = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev) {
+		kfree_skb(skb);
+		return -1;
+	}
 
 	accept_seg6 = min(READ_ONCE(net->ipv6.devconf_all->seg6_enabled),
 			  READ_ONCE(idev->cnf.seg6_enabled));
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -245,6 +245,8 @@ bool seg6_hmac_validate_skb(struct sk_bu
 	int require_hmac;
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev)
+		return false;
 
 	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.12/ipv6-add-null-checks-for-idev-in-srv6-paths.patch
