Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCA5171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EEEC433D2;
	Mon, 22 May 2023 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785276;
	bh=pTB2crwC1cHJYOGMLJrzpKch14Nvu3b5igGgPiZutfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yETI99uInEnDpcrbTeDf4YDNOdzBsH3/0jINdOOs+kghin68B2xjTLRtB579yIyq3
	 YqhG+OaBvX/5CREsAqdH7lykUIbJpew8AqFIn2hgoMTFZEo97wU3FtWllm6dhtp6ET
	 A+EuAbgx5YNWQRhSfm/LcvGu3/TDJnOVxved+iMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huayu Chen <huayu.chen@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.3 350/364] nfp: fix NFP_NET_MAX_DSCP definition error
Date: Mon, 22 May 2023 20:10:55 +0100
Message-Id: <20230522190421.534393266@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huayu Chen <huayu.chen@corigine.com>

commit de9c1a23add9e7842ce63ce6f498a05c66344311 upstream.

The patch corrects the NFP_NET_MAX_DSCP definition in the main.h file.

The incorrect definition result DSCP bits not being mapped properly when
DCB is set. When NFP_NET_MAX_DSCP was defined as 4, the next 60 DSCP
bits failed to be set.

Fixes: 9b7fe8046d74 ("nfp: add DCB IEEE support")
Cc: stable@vger.kernel.org
Signed-off-by: Huayu Chen <huayu.chen@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nic/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.h b/drivers/net/ethernet/netronome/nfp/nic/main.h
index 094374df42b8..38b8b10b03cd 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/main.h
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.h
@@ -8,7 +8,7 @@
 
 #ifdef CONFIG_DCB
 /* DCB feature definitions */
-#define NFP_NET_MAX_DSCP	4
+#define NFP_NET_MAX_DSCP	64
 #define NFP_NET_MAX_TC		IEEE_8021QAZ_MAX_TCS
 #define NFP_NET_MAX_PRIO	8
 #define NFP_DCB_CFG_STRIDE	256
-- 
2.40.1



