Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C94330B30;
	Mon, 27 Oct 2025 18:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591061; cv=none; b=sng0E6Byv7Dvg7hU67IwvfFQWBhARXaDrL9CeEQlHojuyh/NPYccSez7hDJbZtCKx3+ZLEV56yZ9DqJrk7gm5e+9BgB0v1W3m9napfzjMR6cVk9nZH1SkoRvQbc2+q8oQg578IC/rQDD+J3rW7KhRshfkAO6x2We2i8JMi1NHqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591061; c=relaxed/simple;
	bh=eEsUHjiIL6SyfO55wVAvJH8ySAbqRjsOHJGOSmTzmfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G14evzd0tVh8VsYd3hurBBRnzYX4tcE9WmJjcUVBi51VyivLBgjC36SMSuDGWuNgdHHAHkGAeO1CLHeoXpYBf6E4sddpg3usHWFU0ug/Dx+gj3DNito0jIwiu8Fc2q0Uqirf0XQW7x/2Adlj96xXfRZ57PfnjnqAPLBNl2sMoMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IzCYlrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IzCYlrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443B8C4CEF1;
	Mon, 27 Oct 2025 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591060;
	bh=eEsUHjiIL6SyfO55wVAvJH8ySAbqRjsOHJGOSmTzmfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IzCYlrfivBxH8Dqym8vcpioR4Y0gbazE8hhgpVGiW2yPNyilWFlsxOFAH2kQjUpt
	 sVWoGuDSunAP/MFcV0yimOEvYydQs8mkRS88Bog0dNJ+YoUhuEYJjDVAwE4W7DRMpr
	 GM/BARmMIS2rfmhWBJZS+l1iO4Qa+VGVGbsOE13w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/332] misc: genwqe: Fix incorrect cmd field being reported in error
Date: Mon, 27 Oct 2025 19:31:45 +0100
Message-ID: <20251027183525.994880386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0db4000dedf20..cbf674a093680 100644
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



