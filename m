Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602822572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EF8C433EF;
	Tue, 18 Apr 2023 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821762;
	bh=88B838DTdlpDW2SpNu5skgxEB44SPoNUziSs1+nBFws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIz5jiJbySC2iemwOQpOXrLL+LH/jWG1hQF1YcUJG/pHyH/gUZW4jB764r0y+mnBx
	 piJ1PJgoCaBJPZlW1PgnazVxn6MJKnTnkvz/PEr5BVboQ4s9LHaW0mSlda2Wm1mAaR
	 7ISPYRKGFlOsH+XyWcja2I9ryA1zbhdjIo5r73xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/134] RDMA/irdma: Increase iWARP CM default rexmit count
Date: Tue, 18 Apr 2023 14:21:27 +0200
Message-Id: <20230418120314.068823814@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 8385a875c9eecc429b2f72970efcbb0e5cb5b547 ]

When running perftest with large number of connections in iWARP mode, the
passive side could be slow to respond. Increase the rexmit counter default
to allow scaling connections.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230315145231.931-4-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/cm.h b/drivers/infiniband/hw/irdma/cm.h
index 19c284975fc7c..7feadb3e1eda3 100644
--- a/drivers/infiniband/hw/irdma/cm.h
+++ b/drivers/infiniband/hw/irdma/cm.h
@@ -41,7 +41,7 @@
 #define TCP_OPTIONS_PADDING	3
 
 #define IRDMA_DEFAULT_RETRYS	64
-#define IRDMA_DEFAULT_RETRANS	8
+#define IRDMA_DEFAULT_RETRANS	32
 #define IRDMA_DEFAULT_TTL		0x40
 #define IRDMA_DEFAULT_RTT_VAR		6
 #define IRDMA_DEFAULT_SS_THRESH		0x3fffffff
-- 
2.39.2



