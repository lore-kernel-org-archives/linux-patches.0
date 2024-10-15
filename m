Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094611E490B;
	Tue, 15 Oct 2024 11:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992376; cv=none; b=auP1PxV42AMv3kIW6+tGRpmSepCyRCVTsCb8ZrlF7guIE9vH8CWx2KrgAfyrin1nOXavfHkfvEXc7pk6HHi39FJhm7/SJ/uzfqcXDaOJPeYhm5w4CcoG53XUJtRfcVDMdmXi7gDPLf7ujlFcKpPTSSxaFT+YErieSD3qxrAgYtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992376; c=relaxed/simple;
	bh=Lz9PkRi6Nd2CBGVZfpIZtRnyLJU5Oj8ZvJxyIImEKmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BuIv+j4I7rSMsOVPGTivA3Udeg98/66ZDz47tzcGf1EI4ZaZRUkrQl3Cwy9g09z1px28Prs6GgT2SYhBNHRwb3ZbdRWdSs2D4RXY0jgtkHQtO04RlUjy17hXFbucNfH6EkLADfgNJFxHS/stlGPMwQNwd/8gJUPSG6dB+i8/Uh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gj+an4My; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gj+an4My"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A501C4CEC6;
	Tue, 15 Oct 2024 11:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992375;
	bh=Lz9PkRi6Nd2CBGVZfpIZtRnyLJU5Oj8ZvJxyIImEKmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gj+an4My9zCnl/HvT76YZtwlHcKrxxLB9DTPfWFCE6CY86UiUbK1hisSMNG1zLn89
	 XMSXBg1Qc5G7qxaTOFowSaxtJGA6q3cMsPlTTmZyRuAEjG/rB72RcbYwKA87o36o49
	 ZTDcwSNFeTTYqfD72lfYxlBQzp5pnhJuVmLqx0bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/691] wifi: ath9k: fix parameter check in ath9k_init_debug()
Date: Tue, 15 Oct 2024 13:20:46 +0200
Message-ID: <20241015112444.250986116@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a043a49dfe6f..4badc4c453f3a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1371,7 +1371,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 
 	sc->debug.debugfs_phy = debugfs_create_dir("ath9k",
 						   sc->hw->wiphy->debugfsdir);
-	if (!sc->debug.debugfs_phy)
+	if (IS_ERR(sc->debug.debugfs_phy))
 		return -ENOMEM;
 
 #ifdef CONFIG_ATH_DEBUG
-- 
2.43.0



