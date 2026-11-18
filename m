Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047425;
	b=jcC5v1UPyel4yn//qjwrso1eiAfl5Y6WQaCOsdfRmu4jbb0jTjKFtJNxT0l5Tr5XNe7y
	 PM7kkL2Vn+m7Fpo/6jT2Vle3QCmCj8C3SxTrkYZlqpSuxwY7dmgiStqCdj/ertUdjzTR/
	 qs8hluEbeikNrLQtb7FKwPpd5Z4CBQXv2U8M3kNCitATLRjhsoIktTh2nSMRdvF2V8l1i
	 vmPK2uUU4XSpEp6V2IiKnLpSvMXp+5Jku5Rjpru0fx38ZT6tCqpOBpFH0cf05KbWc+Msx
	 YdMd0/S5oJrNp0oK/bV7U+LSwmV015rJSBohmHC2oRSCBy0swB+stlC2D4nPv09GOTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=25bSaS6ulr1FATUqXhdG9tvYlSGApCkHFufqykVRY5E=;
	b=GPYPpEeNVaPrhZ4xrQE6cg666i+YzPc6UM7R4lFtsOSPf49vRpcK0unS4iTA27AWrJ8B
	 LXkV75ZPMJhuyq2ShAkK6jYZ/UwdYk2RsrPgvF04QlfCgsgIDvjy1pF7jtXUBK2YyEx4+
	 mbGlStfD+KMcJpTMuTJfVTTik7s0elkWWaxdIcrgf07kkxxVAssck9mJ0bGTss+AeoLph
	 VeU82ZTn2V4jArFMssm8afy06L96ZYVTeGoV0MGlfNskSlr+I4dGURvB8sEgDJw1Tn9Ar
	 1Qe0md+CGDVNpqSKsrUdpshxpZnrE+40E9NEaqs77Tq0x/I+WNlu6F0n4i4tLl+3Z5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJu+vgOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC05606A325;
	Thu, 19 Nov 2026 00:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJu+vgOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6881F000C5;
	Thu, 19 Nov 2026 00:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047425;
	bh=25bSaS6ulr1FATUqXhdG9tvYlSGApCkHFufqykVRY5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJu+vgORCS5gF+hCRAMS5itCP1Sl56lbmf2EaFg6OFcX321z+Pt7qktRWojwCQwet
	 OwUMNXYO1accDVSnYA5kg/FbuZk39dDk0V9+ex7A7HSmWkeAtLioHO0lE1q1CHDLNQ
	 DktW/D6WjKN/oE6CE1fus+QJrESNlG1wm6UZxujI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianluca Balboni <gianluca.balboni06@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1597/2857] ASoC: amd: yc: Add DMI quirk for HP OmniBook 3 Laptop 16-by0xxx
Date: Wed, 18 Nov 2026 15:43:51 +0100
Message-ID: <20261118150258.875876056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianluca Balboni <gianluca.balboni06@gmail.com>

[ Upstream commit 1e73257dff33ff851af60d5bb00d73893a8b6dc8 ]

The HP OmniBook 3 Laptop 16-by0xxx (board ID 8EE3) has an internal DMIC
connected to the AMD ACP6x audio coprocessor. The BIOS does not set the
AcpDmicConnected _DSD property or the _WOV method, and the board is missing
from yc_acp_quirk_table[], so acp6x_probe() returns -ENODEV and no DMIC
capture device is registered.

Add a DMI quirk entry for this model to enable ACP DMIC support.

Cc: stable@vger.kernel.org
Signed-off-by: Gianluca Balboni <gianluca.balboni06@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20261031102136.24600-1-gianluca.balboni06@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Placed the unchanged entry before HP 8E35 because the upstream HP 8DC2 context entry is missing. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 6cc6dc56b89d3..420c91288019e 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -612,6 +612,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EE3"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



