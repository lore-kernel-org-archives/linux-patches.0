Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D57207A07;
	Fri,  6 Dec 2024 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497331; cv=none; b=R4wPQnTGhHvtmONtkKD3nvjuNqXjVajPfYk0Eq1Kft9+zf6MNWsYNV+ck4NIxLel6swvjpdOQYB+69QiWCzEgmxsnPn7xzi9lcZXynrvllYaThVCkkVz/+GVC9Kx6kh/Qc9ky5HxzTufgaOhDKFVhB3E15Cf/AE3YC01+6gz1FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497331; c=relaxed/simple;
	bh=Ze+GGPLT9fEIrH/McNdhhagt7PKHpD63sVU+EyBsbX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/T+zXuet26+JflAswR+iQrOQPOBX4vn4Aptgv8hbhbN6Ejzg1HharIA8iWwe+sVs0XXK13BpGLIfnTSH+8y+pQvjDKt61tu6U8oslvYwBN8sGEcV+6sPGIuHeApRkKvhlElp2RwUeP/b3eCLxdiCc2BMl2UsGFVpnVtJfMsSR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkQZOCFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkQZOCFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AB1C4CED1;
	Fri,  6 Dec 2024 15:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497331;
	bh=Ze+GGPLT9fEIrH/McNdhhagt7PKHpD63sVU+EyBsbX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkQZOCFbk0SpqL1ENtoiClfnymZOc3GEOKb2OCkq0gZvm5ANxCVuOHg8sMeRqjMgE
	 xS2BkblKceaWl0L0pU/Y++hNdZFtwUQN8ld8ZlVOFR4aCfJQEtKbX+4M82foWjUgKQ
	 b6GFH7A0LJMiXol5ZZLSXv/yYS6zHe/mtoqNQVFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/676] pinctrl: zynqmp: drop excess struct member description
Date: Fri,  6 Dec 2024 15:31:21 +0100
Message-ID: <20241206143703.567012010@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f2be341f73e13..1528f4097ff8a 100644
--- a/drivers/pinctrl/pinctrl-zynqmp.c
+++ b/drivers/pinctrl/pinctrl-zynqmp.c
@@ -48,7 +48,6 @@
  * @name:	Name of the pin mux function
  * @groups:	List of pin groups for this function
  * @ngroups:	Number of entries in @groups
- * @node:	Firmware node matching with the function
  *
  * This structure holds information about pin control function
  * and function group names supporting that function.
-- 
2.43.0



