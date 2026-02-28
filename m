Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2D2340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301076; cv=none; b=dGHbbYUkYTpJnCdheApfBJteqAGgEy/XJrZ8zD+k+yP7DmZFVdpdFIe4ahLUeo7k/B9zYC7EpogeCGFHI2z+l0d87r9dPvpl1aUvzJKUJMtPm5DznzKb2P5hJCN/qbwyIQ3kJ5QctYe6ETAtFGx0mFvgH+FcTjR9mcf2NPARUP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301076; c=relaxed/simple;
	bh=Pjg8P2UFle7rWhfr8Z4MFeiG/Jq8dBkBsCsNoHErQ7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdcA3a7kKXGNDq29xaIr3Lzo+OF3w+42MBLE6gyKyY8yifrnTyUS7xvrKdAbm7571r2ahlDnfxfBw9XA2HSLq7SXQl5PW7SZDDAv3Ng12xgSLLO83NzUaBoDAvm/ZlLbXX+M7E97JSKkh1Wx/XwEharIKjizT+y128glBbOvtWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rQcjUXXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rQcjUXXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE6EC19425;
	Sat, 28 Feb 2026 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301076;
	bh=Pjg8P2UFle7rWhfr8Z4MFeiG/Jq8dBkBsCsNoHErQ7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQcjUXXIM+brUBi6LgVPBrK8x8nhGZpClpUMgXqkOPra6THeDU9CuDgf6X0tSMwMT
	 kn7IdTwgNFensn49Ek5pa2YNiLwaQCdMzR6PCa5LuWmxEQCrpqkfBRh7f50IllOSfT
	 /NeR9Jlern1na7cwF7j4CmgpsfQRO9el1APtXKIkuplQvfRL9B7k+2ll29GkoppyOR
	 MSroidTQtpco1bZnQR391NR6cZUp8oF9XA3KdX/Yyi6JRStJGGpuo/JDKUDDVdvcyy
	 DtWkHvb5xnwgI31T8FhjTTcrBex4pVJzIpTaT7pLqq+UKMYUvOxENQtgJYY/3ipD6d
	 ujH47VZZ5mAuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 223/752] wifi: rtw89: regd: 6 GHz power type marks default when inactive
Date: Sat, 28 Feb 2026 12:38:54 -0500
Message-ID: <20260228174750.1542406-223-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 8c96752d99c0b094af68317a8c701b09bd0862d9 ]

When inactive, 6 GHz power type has been assigned to the default one,
but missed to mark the local control variable, dflt, true. Then, this
might let some 6 GHz power info of disconnected APs keep being taken
into account under certain cases.

So, mark default when inactive.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251229030926.27004-12-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/regd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/regd.c b/drivers/net/wireless/realtek/rtw89/regd.c
index 58582f8d2b74c..8211d1277699c 100644
--- a/drivers/net/wireless/realtek/rtw89/regd.c
+++ b/drivers/net/wireless/realtek/rtw89/regd.c
@@ -1142,6 +1142,7 @@ static int rtw89_reg_6ghz_power_recalc(struct rtw89_dev *rtwdev,
 		}
 	} else {
 		rtwvif_link->reg_6ghz_power = RTW89_REG_6GHZ_POWER_DFLT;
+		dflt = true;
 	}
 
 	rcu_read_unlock();
-- 
2.51.0

