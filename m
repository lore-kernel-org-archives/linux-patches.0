Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769DF168CB
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC76C433D2;
	Mon,  8 May 2023 11:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545800;
	bh=2T7k8ybK9LFmH/mLUCxmVe3PfHbyVW4CxFKs/tc9iC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1y6cA8zBZ6UTCCplm16lLfAvWqBDpmnUfIX9unfmTikhU6qGZthZcYOr1XMX6A3dq
	 jKEx+ik4ckN3gB5RikEktnttK6xgPSg/YD23IS6R1HafM36ZjR8zCH7X/FQD0WpITy
	 XyIlom3VnnOyrL8eMSLa+nMXWuF9M7ewNMbEeWAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/371] wifi: rtw88: mac: Return the original error from rtw_pwr_seq_parser()
Date: Mon,  8 May 2023 11:45:57 +0200
Message-Id: <20230508094818.274438498@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit b7ed9fa2cb76ca7a3c3cd4a6d35748fe1fbda9f6 ]

rtw_pwr_seq_parser() calls rtw_sub_pwr_seq_parser() which can either
return -EBUSY, -EINVAL or 0. Propagate the original error code instead
of unconditionally returning -EBUSY in case of an error.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230226221004.138331-2-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index d1678aed9d9cb..6ad235d7145e1 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -233,7 +233,7 @@ static int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
 
 		ret = rtw_sub_pwr_seq_parser(rtwdev, intf_mask, cut_mask, cmd);
 		if (ret)
-			return -EBUSY;
+			return ret;
 
 		idx++;
 	} while (1);
-- 
2.39.2



