Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7EA1362;
	Tue,  3 Dec 2024 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241240; cv=none; b=HHYZKXzOkMzqPPUvs/dW7WYgo4Q8R7As2IbPNCQ/oS8OlvHkkJPujoLE94XHRQ8acHuzRQbjGHKCjx539p0fuKyMiSmDjYdVKisYXotlJ7D2j9HHXrr368nW+VPPcuUxy4kdHZkxhzINl/WLAgwD3cHfR57r7AEzxmEeIopvuvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241240; c=relaxed/simple;
	bh=MGSS+/ANOdC2wRihEbgO6Sn4iK3m7yiNmXv4+p37nMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwA7CLfqhIcxHhOGh/CedFvdlCOzmsMAW4B+uoDc/Wgh0b/6id88dk7yJzpMfqy5Tg2rDMOn3JplJVsTCuyRnlw+XcBIDGxXs/TdynqL6e6ywXnkA2NxXwsYdCQs38nsyy3Vy8CaOJ9RX8jeWnrdTv+rdfUPWGs4U5a2+fGdlaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBstNnql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBstNnql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E80C4CED6;
	Tue,  3 Dec 2024 15:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241240;
	bh=MGSS+/ANOdC2wRihEbgO6Sn4iK3m7yiNmXv4+p37nMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBstNnqlmCkQtRTKtoE8Q74Jp83Va7PDWXqr5tcGQF9Dpw5uVPoWyypbzsDzpSfzp
	 zFDFC8MEo4PVK4cB4pjf2QPaQsZ+2qHduTT1CzZZzOAyV86BujrDquE9wdqg/jMlfx
	 c5qgu2ac17zn1XRMM+k24X1XHHxJwf2DSKOHIx8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 364/826] pinctrl: zynqmp: drop excess struct member description
Date: Tue,  3 Dec 2024 15:41:31 +0100
Message-ID: <20241203144757.959367773@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 2a85fc7044987d751f27d7f1e4423eebbcecc2c6 ]

The 'node' member has never been part of this structure so drop its
description.

Fixes: 8b242ca700f8 ("pinctrl: Add Xilinx ZynqMP pinctrl driver support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/20241010080432.7781-1-brgl@bgdev.pl
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-zynqmp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-zynqmp.c b/drivers/pinctrl/pinctrl-zynqmp.c
index 3c6d56fdb8c96..93454d2a26bcc 100644
--- a/drivers/pinctrl/pinctrl-zynqmp.c
+++ b/drivers/pinctrl/pinctrl-zynqmp.c
@@ -49,7 +49,6 @@
  * @name:	Name of the pin mux function
  * @groups:	List of pin groups for this function
  * @ngroups:	Number of entries in @groups
- * @node:	Firmware node matching with the function
  *
  * This structure holds information about pin control function
  * and function group names supporting that function.
-- 
2.43.0



