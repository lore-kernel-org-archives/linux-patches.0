Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522C743ACE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLJOZbZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046B1C4E66D;
	Wed, 15 Nov 2023 20:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081451;
	bh=S61TThl1BcRn8hYkdiwi2ACqEJJgn4zuDbj3fhXMDyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLJOZbZ1VWlJzEuXbbBlJFUoeCrzsOBkJbm7EfWa2xyWPiMhSWNEe1uB+JRDwRgW7
	 dD7T9LJD4RAsdUUIZYm0Tyt31yhrfWLOWFHMm8jV8jRJi8TYjUeVLDMOiIc+GxrBZj
	 r6skF9YbbxGz88yDO32jS/VaeEZfjdGz/Ez6e4pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/244] mfd: dln2: Fix double put in dln2_probe
Date: Wed, 15 Nov 2023 15:35:53 -0500
Message-ID: <20231115203558.002143974@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 759c409bc5fc496cbc22cd0b392d3cbb0c0e23eb ]

The dln2_free() already contains usb_put_dev(). Therefore,
the redundant usb_put_dev() before dln2_free() may lead to
a double free.

Fixes: 96da8f148396 ("mfd: dln2: Fix memory leak in dln2_probe()")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20230925024134.9683-1-dinghao.liu@zju.edu.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/dln2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index fc65f9e25fda8..852129ea07666 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -836,7 +836,6 @@ static int dln2_probe(struct usb_interface *interface,
 	dln2_stop_rx_urbs(dln2);
 
 out_free:
-	usb_put_dev(dln2->usb_dev);
 	dln2_free(dln2);
 
 	return ret;
-- 
2.42.0



