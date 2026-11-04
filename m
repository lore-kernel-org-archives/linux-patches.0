Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830811;
	b=re+OrjtC39qgmbp0APTIc2UCSie509MEcGczUqD7H6VGIsfLs6s60wgRPJC3eC1tmWkn
	 oLXcCY9Lmm8z5T3cP1viSLdgJYguS9ElSiedjIxW4dic5O9GL50T0/8QhpO7k199iXpH5
	 2DLQMgwYenAcgN2ELVS5I4xesxS6KdNjCT6llocYe4QUeBq8R+PMLeB1/Yq+WF3IWx+bH
	 tv6fsy3u6FUN49nWw+2uC/4fh5dCLDxye4FE4nxDdBC4U8HxLpDA96IgVYjfyVGlEcc70
	 k2/yHWDNCNOM0ZkIcdh5wZGlTxrXGEEvnV+aabEepLnW7A49hY5DNNTa53FkljU8DFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dHTm+F6aLG1vYdzoV3b6z/1gaDbWkf8hbQjKcYh/P2I=;
	b=RzybR3bs5N//BJTPkAEGXx7qpfoZ6xdn1VDiiBW4Ff+haSfKPY0AQnU+FoJGz7cjZjY9
	 O4f//rMbIywZCk/nbVh3QquAoktcXbzmpELUOnrivi9pM7eR6DVt1aNUPGZEN01w1AD/X
	 rpREEVQjrMQ85XBflD/2B+X9lTGLfDMZ9LgtfNPXhyrCFUqkotfixrL50DascdinH+ZHM
	 yCnHc6c1dLFr5z5kKpfpyhGwGufcPt290lElJS0iyYy+lEtNpnPIHjU9sc3VgcUEqrJNr
	 xwWcPQEagSHsRThRShaieEeSiBd5ASfg0CEZrQVhmNHsKd77NgVDsfMECSduVDKs8Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDzxZmiX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EE8606A329;
	Wed,  4 Nov 2026 22:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDzxZmiX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2641F0280A;
	Wed,  4 Nov 2026 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830810;
	bh=dHTm+F6aLG1vYdzoV3b6z/1gaDbWkf8hbQjKcYh/P2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDzxZmiXprxTC8WxUxCfYrWhBp2sBWYAjPEh4tIFA7f75u9JhIVZfBjpiS4vImfzW
	 SFauda5VzdifcVzik+FMbPYwZDKRp2pjcFxWZvlye3d2ZU6gE+SwZk/PQY6ynPVfk8
	 tpfG1KhCE69+F/wCgT5vOorVZxxx9S2p2ieU2xCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0333/1005] soundwire: dmi-quirks: Disable ghost Realtek on Asus Zenbook Duo
Date: Wed,  4 Nov 2026 16:01:06 -0500
Message-ID: <20261104211053.281886367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ca02ffd4975ca5249abf0cfb750a495d23b453ee ]

The Asus Zenbook Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260720095741.3592825-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 62cee6e2179da..f738e547a1f30 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -200,6 +200,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "UX8407AA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
2.53.0



