Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026624;
	b=vp3lmWwFUjxJLZ+s2Kt+AuqPhn0FxOl/+ndPaOqMKCP/t74gPMddhhzKTRPZLlDpkLn2
	 kG1nH9AuYUPqqe1/QxaE8+7MEQOCqFJIsaSAgFLEL5cN2KfT0cuByP04089yEt3z8KYDE
	 cRXbpGOs8RjUwX6VwwMOo0LQrsBo7zJ1LqIJGTdbBkoVEB3X4f6iohO/PdREExhvZbSCy
	 TNPRXJlEu4/wYbBl1PofyqJVehgrBt0FVCGYiJe1OXoUcTtIlW+9fbve9zKph1Xm8QRMU
	 Tc//N774LGAr2Pmvlv4XEMMhJvf6MY04b9mGlo/9a4Ni5xaGZxj164ksFgQrxrgJ6tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AuRbCm4hgM981Xr8Ex2BfLu84jqLJlmCFyPoMU0A364=;
	b=K+w52Cpz4B5W+qOvsm0XCMtlnTuG3rk9Lkq5dQj0GKVboZPfcztg5WwUcHZzq5iTl8zj
	 7d2B4Cz3n3TRvws4LAD2OPbxdpV5ITIPxiR0VUegVuOq+Pw9xGPMTmQxciRro30h3oH3P
	 JTP39V+PZk9Z3jxp3Fp2dc6Gn32HSd/HlNsMLA/fpuNY7U19oHHS8eakcE52XSI6hQIQA
	 5VCfjrSjaXwfPl3t7XWkf2jwKFnfRcvb8pVoIPT46dVr4LgCGdhQF5JR0mQRbr2OTS/U5
	 TEX+XmRnY/k4ALYBY6tnZwX7abfl0NZ0OYP7C7c/zSAwH140+4NK3/tgr+PhuYTQG1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nO1LNpAC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A100B606A325;
	Wed, 18 Nov 2026 18:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nO1LNpAC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F711F000C4;
	Wed, 18 Nov 2026 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026624;
	bh=AuRbCm4hgM981Xr8Ex2BfLu84jqLJlmCFyPoMU0A364=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nO1LNpACKulTkcMayz9tooU6Rcxf/d0RUvI3I0wAON6lyW1Nq/beue1v5Q1Kgofi2
	 FGLtrG8zyvtZTXJdeefqal19WOs58WLFrDpwnSeJZb3CCllrzA89YWQKweWbSaQAnT
	 Zjb3ABOSNR85xs814QOJW56OpZ+oC0lm0TfLQSvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1500/2151] platform/x86: hp-bioscfg: fix oops on short integer attribute buffer
Date: Wed, 18 Nov 2026 15:53:55 +0100
Message-ID: <20261118150216.513429310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit fd7545cd398adc09ec2f9b603d72671560ee6bf9 ]

hp_populate_integer_elements_from_buffer() ignores the return value of
hp_get_string_from_buffer(). When fewer than 2 bytes are left in the
buffer, dst_size is 0, kcalloc() returns ZERO_SIZE_PTR and
hp_get_string_from_buffer() fails without writing to it, so
kstrtoint() faults on address 0x10.

Return the error instead.

Compile tested only.

Fixes: 6f2c06d5a467 ("platform/x86: hp-bioscfg: int-attributes")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-10-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/int-attributes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
index 5577f571d7c06..f30a63e4fd318 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
@@ -331,7 +331,12 @@ static int hp_populate_integer_elements_from_buffer(u8 *buffer_ptr, u32 *buffer_
 	// VALUE:
 	integer_data->current_value = 0;
 
-	hp_get_string_from_buffer(&buffer_ptr, buffer_size, dst, dst_size);
+	ret = hp_get_string_from_buffer(&buffer_ptr, buffer_size, dst, dst_size);
+	if (ret < 0) {
+		kfree(dst);
+		return ret;
+	}
+
 	ret = kstrtoint(dst, 10, &integer_data->current_value);
 	if (ret)
 		pr_warn("Unable to convert string to integer: %s\n", dst);
-- 
2.53.0



