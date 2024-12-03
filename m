Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2D21F75B9;
	Tue,  3 Dec 2024 15:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240539; cv=none; b=q8TSk6oI189qlZoAj0FRJl9c6JnwE1c2/D7UAPCuXurL1XYNpZTHnoDKqrNUlfj8hL5CePUqaaWC+3nafv35xeLVYlIZMtNDmeVyJvSw23rLQA91yNdWVB41wWBMu2Td2tHMDntOGbZNR3nyUDncCHXr3XJgN8D3aQeUHAW/wl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240539; c=relaxed/simple;
	bh=pdRSffNzWLh4z0oF7Hsk29xA2n0P5KSJ6ccxsYYB9CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho1Py9s/IfBmFveUX6aR2QPPxfrvm+oX3bOjSS0kMe6cZl/CqQ1XI/R0u4G6aVb+8wkhYo4/Ht4RC7E/myq8nWdC9oi9WaMb762pKhClsjcwBWPynwYVMEIVs3cPe6Odtrk65GAHIpIs8UWBNBoPh4p4H/o2e1qGKevU1KJII2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIcSFFIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIcSFFIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C153AC4CECF;
	Tue,  3 Dec 2024 15:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240539;
	bh=pdRSffNzWLh4z0oF7Hsk29xA2n0P5KSJ6ccxsYYB9CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIcSFFIX4cxwdSa1QcknI9IO1MjU64+yaS5wVBygHfozKtBzgyP9JOI4ggSn690Zu
	 QOQa9Cl9ZhYABNJ3KZvsL1vyv31WDukiTGTs/sYW99D8tRoN6h0YVBIaatVICd/ZeP
	 HfXQK19v7NabirtogaDf6vk9VZuk6Umbbn+g8z4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/826] power: sequencing: make the QCom PMU pwrseq driver depend on CONFIG_OF
Date: Tue,  3 Dec 2024 15:37:45 +0100
Message-ID: <20241203144749.126059720@linuxfoundation.org>
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

[ Upstream commit f82bf3c5796e1630d553669fb451e6c9d4070512 ]

This driver uses various OF-specific functions and depends on phandle
parsing. There's no reason to make it available to non-OF systems so add
a relevant dependency switch to its Kconfig entry.

Fixes: 2f1630f437df ("power: pwrseq: add a driver for the PMU module on the QCom WCN chipsets")
Link: https://lore.kernel.org/r/20241004130449.51725-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/sequencing/Kconfig b/drivers/power/sequencing/Kconfig
index c9f1cdb665248..ddcc42a984921 100644
--- a/drivers/power/sequencing/Kconfig
+++ b/drivers/power/sequencing/Kconfig
@@ -16,6 +16,7 @@ if POWER_SEQUENCING
 config POWER_SEQUENCING_QCOM_WCN
 	tristate "Qualcomm WCN family PMU driver"
 	default m if ARCH_QCOM
+	depends on OF
 	help
 	  Say Y here to enable the power sequencing driver for Qualcomm
 	  WCN Bluetooth/WLAN chipsets.
-- 
2.43.0



