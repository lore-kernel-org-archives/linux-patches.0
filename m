Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A7330BF7B;
	Mon, 13 Oct 2025 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369651; cv=none; b=Y6cEF0+EqNP3Bmr3wOgeM1pCCaLDTNtONfkCZru7ok8L9bDi5CbAHYV5eN3wT8WPE+/LJiOyFxVhXAA0KzUpea41Ny+zDG5XAcgSkA32frWnM68s2BftozZN21wSnHF9U/cUFm22PsHffUAzIAKQYAkD/FJtOLGtBsQQ85QTL4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369651; c=relaxed/simple;
	bh=g1E9tttMJiN8Nv+OGuHuEVm2uye3rdaNSdLjHBaqGjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6FbA3RT+/lj5K8Sdj1YO0P8WvN7kRqdH5vARIc6JV4PoffG9lmZyId0ksiIqWRfKBh06WE9vCEyUPJ0S1LqIdQmQvARUZ09hwrp/5EIMxnRSL8D/uczIFDrihpOFiWV8Ag/PDpXJXgfusPR45349xFvtqy0mpBttC/aeEIspxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtA6+tsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtA6+tsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B419C4CEE7;
	Mon, 13 Oct 2025 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369651;
	bh=g1E9tttMJiN8Nv+OGuHuEVm2uye3rdaNSdLjHBaqGjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtA6+tsHAUHtF8q5P2THnsiqjI4Z9nh64Vkl25zUGaGMRZHFs+nUk1NtxXQIHnJAd
	 XQIc2vMnAxtjubIHu1FZ7arSUitVwZYEo8E/LkuD+5rceJqAh9eWt23e8XS7SVasf8
	 AGvU0InNcyF9fT0PDSdjVoBS4M56VIxYhEzaUlV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 322/563] misc: genwqe: Fix incorrect cmd field being reported in error
Date: Mon, 13 Oct 2025 16:43:03 +0200
Message-ID: <20251013144422.929615656@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 6b26053819dccc664120e07c56f107fb6f72f3fa ]

There is a dev_err message that is reporting the value of
cmd->asiv_length when it should be reporting cmd->asv_length
instead. Fix this.

Fixes: eaf4722d4645 ("GenWQE Character device and DDCB queue")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://lore.kernel.org/r/20250902113712.2624743-1-colin.i.king@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_ddcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
index 500b1feaf1f6f..fd7d5cd50d396 100644
--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -923,7 +923,7 @@ int __genwqe_execute_raw_ddcb(struct genwqe_dev *cd,
 	}
 	if (cmd->asv_length > DDCB_ASV_LENGTH) {
 		dev_err(&pci_dev->dev, "[%s] err: wrong asv_length of %d\n",
-			__func__, cmd->asiv_length);
+			__func__, cmd->asv_length);
 		return -EINVAL;
 	}
 	rc = __genwqe_enqueue_ddcb(cd, req, f_flags);
-- 
2.51.0



