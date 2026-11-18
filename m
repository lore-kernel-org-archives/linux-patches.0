Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039555;
	b=Rq34r/47vZHh7jO5X/5sW1FkntLX+g+WIOSvBlgtdnaY/mIaVrsEyS8rdOxMQ6oNWEpF
	 gUOcXPMqhaQj3IIyq7cokP5GGWkp/7wSA6FvNG0BmktYYhNN+2eYwfqDdzBvAEOvPm0a3
	 6+o/blhKrnO9HOR8DoHSpmRwsluYCGxPdKoM1AFpcNQjpMF4u6kvLCJz4Lu3d3GiWWSYN
	 6GL1kfOT9zFjMNNtKDaZBeTjfnrMPNOMBHNXz9ephvH6IX6QfbL4Ab8Uze+cte/jC3pYZ
	 YQXGWQF3/K0sh4XdjSHWn0ai38zuIN3TE+Xs/BdfQ8RhyJX642WwRlLCREIY3XxgtIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhSzBFn0+PdIwDe+Fb4UC3a6b4dfJQ27WuQwB4M5AUs=;
	b=nukO4550LejmSX6vFY8ihQd83hDYNuptXzI3nLIHUvhWCusykoSgghxN1VX6zXklUF5O
	 CykYZAinSdiap8VTdVEw+rHHfepJ2k2OtRhWcpyVIVVlkC0OA+VbWRnilsQeJosOnd6UO
	 Oku9aKDQuzOFoSlWmABM6/aVrUIr8b5Qd/1Q1R2NloBZSPG73J+OqCdU4mEtDQZ3TiZFb
	 Cg6yq0KO9TMvahf5FsA/w7qMuVW3LAcpOEU7MjRW8aizQe6H+P7OfzgonDCwIVo9Z8FtZ
	 TjqQCKgF+S/lo7K+IzqYVWugOltanc6FSJGRGm9XTbGSDjoBGngU4IRdtAZsoN4NlcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=omgzc7WY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B363606A320;
	Wed, 18 Nov 2026 22:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=omgzc7WY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA721F000C4;
	Wed, 18 Nov 2026 22:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039554;
	bh=DhSzBFn0+PdIwDe+Fb4UC3a6b4dfJQ27WuQwB4M5AUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omgzc7WYAgVn7ZCwiUpXYpRjDlcvUcI19lwpfox9V0H0+8fOCPiP8s6Pm4aluGk4p
	 IU6SDCWGtWJaTMaRYBcRaXTS+sxvbIPuWXUflP37f4xYLvTjpyCFRxqwS9kWZ76mmI
	 RSeDby1h9dR1Ep1Lgz5eOec7Oc2iP+eHTAIYwWeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Gallagher <cdine@cdine.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2100/3318] ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310
Date: Wed, 18 Nov 2026 15:45:22 +0100
Message-ID: <20261118150425.086449095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Gallagher <cdine@cdine.org>

[ Upstream commit f16c512a07b954aa3b0b3c580e7abb5dd4f5e703 ]

This patch adds a quirk mapping for the "Blade Stealth 13 (Early 2020) -
RZ09-0310" laptop, which exhibits the same issue as the following two
related products already accounted for in this file.

 - Razer Blade Stealth 13 Late 2019
 - Blade Pro 17 (Early 2020) - RZ09-0329

Summary of the issue this fixes:
The firmware's _LID method still returns "closed" after resume when the
lid was opened during S3, causing systemd-logind to suspend the system
again within several seconds (15-40) after waking.

Signed-off-by: Ian Gallagher <cdine@cdine.org>

Link: https://patch.msgid.link/90ab9b58-da8b-4ffc-bd4b-adf7590545a9@app.fastmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 9449580e48429..a7c65c615c3ba 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -141,6 +141,18 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Stealth 13 early 2020, when the lid is opened
+		 * while suspended the open notification is lost and _LID keeps
+		 * returning closed after resume, causing spurious re-suspends.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade Stealth 13 (Early 2020) - RZ09-0310"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{
 		/*
 		 * Samsung galaxybook2 ,initial _LID device notification returns
-- 
2.53.0



