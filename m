Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C58266563;
	Tue, 25 Mar 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905605; cv=none; b=pFNSTtzSVJ7LDaNVitjxN8C5JjzZ8OO7MEPmzCyIc8nxLVmF3AmULdAmtm7UjsvDinO9vTvN956kRAoCc+K8wbfQvtnrtjkH/vbw76n928DHJVnEDnA1HU+lC4MqBCBkC4mV6ptQPBGf86wOD8c7FV+HTm7B753arJVXqIKfLY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905605; c=relaxed/simple;
	bh=Nrk9PoltTu2f/7Yaehrdx+0CauhLWrr0DsMyCZqUlsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLyxwwsuXV1fEVoakR+zx4FQf/761ctZsmYSP5SzNAmrwr1K3o4fo4R12lzn8gF5ov6X3iRamCqfYFFj5UfYHkiw0wZDFWZFEkXjUDWe+YBc1SM3oBrsph8S9pVFrlDRQUc8KDXOVL6hXMsFTguTGMXEQjHxRdDIZewy3k9kY+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3JYk8x8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3JYk8x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E47C4CEE4;
	Tue, 25 Mar 2025 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905605;
	bh=Nrk9PoltTu2f/7Yaehrdx+0CauhLWrr0DsMyCZqUlsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3JYk8x84609NfX3ougKA0BEf/lDnqDWXO1C8L2iYQawmQD5A4iArydOwT2nugkux
	 f1TR28dwsBwp21oLhL3WEENg4j9cV67AQvT0Dl2pf5Aa7MSaQGeiM3sZ8SUePIr845
	 qHiugldSW3418Q3UwTmojGY0aFaaDOeWttNwUgqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/198] ASoC: tas2764: Fix power control mask
Date: Tue, 25 Mar 2025 08:20:26 -0400
Message-ID: <20250325122158.326163813@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit a3f172359e22b2c11b750d23560481a55bf86af1 ]

Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250218-apple-codec-changes-v2-1-932760fd7e07@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.h b/sound/soc/codecs/tas2764.h
index 168af772a898f..d13ecae9c9c2f 100644
--- a/sound/soc/codecs/tas2764.h
+++ b/sound/soc/codecs/tas2764.h
@@ -25,7 +25,7 @@
 
 /* Power Control */
 #define TAS2764_PWR_CTRL		TAS2764_REG(0X0, 0x02)
-#define TAS2764_PWR_CTRL_MASK		GENMASK(1, 0)
+#define TAS2764_PWR_CTRL_MASK		GENMASK(2, 0)
 #define TAS2764_PWR_CTRL_ACTIVE		0x0
 #define TAS2764_PWR_CTRL_MUTE		BIT(0)
 #define TAS2764_PWR_CTRL_SHUTDOWN	BIT(1)
-- 
2.39.5



