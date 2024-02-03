Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9697171A4;
	Sat,  3 Feb 2024 04:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933900; cv=none; b=fgi6AiFaNMH2uMjGBG5ccc2vbsLqSmnz0YwCN9cOit3Z389XLsH7v4VVzqgHv+FFc9JU+QOmog4y766MDzI1nRiZT7NdqD/6zeJAxp/E+oQ9QKXLJDRs5f6+duPNCHWwe9WOTErVAGSxWijSs3/1uIWxWCDqAP0t56LhqrFJHaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933900; c=relaxed/simple;
	bh=i7fkalby9DtXzgCXhXYEbQaP9RVdlWUB8BeApYVRdr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5HjLczCv3QwdojyEnl4uKE/WuSUZJbZtOoYIMJjYr+mhy8DBKXdeWM3DIHx2wDbVKClBuRi2IueUZPgRAY5q7IqbvV8BZtqhXV428rd7UcidfYuNfgfpK6IDRnRLUBVHaNv/0Bb3ogEn/2johse8WaKClBnVjmbMrHZfB0tp+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvLEdSTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvLEdSTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84088C433F1;
	Sat,  3 Feb 2024 04:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933900;
	bh=i7fkalby9DtXzgCXhXYEbQaP9RVdlWUB8BeApYVRdr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvLEdSTe5vEw1g3FDNnAH5FR0IVDT+j+pCdEIx2UKQmx3oWBAwf4X82jpaJDUHLxW
	 3so5akwDXpqjJePfUapgjWe8OV6CmUb0BMAT3LDro6L5DxicV+cJUpxFXXo/XXkjmh
	 WH64Oi/ahvjiH2GE19MfXA+fYRgjDPo7sCczbndY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 248/353] mfd: ti_am335x_tscadc: Fix TI SoC dependencies
Date: Fri,  2 Feb 2024 20:06:06 -0800
Message-ID: <20240203035411.569268327@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 90ce58fd629e..68d71b4b55bd 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1483,6 +1483,7 @@ config MFD_SYSCON
 
 config MFD_TI_AM335X_TSCADC
 	tristate "TI ADC / Touch Screen chip support"
+	depends on ARCH_OMAP2PLUS || ARCH_K3 || COMPILE_TEST
 	select MFD_CORE
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.43.0



