Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE50612D7;
	Tue, 20 Feb 2024 21:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465250; cv=none; b=K7cJox9RaCl2lSGR+0iWNxROeEZn1qDSMjDN0pPTD679o4crAzJss0AIlIQwdlPMmfCu9L6sXqgUQpdz7ELz9eCzADCSrlbay9LiOw3+TDzJXmIBKr31u7pLf+2JrP25Sc5VD5oaLJWddbQmkfOQQc8ZxZNeBYSQPHFV/Bxpp2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465250; c=relaxed/simple;
	bh=7Ms3Q/UPNWrOSOv0H5ENkiwffBFC57UYFXpbG0aMu40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTK7GjyFnZoh04ejnqF7YCPs+fz+8QHLPZSjOU4bqwDq3MKf98XL5fWGMhHvYtR+tcoELSN3dn02pO9CmwWyr6k8hAznsg9sT3AMgUlsgNDGtGpAQAgd/QoV5h8GRlxV26hyVJCHkdrWhX02XK0ohYF4Ybj2ICLq68nPwCB6rlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2bxrk0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2bxrk0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B349C433F1;
	Tue, 20 Feb 2024 21:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465249;
	bh=7Ms3Q/UPNWrOSOv0H5ENkiwffBFC57UYFXpbG0aMu40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2bxrk0c8EUgQqYCqmX1poKIlzrTF2Uhvw0JYx7dbhpROorBIc7BU8I6hkz7euHzW
	 KJKXa0Qcm0NtPN9xCAPGct1JZCoVxfcJpS9sENwa0gjynofqqTWDE2o8G5pqfd/xv+
	 XGntEajocxebx7AEPgFtojg3Hwmc5rNyxJXf1LiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 283/309] pmdomain: renesas: r8a77980-sysc: CR7 must be always on
Date: Tue, 20 Feb 2024 21:57:22 +0100
Message-ID: <20240220205641.975530428@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit f0e4a1356466ec1858ae8e5c70bea2ce5e55008b upstream.

The power domain containing the Cortex-R7 CPU core on the R-Car V3H SoC
must always be in power-on state, unlike on other SoCs in the R-Car Gen3
family.  See Table 9.4 "Power domains" in the R-Car Series, 3rd
Generation Hardware User’s Manual Rev.1.00 and later.

Fix this by marking the domain as a CPU domain without control
registers, so the driver will not touch it.

Fixes: 41d6d8bd8ae9 ("soc: renesas: rcar-sysc: add R8A77980 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/fdad9a86132d53ecddf72b734dac406915c4edc0.1705076735.git.geert+renesas@glider.be
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/renesas/r8a77980-sysc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/renesas/r8a77980-sysc.c
+++ b/drivers/pmdomain/renesas/r8a77980-sysc.c
@@ -25,7 +25,8 @@ static const struct rcar_sysc_area r8a77
 	  PD_CPU_NOCR },
 	{ "ca53-cpu3",	0x200, 3, R8A77980_PD_CA53_CPU3, R8A77980_PD_CA53_SCU,
 	  PD_CPU_NOCR },
-	{ "cr7",	0x240, 0, R8A77980_PD_CR7,	R8A77980_PD_ALWAYS_ON },
+	{ "cr7",	0x240, 0, R8A77980_PD_CR7,	R8A77980_PD_ALWAYS_ON,
+	  PD_CPU_NOCR },
 	{ "a3ir",	0x180, 0, R8A77980_PD_A3IR,	R8A77980_PD_ALWAYS_ON },
 	{ "a2ir0",	0x400, 0, R8A77980_PD_A2IR0,	R8A77980_PD_A3IR },
 	{ "a2ir1",	0x400, 1, R8A77980_PD_A2IR1,	R8A77980_PD_A3IR },


