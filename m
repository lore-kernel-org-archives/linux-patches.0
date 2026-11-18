Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015808;
	b=5d6h8sY/mxo3NkurkVBsb9geypfFZHd0J00QLajJXITrFPz5kO2QnPrPPjWpqtSq5eVt
	 AmWxHDt7bS7F8POumMLU4HDR4hjMQmQJnO94IkCva3fXCJccwyyOwdPmVpCFWrdzIzI+C
	 /94hO7mK27Suu1rFakEKKHNtgc26HgE33BBchFJIaAOkw0EYQhTr7PTWmWe6aQaomYOlu
	 d1eMa07dAvDWTnBQdf4/ZbnRGmCHzmUOls1mMFysZ/5+CTTONWU/7u0bGr9xbCZDswNqg
	 axG+Pj4Fb5hiGk8BWqATyNZ7zjznHRJi9tw/dR61fiDRNr96kdV309FoZ/E7JGpc5iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QgaR3Ym37dcSJUOdq4m6NQHHa7TBzwhxARWzIYheAOc=;
	b=uWYv2vda8A0+hvUospSWw0sKjCLztsCX0e9FAbz1c2VhVniSmpEjE7KfCqpVfrFDsEca
	 iohv0NfVsnFYxuMPM4mWNNMPe5jqBgzoQBlTJjeokLdCt4TW+yA7OqcJnyk0/a+OK4p8b
	 f1lkkoeOW1/mAhgrVbkiqfjJib/m/BRfqkbD7SrB6jNeU0CEstrMAHMCNYcgLCRU57Vm+
	 7TtgHn9vRuReHgPpexXPOJMR7j+Up3DMEoFAaJihdzpRc+YQcKk+c80gLLHoWIM3oBGnt
	 YUIcXW3bTIr0muNBRGQDJAr4beQrjpOKX6QCMYaeEMMoLm6i5DHcPeOs68Hm+02G/ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZgyzDVWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDD2606A337;
	Wed, 18 Nov 2026 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZgyzDVWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29591F000D0;
	Wed, 18 Nov 2026 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015808;
	bh=QgaR3Ym37dcSJUOdq4m6NQHHa7TBzwhxARWzIYheAOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgyzDVWA6z/Ff5Pn9HGaK/5QNrYqtf/xNLXDU2mhr6x0yl/4wANVgrHfP1kJhmpgY
	 j+rdru/8DxF8bGS8L2WJaScwZK4tm352M5RKVqXEqMi54WF+lJkTBtC8roZ3N6/nKX
	 fCGK0gmZYsG+qNpeIUOhuYhEHonIrXBuzKC4bO7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Gallagher <cdine@cdine.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0306/2651] ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310
Date: Wed, 18 Nov 2026 15:25:46 +0100
Message-ID: <20261118150258.913617784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index cdbb1023a8ee4..34c7173b5a6c9 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -144,6 +144,18 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
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



