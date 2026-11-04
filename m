Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830967;
	b=w/fMrQCVjxqw1JGQUC+tJtovH/Dfq2NEWYfdHamsQXkWX1D8mkF7ExYJepWGr4h6myBg
	 lPRJYYqJt08/WpADhqPgu3CIZfu6pIXKnBlSu5jnpDiYCxMls9Ar6o60zLRRRBIkcQcl6
	 VCqCd+GJJqopgV6XbPpSXW/r9KKXDH4P/rmbAwoDAxM0EVibeAitG4uL1Kez7mD4w14zd
	 RCGbjQ+QjhH+bv3HuN+LO65uHecfqX45F1hHEyABsHhq1kanROxDNbgJrkJRvkssy0XJU
	 WG/JsZ1Trt5Ih7I7La0m3hyxibshmbceScva4D6IKU8NDDKRxDGbV64YAif5EM7onyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QyRnUtFVQlz1rnxwRIUpXwSKvMOG7M4weV+3SOr7sqk=;
	b=EDxBUOB2uUQJHdbp/RlltHAsiZPZUysw9J67L/oFYfrn34IDNaDqqRFX4u3qgZhuVhTZ
	 Z4KN0IixqVX/J6I07flAjgMO6P+dYo2Ertav1+BUteOcYjOyRC4VijZ0XjNfP4hx/iqSY
	 auyQi4aWV5DBXnrNXO7xxi+8v/05LfW92P/rgGBKk4vMoxMllxOvfJ4COBCY+ridKK68S
	 +hq9nAXUYhRCE3yBvsZLZf0cDeO/IVWysLSM/JRM3QbSLQJDcwx6Pe7AiZL+9u/anQWvx
	 LWwiUuWShmfSC37I2vDsqYjb8vZ1BVBIMuLzD0TpyRs6yknRov/GFWkHzbdueSipRvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEX13+yq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC07606A876;
	Wed,  4 Nov 2026 22:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEX13+yq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056171F000C1;
	Wed,  4 Nov 2026 22:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830967;
	bh=QyRnUtFVQlz1rnxwRIUpXwSKvMOG7M4weV+3SOr7sqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEX13+yq2tvBOIsM2uQhSKv3p6gyqFIv5YltKc9Z4UJLUDGogaJKEw/iWsDwhY2Ul
	 mKC5OGUPt24W8rjjQ5jat1gY8heuV/5Ln8j1zr3MpdcuF5THKuaKHMlYz+KuJ0YFRe
	 ZMG3MblyeHJu9Uqs8pXi+nvPcfSZ2DtlYZI+//IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Onyshchuk <andryk.rv@gmail.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0431/1005] platform/x86: thinkpad_acpi: Fix fan speed reporting on Edge E330
Date: Wed,  4 Nov 2026 16:02:44 -0500
Message-ID: <20261104211056.165864719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/lenovo/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/lenovo/thinkpad_acpi.c b/drivers/platform/x86/lenovo/thinkpad_acpi.c
index 075543cd0e77e..f3b2e3c794571 100644
--- a/drivers/platform/x86/lenovo/thinkpad_acpi.c
+++ b/drivers/platform/x86/lenovo/thinkpad_acpi.c
@@ -8854,6 +8854,7 @@ static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_Q_LNV3('R', '0', 'T', TPACPI_FAN_NS),	/* 11e Gen5 GL */
 	TPACPI_Q_LNV3('R', '1', 'D', TPACPI_FAN_NS),	/* 11e Gen5 GL-R */
 	TPACPI_Q_LNV3('R', '0', 'V', TPACPI_FAN_NS),	/* 11e Gen5 KL-Y */
+	TPACPI_Q_LNV('H', '3', TPACPI_FAN_NS),		/* Edge E330 */
 	TPACPI_Q_LNV3('N', '1', 'O', TPACPI_FAN_NOFAN),	/* X1 Tablet (2nd gen) */
 	TPACPI_Q_LNV3('R', '0', 'Q', TPACPI_FAN_DECRPM),/* L480 */
 	TPACPI_Q_LNV('8', 'F', TPACPI_FAN_TPR),		/* ThinkPad x120e */
-- 
2.53.0



