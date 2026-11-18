Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060427;
	b=BarfIU3rEk7Bf3GLgCzqU8kgkzDQSJaMwb5Lrn0xzzwe/ddjS63fBKexNeHgFn3CEUQQ
	 zlpWvEfOVqpq6uhLw+mRMfXqbc9nhAJpbpkeYaqMnxsm0OO7SOjVeonFd7H+wLZEeXzt3
	 PLaB7Rii1PVlNTmeiHegHX5lglB0FMdcqnM2g2/9KXHTYNWhvNdbVJHlyGEebj8cASFgm
	 KrAcPK0Gy6v9prWvouU0hUP4xNMQbI6oPBRvF/3k7hI6jyY5qenOe5Msd0wYA8vH14+fq
	 JwYqUHa85bwxqGcF/fQXabqPSKGGMM/UFevgUcJMjOT+Lov5G+LC7c2Tv/sxv4rt/Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xk59iI2QQkrpHEnzSIk6qedxRFkujtpjzoyT+uUiD+I=;
	b=c6pEVBjwjnM+3nS9Wf7eJ5bH/U+kdJ72PvgUHvBT0jFolSEOXgpEQSMFOM+1TIDyk0TI
	 GltsqcQCTEgIKJmkyAzfZcxI+vJKc2GDZYx3jIRTgHFmY8oH9SFJx1+DP+hCwOfhEk/kJ
	 1miWMYEKKZwDGPhpifNdd2Jo9ZhI16d+bQWSJm6/TZuEWx/EhPtkoV46Vc20BN4VTCv+s
	 VTNSfUh7JS7I3GxgdZGmO8vWwWvSEsY7/Icjuw/0Y7LKSajJ4O7G0pWC3QcIKUb2jEpkd
	 3YuB9XAU6lFU1GRjgh7DmLRhD2zCSL0C3hU6QGj1+d/t/FiqakYDI/vjZaP8UzxKS/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cec1p4fB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5C7606A326;
	Thu, 19 Nov 2026 03:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cec1p4fB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F36C1F000C5;
	Thu, 19 Nov 2026 03:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060426;
	bh=xk59iI2QQkrpHEnzSIk6qedxRFkujtpjzoyT+uUiD+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cec1p4fB2Bbq1ACkjeMrAkMYGfPeFxZTXkAMF0k48h2b8/SuO75jDY+fyZ8aP6+nm
	 Sr6iZWwwsjOGb8N+HxLOVfCd8c+VsGr8Cu2eeo5W0XY1G4ug17ZhwEIYpE54mhFEUs
	 Kldj198xo+db943PeYWb/N9dxm2FAr77MGJJt554=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Gallagher <cdine@cdine.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1193/1848] ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310
Date: Wed, 18 Nov 2026 15:53:51 +0100
Message-ID: <20261118150009.449424396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 10aca4d2b8244..780be406c2c08 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -135,6 +135,18 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
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



