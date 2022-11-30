Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830E779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2496C433D7;
	Wed, 30 Nov 2022 18:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833263;
	bh=7pe1PkZe/SrrO2Y2GMqOMFfTCp6zaav9Mb6qW8e5Saw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7QyloR0n78bV6TkDJH59UwbvT3poE0GebvI1nm44ffP8jPMqyJY5xAP9jw2UtJPC
	 7p6tU3Pt8pLy+6GOqEbGxAxcP8FIA6CVMucHxVR0qkX8m84SLdAMd4jzol7jI5zIY0
	 3pI6+LcqIJC2cechmdwQC9+IgcnE1Vre8x/0FipI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/206] platform/x86/intel/hid: Add some ACPI device IDs
Date: Wed, 30 Nov 2022 19:21:36 +0100
Message-Id: <20221130180534.118802677@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan Hu <ivan.hu@canonical.com>

[ Upstream commit a977ece5773b6746b814aac410da4776023db239 ]

Add INTC1076 (JasonLake), INTC1077 (MeteorLake) and INTC1078 (RaptorLake)
devices IDs.

Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
Link: https://lore.kernel.org/r/20221102020548.5225-1-ivan.hu@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index d7d6782c40c2..4d1c78635114 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -27,6 +27,9 @@ static const struct acpi_device_id intel_hid_ids[] = {
 	{"INTC1051", 0},
 	{"INTC1054", 0},
 	{"INTC1070", 0},
+	{"INTC1076", 0},
+	{"INTC1077", 0},
+	{"INTC1078", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, intel_hid_ids);
-- 
2.35.1



