Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A3F612D7;
	Tue, 20 Feb 2024 21:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463242; cv=none; b=up+yQxA8b06tXhEr9NsGMCn6QlT11Av712nGfsJhcDoaMzmAq1Bizup7zdFao/cO2akvVCnqTeMNXsMqK4cmbu/NwYwJUKlwdGDloEfvP0zBfJGVBdQ3zOckP5P28YtqZjlXkkIZZxsu9iKXJtx/GBkZsRH5cVyQyHLcrAda2c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463242; c=relaxed/simple;
	bh=ndgprG2JVdaMQxQUcb71ezy6YA0c7605jkb111t+JvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xiu/dIfESxF+21DYORqv9IhcRILX1HsFX9vBJU7Bmwdw05E4YBoRc7pY973IF3XIBxmugWDZ0FeQS4K+vLfuAZydHCdI/IW5XGGfFfQQwlzXiHmVUeuh5Z4GrzbA4QKEwiUfxQllK3qdw4m/JSLmA0/9H1BSJZxeYQhgdHCQnxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpLRqYap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpLRqYap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FDBC433C7;
	Tue, 20 Feb 2024 21:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463242;
	bh=ndgprG2JVdaMQxQUcb71ezy6YA0c7605jkb111t+JvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpLRqYapoSoTtCIts7E23vl3yFhNO4EMiL7UwdEhD3Ceo38luVj/Aw8sOEpZkfRG3
	 TWmIYoGw3Og781eQindXxio/XxvBhN8x/gqBZxlVkbq4GknxUfZjTlWIQz5PHOkBFt
	 OpkOdzhJL2FO4gFGeBaJwl9COaThLLQ2urOttcCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lin <yu-hao.lin@nxp.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/197] wifi: mwifiex: fix uninitialized firmware_stat
Date: Tue, 20 Feb 2024 21:52:20 +0100
Message-ID: <20240220204846.488999335@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lin <yu-hao.lin@nxp.com>

[ Upstream commit 3df95e265924ac898c1a38a0c01846dd0bd3b354 ]

Variable firmware_stat is possible to be used without initialization.

Signed-off-by: David Lin <yu-hao.lin@nxp.com>
Fixes: 1c5d463c0770 ("wifi: mwifiex: add extra delay for firmware ready")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202312192236.ZflaWYCw-lkp@intel.com/
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231221015511.1032128-1-yu-hao.lin@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index e55747b50dbf..2c9b70e9a726 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -779,7 +779,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
-	u16 firmware_stat;
+	u16 firmware_stat = 0;
 	u32 tries;
 
 	for (tries = 0; tries < poll_num; tries++) {
-- 
2.43.0



