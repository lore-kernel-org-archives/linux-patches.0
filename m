Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044280;
	b=JzKjdkcXNl5qky57Zn+7Xi72r5d23eqS+vGIVHXDvVPC45K309vtwzbzvO+RzbwVB8Q2
	 ru+OSa6f7wDVCeG+Hc+307yCHtrTyxNP0O16tJGhUJ/6wVcl4q+zof8GGpkAZIGIZckbM
	 oqoUybhrT/mhjRExJl/MUj2uT+f7p2OaxdnHpXf5jXvUuIHcdY1kjaq2A+W+OuNLtxrwX
	 lNw9OX/dH3H1Zwi/cWRJePex5p9cpeRZi7Ap9q4qN6tY65l7Ih/TEdI9mlg9gGDOtGHJA
	 BOdB8Lgem0G9vPTulKKd3WP3/mNMVxW1SFlNbW+Vgb0TMbXTK4HGoLCC0jnn38HHv8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=icP6RqiA7PZL0e3cRMQWYWIH+CUfZZs7eq8kP5V9JxU=;
	b=Nw+eAGeYvYMWC+19ZnXRxNDr8CnTwEealCHxsGDarWuMLRqYQHaD5QOId/QXT/G2vg6L
	 rpmWhyjcWeIbVRgcNakEUDWDH4Gr744yqnBcp+pmoa0lubKFdKdWG53qrrVhDo1D2uAVy
	 nxdjK4x2s41+SDSgmMd1fpshbzRVBAcPFx/cng04K+qsSz1I81mmkPZpIttEgs/j7yN6r
	 tWOAEdPC/e8iOzN8DP+sMneVCfWzHnso1FOYSgax8wxMTEB6IZ0MdSPysnHFI8/6qfvA5
	 +Ihds6ZYabi2AbyD/v9wVz6xsWKVPw5izeLlZV3HpHeMMSWRiIGQaIm8RjhVJjOiJfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDPjr5Ht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF65A606A32C;
	Wed, 18 Nov 2026 23:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDPjr5Ht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EC81F000C4;
	Wed, 18 Nov 2026 23:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044280;
	bh=icP6RqiA7PZL0e3cRMQWYWIH+CUfZZs7eq8kP5V9JxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDPjr5HtCCnbf7PCg0VXEPOg2iGqVHqNyy9OYf8FK7H9HJVyLA7g8EGAfJCGJCq1e
	 xLAFwHP2Ort18ij2gcz5JeTh4TLYz/U9dH0hPk3PLMdG1VG5jwTgFwu7Lgr/k9RZeB
	 Nr2RdRrcu+lQsuLaA+Q776GqvV9qQPyJHmXOoVts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 0509/2857] backlight: qcom-wled: Fix WLED3 brightness register stride
Date: Wed, 18 Nov 2026 15:25:43 +0100
Message-ID: <20261118150219.789841292@linuxfoundation.org>
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


