Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7051E0084;
	Wed,  6 Nov 2024 12:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897937; cv=none; b=jqI3Dwo0zfddJVJGPmOAZQt81ItS7oF7EM27mKIQYr8pz+sksBqmjizXYRiGyRNOTNb4Tj3m+XADKfsSYVoD22HTBNnnj6Qz3PupO1Q19T/gqIVAYpWoZTtxUsvFBxBLpJZ7FEgHRE0zsUSQcP3SKpKn7sOOgSHWbg9naJsiWFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897937; c=relaxed/simple;
	bh=lyGGvb3jKhzhfSn9ipy2XplSGuP08IVLD0hexZSWilk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LQGUFQt/A1u3GLj5KHnwFr2Mp5uxWpWlNC8lMi6f0a3PWPO4a+4aMRNk0ohDOyNYa5jPv2A4oGMylrMyxGrJ6cNZW3aK1Sf6R98pxIeNZakVxdVsdJQrXnESGph4ssKAtUG4vSSZ/ngVF2me92Q1daBXGub2jfHwwVL9WqDEPS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scSF9IFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scSF9IFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2731AC4CECD;
	Wed,  6 Nov 2024 12:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897936;
	bh=lyGGvb3jKhzhfSn9ipy2XplSGuP08IVLD0hexZSWilk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scSF9IFNNTBLpKQZJhjNoKCbuNRk+7Q8XKNf1lRA9+g1jAIOg1fPpKa6s/5QHhjZf
	 Vf8nroqrMqQHD5CBrfewhlEWLzXOihfAUg+w+TOOsOQF01EQXIhNeiLuVj/kelLWiK
	 tSJKiV5Xz+gN9e3RsBJ1ieAHykPxkP4WmImxu9Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/462] wifi: ath9k: fix parameter check in ath9k_init_debug()
Date: Wed,  6 Nov 2024 12:58:46 +0100
Message-ID: <20241106120332.338445161@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8d98347e0ddff..42f404119912f 100644
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



