Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12FD6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1356DC433C8;
	Sun, 17 Sep 2023 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980235;
	bh=lNz8UXBmQwyRzBmIogOTD9NOv0ozDdU2tK/udVornes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8W5DYZzBpaokvv2XezXLD081vAv5mv7EBcLWknv1ARWYlOGAKs5M0+H1g1jGyAl1
	 v2X8K+42DsUJw9gJ/eJxqbkV55PfqQbe3OrBFCagNchUNfNO+BQ58NwqmcN5foq5uM
	 DN/eqFLPZdwDOdM5rNNErAmohRRvU1mih0rvl9ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 096/285] i3c: master: svc: Describe member saved_regs
Date: Sun, 17 Sep 2023 21:11:36 +0200
Message-ID: <20230917191055.016182665@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 5496eac6ad7428fa06811a8c34b3a15beb93b86d ]

The 'saved_regs' member of the 'svc_i3c_master'	structure is not
described in the kernel doc, which produces the following warning:

    Function parameter or member 'saved_regs' not described in 'svc_i3c_master'

Add the missing line in the kernel documentation of the parent
structure.

Fixes: 1c5ee2a77b1b ("i3c: master: svc: fix i3c suspend/resume issue")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308171435.0xQ82lvu-lkp@intel.com/
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20230817101853.16805-1-miquel.raynal@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 2fefbe55c1675..6c43992c8cf6b 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -156,6 +156,7 @@ struct svc_i3c_regs_save {
  * @base: I3C master controller
  * @dev: Corresponding device
  * @regs: Memory mapping
+ * @saved_regs: Volatile values for PM operations
  * @free_slots: Bit array of available slots
  * @addrs: Array containing the dynamic addresses of each attached device
  * @descs: Array of descriptors, one per attached device
-- 
2.40.1



