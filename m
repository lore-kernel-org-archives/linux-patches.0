Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80F7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8270C433EF;
	Mon, 24 Apr 2023 13:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342780;
	bh=61CpfB4NPx3Sn2ArhV0R5wLaJ+ElHuIv6dOpo25OXQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0C8BX1Jn0+VIo2YWn/mUFEkD2TiKAIdhQbl8UKjtC3ZzFxp9gw5snf3bkd1575le
	 9RgmYd+eMXjnMA4WJWJqs7bfgl2dZh5JKExaRdmpnRClPj6SFQQfluiElacmQmGqka
	 XRYyqr6Se40Au+38ckpyMautcdS5+UxqE04MOgTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	weiliang1503 <weiliang1503@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/98] platform/x86: asus-nb-wmi: Add quirk_asus_tablet_mode to other ROG Flow X13 models
Date: Mon, 24 Apr 2023 15:17:10 +0200
Message-Id: <20230424131135.695296332@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: weiliang1503 <weiliang1503@gmail.com>

[ Upstream commit e352d685fde427a8fc9beb2ba30888f5d6f2e5e6 ]

Make quirk_asus_tablet_mode apply on other ROG Flow X13 devices,
which only affects the GV301Q model before.

Signed-off-by: weiliang1503 <weiliang1503@gmail.com>
Link: https://lore.kernel.org/r/20230330114943.15057-1-weiliang1503@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index cb15acdf14a30..e2c9a68d12df9 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -464,7 +464,8 @@ static const struct dmi_system_id asus_quirks[] = {
 		.ident = "ASUS ROG FLOW X13",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "GV301Q"),
+			/* Match GV301** */
+			DMI_MATCH(DMI_PRODUCT_NAME, "GV301"),
 		},
 		.driver_data = &quirk_asus_tablet_mode,
 	},
-- 
2.39.2



