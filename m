Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9BC6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D567C433C8;
	Sun, 17 Sep 2023 19:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979598;
	bh=htgHOyql5qoQ6s1BSc0EOtxstF/5bYAz0N284ZJHjGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKym0uektYua/BByLRMcwoi7Lx21k/3hFbKfWJXNF/ReLIlLQAno2Nyr2BkGBDfDD
	 O+Miw+66ePCyMWBAk4nF91Tzhgqcd0FKS3WJB9NyXi+e4OwAPEs6pTkU5KH90qAMjE
	 Wuz/nc2M2zQFjdlN8RHVVSrnsfs1scmewDydby6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Zaborska <olga.zaborska@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.10 359/406] igb: Change IGB_MIN to allow set rx/tx value between 64 and 80
Date: Sun, 17 Sep 2023 21:13:33 +0200
Message-ID: <20230917191110.754870188@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Zaborska <olga.zaborska@intel.com>

[ Upstream commit 6319685bdc8ad5310890add907b7c42f89302886 ]

Change the minimum value of RX/TX descriptors to 64 to enable setting the rx/tx
value between 64 and 80. All igb devices can use as low as 64 descriptors.
This change will unify igb with other drivers.
Based on commit 7b1be1987c1e ("e1000e: lower ring minimum size to 64")

Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
Signed-off-by: Olga Zaborska <olga.zaborska@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index e6d2800a8abc5..da0e3897e6831 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -34,11 +34,11 @@ struct igb_adapter;
 /* TX/RX descriptor defines */
 #define IGB_DEFAULT_TXD		256
 #define IGB_DEFAULT_TX_WORK	128
-#define IGB_MIN_TXD		80
+#define IGB_MIN_TXD		64
 #define IGB_MAX_TXD		4096
 
 #define IGB_DEFAULT_RXD		256
-#define IGB_MIN_RXD		80
+#define IGB_MIN_RXD		64
 #define IGB_MAX_RXD		4096
 
 #define IGB_DEFAULT_ITR		3 /* dynamic */
-- 
2.40.1



