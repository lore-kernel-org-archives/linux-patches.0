Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD022115
	for <patches@lists.linux.dev>; Sun, 27 Aug 2023 09:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85DCC433C7;
	Sun, 27 Aug 2023 09:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693127775;
	bh=ifhjfbkF54pu+s9QfpyKHg00vpepv27xfMggy8lwBDo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=NlixN4kAH5c107A+QAdeHcqQZTc45048/1gTK+x8B44TRtXdy/z3Wv2pdsiDQw2H6
	 oQziRAIOX2OI8C2kAUcDDEGp8/2/gMh+NPbtCMUYTV3qxqUCSZLidd+uOTqQBAMt9q
	 GrJkCj7yA8jDZyCyVVwMP+l2ttcNuRzDztC71vRk=
Subject: Patch "netfilter: nf_queue: fix socket leak" has been added to the 4.19-stable tree
To: 20221024112958.115275475@linuxfoundation.org,akaher@vmware.com,amakhalov@vmware.com,coreteam@netfilter.org,davem@davemloft.net,fw@strlen.de,gregkh@linuxfoundation.org,kadlec@blackhole.kfki.hu,keerthanak@vmware.com,pablo@netfilter.org,patches@lists.linux.dev,psinghchauha@vmware.com,srinidhir@vmware.com,tkundu@vmware.com,vbrahmajosyula@vmware.com,vimal.agrawal@sophos.com,vsirnapalli@vmware.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 27 Aug 2023 11:16:12 +0200
In-Reply-To: <20230826065055.4691-1-vbrahmajosyula@vmware.com>
Message-ID: <2023082712-sublet-foam-fc54@gregkh>
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

    netfilter: nf_queue: fix socket leak

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     netfilter-nf_queue-fix-socket-leak.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From vbrahmajosyula@vmware.com  Sun Aug 27 11:12:19 2023
From: Vamsi Krishna Brahmajosyula <vbrahmajosyula@vmware.com>
Date: Sat, 26 Aug 2023 06:50:56 +0000
Subject: netfilter: nf_queue: fix socket leak
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev, pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, amakhalov@vmware.com, srinidhir@vmware.com, vsirnapalli@vmware.com, akaher@vmware.com, tkundu@vmware.com, keerthanak@vmware.com, psinghchauha@vmware.com, Vimal Agrawal <vimal.agrawal@sophos.com>
Message-ID: <20230826065055.4691-1-vbrahmajosyula@vmware.com>

From: Vamsi Krishna Brahmajosyula <vbrahmajosyula@vmware.com>

Removal of the sock_hold got lost when backporting commit c3873070247d
("netfilter: nf_queue: fix possible use-after-free") to 4.19

Fixes: 34dc4a6a7f26 ("netfilter: nf_queue: fix possible use-after-free") in 4.19

Fixed in 4.14 with
https://lore.kernel.org/all/20221024112958.115275475@linuxfoundation.org/

Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
[vbrahmajosyula: The fix to the backport was missed in 4.19]
Signed-off-by: Vamsi Krishna Brahmajosyula <vbrahmajosyula@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_queue.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -93,8 +93,6 @@ bool nf_queue_entry_get_refs(struct nf_q
 		dev_hold(state->in);
 	if (state->out)
 		dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (entry->skb->nf_bridge) {
 		struct net_device *physdev;


Patches currently in stable-queue which might be from vbrahmajosyula@vmware.com are

queue-4.19/netfilter-nf_queue-fix-socket-leak.patch
