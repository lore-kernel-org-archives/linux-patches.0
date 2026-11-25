Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617611;
	b=2QU7k9cuXC4yjnzbdcHzn5bBw7bWEj7ohTPjzdl6yLRWyEAd+ajHnVxdvMKmI9PFOTU9
	 wr1oraQgt2uiZAfDR3MbMJGA8k+NdC2j/9PA6/BIz2jhEg2zNZx3r92peq7t5KZYTN6Ki
	 q8l7bD0ZfSJvSJSS5KUVLZXcdRdC+qk3/dR//XoaPHPIlduKlQGeEJYwaC4/vngveQkzq
	 xOW5t59aBK2ECKN7Y3ymE4rJFginZqUdc/ido0Xj4/I70b94ptLIFOM1JlUd1elgtwGT4
	 YNfabN+vG0afDtpxGYe8E7X/X2/MHbt/T6q8yPHxLqeHtOACmIfpVLBrHgbdiaAH5Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=moQ0DxsZaDwLZq9k4qlAA6qlS2Sf4eTqkbBgPAY5elA=;
	b=rnHiRd1NBZySb+Hb1kCDTKV0kKDcc7ELDPTVievjAcER53Ha83d5uhEMExQ1pUqpQ3E7
	 G+KPkkZQOd8PDb849LvNv7HE0UJgjrV0LEBTkk250UgEiXZl+3tXclbq7tZXJDomq+TWz
	 brsgwuxlCO0hxmhlkWObgETJSQZtL/aUEpwT2EHCMhD+Vh/+DcI3y29DhbTnuvcFl7gJb
	 4RWx1NQC+LuSoSR8h+sm7rtPLykj4zy2n6+5rNxVmNwMdmU1rV38qsNE3PE7ZgMdQ2cbL
	 7I1rmumIRQypy5MTHva40ar3hYAIWjQMWre12uVE2hVs32uoGGbZgUGhZPputDehQ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKXgIMMm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A96606A31E;
	Wed, 25 Nov 2026 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKXgIMMm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D39C1F000CA;
	Wed, 25 Nov 2026 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617611;
	bh=moQ0DxsZaDwLZq9k4qlAA6qlS2Sf4eTqkbBgPAY5elA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKXgIMMmPg5MnXofFPyj1g3jXFrgQvLdBX23/7891mpUQwmUMFBKhM7uOcupMz1th
	 5X/1DLjoM/gKy7WCdEc4SPwGwYte9FlTA88IppfURNmzVvMcImpjyG8AzFdJc1FjhX
	 y1G0/TYPDYohmnWB29kOeENXHQo9Y5nNw8ujcqPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sataporn Saijai <excursively@gmail.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0003/1005] soundwire: dmi-quirks: add Lenovo Yoga Slim 7i 14IPH11
Date: Wed, 25 Nov 2026 15:22:21 +0100
Message-ID: <20261125143821.818024301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sataporn Saijai <excursively@gmail.com>

[ Upstream commit c3133906d5bda343bd5c1d8ad63074a14506ad72 ]

The Lenovo Yoga Slim 7i 14IPH11 (DMI product 83QM) declares an RT722 on
link 3 that is not actually present and never attaches, leaving the
machine with no audio. Since the address is already handled by the
ghost_realtek table, only the DMI match is needed.

Signed-off-by: Sataporn Saijai <excursively@gmail.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260818182020.143096-1-excursively@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 62fa64b224123..8140f9b9db0a7 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -221,6 +221,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83QM"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
2.53.0



