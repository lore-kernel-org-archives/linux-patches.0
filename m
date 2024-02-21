Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71EB7EF1F;
	Wed, 21 Feb 2024 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524810; cv=none; b=WuNWir9i6Wg6cfg6q4WM0+UYOelem+ob8UFQAVhG8mR9FHSERJxK82Wdq7HV7ilVCOtZWqBm9p1/sc9qvxWrfEG5evH0czD3gqvTZtYjQGjS6R8vHchwnaUfKD4Jb6gpOA/7tVNFCMEaNZ0cuj2QEKSsDg/lXxDOhjTPcAcsv/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524810; c=relaxed/simple;
	bh=5bJ+gA7stFkIVHQCCpPf7514/NOAB3/JoP7WINfAVdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wh4b4XsytC/wRjKsw+4j7DYwHivjBChlpMF+QpPv9V4e/3XTJOcdPgA/KcOkJajbZHlfTjIvlcEeNC5lHFVCFr9MB1eJOKjGSrxkQFLXpEPVEh1gUue5d+56ZjZsHKZKLaTUSlc8ttJvqg4DYKgNIR+ygULZMRxip8kKb/EAAcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7YYMqpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7YYMqpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60201C433B1;
	Wed, 21 Feb 2024 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524810;
	bh=5bJ+gA7stFkIVHQCCpPf7514/NOAB3/JoP7WINfAVdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7YYMqpJY7m082uvcK/j9zV1fm1RiZFoZV8TQErCPuum3ftQBn99+QFK26v7/FncJ
	 CCJB1iSsfZB3XWJYE5B2OKtrNqL8JDSZ/gqNDT0uwcwhRcel6YEpOYsXGtNLNJcySL
	 ysJ3boam1aPL+uDHbFmMY593PCtp9O/C+hvezYdY=
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
Subject: [PATCH 5.10 356/379] wifi: mwifiex: fix uninitialized firmware_stat
Date: Wed, 21 Feb 2024 14:08:55 +0100
Message-ID: <20240221130005.580763500@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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



