Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047984;
	b=Gw9LgG4/xWZaCHf5eaW6A3DgGJc0QuJGVMgMgEcYXuIXE9+NZvReYtbWtWcN6a5fL9g2
	 4GEonhSI/99FWK45N2SW9tOQrWJKZXRJff0RGjrpCBxNOmUMqopuvfdeMbe4hVaj1rt0V
	 RpIpgDu3D5VCVuBnUZtC6qWKEXFLqkM1EeOolHIY8xqkMqfHDfYyt2Z9uJtJbZ054zkOV
	 R6VhcxjCTjElKSGDIkLSiSsFcvkaS10sH6v4ZjmmINvfoci7Owgq+wC/FXlec/JfNMGSL
	 mh0RmhJ2UQMg8y72GKDnuX0CPVl70bFKzcmZy6t+85+SMIK/IOxQo6DAMu7AatSjhGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hMer/ihbWgyWlS+d3yNBajvXfRFOkANSbRVCGDZ4I00=;
	b=foYwxLocLBc+j/y98KykudrpcPMDrzaB5ZFwjWOkOd0T1sufxmAJzSgf/wzwaYU5e9lr
	 p+u7zutd+QsXcZoBD8t9QZEsYIozpP6dpBv9SjRLKLNHEunXST+GLEa3+VjcKMiD5JV35
	 8Ny1LAGOYvO4e7wOAm2v9lFDfKS5VgSJIFKj3E9u/5m3qNNBlSeQvMUBBvRGPdCPNs8YT
	 rcm1g6JGgjGbYrcTdlr4HtdE/B7Eunszc9qaV/OMkk5ch1fVs/ykTqg/+oWQyYjD8D+ER
	 KiSt8pPnCfm4Bz8MvgMf6d6Pu7dnrdItG+ZcEbd2Oee58YSbtZu2cvh65TpM4Bz6bUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yCSz8a2q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F008606A320;
	Thu, 19 Nov 2026 00:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yCSz8a2q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3E81F000C4;
	Thu, 19 Nov 2026 00:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047984;
	bh=hMer/ihbWgyWlS+d3yNBajvXfRFOkANSbRVCGDZ4I00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCSz8a2q1HfyAfoYZrK16d1tBNtFuYo8lFinkWfIzG4oIX/kTDnqJQaPbAYP0Jtgr
	 J1ApxmW1P3SgS6YnnLQK8UE4IHpvW83Z6HlrxYjkj54JCt+MCQvEBL/obw9cvE4C/H
	 1AJmnMOZUpXvsn7Q80myRb+3cxcc6kgHqXpnJ7G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Gallagher <cdine@cdine.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1833/2857] ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310
Date: Wed, 18 Nov 2026 15:47:47 +0100
Message-ID: <20261118150307.251394458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bc2906038f4e0..2cdca9b5f6b9b 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -132,6 +132,18 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
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



