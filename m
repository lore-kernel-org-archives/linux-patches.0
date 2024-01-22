Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE5E59B72;
	Tue, 23 Jan 2024 00:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969803; cv=none; b=tdewWTFMGTDqE7f200lT6VN+oJvAvv02Enohr30K/fCEqlue0zSzrRJGyzGAjgGjJhYaYVksP87mv74bscStqZQA9DVVJYhqF3yEkUURJhKn2PQi9ctuuY4m9CFaqE+yg9ZCOtnX3w2GOTfd/rO4ONsw+xZVE7elI+J2bsP60es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969803; c=relaxed/simple;
	bh=GorgIaBc1dtvBg+2Efny89nUoodAmqH/pWipFuMvb7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg+5PToUEFN9r4uBwdelN+fC0Krh7d1LJdT449vY8Pruq+aLU6F8vqTcb8sA47c+INRM4pp9nScda4uA/c5PDLkQ2cveQhCGv4ut9/sdpftMt6cXKOpsQW89FIrwF/OBodbpZRRyOALWc7iQRYYECV4WoRecIfNsP5MPb6x8Vjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCTUqXve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCTUqXve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C2C433F1;
	Tue, 23 Jan 2024 00:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969803;
	bh=GorgIaBc1dtvBg+2Efny89nUoodAmqH/pWipFuMvb7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCTUqXveVlivqzrEo9IS/5F0rbxloVSHqQpBljYvtcOMehEIyIGW6tMnVs5UxFjwz
	 TXdyretYbeTkAodCKKYFQxWq49UA5rXQFgmBJjCpsfmM3oiJb8i/R0DZJJSNmHSQbK
	 XizJpkge14Lq2TvwxKr/QXxwewZH4P1hdr/1zkC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lin <yu-hao.lin@nxp.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.7 459/641] wifi: mwifiex: fix uninitialized firmware_stat
Date: Mon, 22 Jan 2024 15:56:03 -0800
Message-ID: <20240122235832.395373172@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


