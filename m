Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EF41D5AD7;
	Wed,  6 Nov 2024 12:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895109; cv=none; b=mVDHwLqApcjbhqxaexrw785I/4PJAFvgJ7Vb2ccDRpImg2otdx4KbQRuKMfRYvUMPmiK/kTIg1yESmx9QLvFtUXwl2DkgGkDyvRffqcmTEvXCU2AqxpO4LoqrW6HGvtqqYSCju8WAjdm8MtSPGHOcKfAVTXHAtjjziqRNFRg8eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895109; c=relaxed/simple;
	bh=xUBEwvxLGLRsnyz4tdJF3x+s2jCtdCTYducSzM3FHqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrUIPhXAydOO1qNDJrMi7LOMzcZ9S/M/Ak3T7EJFUZvnU71vhKc5vdV1ddVirfXzP5YCmosUREFo9P1kbr3IlU8halW09D2viS9ejrBVMboHGj9sKO8lYRVCjB8TnCGfPKFLRhuTil+S+ZpqjzgzBRj2de3zpHFBeIzKLWvpzAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uw7xmATy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uw7xmATy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A166C4CECD;
	Wed,  6 Nov 2024 12:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895109;
	bh=xUBEwvxLGLRsnyz4tdJF3x+s2jCtdCTYducSzM3FHqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uw7xmATyeWzndTyRasswYAuRYoUdSJNbgacC6Z/1VvcFW/0u4LNC20W/ul5I2R/yb
	 Fbd+M23MyuvbRt0bUDN4eQBoGe6kDDjPnpDI0xmGrB/0TzB5HYJHMB7qexGZGN2eDY
	 7mQMV+vmONzEdfqVWc2TtBfXvx5omJ3hwJX2m0n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 108/350] soc: versatile: integrator: fix OF node leak in probe() error path
Date: Wed,  6 Nov 2024 13:00:36 +0100
Message-ID: <20241106120323.570928581@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 874c5b601856adbfda10846b9770a6c66c41e229 upstream.

Driver is leaking OF node reference obtained from
of_find_matching_node().

Fixes: f956a785a282 ("soc: move SoC driver for the ARM Integrator")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20240825-soc-dev-fixes-v1-1-ff4b35abed83@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/versatile/soc-integrator.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/versatile/soc-integrator.c
+++ b/drivers/soc/versatile/soc-integrator.c
@@ -115,6 +115,7 @@ static int __init integrator_soc_init(vo
 		return -ENODEV;
 
 	syscon_regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 


