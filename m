Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA352352022;
	Wed, 20 May 2026 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294870; cv=none; b=OV1ER1Fg4rRmslWOVqT3dtuGWiN9plz2RyFAMJDNmlyYATrxqkZZ2WayV0amydUZeMxn5Wv1cgPpbzVm0nw9ctjz/SARAj2g/1c8bCNra6qtUcs6mIQ1pgMr+oa/sdKrutGj0189zJGyEBdfWMXidu9gmMHMumFJeD62xPQYkHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294870; c=relaxed/simple;
	bh=EVUnyIMe+uskJAIwS4wTbg4YWQIb6V/xwibQzMGk4T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbHGRS9vVWcBNKsExc8HiIFE8uU4RS9AwhTtVhJ4X5j7/JDh7fy609sAsjXQhbfyHcnZYSiURN9RKMkIHN2L/y9CM87TRybpVquYrX09QU4w6PmYSJ66hvzEhLqIf8sIGohOncjKnOCsvZuLMtJHsa5NivGFUz/zUu3p739Lh88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLYY3Cjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLYY3Cjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFC01F000E9;
	Wed, 20 May 2026 16:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294868;
	bh=1WiZr5aYaVXI7dgdN0tRMQNovlXUXz6gfaybFE1Gb7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLYY3Cjxw/H0C7fWt02muP7o16nTrbZcoiX6XO+1719FLXAFjDVGmp5JFJx/oviYJ
	 OiMjIuq0hq7b812XbfAkuWpRQp8hrmEIHuWJmg64OgGTFifZL1u55dDpaHhrB4XTpE
	 wVDcgv8GzsB402g7Al6PJ0HV7Hqad2IOmHYXIpEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0202/1146] net: ipa: Fix programming of QTIME_TIMESTAMP_CFG
Date: Wed, 20 May 2026 18:07:32 +0200
Message-ID: <20260520162152.841996227@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit de08f9585692813bd41ee654fca0487664c4de30 ]

The 'val' variable gets overwritten multiple times, discarding previous
values. Looking at the git log shows these should be combined with |=
instead.

Fixes: 9265a4f0f0b4 ("net: ipa: define even more IPA register fields")
Link: https://sashiko.dev/#/patchset/20260403-milos-ipa-v1-0-01e9e4e03d3e%40fairphone.com?part=4
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-ipa-fixes-v1-1-a817c30678ac@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index edead9c48d1fe..216506eeef1fb 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -361,7 +361,7 @@ static void ipa_qtime_config(struct ipa *ipa)
 {
 	const struct reg *reg;
 	u32 offset;
-	u32 val;
+	u32 val = 0;
 
 	/* Timer clock divider must be disabled when we change the rate */
 	reg = ipa_reg(ipa, TIMERS_XO_CLK_DIV_CFG);
@@ -374,8 +374,8 @@ static void ipa_qtime_config(struct ipa *ipa)
 		val |= reg_bit(reg, DPL_TIMESTAMP_SEL);
 	}
 	/* Configure tag and NAT Qtime timestamp resolution as well */
-	val = reg_encode(reg, TAG_TIMESTAMP_LSB, TAG_TIMESTAMP_SHIFT);
-	val = reg_encode(reg, NAT_TIMESTAMP_LSB, NAT_TIMESTAMP_SHIFT);
+	val |= reg_encode(reg, TAG_TIMESTAMP_LSB, TAG_TIMESTAMP_SHIFT);
+	val |= reg_encode(reg, NAT_TIMESTAMP_LSB, NAT_TIMESTAMP_SHIFT);
 
 	iowrite32(val, ipa->reg_virt + reg_offset(reg));
 
-- 
2.53.0



