Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061046;
	b=tIxPJIiPo4S9q3jPYmt9jB+UPL04PWUbA1rrgyplL8gYwGuSTJiH9MX3n7Usyk4iEDtm
	 wfGIP/JjGVKK5JUAVQzp48sg6TH1mNYp+0WwLRq7cH4buKt8t2AsMkRw3FBvrzUX97xyi
	 7C1ThTiyRdtGWJbasLTx4cWObS5TOG7ekucH52tW93/4Go+ySHRZ+OU8LncmcvsjKGwbU
	 2iLP9u6UB9E/+hJXxcmdAgeCXOaxxRl9YDxlcoD3zdO2/m6obCmJLVR5XyJ+vw+ij7KgN
	 acD301soBkC+CkJInITvtmnUBjz4DWJdrYX0rgCiwSyBZ7NrNmIyj//H7VQ5saxEnRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cYjoIGlGJ1h5yLvNJZ1BJTHgotX5pSnlMSKepOlRWLk=;
	b=fbQ2i98wpStQFjMglhtwFQpDBhYMXOrhstdWMm2b1JaUnmLW90RVaphO+VDTfkCpckTF
	 8XuTSixu6EW8Y4kjv2shwG3fZlogjBpSAPEKf+8+g0mFsgMVouSRiz1e5obfvl/fSxWRo
	 UoeLtrxIeBPiTpRbrfpf7RUo/fq7M2zj+T8gLj/fJmJRt3b481zviUrfolNHAVrLKDHV8
	 z1gRgd9TQ8yAU2kOzfOgQ9Gf94jBCnnL+n+XxtDjTky54qsQo17d0QZlOrtl7+NoxSDfC
	 5OW7hlplbly3o3GnlNINmHENykLAJYgnDVSL15NuRCKUpb6FLGA4DlrecPO0jCkcCnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PoL2yw0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59074606D801;
	Sat,  7 Nov 2026 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PoL2yw0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EA01F0089F;
	Sat,  7 Nov 2026 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061046;
	bh=cYjoIGlGJ1h5yLvNJZ1BJTHgotX5pSnlMSKepOlRWLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PoL2yw0Ccu/8tumvwhWwaLkU3kyDWYThDvt609PrhUeDacRJT52shA0LHykUtFQ5D
	 szrCabm3D/vdSwkipCef8lyjVLLBwTzTMRvoXaUVmk2UCSM2j8W2UyuSovxVufrMRL
	 oUWeJckjP0BTepX1HUCSaKhywByDaglOrx7MXKN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Everaars <robineveraars@pm.me>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0379/1536] ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch
Date: Sat,  7 Nov 2026 08:39:55 -0500
Message-ID: <20261107135008.271060214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Everaars <robineveraars@pm.me>

[ Upstream commit 415125669c2ddc773c579a60df108f75712dfa83 ]

The lid switch reports "close" but can miss the matching "open", leaving
_LID closed after resume. systemd-logind then suspends the system again
roughly every 35 seconds.

Reading the embedded controller's PSTA byte while _LID is stale shows that
bit 0x04 is set, which the DSDT treats as open. The DSDT returns the cached
LIDS byte from _LID. Its wake path aborts in RTEC on an unhandled
SystemCMOS region before copying PSTA to LIDS.

Initialize the lid state to open on resume, matching the existing quirk
for the Razer Blade Stealth 13 late 2019. With
button.lid_init_state=open, a physical close suspended once and resume
reported open without another suspend.

Signed-off-by: Robin Everaars <robineveraars@pm.me>
Link: https://patch.msgid.link/20260817141414.213075-1-robineveraars@pm.me
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 6d7c413982167..4f5b51f8114ca 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -130,6 +130,17 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Pro 17 early 2020, notification of the LID device
+		 * only happens on close, not on open and _LID keeps returning closed.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade Pro 17 (Early 2020) - RZ09-0329"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{
 		/*
 		 * Samsung galaxybook2 ,initial _LID device notification returns
-- 
2.53.0



