Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061090;
	b=ryw4dYLCixnJ4t0DCFCOgOjZKEcYMG/MsJns7ZIVNnv3NgsBh3NrtM5oA/WVQMylekph
	 f/CaX3/7xd5xe+bXzDiA3uvj+QO45MSnqR3KPLzTHVe1pHmrsRtY+7IbwwJLnu0+QeOC3
	 zCL+/BZMTjXh8UV+a4g/XmgWsFr6zLhi0UuZ62b+5PvKyhCIqqdkWzG1zLj1E1mcHxsOl
	 4C+wjWajnKnnRw5LXi/Qqtg0bi99EibIM2xL4K38xHdk+Reu2c3MzIoZtZ/M4dcN9psxi
	 eDvr/6W+FFbfK9cfWwCpfgTQWIwcsQp4k2Sc26d2raiNsU/Icc9iz6PIIEQnj+1qhuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9eFIYja6QBjDraqqBmn0/Y2UJteFZY9nXvY/MaS2xlQ=;
	b=zncyWk7Dg/HGVKLgHvtcQ0dPNsIaxnr2WgIQVH+DaTKL/cUqi+5uzK/OTSogZ4MTtsrh
	 /1NDzBPZIrGMTCLUkMFwPc4j9XtJO4doMPQt81tR2rLEyb1clQsBP0bEtsbD9ntO+X6KO
	 VknZ2DBImhtVWhG3CHds9sA0fHaH+DFq1PmfWNQLWZMWpCtO5pKEd1QDKjN4HTQV1zb/o
	 t1N2T0eRwvs/jN350BN+BHmZBMTCUnmOf11Da/S6ILGkRdYcshjc6ECC60i1dmslsg9KS
	 5gGXPoupSJDUUhwR+scmhNtEqKKPsVAqIcRzoLuJMPrjZ8cQ+4pQkCVQVxtsOhcADiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kY8wPDAa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F50606D833;
	Sat,  7 Nov 2026 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kY8wPDAa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D06A1F008A4;
	Sat,  7 Nov 2026 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061089;
	bh=9eFIYja6QBjDraqqBmn0/Y2UJteFZY9nXvY/MaS2xlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kY8wPDAah3mg1IXAJ+SpZ08a6hh+dKUMd99/ErjVGdgBJxCpZY4bSTLrrxCEXIPDE
	 0OWEc3DqOWDcY0lJ1fkwQ2iRRUJ8wHp2+n3mzMqZ8gT/DdQd//xKBWA3ttZGdTErIX
	 QdX+bcPr+qmgHdjoKiJ/A8tpFAGQPehiR3d/An4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Ortiz <letargopausado@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0410/1536] ASoC: amd: yc: Add DMI quirk for Lenovo V15 G6 ARP
Date: Sat,  7 Nov 2026 08:40:26 -0500
Message-ID: <20261107135009.091272289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Ortiz <letargopausado@gmail.com>

[ Upstream commit d395e1b62d9694f2e4add9122f8d473eacd374aa ]

The Lenovo V15 G6 ARP (product name 83UU) uses the ACP6x PDM interface
for its internal digital microphone array. Its firmware exposes neither
the AcpDmicConnected _DSD property nor the _WOV method, so acp6x_probe()
falls through to the DMI check and returns -ENODEV, leaving
acp_yc_mach.0 unbound and no capture device registered.

Add a DMI quirk entry for this model. With it, the machine driver binds
and the DMIC capture device is created:

  acp_yc_mach acp_yc_mach.0: Enabling ACP DMIC support via DMI
  card 2: acp6x [acp6x], device 0: DMIC capture dmic-hifi-0

Capture was verified working with arecord and PipeWire.

Signed-off-by: Daniel Ortiz <letargopausado@gmail.com>
Link: https://patch.msgid.link/20260920011920.2482786-1-letargopausado@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1989929181045..1aedead0a9275 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -367,6 +367,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83UU"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



