Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034994;
	b=cCF1ba3AtIR4BxsJ3MP41PS4i1iDoI06ydodEJSAACBEUR/vWAGj0MZARRXambz+DRV9
	 2n1+afUCbtCNUtqVvNVwMXBisby2sz2Yff4Oo9RDvoiZWoNOstPUzDS0Hnos1bzUEld4K
	 FYEm5syGhNy/l4UNhdawmexbToL8S6/ZeOIssmUMUZNiGm5g+AgmCgLdrnohHBAh9HbCV
	 f6SvNuEUT+r461jibpPqQXeOoKe1pI49MOhIeLhXRIWylI/G2MRAiCQfay6wq+rWyDnTm
	 r1k1UKCta0hb9gSxjzAj8++itl8Gg8Hio6G2WGxzhz8kDha6xNkWJB8tzFxc+Gr5VZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nwhQZEbV5Ydcjj7Dac2qG1UI0buQIYN6bxCm9Qgv2PQ=;
	b=3JYUYIB8/1shQzqihxkiWj0ZdkpRXrIYtEQcKNZZRIFmB0l2hqkBn+OydeDKXHEu6z/9
	 w67Ug8NQUimOBdfwA9k3ajaCECh+xvbU09Iaex87R1da+68cSkAY9hjnMTWHxD6VvUAtw
	 5ryxNdO6e1GyJmliIwNcs+M/Rafw6ZAypcZkT9cLpRkup6vjzLwwB8vvsZoT3/CB1NghU
	 MznlQlPb0TXj+e9HkqCAx0AMttfN4HUUg1oIwYQksDhvbp40dT0CghB3U9O2I/bbIAquP
	 LrGhM9zshSdszYgFngEAyZaAUGzO3ZPrCL8tEuGWCvjOFSlIhk0CFloxYz63hOmrHQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RXS7CyV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A35F606A31C;
	Wed, 18 Nov 2026 20:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RXS7CyV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541171F000C4;
	Wed, 18 Nov 2026 20:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034993;
	bh=nwhQZEbV5Ydcjj7Dac2qG1UI0buQIYN6bxCm9Qgv2PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RXS7CyVQ7FrK3yDchc+RcZj/78Zl4uluvGyR9aCfJzi1cSZ5xJP4dQKTiD9E19Es
	 pJ4ZmQGMSIc8xZXpqU8CBFSQMQW2cBKm56xPwtOjneMGZET3bX1+5rG9OyT14vGEab
	 18AzdvvvfHXkiTrWG8CO5FZN8PvxVC6zsUJ06iRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 0566/3318] backlight: qcom-wled: Fix WLED3 brightness register stride
Date: Wed, 18 Nov 2026 15:19:48 +0100
Message-ID: <20261118150334.378850845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


