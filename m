Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A2EFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA975C433EF;
	Mon, 15 May 2023 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170030;
	bh=OORrfuUZocx0djOc4uov2tXBCCCru7qy0rWNyvf1UuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm6jHwW7v8gcmrvOqfp/HqfpZj+VK9IusNrHDkCj6/hSRtQXDP/ZsA3GtuqjkoV5D
	 Wza7eRznTGNr7e9WW+cRPE7L35u0aOZA/vzx08As4hoF7lkmjG3xkuMkEWbM3vaugz
	 sdgzwwZ1U7b0X9504jJO2imDP7qE2wt+0ZxBxf38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.3 213/246] Revert "net/sched: flower: Fix wrong handle assignment during filter change"
Date: Mon, 15 May 2023 18:27:05 +0200
Message-Id: <20230515161728.987764060@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

commit 5110f3ff6d3c986df9575c8da86630578b7f0846 upstream.

This reverts commit 32eff6bacec2cb574677c15378169a9fa30043ef.

Superseded by the following commit in this series.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_flower.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2231,8 +2231,8 @@ static int fl_change(struct net *net, st
 			kfree(fnew);
 			goto errout_tb;
 		}
-		fnew->handle = handle;
 	}
+	fnew->handle = handle;
 
 	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
 			       !tc_skip_hw(fnew->flags));


