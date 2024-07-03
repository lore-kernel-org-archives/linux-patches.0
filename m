Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBA117BB11;
	Wed,  3 Jul 2024 10:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003887; cv=none; b=g6zO3VwycAV7ke8drM2jBW+U554Cg0FyVJkf7bGKFCc2MOZ5m0KDVeE7YgBIvLITen0Rosy7sDYZs6EwySCWB1EwTw6Ney1bijYo46ik9i8Aljl5F7VFIpD6qSAxIw+iFKEGhEseIj1rSDuQAOWpxsJjLYdaVEUmQezxpThQ4fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003887; c=relaxed/simple;
	bh=eox8zAc8eenpBeKTumtFTa2kBH4dEgwRyvKS2dgMLlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTbWTEoWxbxprBqbZqwdmwR8rShS/+8Q9brEuCGrpSSJxUElzcE51Cy3GY2+v0zteU49WAsO7fYmYhXrNrAzB0jY5/mowOVsP+5qk1Lbpf0y69mVk6RNl46xjJK1i2Uas52c17/dQTXhrBsFG+2m+c7rqKHjmt/xF8XfyfoVa6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5NA0hqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5NA0hqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F93C2BD10;
	Wed,  3 Jul 2024 10:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003887;
	bh=eox8zAc8eenpBeKTumtFTa2kBH4dEgwRyvKS2dgMLlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5NA0hqmpkU5kWzmdGqQZbzB5mc0NwuMGRZ1yZlP8ORDm4GexWP3MFljrGejzO4ia
	 Smiau6o8Vk1LjBxa0QYPga8puwNB82e6nEFcAT7EBIoWq8qlV3UN8aJY2iS9I3l9tX
	 0evehzLap9w4PVsIIrb24y0+o06aNYoZm5gVPWPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/189] gpio: tqmx86: fix typo in Kconfig label
Date: Wed,  3 Jul 2024 12:38:33 +0200
Message-ID: <20240703102843.477413671@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregor Herburger <gregor.herburger@tq-group.com>

[ Upstream commit 8c219e52ca4d9a67cd6a7074e91bf29b55edc075 ]

Fix description for GPIO_TQMX86 from QTMX86 to TQMx86.

Fixes: b868db94a6a7 ("gpio: tqmx86: Add GPIO from for this IO controller")
Signed-off-by: Gregor Herburger <gregor.herburger@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/e0e38c9944ad6d281d9a662a45d289b88edc808e.1717063994.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index ae414045a7506..370065e7bd3ad 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1230,7 +1230,7 @@ config GPIO_TPS68470
 	  drivers are loaded.
 
 config GPIO_TQMX86
-	tristate "TQ-Systems QTMX86 GPIO"
+	tristate "TQ-Systems TQMx86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
 	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
-- 
2.43.0



