Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7685275B18;
	Fri, 21 Nov 2025 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731265; cv=none; b=XRNNmW5h1n0PRCKHvecghPt7yL5bsa8SoVIZP14TBqD3pVtasYXvc9WWNVj5dMXmu4JQYKk6upBYGn93P3BKblEkVO0rjFlXuby08SVmiJUu4P1XSEp6kR0jIhkvIfc0XsFT78VqkTMhdsBmBBe9K1F8oCTD3/s8q8fVIrffi9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731265; c=relaxed/simple;
	bh=WI6EwGNQ2gpN4PntncwU1GQEddG7qgq9rc/8V7UbZjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKvbp51nOWCR0mcs7AD67oBuOe0IXrmSFX3bVZsY4Ck1qOjrjQ/pylrsCWbtYUPiXg89lWBqibkIaWL/EyNtp6vOnDJM7FAiyQ0IrK0yIeUq6t5hnuogjwval7ThgKXa2+cSZ6iuAmUW23Ibc9Vbpr5Cj+kj4MQCD0PJilQ8iBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdDFb8kD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdDFb8kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B2FC4CEF1;
	Fri, 21 Nov 2025 13:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731264;
	bh=WI6EwGNQ2gpN4PntncwU1GQEddG7qgq9rc/8V7UbZjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdDFb8kDlPEL0iHXq4s+7PvMjjS42ELMnArgHDXXpeqre0kAx8POC6oVTvaXYiw/R
	 dv2ucIvrvHwUyMUlFwg8QLyvxvnngxujs6lHMeVe5J2TMDObnEaUwNmC7udjmVglIn
	 MU+wCgiMaiqRuXRYahdBa4Mx6UAFZ/ctZHII72k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Wang <ziniu.wang_1@nxp.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Liu Ying <victor.liu@nxp.com>
Subject: [PATCH 6.17 146/247] pwm: adp5585: Correct mismatched pwm chip info
Date: Fri, 21 Nov 2025 14:11:33 +0100
Message-ID: <20251121130159.963560084@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

[ Upstream commit f84fd5bec502447df145f31734793714690ce27f ]

The register addresses of ADP5585 and ADP5589 are swapped.

Fixes: 75024f97e82e ("pwm: adp5585: add support for adp5589")
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Tested-by: Liu Ying <victor.liu@nxp.com> # ADP5585 PWM
Link: https://patch.msgid.link/20251114065308.2074893-1-ziniu.wang_1@nxp.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-adp5585.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-adp5585.c b/drivers/pwm/pwm-adp5585.c
index dc2860979e24e..806f8d79b0d7b 100644
--- a/drivers/pwm/pwm-adp5585.c
+++ b/drivers/pwm/pwm-adp5585.c
@@ -190,13 +190,13 @@ static int adp5585_pwm_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct adp5585_pwm_chip adp5589_pwm_chip_info = {
+static const struct adp5585_pwm_chip adp5585_pwm_chip_info = {
 	.pwm_cfg = ADP5585_PWM_CFG,
 	.pwm_offt_low = ADP5585_PWM_OFFT_LOW,
 	.pwm_ont_low = ADP5585_PWM_ONT_LOW,
 };
 
-static const struct adp5585_pwm_chip adp5585_pwm_chip_info = {
+static const struct adp5585_pwm_chip adp5589_pwm_chip_info = {
 	.pwm_cfg = ADP5589_PWM_CFG,
 	.pwm_offt_low = ADP5589_PWM_OFFT_LOW,
 	.pwm_ont_low = ADP5589_PWM_ONT_LOW,
-- 
2.51.0



