Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062776;
	b=cPdkyRB0OAoDeFk1A+Qqtx9L8UzLNEfWvEBSvn/6C10RDvzeM3WTH3bRaFN0E93ZcoMA
	 tryL/D2tdDV9qH3R52jyhNvNqfqdf2jNWzSmIPs6aljFBDLRE3/jyp4itPETZIjN8zoai
	 Aj7DOvj/cTtDwL4+Z7aEE3nUnGzzL5cy2LObhuKUIvOWDgiW+EGBWNRZYMM9OlcOalKO/
	 XT9h+DzLIULZiq8c88stZ6mycB2cwPl+3DCxwrbjUdwD0kJMUaHLlpizkSafLMHA8K9l8
	 vJrDPzX1jJHOx4jsHvorH5AwCKZZGX9VCR9Zx1iZK2jn2IFEX1rrUMV0/goDMP3Jrcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SxPsu3ZoW9fvhoZubSW4/hW0VfLX4Dmc5uqw0JzFrac=;
	b=pO2aCQYaTv+M+gi2NJWndEZ4ArvLZufjStzsznsw5CQVpCDavJC85vcLanj+heKdDS4E
	 5JublbRXEOl/+otJoYC+vWw3H4VksOweNd+wpJM6wwty8wnWWOI65dgDEhixFw/CyHf9l
	 ojT7klXiyfw9ZzJ5nwjBFZf7xov/DmYtRqbVK30QBnssRePfAO7VWM91aUNa3C+mE9CH0
	 jLyikq3Ch1a+g+MKJwrXd1xmQbk34rMpQKwAJT9GzC2gKUL5uIod8bORQS5T80V3Cyzhq
	 RJWurcYKpMX07OM/jdETuz7dlls0hqvj4dlAg7aGo9noX6BBxPf66z50unZBChg7abg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLYdPYnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54712606A32C;
	Sat,  7 Nov 2026 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLYdPYnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D361F0089F;
	Sat,  7 Nov 2026 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062776;
	bh=SxPsu3ZoW9fvhoZubSW4/hW0VfLX4Dmc5uqw0JzFrac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLYdPYnNWvoM4rs00LGcUV8IB6omrVEc1fgX6Q31vUA1j63iMx5waiD/aXfjV4yJ+
	 0mGaLZWy9iduWGc9Ahy7jccZbrb7aG6JDXF1hfpMDEUiuV1IXddAwyw7daPlym0YXD
	 +tQnuu6TWIfpAvvSTKXO0q9ArxBcf1BqUWEFERw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/869] soc: qcom: geni-se: Widen fw_size to u32 to prevent wrap-around
Date: Sat,  7 Nov 2026 08:45:28 -0500
Message-ID: <20261107134853.680400348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit e976c865bf31b562ab3908f0f1e2160da77fa156 ]

fw_size is read from the 16-bit fw_size_in_items field and incremented
when the count is odd. If fw_size_in_items == 0xffff the increment
wraps to 0 as a u16, making the bounds check below pass for a firmware
segment whose actual size was not validated. Widen fw_size to u32 so
the increment never wraps.

Fixes: d4bf06592ad6 ("soc: qcom: geni-se: Add support to load QUP SE Firmware via Linux subsystem")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260821-fix-write-to-read-only-firmware-buffer-v3-2-43e6a3abd651@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 53e53736766fc..f73ac13e90014 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -1009,7 +1009,7 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 	struct se_fw_hdr *sefw;
 	u32 fw_end, cfg_idx_end, cfg_val_end;
 	u32 prog_ram_depth;
-	u16 fw_size;
+	u32 fw_size;
 	int i;
 
 	if (!fw || fw->size < sizeof(struct elf32_hdr))
-- 
2.53.0



