Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059154;
	b=EjwREmy8Rh9dSHPxiT2dFOq4VtRw40SkQWkDI++uEy9zXvr32+1j1IcgvyYd+bHOLpds
	 I36EVpzjOmwDY6cGknRmpsqfJJ/67BB7a2/7eXEFT3OMKdTWekPfCBWvKJz5WShKi2ea5
	 Eq7ZrCXztqAot/qvyMo/S4ogY9MUF746dtYiW4cHvpyscSVwIMj3kXcT8Qs+4lh2gUIC8
	 7PEy4V6fMAfk6scRO7kc4vzOXeODY4AMmVwYghu+KAvt4ICvNX30s5z/piNSGkYjgO9kV
	 mqbhS0C2sdhjIy62WnmfvEXWgU7K2VoMEAzKHCX81yjAhRY6Hr7UNIcmvlW0ZfS06rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OwggkdaMOVOMXymJ93skLo/mMWCZHOwiBE8itqmX1U4=;
	b=C2XZCGscX9uz32CD4cooLFtdKKZ6pCmbNaNIiP6hmzEuvnzvSYeZ6fqU+ZVF1xLXr1Hb
	 7qbFQs2zILbZoMFPP4X3f6gQ+euadpHm0cdfTU+FDcwNYymxJOV4dcmWfivRsB0t6w7td
	 /xPCoM1z4h4qmINpt+Fwm9drrraSkhdySh6rG8tmB21K9WiSt9KuVJfsvsPKdDg3hTZB7
	 54tgLXiaRd4ZrdjsfJu0WNCAN/poPiStDewgu8O6J0rttPduxhjzk9WEfoxHn1lHKkRbT
	 pf+tVfjRfH5TyOjawEi+WKZm6mhIYKmm8VXp3ypvnm7+uKQCVDAv0xI5rCwCZKd3euw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPTQKVu4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8068F606A31C;
	Thu, 19 Nov 2026 03:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPTQKVu4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3551F000C4;
	Thu, 19 Nov 2026 03:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059154;
	bh=OwggkdaMOVOMXymJ93skLo/mMWCZHOwiBE8itqmX1U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPTQKVu4oiss1vci2PZtefoXDPg0VdVNJi9VX9bp2AC8WSVWMVhpEna5iAl2a2gxh
	 u/5fSA6OMuA1SMAHP/W4W85j+QuTsesItsBXlbHUsOMtrkSo2doG+HUueoh9Cjbrf+
	 iTryCM7Bq2CwvpBb7WZW5hPOBtroNAwVKogoDivQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0740/1848] ALSA: cs46xx: Handle SCB creation failures before dereferencing
Date: Wed, 18 Nov 2026 15:46:18 +0100
Message-ID: <20261118145947.334900375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 023d3e1176202339cd94a3d732e3aec74e36ba22 ]

With CONFIG_PM_SLEEP enabled, cs46xx_dsp_create_scb() can return NULL
if kmemdup() fails to allocate the SCB data saved for resume.
cs46xx_dsp_scb_and_task_init() and _dsp_create_generic_scb() dereference
the returned pointer without checking it, causing a NULL pointer
dereference on allocation failure.

Check both return values before accessing the SCB descriptors.
Return -ENOMEM when creating the null SCB fails and propagate NULL
from _dsp_create_generic_scb().

Found by Linux Verification Center (linuxtesting.org) with SVACE
static analysis tool.

Fixes: 41116e926cb9 ("ALSA: cs46xx - Fix suspend/resume with new DSP")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261030142529.415697-1-a.kazinsky@ideco.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/cs46xx/dsp_spos.c         | 2 ++
 sound/pci/cs46xx/dsp_spos_scb_lib.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/cs46xx/dsp_spos.c b/sound/pci/cs46xx/dsp_spos.c
index 5d7c38a0ac7be..1712fb7c0148c 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -1109,6 +1109,8 @@ int cs46xx_dsp_scb_and_task_init (struct snd_cs46xx *chip)
 
 		null_scb.entry_point = null_algorithm->address;
 		ins->the_null_scb = cs46xx_dsp_create_scb(chip, "nullSCB", (u32 *)&null_scb, NULL_SCB_ADDR);
+		if (!ins->the_null_scb)
+			return -ENOMEM;
 		ins->the_null_scb->task_entry = null_algorithm;
 		ins->the_null_scb->sub_list_ptr = ins->the_null_scb;
 		ins->the_null_scb->next_scb_ptr = ins->the_null_scb;
diff --git a/sound/pci/cs46xx/dsp_spos_scb_lib.c b/sound/pci/cs46xx/dsp_spos_scb_lib.c
index 1f90ca723f4df..af5c78e3fd200 100644
--- a/sound/pci/cs46xx/dsp_spos_scb_lib.c
+++ b/sound/pci/cs46xx/dsp_spos_scb_lib.c
@@ -285,7 +285,8 @@ _dsp_create_generic_scb (struct snd_cs46xx *chip, char * name, u32 * scb_data, u
 	dev_dbg(chip->card->dev, "dsp_spos: creating SCB <%s>\n", name);
 
 	scb = cs46xx_dsp_create_scb(chip,name,scb_data,dest);
-
+	if (!scb)
+		return NULL;
 
 	scb->sub_list_ptr = ins->the_null_scb;
 	scb->next_scb_ptr = ins->the_null_scb;
-- 
2.53.0



