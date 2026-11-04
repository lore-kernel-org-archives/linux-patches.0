Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831391;
	b=vf2z9gxuQc1P7S+Ysc8YI88BQX0lqYjd1cgEZx099Ea5xcqMauaJb8G2jzdECcM3CUrQ
	 HaNO1SfpP7RFZb4EGHHAsODvX0E9rH9OO4H5P0j7PVUi0kcSaGeZwfULfr+0wpz0Hx0QS
	 4NWTC4rl/8F1I1lnIslqysKIAp+UbfgmDIv2w3gYM56RLnZU+kI69jN0Qu9C7TduwGCaF
	 l4J/waF8SzVYMFaI5uozT8N49IDNb7n3zzWPhE2YcnrPIQoXfznI3f7hEcqnTf53xigZy
	 nXEGYpbD8CFSuXjMNvFbCllhamHxxibLRHf8370t//ONrLczlpZzo2gA2mLCO9V+Diw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmuAJvQMUCitfLhuue+Fq2rs3ITvAEKJEdfZtxmkqKY=;
	b=BttUSzPl7GIHTCR01l8HVM8U0t5YI1Vtx8tE46PklhNmtJ8PzEu4k3wTtjfPAuMqk8HT
	 a40XKJz7KcCkHgb4Om2hHvkE/6BmDnpSO8dpm1QRpax5mq6/BUVvQsc9sheIzt/53+wKW
	 JKJqu7KMjpZYoJGYx9eOpF3ULn2/Atq2KMwM6RwQhOXVWpX3lHkSd9iEekZ6v0Fxtsvmn
	 Y9iojvS9dS3gJCJD95c31MjIpqYaoH+EE0UooJVg8agtwy6oJWQuzxSPdyTV2u0nSfGM+
	 L4GGSCG4PAwhHn2QzZcnsAQhbGVdd4XjFALoPDScneVgxLUJHsZNfXlmAv7JaXQAUfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ea0DN7M2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF687606A87A;
	Wed,  4 Nov 2026 22:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ea0DN7M2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B4B1F00A16;
	Wed,  4 Nov 2026 22:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831390;
	bh=kmuAJvQMUCitfLhuue+Fq2rs3ITvAEKJEdfZtxmkqKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ea0DN7M2ud7cyoH419R/S8MVu8xDHmxzMyKLDLsL5dp9sEm+rf700IwupJJobdomb
	 Ro6rTdiKP47Aiwdil4SeCAK2Pvp34FkzTsALd8IJXkjNuR/4dNIQ6MPdubv/6jnU2q
	 EBXgSph0RjDhENb7dJpmoKL6SQDgYhWl1QA3ITGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 0639/1005] backlight: qcom-wled: Fix WLED3 brightness register stride
Date: Wed,  4 Nov 2026 16:06:12 -0500
Message-ID: <20261104211101.661077671@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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


