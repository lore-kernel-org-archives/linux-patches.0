Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725EA847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCDAC433EF;
	Fri, 10 Mar 2023 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456795;
	bh=0tZ/4NzooGbrjMVXg9sTdBqHaTj1hP3blSQVZAnuiwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajpoqMaJuqcPS5A9pAbxgWaoC2y3vzDNXjuEqLMoxEriXP6I9WI8xvxMe5kwl86Y7
	 TpBMO4jTO3HE53VMj4glzQmBm9GlaQ4uCUSCjfzXEM50N8Z2Ohfge5JKq2WMz1vBLy
	 Bqf+mMGG04msRJjn0yT2RS/oCySxU63v6LyaJ4aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Darrell Kavanagh <darrell.kavanagh@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 127/211] firmware/efi sysfb_efi: Add quirk for Lenovo IdeaPad Duet 3
Date: Fri, 10 Mar 2023 14:38:27 +0100
Message-Id: <20230310133722.593929108@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Darrell Kavanagh <darrell.kavanagh@gmail.com>

[ Upstream commit e1d447157f232c650e6f32c9fb89ff3d0207c69a ]

Another Lenovo convertable which reports a landscape resolution of
1920x1200 with a pitch of (1920 * 4) bytes, while the actual framebuffer
has a resolution of 1200x1920 with a pitch of (1200 * 4) bytes.

Signed-off-by: Darrell Kavanagh <darrell.kavanagh@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/sysfb_efi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index 7882d4b3f2be4..f06fdacc9bc83 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -264,6 +264,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 					"Lenovo ideapad D330-10IGM"),
 		},
 	},
+	{
+		/* Lenovo IdeaPad Duet 3 10IGL5 with 1200x1920 portrait screen */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"IdeaPad Duet 3 10IGL5"),
+		},
+	},
 	{},
 };
 
-- 
2.39.2



