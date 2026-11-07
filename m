Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060843;
	b=rDzpoWqbSNhq77E0j0/NA0aHgtvtNjkOrtIoA7is7cr39rxYuHjcFTBM9qmrMmGrK91v
	 2J1OqI/zxo2voRvMyfyg6fCBcZHuI2+9zOD9tTFPQNBsPvhci/KLt0UXMdQMBNaUwZ+yp
	 vJh3uFqimzWIli3llSdJB4YHk25r+L0+x5kOOTy+ThlYIG9jp4nK4ui6RNMlQc1qfR8qG
	 95cnYKbe5Ex6/JOx+rN8M60Vpuy87iICWXar5LnGqvaEHZXjwblhL7GNQRNrA6zLIuL5H
	 fGoSTYBkKvn4UzC9YnLcM+Qu13dn7kz9dmJKot+s0XSHrBvky41p2cNogWoTj8krdIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ahkFgklN7AO7O3c4FLuyHMCvGDv5p1uCC5uHR+wE8D4=;
	b=g21zGyvDnGrl37VrQgiGQNu1Gq+TsVcS/peWJsLnPoPKyNZ4NvULUuIOGeYc5nUYL4se
	 syUjDRrT4wlR2J2BCGfhhEZFFoKkY00jIP6n1zC0D5NAEM922ZXcrX0E92cvxO/UJ/Qs5
	 ozTwTxLZ0dGpknakGe7DaGoosQpwwidxXfP/QIfCBC1qGWAScrp+58S8gdwE1pN/fkV/I
	 rb8iYp2jY95Ot7tFU6Zsdv0VpyvM84X/gAbkE9cKcVrnklARESXJ+s9hraB/T9JmyCiw+
	 VFyYN8pyTgSSAcf3LTwi+bS8EDbbwSqRRhqSuIyxEirft9tOdU/fOBPjBnglPr83IEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2n4gDS6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACBE606A330;
	Sat,  7 Nov 2026 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2n4gDS6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077771F0089F;
	Sat,  7 Nov 2026 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060843;
	bh=ahkFgklN7AO7O3c4FLuyHMCvGDv5p1uCC5uHR+wE8D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2n4gDS6wOrHvYFCb6NymF9yQsZfq1sZ/JyiqNXVvYlBTysD9F9asOg7a30IV6SWd
	 zOytCeWZVhwJcZjCzcB4VrGSCUX6orJExIniAkQTZeEiPjbZ35US1eIZBCTwJKoSPm
	 cgy1llRUsPAvxwU5YoQrHufEFKcfe3hStsU/feoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0232/1536] ALSA: hda/realtek: add missing NULL check for codec->bus->pci
Date: Sat,  7 Nov 2026 08:37:28 -0500
Message-ID: <20261107135004.187058583@linuxfoundation.org>
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
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 72d540182f8d0..25b37626a705b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -12516,6 +12516,7 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
 		if (codec->core.vendor_id == 0x10ec0236 &&
+		    codec->bus->pci &&
 		    codec->bus->pci->vendor != PCI_VENDOR_ID_AMD)
 			spec->en_3kpull_low = false;
 		break;
-- 
2.53.0



