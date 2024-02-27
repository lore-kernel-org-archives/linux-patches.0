Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B833B13B798;
	Tue, 27 Feb 2024 13:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040691; cv=none; b=LBzTi+R5QkF3m44/EXvxwEglcuefoDAffYr2m40gegJZLzhuTVH/brsFt9mVC2XXxQ+cAG2/BbXE5A2TCp4bnncjRsqJmTSbChld2HdfnX0vsN3+hVPcZNdPTrUpgmRdwq4NwOfu3TqGzC0VItOhyQqfmWF5udcPktkOslIuGQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040691; c=relaxed/simple;
	bh=A54CNhMKDG8ymx7r3GiWKfUsLOz0vbikDUX7pBV1Ev8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUnrGctIll5TPY51n7xxGLIBPIO1BlAOn8BToSrghgDsfnlv5IAux4HGW8bveZgP9XlOITZ+P3wiv5S6UqengTLjtMWVMLXG3Mmmk8Eao8AEV0HDJn4Br2EkFvE4vkbbpyu8rwNjjB622orZZ74py0nvYhMWKJmdQRrBuH2V3Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prdzbgEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prdzbgEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4354CC433F1;
	Tue, 27 Feb 2024 13:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040691;
	bh=A54CNhMKDG8ymx7r3GiWKfUsLOz0vbikDUX7pBV1Ev8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prdzbgEcMFmaQ4Q+DTkt94JIyYuGdH6+pjFVe/tqyYuKMKIixP4f329cs2w8Zs+aY
	 Ggw1EtRp7bvT9/g97apnNv+kSb/V/B3lGKNKjryNQimNjlvCBGhJ/wwxVqZeP6wjp0
	 jCvFMtC7ADlUFj7Og1m6zVRhIjmgh44LfqRzoks4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szilard Fabian <szfabian@bluemarch.art>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 075/334] Input: i8042 - add Fujitsu Lifebook U728 to i8042 quirk table
Date: Tue, 27 Feb 2024 14:18:53 +0100
Message-ID: <20240227131632.960704107@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szilard Fabian <szfabian@bluemarch.art>

[ Upstream commit 4255447ad34c5c3785fcdcf76cfa0271d6e5ed39 ]

Another Fujitsu-related patch.

In the initial boot stage the integrated keyboard of Fujitsu Lifebook U728
refuses to work and it's not possible to type for example a dm-crypt
passphrase without the help of an external keyboard.

i8042.nomux kernel parameter resolves this issue but using that a PS/2
mouse is detected. This input device is unused even when the i2c-hid-acpi
kernel module is blacklisted making the integrated ELAN touchpad
(04F3:3092) not working at all.

So this notebook uses a hid-over-i2c touchpad which is managed by the
i2c_designware input driver. Since you can't find a PS/2 mouse port on this
computer and you can't connect a PS/2 mouse to it even with an official
port replicator I think it's safe to not use the PS/2 mouse port at all.

Signed-off-by: Szilard Fabian <szfabian@bluemarch.art>
Link: https://lore.kernel.org/r/20240103014717.127307-2-szfabian@bluemarch.art
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-acpipnpio.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/i8042-acpipnpio.h
index cd45a65e17f2c..dfc6c581873b7 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -634,6 +634,14 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOAUX)
 	},
+	{
+		/* Fujitsu Lifebook U728 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U728"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOAUX)
+	},
 	{
 		/* Gigabyte M912 */
 		.matches = {
-- 
2.43.0



