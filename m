Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1B4139579;
	Tue, 27 May 2025 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365789; cv=none; b=nOmnQpby9rDgAP6PtN+svzZsx7ivjN6TrSh2oddH0RT2A9gT+4vg4SKOFygjJeDLEL8VYLdLlsmmaOr0JDX9dzeYn3HD9pU3a1+YU47RZAhIEAsaho3uS9CEgelUcNc7+CFTBjX/C0VdnxXArSjmiUPKLhJjXwPDIdgaiJX6eCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365789; c=relaxed/simple;
	bh=uN8vZntkBZBon4DZ2UY9EZKdY5yZrLCdnR6bp2Y9AAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qXhzSipg76Nd1S5v16j3fgKXfl2DE2sw/4IdcrEvD+35OZXTiB24bUdJFfYf13kAsmzESJZRyWjgElCSFIw44g9OCSyeia1Ghs/EKWaIWgsNwWwUi4sorX8HSX5wKwKgcl0+AxgOc2wXL+UdkKRrgpWpN1DeS+L6OR1nJUbKjAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6Em5re5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6Em5re5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43276C4CEE9;
	Tue, 27 May 2025 17:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365789;
	bh=uN8vZntkBZBon4DZ2UY9EZKdY5yZrLCdnR6bp2Y9AAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6Em5re54Ri3aL23+V6+uGuwUftCAh4+LZu6mD+IvA7Jwv8HqDfJXrsdXZgF1XqQE
	 hVwTYoT2QbcoPe0z0KVqSSbL2f09cZW/dwpWGQQK1HGtFkqZ/kTU97C3AECBmer/WF
	 Lx5LctUahM8uLDdvL8Gb5X0ztJJa28R1Nq1ETsmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 490/626] wifi: ath9k: return by of_get_mac_address
Date: Tue, 27 May 2025 18:26:23 +0200
Message-ID: <20250527162504.890665639@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit dfffb317519f88534bb82797f055f0a2fd867e7b ]

When using nvmem, ath9k could potentially be loaded before nvmem, which
loads after mtd. This is an issue if DT contains an nvmem mac address.

If nvmem is not ready in time for ath9k, -EPROBE_DEFER is returned. Pass
it to _probe so that ath9k can properly grab a potentially present MAC
address.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20241105222326.194417-1-rosenp@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7fad7e75af6a3..619bebd389bd2 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -691,7 +691,9 @@ static int ath9k_of_init(struct ath_softc *sc)
 		ah->ah_flags |= AH_NO_EEP_SWAP;
 	}
 
-	of_get_mac_address(np, common->macaddr);
+	ret = of_get_mac_address(np, common->macaddr);
+	if (ret == -EPROBE_DEFER)
+		return ret;
 
 	return 0;
 }
-- 
2.39.5



