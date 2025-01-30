Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78370C13D;
	Thu, 30 Jan 2025 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245636; cv=none; b=jkz3gTj92tVl5RFMhy47w+vlzorbnA9TwhDFdi1OBK20Zf7Wxw7DqLx5/d0zDKFF7lO2IbVX1pOMDBdsJDP6PLVtnY44fERooCTy2PSfueocHjLEdBAGZRjM5Fxhy4PmBzlxeVMqDtY1UhDX03zJ7d0kVW6/ftZ/DzGrJcdQgyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245636; c=relaxed/simple;
	bh=s7Om5Eej6f7ATTchlM0PWu9p4VedolSL8coZ+pBKjuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKRE3Rg1doqjNmEjdQ9rrFHJY4GUN40X4ekJk1jkkjtYb6NP2vJJecVdIRY+dKPfHm9QYZ2FMGdw1ruQJ3UZWJ24zgpIWPD0JiYaS+yFP7K1kcwqa1ARVLrKkCP8s0NheQTHBulSQo1UuY8DUq/hHNPT0DBTCyXmmUQDxLqILgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xI152wfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xI152wfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC53C4CED2;
	Thu, 30 Jan 2025 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245636;
	bh=s7Om5Eej6f7ATTchlM0PWu9p4VedolSL8coZ+pBKjuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xI152wfW6XT+Koziv1feAF0TaMjNgIlTLdTKZfVpxzKP8GChsh0K7PHPaksh9yCEH
	 0YXql5QMpFrknbKANgHQJBZ35wWolJa49+1ZvUclpQ+0Nt2K1vMnZpLp+1VF2NqsXt
	 EnzIZdWuQ441vn6q5HVJMIK8aoBU95D8nULg1a78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 01/40] ASoC: wm8994: Add depends on MFD core
Date: Thu, 30 Jan 2025 14:59:01 +0100
Message-ID: <20250130133459.760661432@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7092842480ef1..0d9d1d250f2b5 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -2397,6 +2397,7 @@ config SND_SOC_WM8993
 
 config SND_SOC_WM8994
 	tristate
+	depends on MFD_WM8994
 
 config SND_SOC_WM8995
 	tristate
-- 
2.39.5



