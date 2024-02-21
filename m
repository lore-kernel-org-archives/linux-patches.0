Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A383969942;
	Wed, 21 Feb 2024 13:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523419; cv=none; b=fdqhVGBd/gn0mraBViKj1gh76eY/tQUS4lvIdbH2zP2jh14S0iwzLTiBKW0G8vcQQFP+Ua4Xc2JfPlc0FVqjcM+b8ux/L+hkOLXiTpROwLqfMD6GDTYM9YSjQ3Nzfyhrx5/KAnz2F8k1oXmiLfw1Hz37EN7g9+6HEHLu8ams7HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523419; c=relaxed/simple;
	bh=cp89iE8V4iT78vY2rPN7fEhJbu2PhOGx9jb9x06c+8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+W7lUvdeAXGbspjpMZ4s8VHKfvdoTySWcVW5WdeMcdmGa5MpENoNlndEwoK+VQzipxVUDpkFulyaVv7J5jtKlbQey3izQwYcvNc8Pq++7nLFs0q+whOAqfVsC4Ue2vh5guBDcAuljWUzvbCSwkMaY9kx39PmvQuJIGHouyTLWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuCo2Gv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuCo2Gv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEB2C433F1;
	Wed, 21 Feb 2024 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523419;
	bh=cp89iE8V4iT78vY2rPN7fEhJbu2PhOGx9jb9x06c+8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuCo2Gv0EvuKdgLgKVYE2L6CxNaegNrQrqfaD4JllsSjVxrRBEvRR6BURHAyEcy9U
	 zV9mJ4odl9YPo+C5u/bGxbTxP1cCv7kGqEG6Zu/YQ4rOxcnEM2EKK2RVyUv0+coFcM
	 eKyDLqybCxK2xP12ZzNdtN/DCNY9CR+TIMUZSVCQ=
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
Subject: [PATCH 5.15 431/476] wifi: mwifiex: fix uninitialized firmware_stat
Date: Wed, 21 Feb 2024 14:08:02 +0100
Message-ID: <20240221130023.958578187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd4bfb7d71ee..45f46a445a6c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -790,7 +790,7 @@ static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
-	u16 firmware_stat;
+	u16 firmware_stat = 0;
 	u32 tries;
 
 	for (tries = 0; tries < poll_num; tries++) {
-- 
2.43.0



