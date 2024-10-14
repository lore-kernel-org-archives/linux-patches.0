Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96E01AAE0C;
	Mon, 14 Oct 2024 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917390; cv=none; b=BraCGqA88LPuf2aXRx+nn71ocxXBS3YP6HHaFfN4uphUgyRNmctq8LXE/8N9q/FyiIkeNuY6OAv02NcoIztUO5aifcOCLDVrJmPUEDi2QUhWT6Y8kMJY/GZUv2PbB44DBDd3nbQFFLks7qmIblQcJbOJl75aTg7lQFFFWaa71Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917390; c=relaxed/simple;
	bh=JqYYiqcerPSAyrYozpwOC2CYS7LsFzEgaQEDwVNqGsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tp8VJt2KhZ163MRUTUM/D86fUh54qFZfJR2y99pE7f9IdjhOonM2c6C3SZNXgHKsE6/D4D2tmZVEO+J6dp3GOug/Gns+s32eMXqOGNxZT/qGEiO5tE4T3OKBeNevjDV+EJzbUq96sqVOPrxXxTsjRr6Hvtvc691uhsiLEYZfSbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4ydlUvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4ydlUvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3218EC4CEC3;
	Mon, 14 Oct 2024 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917390;
	bh=JqYYiqcerPSAyrYozpwOC2CYS7LsFzEgaQEDwVNqGsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4ydlUvLJUO5I+Mg6yYnBh4tmrVh3f1v69r2oijD/kh3U8KtYc7XkyVPQbPPHmRBz
	 HvmFnJ9GG70/JTmCL5n0Vx/+b+Pdlu1NtQCiv32SRFUK7EO5GBkD7R+zg1FL/DOwE1
	 TQ/OhyxgAVE+ucKtznHjYjQ1tz6DSjaN45tN3Btg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/798] wifi: ath9k: fix parameter check in ath9k_init_debug()
Date: Mon, 14 Oct 2024 16:09:20 +0200
Message-ID: <20241014141218.202085015@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minjie Du <duminjie@vivo.com>

[ Upstream commit 6edb4ba6fb5b946d112259f54f4657f82eb71e89 ]

Make IS_ERR() judge the debugfs_create_dir() function return
in ath9k_init_debug()

Signed-off-by: Minjie Du <duminjie@vivo.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230712114740.13226-1-duminjie@vivo.com
Stable-dep-of: f6ffe7f01847 ("wifi: ath9k: Remove error checks when creating debugfs entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d9bac1c343490..72660a66be1df 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1420,7 +1420,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 
 	sc->debug.debugfs_phy = debugfs_create_dir("ath9k",
 						   sc->hw->wiphy->debugfsdir);
-	if (!sc->debug.debugfs_phy)
+	if (IS_ERR(sc->debug.debugfs_phy))
 		return -ENOMEM;
 
 #ifdef CONFIG_ATH_DEBUG
-- 
2.43.0



