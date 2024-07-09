Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D33727713;
	Tue,  9 Jul 2024 11:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524459; cv=none; b=tUN3tJfCvgA0Wncnn/wEGNUTYhe4omqj2Pzmb90xT92+a9g1Bl2R/IkK0JYcseelAhTOtjHYqSLam4O2vIfCMectzYc8DJ3NYVME+1GSCjU+mRFzEOM5pucg+6lBhcwdaAsKyas25LIQFfz3KaMZoFEoNnGAidqsP6CvdYc0fAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524459; c=relaxed/simple;
	bh=qnxVVMORsyZx0Q/TZTWxqRJKRIR3/oOWigI1+vdNHB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sl1Zj5jEzOplJ5yEfyhPy4ZLbt87It3V2jCI1/29ex97T8vMZYP8xk1sIrhPD4VKhxg1g42CB7G4pJzS/PwaWfZuG8MX8IvkRwkkWv8YC6A9lHzN0cBkLcmvBrisXJ7GtAq5krqhnOwg+Vx7cfQtq4DjMez6o7qWVRAXjB/Kil0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2y8iYr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2y8iYr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE20AC3277B;
	Tue,  9 Jul 2024 11:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524459;
	bh=qnxVVMORsyZx0Q/TZTWxqRJKRIR3/oOWigI1+vdNHB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2y8iYr7nfDYvjwsdfSBa9PSqUGhJMEfOkljhCzSv3tA7r9Jmbi9eGW3mFjK4RgD7
	 7f30S4j/vhFG5lk1mZnfss38UZ44gYYRD7KCFaETZ2fBhP3EJO/YEyIRk/Y35+fNgD
	 4pKKADtswaKpuJ9Q/qov9NEMqTuXsrqU2NgvcykQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hmtheboy154 <buingoc67@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 187/197] platform/x86: touchscreen_dmi: Add info for the EZpad 6s Pro
Date: Tue,  9 Jul 2024 13:10:41 +0200
Message-ID: <20240709110716.178209507@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hmtheboy154 <buingoc67@gmail.com>

[ Upstream commit 3050052613790e75b5e4a8536930426b0a8b0774 ]

The "EZpad 6s Pro" uses the same touchscreen as the "EZpad 6 Pro B",
unlike the "Ezpad 6 Pro" which has its own touchscreen.

Signed-off-by: hmtheboy154 <buingoc67@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240527091447.248849-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 88bd117f0bf56..89e1be0815b52 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1401,6 +1401,17 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "04/24/2018"),
 		},
 	},
+	{
+		/* Jumper EZpad 6s Pro */
+		.driver_data = (void *)&jumper_ezpad_6_pro_b_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Jumper"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Ezpad"),
+			/* Above matches are too generic, add bios match */
+			DMI_MATCH(DMI_BIOS_VERSION, "E.WSA116_8.E1.042.bin"),
+			DMI_MATCH(DMI_BIOS_DATE, "01/08/2020"),
+		},
+	},
 	{
 		/* Jumper EZpad 6 m4 */
 		.driver_data = (void *)&jumper_ezpad_6_m4_data,
-- 
2.43.0



