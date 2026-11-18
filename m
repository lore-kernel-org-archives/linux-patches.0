Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033591;
	b=Sltcf/ENf9mjHPESZ4ZX+/HdG2ROICSlW7vJyBkuQx7kTbIYYd4laxI/AHcH0FCMOZfc
	 4hIZVDiwmDR/AqgSAES+e3dR5AQxHDR4mS7kSuCJwJbpXfm8ojBVR27ZHw4e9FpxZ747s
	 /4FsXFqD8IBEjSitfzWEqYUxDDjG1U1NAmwNBHhHMOOWdigDU2xzCjCEhy7+I00Zus20I
	 08gqhZ324zWbIPjWgqllvIXVq3vf98LO7/cOovzhUupsq4VZHa3vKo2waOOypIc2HGneE
	 9Io1xZ9UFKnV/74M5SJ7vmPIBA+XB68I8BPRq2DY8xVGKiso+1sPgNB4pa2vq4nAbVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pGhQBSNkH5Srz+u2oNwDMREDPvl/iNzF2O8GnKfxZAg=;
	b=YhvgEsnEufTP8hAhDBg44/lNjNcgf8n3tfeTwi6e5rKS2qzHSZOGIfm9vpL/dDqaG6DC
	 M7L+4B1AgeC0pZ4mrpfDPp3kj/Q/phYKxRKFWufyFkxx21Kleuld1IgaofNQ1/2KA//xX
	 4rgBm3fHVkSsMdphAmJ53P7R7P+eXXLrUQvOzltTzXVJf+gtEYTaGjZ4Q/RA9R8TV7wrq
	 cliuZP4HmhyDS0QyTBgEgmZzPE8kvam3LHAk1dallWk3DTMoC/HEyTM3yasOtVZaCdBHL
	 t5wSre/YLTbsecpzS5QCha4wY20oEMxUGT5g297zxurFVkv0C14c4PVrdAfKxU/+HiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e8tn7819;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7266606A31C;
	Wed, 18 Nov 2026 20:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e8tn7819
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379721F000C4;
	Wed, 18 Nov 2026 20:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033591;
	bh=pGhQBSNkH5Srz+u2oNwDMREDPvl/iNzF2O8GnKfxZAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8tn78190ptTyHaHkL7ORa8xuR8T8PFT2fDYYGAiZihZYOl9aKI8pZek6IrhS6cd8
	 uOg45CVScE37H9btQX/f//IELo3ia7O4gu3pRAmBWVflUS6Q/Veg1GSEJb38x4K8vL
	 R3Y1tgFWTUZ2FLEs/kCwBORCY9aU6wr/LYC1iLbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0067/3318] soc: qcom: socinfo: Add SoC ID for SDM850
Date: Wed, 18 Nov 2026 15:11:29 +0100
Message-ID: <20261118150316.020919255@linuxfoundation.org>
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

[ Upstream commit 743af1d6a8b4bfa62dd01b5c2d81b1c62ea597f7 ]

Recognize the SDM850 SoC.

Signed-off-by: David Heidelberg <david@ixit.cz>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260627-sda850-v2-2-44bf46ade42e@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 714d1259b3137..33d6be349a067 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -339,6 +339,7 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(IPQ8078) },
 	{ qcom_board_id(SDM636) },
 	{ qcom_board_id(SDA636) },
+	{ qcom_board_id(SDM850) },
 	{ qcom_board_id(SDM632) },
 	{ qcom_board_id(SDA632) },
 	{ qcom_board_id(SDA450) },
-- 
2.53.0



