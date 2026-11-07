Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060970;
	b=UA2n0yVdTiSSZPJ9zorr4LdHe7pfBuv7vVkJ3mhf5OwwuHYw283t8eylLZvato+eI4/H
	 LN1ISHs0GsgTsBDJRhIJIgglGkLC3S6Ys9H9Qvy4OQkvIsPAsK70bz8VN7z5lbLCtAOGq
	 ai6jYI3PoVsmPTsn271TOFzfgHGp22SiIzoetDpqL6k7eKUFiJlUvcZ5qNu/WyYBDXoGm
	 YoIV16hMHk8riCk6kbFh2dugqrzbfGnXh5CtbXEmQEK/CdymIDwoVjG5mMYEyYZPPcD2B
	 t4NmXDiVx0z+nJt2dIJzpI6q6nHLmir9swHhdLeTmGY2Qu4CQYFHuviAF7vPyjgcXtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bg1Hg6v3gxqBbMHUth4tX8HIlbooZAn8HrP+IpMBNAo=;
	b=V1KDUJ1OSAaVw5LW53ETlcnwi7Ky8OZRGMRHf6uH1cnlCZMHhyjYZNKHadJVzvAMssNM
	 YwxuwIXG6efTr3jEe5LVJotwn0yvq8xSIl3oDptSBhk0+e9qNIEV1G/mUF91zEqpyosoF
	 o6Iu1WrvflVfeSjpNeIsptYQvU0RE8TsOcM4NSDZuWZiFHffF4b1iIqOHzTgfROIqFSu1
	 BcudTpPPIgJnbQORi2f1RstfAZxNd/gLn3U9ZyAQTIZZy8D9hrR1mr8wuDMxanaGUyFvg
	 OxIh462PnnurSUIlPLYjp2TM1KlLnBv1HcVFz+IVkGMAMm0kQTYxU7xgY3DrydTSeww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JpqZ/hde";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB41606EEA5;
	Sat,  7 Nov 2026 14:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JpqZ/hde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9E21F0089F;
	Sat,  7 Nov 2026 14:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060969;
	bh=Bg1Hg6v3gxqBbMHUth4tX8HIlbooZAn8HrP+IpMBNAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpqZ/hdeiva3ZAWEEN9thVueokakHvUN9QvIdTtLytR/gEAMdpY8k4Dv+rnPml3+n
	 MnXP7nAhYokS2vvEHSEhA5yYU48+1SQZI6msQfu8B0pAipfvUS816CkugxWSZfylql
	 WQoaRciwsFs8VNfQSDc00dvHyb1J9KbSGYOSe3C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0323/1536] regulator: fan53555: Add support for FAN53555BUC23X type
Date: Sat,  7 Nov 2026 08:38:59 -0500
Message-ID: <20261107135006.791412100@linuxfoundation.org>
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

From: Arash Golgol <arash.golgol@gmail.com>

[ Upstream commit e739acbe05b06de78ef7089470f122432f651faa ]

FAN53555BUC23X has the ID 0 and REV 0xc, starts at 600mV and
increments in 12.5mV steps.

Per the datasheet, the FAN53555BUC23X (23 option) is grouped with
the 00 and 13 options for soft-start timing (t_SS = 300us typ.),
so the existing enable_time = 400 is reused here as well.

This variant is found on the ASUS Tinker Edge R (RK3399Pro) as the
supply regulator for both vdd_gpu and vdd_cpu_b. Verified across
the full GPU OPP table with the userspace devfreq governor.

Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Link: https://patch.msgid.link/20260812125054.19111-1-arash.golgol@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53555.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index c282236959b18..59155cad99bc6 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -113,6 +113,7 @@ enum {
 enum {
 	FAN53555_CHIP_REV_00 = 0x3,
 	FAN53555_CHIP_REV_13 = 0xf,
+	FAN53555_CHIP_REV_23 = 0xc,
 };
 
 enum {
@@ -305,6 +306,11 @@ static int fan53555_voltages_setup_fairchild(struct fan53555_device_info *di)
 			di->vsel_step = 10000;
 			di->enable_time = 400;
 			break;
+		case FAN53555_CHIP_REV_23:
+			di->vsel_min = 600000;
+			di->vsel_step = 12500;
+			di->enable_time = 400;
+			break;
 		default:
 			dev_err(di->dev,
 				"Chip ID %d with rev %d not supported!\n",
-- 
2.53.0



