Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900AA1D2784;
	Wed,  6 Nov 2024 12:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894876; cv=none; b=fCwxVuRZjzggZoMvz63BVPOobfBDaqcMmmVf1k4Uyiys1PPsh0x5qVrG8q+Q3mppIpy2yyLzgz9daw3DK2d1O+1YUtEOtd8qfZ5Mn5wvlFqwmY1JuY+zoHYdfaFYSxXQPpsCtDZCFnaV+0y9jtr2d4JXNKjcV1MxRDYQH3VFR+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894876; c=relaxed/simple;
	bh=EKTvmfKzGPFAgAAn9IAmhsD/YEVC4iKJqcwWCXgmfPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NgDI3YGb7OI+UPZGOmd0RN+P7+ZkH2xn6uIPZcdyNsPfpFSUal6kQoAPcQAxP6aow0riQZYRFFt5KcZ+N4z9S/EBYXR6e5dKestuBJWruF32+OrdIdlH73AKTlIxCJRYUKfNTbzhFkCA5GtlOSCEdKc93nJlk0FsYxKLJUjGaxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHP5hEvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHP5hEvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5333C4CECD;
	Wed,  6 Nov 2024 12:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894876;
	bh=EKTvmfKzGPFAgAAn9IAmhsD/YEVC4iKJqcwWCXgmfPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHP5hEvGKYWBKWAiZXnFGD3eS8EdSYQudpAgAwTj12Uuc3zp8igyhzgpd+TOw5cNl
	 iIIRCT1Pln4MLvW/5dWjJK8vqX8IkFo6Es2cygKu1Mi9uuiOrjYIgtWT36+D7qAEl5
	 9jSzerS1u6jJtvmifF+08js7p5I51dd+A9Y23th0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/350] wifi: ath9k: fix parameter check in ath9k_init_debug()
Date: Wed,  6 Nov 2024 12:59:17 +0100
Message-ID: <20241106120321.596654559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e0a4e3fa87305..1700d23f0aa9e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1384,7 +1384,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 
 	sc->debug.debugfs_phy = debugfs_create_dir("ath9k",
 						   sc->hw->wiphy->debugfsdir);
-	if (!sc->debug.debugfs_phy)
+	if (IS_ERR(sc->debug.debugfs_phy))
 		return -ENOMEM;
 
 #ifdef CONFIG_ATH_DEBUG
-- 
2.43.0



