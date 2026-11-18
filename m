Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051654;
	b=yMM3ucjXHFQPOvSoyZskjv0nWbxamQZo0dKlGjakdgW4Ss9fGP4kVPUSdkn5nLKeXK7v
	 kiC75Ow3gTp2yOpKgsvr9sI+JMfc0VPFEJAgaSSsSh3Cmvgax3934iYa6n6wNqBWbxmgG
	 PbFXUBzWZTu5bUaGn7+9y2O2fcxVMTLAscl5WHNY1i/HQqiU2axeZ86b5lfezJewcy/ya
	 O9nNC/yWJ76OqWX3kHcJOueevpLrJvdNNVcfo1WOLR4dsWP4+KHpcmmSlm6OX7QIHgRDa
	 Flwih57NPx8dTGbi5DeVRJVI/VlV9oLDBAYDQEeX/0hQ3GjBPoqeOHSM9OYO37xzRmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GbIgTNVLGcm4BJuRUlL/Hyj29tUVGeh2Mo7Okgpl7k8=;
	b=Pv6gFMLkeBgz1KYS8vs6ScBq/O4V6BBgH3H4Dg/Kd2GQSEObMMk7JVHy2G6E7GaWSAuX
	 +JUNKqhCvtH3DQ2KKs88kNLw8ZZpJU2y5T+XYXlvU0M9Lp6ojevdARV4Lh2HghI1outoA
	 bENlPSVo99oKaG4YbO2Ed/84W2neYcpD7IQ4EBET1v6hmDw8bsY1MxPu4xAcPn/Ziuj9b
	 5zStpv3w0hXVCZw66kAiC1Uo3a4La8nkoDkiVFAgkskKqZ/HMmN58gBpf8vJhXAPS6toW
	 mOx96o8C5ArqbW6s6kaetqo9w/RBRXMPZuXLBWARM+0QgUWdQvA+FQzL4cDFK4V3Hkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLhRmHIE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE8E606A31C;
	Thu, 19 Nov 2026 01:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLhRmHIE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF6C1F000C4;
	Thu, 19 Nov 2026 01:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051654;
	bh=GbIgTNVLGcm4BJuRUlL/Hyj29tUVGeh2Mo7Okgpl7k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLhRmHIErtQ+SRBwv/79r++RNKlunBD5frXx/YpQu9xnICAliWrpx9UsxwQkJH47e
	 SVGgmaeuahiwiR8zdPJpDdu+VpD1MJH9IHNAmFt5mvDJvehjJz2hIxPDlv/Fx1dqVs
	 8DrPBIr6PXHyg7kDF/aecQPEg7lCuNdqnB6l0vIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 0285/2214] backlight: qcom-wled: Fix WLED3 brightness register stride
Date: Wed, 18 Nov 2026 15:32:41 +0100
Message-ID: <20261118150021.454747614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

commit e60dc9c05e0f415ef8bc63b3179abdd49830a619 upstream.

WLED3 has a 16-bit brightness register pair per string, at 0x40 + 2*n,
which is what the pm8941-wled driver wrote to:

	rc = regmap_bulk_write(wled->regmap,
			wled->addr + WLED3_CTRL_REG_VAL_BASE + 2 * i,
			v, 2);

The restructuring for WLED3 turned that into WLED3_SINK_REG_BRIGHT(n),
defined as 0x40 + n, so the two byte writes for consecutive strings
overlap: string 1 overwrites the MSB of string 0 with its own LSB, and
with the default three strings only string 1 ends up with the requested
value.

Use the 2 byte stride.

Fixes: 775d2ffb4af6 ("backlight: qcom-wled: Restructure the driver for WLED3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-qcom-wled-backlight-v4-2-bab8c7ef73cb@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/qcom-wled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -59,7 +59,7 @@
 #define  WLED3_SINK_REG_CURR_SINK_SHFT			5
 
 /* WLED3 specific per-'string' registers below */
-#define WLED3_SINK_REG_BRIGHT(n)			(0x40 + n)
+#define WLED3_SINK_REG_BRIGHT(n)			(0x40 + (n * 0x2))
 
 #define WLED3_SINK_REG_STR_MOD_EN(n)			(0x60 + (n * 0x10))
 #define  WLED3_SINK_REG_STR_MOD_MASK			BIT(7)


