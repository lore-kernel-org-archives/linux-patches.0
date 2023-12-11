Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEE020DDE;
	Mon, 11 Dec 2023 18:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTDMt3Wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871F8C433C8;
	Mon, 11 Dec 2023 18:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319978;
	bh=iTF/t5zm7sc+X+fFG6dgXWbJf+4EIkkWtYVI+bwWIaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTDMt3WxvIRrBgX5C5Zt9uT7llMtwBX2XvNv7WG7Xql5Z/4CMKuegQ4gum3brScRZ
	 lGggM/jVKd/r8rBcpkaJSjZXu4QkTBQl7nKm9Xpjd+gHDVze7vmJNQ7Y7H7TyufGgl
	 dUxacXsx8bRkv0eWhdhB2vzDNc00CscVe3lBKO/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/97] ionic: fix snprintf format length warning
Date: Mon, 11 Dec 2023 19:21:32 +0100
Message-ID: <20231211182021.026014921@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 0ceb3860a67652f9d36dfdecfcd2cb3eb2f4537d ]

Our friendly kernel test robot has reminded us that with a new
check we have a warning about a potential string truncation.
In this case it really doesn't hurt anything, but it is worth
addressing especially since there really is no reason to reserve
so many bytes for our queue names.  It seems that cutting the
queue name buffer length in half stops the complaint.

Fixes: c06107cabea3 ("ionic: more ionic name tweaks")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311300201.lO8v7mKU-lkp@intel.com/
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20231204192234.21017-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 6c243b17312c7..64d27e8e07725 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -191,7 +191,7 @@ struct ionic_desc_info {
 	void *cb_arg;
 };
 
-#define IONIC_QUEUE_NAME_MAX_SZ		32
+#define IONIC_QUEUE_NAME_MAX_SZ		16
 
 struct ionic_queue {
 	struct device *dev;
-- 
2.42.0



