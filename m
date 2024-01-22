Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7652B768F9;
	Tue, 23 Jan 2024 02:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975489; cv=none; b=DBIN8ZmqAntIkMf+KEbAOVSFdg3+CNRnDeoNijugR8oZjtwr1QJ8e5krfO+frjOltl0cn0j3tI6uzGuLLj/fwQ0vhPNSNxGvfPkE9RnXnxADDx89umnaHcsfi4yj7LcSBWNX4JZBNfdQDVM6cDZBNW4mF8A+DyxJNyR3qzdYUlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975489; c=relaxed/simple;
	bh=s0QC7/OKRsVK4L/y9SZ9RLJ9Abrcy+veHpkZIo7e0xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFQve0PlYSEhIK5JnlDnPM49cl0rVOWxvQp0zTkuai8UE17Cp6R/bWcaAQ+Z+2cTeu/XjFuSNoi/aw//wuKR6mMZNFx8vf4K0vZKyVD9tDF2nwLh3B1/Ys5fAjZ/wk23iWLS5LyWaUqCltyFs1WoGRnwpgpsT/LnxX6aW7R/s44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbDhbYtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbDhbYtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C26DC43390;
	Tue, 23 Jan 2024 02:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975489;
	bh=s0QC7/OKRsVK4L/y9SZ9RLJ9Abrcy+veHpkZIo7e0xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbDhbYtGeUBDk+/R7lr6G1wDVK7wB8OGfn3W9d5UdrAtgdxlfOlyzP9iJQ7c5VZlO
	 5w4QpuHzs/3WexSVhBLP/H2x7DtDyfVYaE8CQuuwFB+g+7sO4W7MtDzdAmPXImtsGw
	 E7RLYYUn6gO0zHkQFR6GjQ0CGBLen9LSj5bhRsK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lin <yu-hao.lin@nxp.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.6 418/583] wifi: mwifiex: fix uninitialized firmware_stat
Date: Mon, 22 Jan 2024 15:57:49 -0800
Message-ID: <20240122235824.755793809@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lin <yu-hao.lin@nxp.com>

commit 3df95e265924ac898c1a38a0c01846dd0bd3b354 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -779,7 +779,7 @@ static int mwifiex_check_fw_status(struc
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
-	u16 firmware_stat;
+	u16 firmware_stat = 0;
 	u32 tries;
 
 	for (tries = 0; tries < poll_num; tries++) {


