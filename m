Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357DD3FB3B;
	Thu, 13 Feb 2025 15:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458862; cv=none; b=Eu36jEVUO6bnhf81pB/n+V71fQDPJUclDp2uhf/dMhSBPMPsEH/h8rLGkibJIiLV1lWxJCm3GNXKf3muOvpriIhkkc/8pqQiKGgPHNcQZHe3/DHjnFuPRtRsefzJ4p48U9l4Z8U3GHyunT4spwK+Yy/3+Wmuco1ZXArfToqF8+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458862; c=relaxed/simple;
	bh=RcgsCUJ/L83KHx6LLKeiMnPlckKX2j5HrVkDo+LplSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GtjkbpqV2YYPTDORhBMMUkn5dY9V/56f+XVJtET4t+oEA90/ubSq26bfe1xNy1gKwKy+unsNUF3VbZDqhf5TeN0aDGE6GqLsvU0UHf3X/YGVPl8pAbi7JyqrYkpt82sTM4/xZE7YJgesd6mwwVj9AJ5EGvdLi7MUPsnswtnhB4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLjLzs5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLjLzs5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946D5C4CED1;
	Thu, 13 Feb 2025 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458862;
	bh=RcgsCUJ/L83KHx6LLKeiMnPlckKX2j5HrVkDo+LplSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLjLzs5zYxyNduw6Gy5HMo0Yp+OOr4dzF1a4aHx4MQdZpB8Ypk+w1jeHowf4/5lyv
	 cc8tBkJYhF3rYuv5oXRiGjLau+VUPFlqn3YuTP5aNNljVPDPj68PQZZRyEDE1Fze5P
	 Wd5VTIUD4KPZsQc86WDWaX4PiZ2jRgandm8E11o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Johnsten <ejohnsten@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 097/443] platform/x86: acer-wmi: Add support for Acer Predator PH16-72
Date: Thu, 13 Feb 2025 15:24:22 +0100
Message-ID: <20250213142444.352997313@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c85b516b44d21e9cf751c4f73a6c235ed170d887 ]

Add the Acer Predator PT16-72 to acer_quirks to provide support
for the turbo button and predator_v4 interfaces.

Tested-by: Eric Johnsten <ejohnsten@gmail.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250107175652.3171-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 5cff538ee67fa..3c211eee95f42 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -393,6 +393,13 @@ static struct quirk_entry quirk_acer_predator_ph315_53 = {
 	.gpu_fans = 1,
 };
 
+static struct quirk_entry quirk_acer_predator_ph16_72 = {
+	.turbo = 1,
+	.cpu_fans = 1,
+	.gpu_fans = 1,
+	.predator_v4 = 1,
+};
+
 static struct quirk_entry quirk_acer_predator_pt14_51 = {
 	.turbo = 1,
 	.cpu_fans = 1,
@@ -598,6 +605,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_predator_v4,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Predator PH16-72",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Predator PH16-72"),
+		},
+		.driver_data = &quirk_acer_predator_ph16_72,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Acer Predator PH18-71",
-- 
2.39.5



