Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A9463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B75C433D2;
	Mon, 20 Feb 2023 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901270;
	bh=eYVsuz7yIS4jkNG98M87pZNda/oClfDzRcrDjEc1DpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zy1vJGVZwXQuCCkJKu9YR46VqrB0LRE2f/uFHx+AWg/dfSp2f731KKKm7FP94OFpK
	 daCicHxYKp4c0Zgk1dz2rJIELdlq/qlSSMolTSzFRKqEwqQbldqXRl8dxh2vOM1Sz2
	 +nU7UoxzmOSTz/VDp9bfCILvD5RtuPCeBisi7t1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/57] platform/x86: touchscreen_dmi: Add Chuwi Vi8 (CWI501) DMI match
Date: Mon, 20 Feb 2023 14:36:19 +0100
Message-Id: <20230220133549.758101692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit eecf2acd4a580e9364e5087daf0effca60a240b7 ]

Add a DMI match for the CWI501 version of the Chuwi Vi8 tablet,
pointing to the same chuwi_vi8_data as the existing CWI506 version
DMI match.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230202103413.331459-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index bc26acace2c30..b96fbc8dba09d 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1030,6 +1030,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "05/07/2016"),
 		},
 	},
+	{
+		/* Chuwi Vi8 (CWI501) */
+		.driver_data = (void *)&chuwi_vi8_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "i86"),
+			DMI_MATCH(DMI_BIOS_VERSION, "CHUWI.W86JLBNR01"),
+		},
+	},
 	{
 		/* Chuwi Vi8 (CWI506) */
 		.driver_data = (void *)&chuwi_vi8_data,
-- 
2.39.0



