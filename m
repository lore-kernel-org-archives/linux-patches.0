Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9559C29DB8F;
	Tue, 31 Mar 2026 16:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976287; cv=none; b=hdpDdYJZy4ND2snlH/dFNCeKcZOZLV4ddkdoAqs7/dWfMIOn3zdzWN//k+YjDiV+VfpO1ESgEwOIDuQbRQTbu3mkaE5pnPBydMTzNPVoTAYiaolYiYIB0AzkOQSe31wy1tHHb76I1vb94x1ztfT/DRi2UumOTYrvd8Qi3yVdSMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976287; c=relaxed/simple;
	bh=zhFjlOsEfYtSFsa4t1X7C889HTxdVQvXfEP1u8S6NaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mD5RqfciRFHvFf6pz6hNb1uoUCKlOpKFiT/vbGr4UG7xxvhScptl4LNEqyBPfUdDap/sPNIF3ivPIPB18OW9P91Hh4bt74j0OM5QCz7IEGJh4hmLnAXiLGx2HYpU0XErXLkqNew42XUC1RImKLmjVza+/9Tvw64n4MURPdbtKqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otW8v2vF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otW8v2vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C87AC19423;
	Tue, 31 Mar 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976287;
	bh=zhFjlOsEfYtSFsa4t1X7C889HTxdVQvXfEP1u8S6NaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otW8v2vFEf6BdFyJYzp74gzaTvnK/jeRw8/NIzfllwHbP9Tgi1Cmj2PdoQgBnYglW
	 TaVqDY9kzkT1pf7ISpo0POKybMUQXikRkNfr7r+OFTdOlsP9zrvnl8BtlIUE8929XK
	 orwYFWtjqpIlLoW9pDwxgMXLQWEwuXCOadWptAmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/309] platform/x86: oxpec: Add support for Aokzoe A2 Pro
Date: Tue, 31 Mar 2026 18:18:58 +0200
Message-ID: <20260331161754.774469980@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit cd0883055b04586770dab43c64159348bf480a3e ]

Aokzoe A2 Pro is an older device that the oxpec driver is missing the
quirk for. It has the same behavior as the AOKZOE A1 devices. Add a
quirk for it to the oxpec driver.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260223183004.2696892-5-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index bf07732776ca9..d66c9c0003585 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -124,6 +124,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)aok_zoe_a1,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AOKZOE"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "AOKZOE A2 Pro"),
+		},
+		.driver_data = (void *)aok_zoe_a1,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "AOKZOE"),
-- 
2.51.0



