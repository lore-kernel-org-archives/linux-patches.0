Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5FF1E522;
	Thu, 30 Jan 2025 14:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247350; cv=none; b=Z+IbcwjzWGWM1IAekUYhiNU2pRychOmSYrlLc5ZdhpptaEIXeJI9jHuQw7qpLY+HNb3DzSNjk0An1olLVYJOOMfPDFe6ur773Ut+7kl9gp9byP2fgWInXfC9jbGXlgvMNocCJ3YXlXsYd+kMR1B893HqiBO+Hv/7AjTsPpVZIbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247350; c=relaxed/simple;
	bh=LwDPnSlkwNjTCkXp2NeCFStUoGW3eYU21p0TN7kH7sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTbzh6J5vSisFsUqznX+H6u5sz1EGSC67vtZQflk6GAue3cnwm58hCnpXfeeO6iiUkvTwjxI/CAHz2Xw3BrZhOogB4QLoqO6enRE98ch5uJcjULmfJeHOhJBg6tAOsi9pCpmAjcNUfRKqc9h7dQh3Fzs0LFg3c2CcFZ9FiSZ7ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KF1KRpS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KF1KRpS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74097C4CEE2;
	Thu, 30 Jan 2025 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247349;
	bh=LwDPnSlkwNjTCkXp2NeCFStUoGW3eYU21p0TN7kH7sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KF1KRpS+kdkGcrVwCGU6drRvYb/MHxedmib3BjX+vf1lJsbNsKIxLVtuxpsmiW4RF
	 EL1cRil8irW50bA3XdWo0cnDuy27BI8BOg1Hmk/t/YJ9Zq9G6qpBPXI2c77et2/wsc
	 KK67zVDGcS17zM3HBV4ib4w8FFRr1uhG98K3kUbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/49] ASoC: wm8994: Add depends on MFD core
Date: Thu, 30 Jan 2025 15:01:37 +0100
Message-ID: <20250130140133.886172449@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5ed01155cea69801f1f0c908954a56a5a3474bed ]

The ASoC driver should not be used without the MFD component. This was
causing randconfig issues with regmap IRQ which is selected by the MFD
part of the wm8994 driver.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501061337.R0DlBUoD-lkp@intel.com/
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250106154639.3999553-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 0904827e2f3db..627e9fc92f0b8 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1982,6 +1982,7 @@ config SND_SOC_WM8993
 
 config SND_SOC_WM8994
 	tristate
+	depends on MFD_WM8994
 
 config SND_SOC_WM8995
 	tristate
-- 
2.39.5



