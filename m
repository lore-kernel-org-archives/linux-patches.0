Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057727;
	b=f0qQQPnNuKqmYNV20WihsZI0mgzcqjBDuZJ/gzOzyzFuG9S+zajye6tCfC9BD8odVnc9
	 BXUB+PqT/pualOB/nnrYYZamFgPyUS70J8dog/OwIZdwhpsNSh8SuF32SWDfRtxcyfMLv
	 N5+6UFbGxnX+C4u479jNJXB8m+n135qVInovMR2/msWOGtk0nc2RRF64Jb2ea3weHdBUJ
	 h2egr7f0GEbpIT7i10072VRog4bB/y8Tc3N6TVpjYAlUza9YOiAUwmtd2UKubi6zgK3fG
	 fjbKlDpDZwLihbCIucP3+N/hihC+tsur1ty030qM6k5DvRLEeRx5kUX295tCjpo7+xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SdSYCaaZUUJBmwaaMVGAy+mkx6RYwDtFfFqPAgRySik=;
	b=jYn+1Oij7gdjKgDUMWO65PNLxsd+86tU9KTd9hbGUyHvLWkEkMWGAGDaf6Jh+MgeylMP
	 FwsGypfaHJs+u2Nzi5u6kv4r+NAO912gLJ+h3TYmRhqhCbfG5v4XJDkBEJ7aNSz3T+8TX
	 SPLA780VKYsiq9MGc2xWsnVRL90u4OXabgzKNxJuhoQAvGPFNAlXJW13x3rHxXt13QhoG
	 g9NczotVUARb9+TArwlg8Vxh1Hjc1uOyvuQAYs/qT9ayM4apPuSgnyBKJG2IYD4kG9i1Y
	 +kRLgKLrP/pTo/JiQOxdGbheg2RB7Yrb4d5PRI4tFQ86SVNoHvpTJRW5jjImwP5WdxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L12kIOIw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B72606A31C;
	Thu, 19 Nov 2026 03:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L12kIOIw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6766B1F000C4;
	Thu, 19 Nov 2026 03:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057726;
	bh=SdSYCaaZUUJBmwaaMVGAy+mkx6RYwDtFfFqPAgRySik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L12kIOIwtjgMTAH17sMMtLaAXtoYtal9eFjqfDhJ31chSOpTJBuazY9jscdwJnC7t
	 KlihHEmAuQ+fq1C/BlVUUCjbQIUnoHy3UYPccDpDq0bvVnBOFPE+Yii5WHtLGFH6b3
	 evxnqZh6CM5uvJYjMX8uPxsQCvdaSst8M/J3a8JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 0234/1848] backlight: qcom-wled: Fix WLED3 brightness register stride
Date: Wed, 18 Nov 2026 15:37:52 +0100
Message-ID: <20261118145921.750068087@linuxfoundation.org>
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


