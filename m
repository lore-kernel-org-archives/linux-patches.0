Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E09145B1E;
	Thu, 11 Apr 2024 10:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830416; cv=none; b=KVcz2ayWwAiPZY6GyCsphpYswV31jpHXiIoNgicUj5Vl7R8KjVA5Hl6t6HyfL6BI7nqrqhLVD11kyYXmlY8ULH9IdFvjlLGaYqGYG2V6jM0VUyH8UPhj4IR93fm09UQplf2RfRscrxpHeNB/QLH/8eU7K84trPziVorRc1ex2R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830416; c=relaxed/simple;
	bh=SifY4LBYSMoGkXSEx+EdXH5XDw8QTg0Yrw6AkpzdaO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lbazRGJARKARuf2oSmlcuRSm6/eioQwkE6Oa83uqFmjXlvUkzs9lImp27uHu1rSmwDZGeLdSCmYzXDllGllBnZJmlYVb/yK3PkRQcH3USAHz703VDDR/rw3NlyAc9kgSupzudbceFL1NqwRKzn0h3VAuniiw7/DW7pQQ3yExUno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuuLAqwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuuLAqwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DD4C433F1;
	Thu, 11 Apr 2024 10:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830416;
	bh=SifY4LBYSMoGkXSEx+EdXH5XDw8QTg0Yrw6AkpzdaO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuuLAqwF4ETd5JzWsAlWZDzxeRDiMuEUr/B67jUO20sUYXRKDcoVSKpL4T7ozFsQD
	 1GvqskU0zmG87hlgXwhmIbiRRxs+7BF36KYXsQzH0J//2PHBggNtikprVABuyQ/wrm
	 XWiRBJRfuQbkv2DWGMo8PaCMObfCmuTp3Zb0w23o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SungHwan Jung <onenowy@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 100/143] platform/x86: acer-wmi: Add support for Acer PH16-71
Date: Thu, 11 Apr 2024 11:56:08 +0200
Message-ID: <20240411095423.918501151@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SungHwan Jung <onenowy@gmail.com>

[ Upstream commit 20a36ec343d4c5abc2378a45ab5e7ea1ca85020a ]

Add Acer Predator PH16-71 to Acer_quirks with predator_v4
to support mode button and fan speed sensor.

Signed-off-by: SungHwan Jung <onenowy@gmail.com>
Link: https://lore.kernel.org/r/20240220055231.6451-1-onenowy@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 88b826e88ebd7..771b0ce34c8f9 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -584,6 +584,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_predator_v4,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Predator PH16-71",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Predator PH16-71"),
+		},
+		.driver_data = &quirk_acer_predator_v4,
+	},
 	{
 		.callback = set_force_caps,
 		.ident = "Acer Aspire Switch 10E SW3-016",
-- 
2.43.0



