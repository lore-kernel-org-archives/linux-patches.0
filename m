Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7550128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DEFC43392;
	Mon, 12 Dec 2022 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851991;
	bh=n49rOSjN6QSMqHzixuhRiwhZN7drgO8k9Cbv0o4YGu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9iZLf7cRKYTewBNecwKGTKNfbplGakzym5Do8Y8WTC1Sz6zlFWrP4AKN02h25Bck
	 6ntp86J4rtuVRLfQLlD+b/LNGA1PUU7f7HybSQ7FZH+bloREZztKdTDfn848YQJoUj
	 X624OMqOPOtKF12omxDm1oxUheUPZzEe3Kk0Xqf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Jason Andryuk <jandryuk@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/123] xen/netback: fix build warning
Date: Mon, 12 Dec 2022 14:17:57 +0100
Message-Id: <20221212130932.009739363@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 7dfa764e0223a324366a2a1fc056d4d9d4e95491 ]

Commit ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in
the non-linear area") introduced a (valid) build warning. There have
even been reports of this problem breaking networking of Xen guests.

Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in the non-linear area")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Tested-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 6bd7b62fb90c..26428db845be 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -530,7 +530,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 	const bool sharedslot = nr_frags &&
 				frag_get_pending_idx(&shinfo->frags[0]) ==
 				    copy_pending_idx(skb, copy_count(skb) - 1);
-	int i, err;
+	int i, err = 0;
 
 	for (i = 0; i < copy_count(skb); i++) {
 		int newerr;
-- 
2.35.1



