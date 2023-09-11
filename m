Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2B711706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86772C433C7;
	Mon, 11 Sep 2023 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444652;
	bh=79KIJCex9NAsdMIKK9Cxcm8l+FRTCmEYIHqErbkhUP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TblReKV4cM4NKgojvuRU+CkDLFSX03P+Zxi3xFax9LxwHfMDiwX/ZxurwsCtlTG7l
	 2vrTVByVHnykjJ31vgDtFb69bBVuNpnGWEYtfFbBJ7tNRriV3vhl5w1m4EmUErry7J
	 4l0YlgRW/e6papE/NoTfosjx2LON9nYwm0X+2j7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/600] Revert "wifi: ath6k: silence false positive -Wno-dangling-pointer warning on GCC 12"
Date: Mon, 11 Sep 2023 15:41:23 +0200
Message-ID: <20230911134635.088510831@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Kalle Valo <kvalo@kernel.org>

[ Upstream commit a1ce186db7f0e449f35d12fb55ae0da2a1b400e2 ]

This reverts commit bd1d129daa3ede265a880e2c6a7f91eab0f4dc62.

The dangling-pointer warnings were disabled kernel-wide by commit 49beadbd47c2
("gcc-12: disable '-Wdangling-pointer' warning for now") for v5.19. So this
hack in ath6kl is not needed anymore.

Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230724100823.2948804-1-kvalo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/Makefile | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index a75bfa9fd1cfd..dc2b3b46781e1 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -36,11 +36,6 @@ ath6kl_core-y += wmi.o
 ath6kl_core-y += core.o
 ath6kl_core-y += recovery.o
 
-# FIXME: temporarily silence -Wdangling-pointer on non W=1+ builds
-ifndef KBUILD_EXTRA_WARN
-CFLAGS_htc_mbox.o += $(call cc-disable-warning, dangling-pointer)
-endif
-
 ath6kl_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath6kl_core-$(CONFIG_ATH6KL_TRACING) += trace.o
 
-- 
2.40.1



