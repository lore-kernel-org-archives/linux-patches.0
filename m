Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845C6281360;
	Thu, 13 Feb 2025 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457363; cv=none; b=nYOLU5dkSpx+g4UM65YYtbng1HoAz366I4Ka2qUJsQcUBXwBr6lTeju3k0Gnj6OFD/GmLDB9uGBpzxfRsaKfNBMVXZWvgd3aHp6ia22t9+SNkm/F8nTICwraxsgp2ZM9ZUi3ja31E18ECCToWiKwnEn5sGs6SuvwAIgju/osGaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457363; c=relaxed/simple;
	bh=7tvOftF0byNH8kCzxl0KXN2lM3h7cv4Fv1BM6gg5BpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U+hFwYcdmqU0VKAWo0KtPcKmgajQLQ4M1Qsp6cTjaXTLMGPN8o+sYqv5Y09au/RVxD3FkTtCHsW/bT/sVqkiqavZ76PLCj4zXRAv08kbURTjR0MhCFFaGDoNtu8yLMKn6tv+SUN+vDK6viWdnSNXVlJLeDIDgIUrT78eJ3jG0fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxazbndE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxazbndE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93907C4CED1;
	Thu, 13 Feb 2025 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457363;
	bh=7tvOftF0byNH8kCzxl0KXN2lM3h7cv4Fv1BM6gg5BpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxazbndEVhRM8buzlmRNkdWJU9e95j8DntWs8+xQovSI/OqWwKK3Dh2kA5jh+ywBU
	 YXT1IXGodpe/XjylAa9dSesGuz29e0QFU5Pz+N4qsCrLHL9i4Ep7nJRwT74axq4U0M
	 ZVPU6XZrmqbskKchAtVWZZ9DnYCi6n6RJS5Wyk4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hridesh MG <hridesh699@gmail.com>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/422] platform/x86: acer-wmi: add support for Acer Nitro AN515-58
Date: Thu, 13 Feb 2025 15:23:56 +0100
Message-ID: <20250213142439.911054858@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hridesh MG <hridesh699@gmail.com>

[ Upstream commit 549fcf58cf5837d401d0de906093169b05365609 ]

Add predator_v4 quirk for the Acer Nitro AN515-58 to enable fan speed
monitoring and platform_profile handling.

Signed-off-by: Hridesh MG <hridesh699@gmail.com>
Reviewed-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250113-platform_profile-v4-5-23be0dff19f1@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index f69916b2eea39..6534f0cdeb2bb 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -583,6 +583,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Nitro AN515-58",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Nitro AN515-58"),
+		},
+		.driver_data = &quirk_acer_predator_v4,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Acer Predator PH315-53",
-- 
2.39.5



