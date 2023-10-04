Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554711D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhJPyrRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA82DC433C7;
	Wed,  4 Oct 2023 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443537;
	bh=oiWy5al20uEiW+wuMmBIpu0AAdh7fv05abRYUF1V0Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhJPyrRp6QaNpFoFsdGEBLi/48+050+XainIF+DRtG0D36hUkPD7lm7Tk8VZGY3B1
	 3RM5l6VwOB1LPRjzhwxa93yibDS5tEtgHqZ3PfTR0/hC2SBo3WRlhS0aIHeFAxywLg
	 I9ZVQtZBxy6GSwNYsu72/EzUU4wJynDaeBX0GpS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/259] platform/x86: asus-wmi: Support 2023 ROG X16 tablet mode
Date: Wed,  4 Oct 2023 19:55:36 +0200
Message-ID: <20231004175224.776077727@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 4106a70ddad57ee6d8f98b81d6f036740c72762b ]

Add quirk for ASUS ROG X16 (GV601V, 2023 versions) Flow 2-in-1
to enable tablet mode with lid flip (all screen rotations).

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20230905082813.13470-1-luke@ljones.dev
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index fdf7da06af306..d85d895fee894 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -478,6 +478,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_tablet_mode,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS ROG FLOW X16",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GV601V"),
+		},
+		.driver_data = &quirk_asus_tablet_mode,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "ASUS VivoBook E410MA",
-- 
2.40.1



