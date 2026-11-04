Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829568;
	b=a2Rgg0rlxNS78n5UzkxP+UGgFfTNGtqqkiDbu1fpzACtqArRschd92FC89Flll/oD6sg
	 flwb5EGb59kKHUDz0t3ktelf34wYPBjiHwAIaeiYNduEByrcNLVLUbD5v4YQ5Rg3JWuTp
	 Dkm5Y4CcU3IJ8BeD73b2Tt5ITeOt0CGd63U5CsS7SWKy4XH3pIBE2IO05wh+DzgmxdIyM
	 f7R4oGI2uj36YBGrnoZye4uf6DK+LB/qY4DmpK/V0pauCniHUm6n04aoMi/mIKgOh+sFX
	 WCHXtQcMcNrF64SjRPPPZN5iiqvgXORJfRJvvKOYSDu9ZTLzAOSTbwsEyjox16iS3VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mU/9zlP2rXhcpCFqv/X28dTNF6BtbqNh1SmbWJo96XQ=;
	b=KKM/DWNtmy4rNGVh/hswKFxXa5sXbFYFRbImRE/owtaaPVDmTKms8Aqzjh1N0YEzrfi8
	 R1wX8K6xVh0kK5q70FmAIfKbU+lv2JOtwzha3FfgFH8Sx8YumNU0xe69tSnlYhWLu1n+r
	 CUPMaGN4Cmv14lxcAA3hSY5jhMgCmBHnLo2MHxfaX0SB4+h2FQp8wrvk7gy1C1BJjxWPj
	 +Jbeu9wPnUDioBs6ghJ0XUjB+GhMQjYzLudR9PQhQ/bznQEfS1i030XvFvpJ3+z0N1mBj
	 +NXiNHkMeCuwFzcmeXGZwUxxYHlROSHN+YrgcjTVDHV45EnFQIEgxqCNMGQq8LFYDGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAxwc5L1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C635C606A33E;
	Wed,  4 Nov 2026 21:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAxwc5L1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2321F00A16;
	Wed,  4 Nov 2026 21:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829567;
	bh=mU/9zlP2rXhcpCFqv/X28dTNF6BtbqNh1SmbWJo96XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAxwc5L1b4UhM8uihekVMuukqgUwMJKQ9B85HPoi/R490X744AuEKLp9BBfpsQPRa
	 PBCVeEh5r+YNCTYJ7EjaRyUOen8OYCP6447WvRkW+E+Db3k+4l4RjOEFGMEeJnkY7A
	 WDhjTInaSCQYghz5Hk/wqhZ6DQDt2ouLbs2cpwY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0206/1005] ALSA: hda: Check snd_hda_power_pm construct error before executing verb
Date: Wed,  4 Nov 2026 15:58:59 -0500
Message-ID: <20261104211049.571349634@linuxfoundation.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit df27e4dc80c4a30ad206432cb848aab00de22ca7 ]

When userspace writes 1 to /sys/bus/pci/devices/XX/remove to remove
HDA PCI device, the HDA hardware control path is shut down and devres
unmaps the BAR virtual address bus->remap_addr automatically during
driver removal.

If a delayed HDA verb command arrives after the MMIO region is
unmapped, the driver will access invalid virtual addresses and trigger
a page fault splat.

So add an error check right after constructing snd_hda_power_pm.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260717024948.506335-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/common/codec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 8cab932177194..7869f673894fe 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -39,6 +39,12 @@ static int call_exec_verb(struct hda_bus *bus, struct hda_codec *codec,
 	int err;
 
 	CLASS(snd_hda_power_pm, pm)(codec);
+	if (pm.err < 0 && !bus->core.chip_init) {
+		codec_warn(codec,
+			   "Failed to send cmd 0x%x ret=[%d], hda control stopped\n",
+			   cmd, pm.err);
+		return pm.err;
+	}
 	guard(mutex)(&bus->core.cmd_mutex);
 	if (flags & HDA_RW_NO_RESPONSE_FALLBACK)
 		bus->no_response_fallback = 1;
-- 
2.53.0



