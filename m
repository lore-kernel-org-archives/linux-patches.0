Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829694;
	b=1Pym8KwxxZ1wQ8hXI21yCq5d6vY6vuWMm/u4uUvUuPZKkXkI2F/jnKUv+aac16EJkQ2J
	 zRj0fJ5Fm3kDTV/kKyPu1gA+aZ4cAP1h7aFUpuCaZdW7LRm6zi4tcUBZj4qw4Gtizt8rA
	 S6wGqkK5f7Ct1NzkSASbDdATKnX6ffvEivyRntlBinllkZ7/6ONezU4fFPWnRrqN9/wNF
	 9jFPEUKtYxSYf/2CyeLSUWhp1b3i68HOKT9f9on4tnrob72IudKwPH7Lbs+Qk+O7JvJ4n
	 AJ5AM19knulHrpkUQX5rLqSluknaWmq7x58O6F9K1wAXv5ezBl67NzmSZg1XXK6FeuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ZQMA3jFd3UyLIpOZHRrBOOpbOQNjRe2KMFkshG7rw0=;
	b=Ej3wVmOSyep1hWLRjn2j4VEXnEiSS/ItfUP/RIfOunGSL37BbxFMPkGi/KXJL+FBQXCY
	 DGiSrSDbOUxLuS/e9I5zWGPh8AB/lMczwwH1e37uw8Dv215u/fEd/2OFpJQeXhpcOV2So
	 31LA+u5VNgih9sDhCkUFSU/04+Xm22nk2WRb53gjF4MY9AIiO6Ac+Jm1vejR3gvySKtIM
	 5prwiz/FaN7dKgSisV1M3NEwJbry+eN6QWA1XZoYB14XfonAH1FtlpiYinq+4vJvU6uO6
	 9VTf+0djHwZWYh0XBg7vGVp/rEAcEqeVDud3I6OoVuwK5gsexRdkPCvoryT51k9O7lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QADm8bjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2019D606BA30;
	Wed,  4 Nov 2026 22:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QADm8bjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE7F1F00919;
	Wed,  4 Nov 2026 22:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829693;
	bh=8ZQMA3jFd3UyLIpOZHRrBOOpbOQNjRe2KMFkshG7rw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QADm8bjARdpVFAhhmmTG3XEgwHKTvu0ib+KvXbjcnaFlp9pMUYwp8Oaf2I2GrPM39
	 e/dSFZKxS0prgmYZkCtgkFgOWbv7qjU8oz+JdP6b9xGjY+07p4q7RvLSjsEK3bvuSk
	 VqbySqvl1fp4tn+GdNzG8eYNw7FuUNgm74pCQR1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0284/1005] ALSA: hda/realtek: add missing NULL check for codec->bus->pci
Date: Wed,  4 Nov 2026 16:00:17 -0500
Message-ID: <20261104211051.853641669@linuxfoundation.org>
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

[ Upstream commit 3b36ac93739e7b119a30affaee9c2dd41f24efbb ]

In alc269_probe(), codec->bus->pci is dereferenced without a NULL check
for the ALC236 vendor ID case. Add the missing check, consistent with
the existing pattern used elsewhere in the same function.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260730015302.253008-2-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 6bf500c0b5f9b..d88627558150f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -8451,6 +8451,7 @@ static int alc269_probe(struct hda_codec *codec, const struct hda_device_id *id)
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
 		if (codec->core.vendor_id == 0x10ec0236 &&
+		    codec->bus->pci &&
 		    codec->bus->pci->vendor != PCI_VENDOR_ID_AMD)
 			spec->en_3kpull_low = false;
 		break;
-- 
2.53.0



