Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208983;
	b=P1g72kiszgLO0ypaG4M+GrITK/Wtdts1I1g7PQakFzaLmvt6hDQFFbfXxt3JvOSCJOK+
	 TDezH8QA8FA/CwRSIrJmDuqb1k5gw1G7nY55igsZgOQ0uy0dCTiqgZlsnfzhevPkh6I6l
	 FTJ3sX1+PAdPn8ifhPn1b727C3KSbP1eBFyNv6Jyl2smzHuoqpadDIk3Eq2l87fFdHYyQ
	 I5912KP5KKTezDZ+G4hOsB8oNZXAYgTvywid7Ag61ycd8GikI/g6+sISSfvuBzda5ok8a
	 /wZUFfO9rwTdO7i2kh6DaNMhh06ZdwTVSq8xPrSvNH6bA5rNKbu0WY6akN0bIBEyprA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tFh+VYH1SLVTo+3u46ZXqJDUTNCeENLQX4a1lZtnH/8=;
	b=5k9Eg++X4N7TzRUJh3yG4mjWEqBJjHYU71lW1wAgfgfhsSJXOZZgG71Au/lqgVs4PF/Y
	 hLfXHAd7+Cs/5bU/BAicVKMhlzcRhJQE5b+mX11HdlidjgubwHnDLovVEaHheeTDSQnlT
	 ReKkeTIwa0IY88rSuJp8ipD5Q+M9N6PEkRTXhgBjf1OUmxJyI93FKp94BtpqKxK6eFWDZ
	 JrrDr7AeMtdPpn68uVk0PMuc48x8gp/oiD2qhxBO97IggUkyzJC+oj5BsqwH3ZZDkASlJ
	 s/iro/YFrl9JiHwiESUJjbvssWEnAt7JTrfFcn3WYvROElV7bIKRrwcLtbI3bePX1GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhrgU26O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA62E606A31D;
	Wed, 28 Oct 2026 17:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhrgU26O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E010C1F01825;
	Wed, 28 Oct 2026 17:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208982;
	bh=tFh+VYH1SLVTo+3u46ZXqJDUTNCeENLQX4a1lZtnH/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhrgU26OUZs4hWw3p+DmE/6GPHME6l8ELxnRHyafmUGsZr1+RJb4wkDhMBXaS1taI
	 qKef9UhjBXZAWr4nIR7hHkCps8zOwtsiFtp9aneEYjrHrGRTyUFgj3CsKPLhpIBh1l
	 03TwMPszcGBoJ8jP20zTgigWHk/2xMuLIUVw4kY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/516] iio: adc: aspeed: propagate reset deassert errors
Date: Wed, 28 Oct 2026 17:57:42 +0100
Message-ID: <20261028170010.833844617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 95e4eb426b4bd666fa2f37886c0ddf74a0cc6167 ]

aspeed_adc_probe() continues to register ADC resources after deasserting
the shared reset, even if the reset controller reports a failure.

A failed deassertion leaves the hardware unavailable, so stop probing
before installing the cleanup action and enabling the ADC.

Fixes: edf7550a1f93 ("iio: adc: aspeed: Deassert reset in probe")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Changed the direct error return to a jump to the existing reset_error label. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/aspeed_adc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index 34ec0c28b2dff..012cc9291bef3 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -221,7 +221,9 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 		ret = PTR_ERR(data->rst);
 		goto reset_error;
 	}
-	reset_control_deassert(data->rst);
+	ret = reset_control_deassert(data->rst);
+	if (ret)
+		goto reset_error;
 
 	model_data = of_device_get_match_data(&pdev->dev);
 
-- 
2.53.0



