Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061027;
	b=HB1MeUlk5SKJuoik7gOZuRlCFPsMXw22DN5SugEv1HRcSkvbXwSjCFKruBVO47iZgKpP
	 xLZyGJ5iVJDkbMN0FEwoV1miWRA9zky9wPHxGemaLTgVHH3TFzd5CCPuXSTagM5BJ7BPG
	 VigKElJhpClB0ZkhR7d6t5lqgIM1sf2555IInXdRQdvIo1+8A0bddVk8aWu140bvPgYsz
	 ILdzvRzFdsjutZiQUAejHXwAC9YdCOGOukz1uL91qZ9Qmdaud3oK13zdjf9TBZSq0dHVb
	 ZGkp6qeBem4Rd3dJ+ztrqyAH61ayHFOHwScjNNe4PxjPO7g2JdtogtXmOPLT+RgqzsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8L0lp/5kronIlQ+wZcgEDCdk5iKrv9t3d8xBDJ33MGI=;
	b=gIBD0LqwBuZLneCpMwXcAiD5DeCbTQ9QW7+2FoML8n+MGhEPZwF8pubOgyU2SH+qm+WR
	 GWUtH5yVDPzfYvAFMNuMxyfGLRoQ5JBR2GXkPc2xE1vhccQanqMfzZHreFXa2GQtHz1C/
	 FBd1/FhBH589hCtZ7MTga3MA+vSZBOy/EeP7pMddcxtmKm3wka/Zqw2RTTEbleYvbi7bW
	 Mu5VwZR6fHlMnQ9xc0KbdTkEA5Kd1KbpSC4b9mJAnEV3R5TFadlE5FcnJm/hAJ+hDd5FQ
	 EhcgX746i5YikF8Vjpn/7XYno7pO+UhH28HPQoTFWXmbY3rNoOekIR2j+sTAMOqyHBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozvdTXV4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4328A606D81F;
	Sat,  7 Nov 2026 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozvdTXV4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AFE1F0089F;
	Sat,  7 Nov 2026 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061027;
	bh=8L0lp/5kronIlQ+wZcgEDCdk5iKrv9t3d8xBDJ33MGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozvdTXV424NZl1pFukczgaDN0Cj3q2Sz2+R6yJz+WCfHr6M8FnpzaWJdguj8Ev8jX
	 gzmk2Mz/To8xF9oqkMFaOz7LBvGVOxEHiQBGCYMzvlWgEgtgKmSMjx3UiRKJi2ZrmY
	 WACsX8Mrl8AlBH4UtMS6iNBmmf5X/OduB7uDmJyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Onyshchuk <andryk.rv@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0363/1536] platform/x86: thinkpad_acpi: Fix fan speed reporting on Edge E330
Date: Sat,  7 Nov 2026 08:39:39 -0500
Message-ID: <20261107135007.853484868@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Onyshchuk <andryk.rv@gmail.com>

[ Upstream commit 8d840dad456f88374d8a3b03851452a280d6ee50 ]

The ThinkPad Edge E330 with H3 firmware uses the non-standard EC fan
register block. Without a matching quirk, thinkpad_acpi reads the legacy
tachometer registers and reports 0 RPM.

Add the H3 BIOS family to TPACPI_FAN_NS so the driver reads the fan
period from EC register 0x95 using the existing non-standard reporting
path.

Tested on a ThinkPad Edge E330 with BIOS H3ET77WW and EC H3EC35WW.

Signed-off-by: Andrew Onyshchuk <andryk.rv@gmail.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20260806154417.618575-1-andryk.rv@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e4fe90b70e50e..dc3ef1504dccb 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8828,6 +8828,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('R', '0', 'T', TPACPI_FAN_NS),	/* 11e Gen5 GL */
 	TPACPI_Q_LNV3('R', '1', 'D', TPACPI_FAN_NS),	/* 11e Gen5 GL-R */
 	TPACPI_Q_LNV3('R', '0', 'V', TPACPI_FAN_NS),	/* 11e Gen5 KL-Y */
+	TPACPI_Q_LNV('H', '3', TPACPI_FAN_NS),		/* Edge E330 */
 	TPACPI_Q_LNV3('N', '1', 'O', TPACPI_FAN_NOFAN),	/* X1 Tablet (2nd gen) */
 	TPACPI_Q_LNV3('R', '0', 'Q', TPACPI_FAN_DECRPM),/* L480 */
 	TPACPI_Q_LNV('8', 'F', TPACPI_FAN_TPR),		/* ThinkPad x120e */
-- 
2.53.0



