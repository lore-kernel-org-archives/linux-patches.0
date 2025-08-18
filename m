Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A82B335BBE;
	Mon, 18 Aug 2025 13:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525178; cv=none; b=QNtdnFlBrSQJYgeNCymzJXuM2MQP+fkK9HUHPXf4iFVKXUTTgGM1/06UaGQlVnJ9Z+aUuQjkh9SedXyE/m3AsNJ6WZ2C42HbZ9JS1165W84BsFtrQJbrhLh1/Z50LosnuWVa/mgaVfEniPbcJE0cez5CBE4oxn4IuIs0aYEw3QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525178; c=relaxed/simple;
	bh=DxCcReqlhsjnszGEU0GGfKyP95luHyhpzp4KCuafyFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODit86YVQoAf8J7GwtyFzPYHX96uCROjbfGHqVt2iGFpq+bX+DVKqBNQbWUBjs5oMe8+J9j7/wWQS1s9EU98SbtBLdKoSgYRk9V2qguGDcOTI6oKO4WweSVw0ez61E9K8y0XVQAIUWGjqkPBRxhphnU4dhdfMQtMempQo/ihFig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmEg+err; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmEg+err"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7AEC4CEEB;
	Mon, 18 Aug 2025 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525177;
	bh=DxCcReqlhsjnszGEU0GGfKyP95luHyhpzp4KCuafyFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmEg+errcLFxcNVqxS309P7a4j0BRqbdgklkThwzurHS6B2JONaCKFpbpBAr1DX/y
	 fKilkgx6/kTIlCD3ozXPmLU8xu9egAllQNbNI7HZX46esXe6DJOFIEIreDdaUpNOOu
	 RGnC/rNqcdj6H+cOfwi4MM8wF6mFMFPHzEq+p+ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Gaidarov <gdgaidarov+lkml@gmail.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 183/570] EDAC/ie31200: Enable support for Core i5-14600 and i7-14700
Date: Mon, 18 Aug 2025 14:42:50 +0200
Message-ID: <20250818124512.859973002@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Gaidarov <gdgaidarov+lkml@gmail.com>

[ Upstream commit 493f9c930e5ff72b3508755b45488d1ae2c9650e ]

Device ID '0xa740' is shared by i7-14700, i7-14700K, and i7-14700T.
Device ID '0xa704' is shared by i5-14600, i5-14600K, and i5-14600T.

Tested locally on my i7-14700K.

Signed-off-by: George Gaidarov <gdgaidarov+lkml@gmail.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20250529162933.1228735-1-gdgaidarov+lkml@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/ie31200_edac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/edac/ie31200_edac.c b/drivers/edac/ie31200_edac.c
index a53612be4b2f..6aac6672ba38 100644
--- a/drivers/edac/ie31200_edac.c
+++ b/drivers/edac/ie31200_edac.c
@@ -91,6 +91,8 @@
 #define PCI_DEVICE_ID_INTEL_IE31200_RPL_S_2	0x4640
 #define PCI_DEVICE_ID_INTEL_IE31200_RPL_S_3	0x4630
 #define PCI_DEVICE_ID_INTEL_IE31200_RPL_S_4	0xa700
+#define PCI_DEVICE_ID_INTEL_IE31200_RPL_S_5	0xa740
+#define PCI_DEVICE_ID_INTEL_IE31200_RPL_S_6	0xa704
 
 /* Alder Lake-S */
 #define PCI_DEVICE_ID_INTEL_IE31200_ADL_S_1	0x4660
@@ -740,6 +742,8 @@ static const struct pci_device_id ie31200_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_RPL_S_2), (kernel_ulong_t)&rpl_s_cfg},
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_RPL_S_3), (kernel_ulong_t)&rpl_s_cfg},
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_RPL_S_4), (kernel_ulong_t)&rpl_s_cfg},
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_RPL_S_5), (kernel_ulong_t)&rpl_s_cfg},
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_RPL_S_6), (kernel_ulong_t)&rpl_s_cfg},
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IE31200_ADL_S_1), (kernel_ulong_t)&rpl_s_cfg},
 	{ 0, } /* 0 terminated list. */
 };
-- 
2.39.5



