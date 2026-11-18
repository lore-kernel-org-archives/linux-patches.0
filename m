Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053418;
	b=nAP5kCN3cGqyHhvWjaNtGZAAB3YIJlO4FSi6gCYgdo1ST1L88Ef2nxi3Bet8WM7efEbl
	 r1zlp0hGR7EzQwxvMN7BxY+kPUmp5PN5Dn8SiozsKG6rfJRUlQReMzOqN0nf5ksbe8zmh
	 xQKf/rQDuBW8BNKzTotkLB4XiCrp9TM0llVKwH+K19/hl9XwJ+j+jqnOPx8xSjzIceyC9
	 6aOiZSsgnwObwSSdNZ2lnYFLGzrPIQJjDOIdZm3aJB1vWy+kT+rHHa5d9iG9+/6K0IJPV
	 SAP1TdD8mAe0/jplSbjPw2XBcPajJ4KB1s6f6g/OiE8+NMVhxaKDJzcBasdREFtBhYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOMevrjzC3wIysS1Jznxhn3e8aDyU35sgpm/hDNZ4tQ=;
	b=UdVSDpkhUub7WcsBoNdPdohtvFP70qdgUhq+rI6c182IDj28vCbDRuV6nvTS+wVHDWT3
	 zQAizE3ebN+kejhNyVjTWpFAvkecExp17zc9oJLnTsidRBja363s7fPOK6aBkMjRvZih2
	 85HBhLD5lPgBncDi9gJYp8f6WvK7KVSs4rUjGQTfNGAb9KAzKRMlWlV56GndRzhW84oiK
	 FbrQVX/G4VZjZNWPySYYIvmRbKfYOg0/v3UF5p2XRjK7bUj/hHHHhT/n/g+r21tI5UChL
	 WDSZxJPgQ0KUs6INVR3+6jiOHThoUj1h0LkOgblpmBL9vG9uJP1cLDRIcV0I1n921Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=We2CUZX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B978C606A320;
	Thu, 19 Nov 2026 01:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=We2CUZX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E7A1F000C4;
	Thu, 19 Nov 2026 01:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053418;
	bh=ZOMevrjzC3wIysS1Jznxhn3e8aDyU35sgpm/hDNZ4tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=We2CUZX6eWO3oTwSqgVRnV5qRXOD/EoWR2Pl2+3NugQ741p+sLeJxSMS25MtgsZTW
	 uiHtHb+USIzZ04rWEspd23SLKjA0rCzEQhPQ4C4Vd7fE513g52SxQ+gG7PUxYeFl93
	 g709JJRt8uGUzLPDHG9LwFSKP5gxSu+o19Hp4NcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0913/2214] ALSA: cs46xx: Handle SCB creation failures before dereferencing
Date: Wed, 18 Nov 2026 15:43:09 +0100
Message-ID: <20261118150048.879074658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd23b7d68c164..dd37c185bcf07 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -1110,6 +1110,8 @@ int cs46xx_dsp_scb_and_task_init (struct snd_cs46xx *chip)
 
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



