Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D463FB21;
	Wed, 21 Feb 2024 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522753; cv=none; b=AbS51N9xmlRFcTMjDztTK10YIxDbQvB/Fe+6bF9GxjGrkITe5KFDN3qtjRz/uVlMSqSPNkeT1N68gebMKM7ukXwqHb5ghGJBNGLSbDyJ4DJyTg1/ghTUnhSKbAjqKtNtU9W01lqbY/GFlb3x0xtSEChjgvOt5r6oazq4ocFGGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522753; c=relaxed/simple;
	bh=0grR+d0IR29jTrL2VCNp2zsiZvfubsykemIJbpGVGjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDLPYxulTujjpxB97zp6qiVyumRfZdHtcpsE8ByZFyDLxTKDPagSlrzjQ7nE5B4AsNsqR/RIWWODPHElMQnEaILuH196Sdqq0Ov9NC8wEUjFyWqYtwkGlOzkv6ilbe57PT9tcrcoB5uB9xlqmKzMn5owJeUIkekNkI9mIy3JV+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qj3ap9Cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qj3ap9Cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724A6C433C7;
	Wed, 21 Feb 2024 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522752;
	bh=0grR+d0IR29jTrL2VCNp2zsiZvfubsykemIJbpGVGjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qj3ap9CvZYbqmwLFm5oL4KyutOIN+2ULjfBuhbABSTVz8y3TV2OB7zhY8/SLvre54
	 X19FAYeGapxD4OFXsRZvHaIR4TUa2Vi/y7PU5YI8OVNpYzLupKYh8yEVwJO2lyf0M7
	 2ZOhnhBmYgkNXZs3ovoml1BcYl/17pzw8fSn6fi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/476] mfd: ti_am335x_tscadc: Fix TI SoC dependencies
Date: Wed, 21 Feb 2024 14:04:58 +0100
Message-ID: <20240221130016.990892182@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 284d16c456e5d4b143f375b8ccc4038ab3f4ee0f ]

The ti_am335x_tscadc is specific to some TI SoCs, update
the dependencies for those SoCs and compile testing.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20231220155643.445849-1-pbrobinson@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ef550d33af92..1a790e7f6549 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1377,6 +1377,7 @@ config MFD_DAVINCI_VOICECODEC
 
 config MFD_TI_AM335X_TSCADC
 	tristate "TI ADC / Touch Screen chip support"
+	depends on ARCH_OMAP2PLUS || ARCH_K3 || COMPILE_TEST
 	select MFD_CORE
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.43.0



