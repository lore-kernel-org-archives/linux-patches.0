Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0AC32ABDC;
	Mon, 27 Oct 2025 19:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592277; cv=none; b=cfcRbeRntyf/kvxshZFjNkjfoN5BMBngVZ+JIe5Lnk+COC2O+T900j4E2ifMv2Eq4QSVYAgje4y4TETVcz0xpH5JE3Iz6CHV7MZnFRr3lI2Jl2Un5FsJ8dmt4GBk22V9TrCvtCApRNILWHAvHbJwLwDh+CaCoex7/50j9umjrdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592277; c=relaxed/simple;
	bh=70SAgvE2eE1JDZWmx6H+rWwX7VSQ5iS74BU4ARsEvjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcCfYdp2bGMuDMo9Ya2rZLGeLcT30bpp5j8gjjolMX6XlDuGT4uG6OhyurpYUtxxtpuMe/a/zl9QbHImzudifU2eTwX8ZZeFloJMXJ65/nHlEHIcP55NgYrySfC1Nl7LteuuqU01NfY2iva3jhoGwmN3ITYt3x56u02JuMUbHO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLuPaRu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLuPaRu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAE2C4CEF1;
	Mon, 27 Oct 2025 19:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592276;
	bh=70SAgvE2eE1JDZWmx6H+rWwX7VSQ5iS74BU4ARsEvjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLuPaRu0lGYysxWDHDFOU5xBAVGsaAvPajjty5bnuwCPPbF+s/7KvusZE656gEcyW
	 KVry0+bER8TTguNVEJ67BxvnkWPuEiz0A5BIKRo66TVPo6LKvaxyRBpe2ePBZJI6FZ
	 Ur2ABXtK3VfbH3deCKIHTZsAhvSPo3V7QXT5DYo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/157] ALSA: firewire: amdtp-stream: fix enum kernel-doc warnings
Date: Mon, 27 Oct 2025 19:35:22 +0100
Message-ID: <20251027183502.922666822@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d41f68dff783d181a8fd462e612bda0fbab7f735 ]

Fix spelling of CIP_NO_HEADER to prevent a kernel-doc warning.

Warning: amdtp-stream.h:57 Enum value 'CIP_NO_HEADER' not described in enum 'cip_flags'
Warning: amdtp-stream.h:57 Excess enum value '%CIP_NO_HEADERS' description in 'cip_flags'

Fixes: 3b196c394dd9f ("ALSA: firewire-lib: add no-header packet processing")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/amdtp-stream.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/amdtp-stream.h b/sound/firewire/amdtp-stream.h
index 011d0f0c39415..dc70256ca2203 100644
--- a/sound/firewire/amdtp-stream.h
+++ b/sound/firewire/amdtp-stream.h
@@ -32,7 +32,7 @@
  *	allows 5 times as large as IEC 61883-6 defines.
  * @CIP_HEADER_WITHOUT_EOH: Only for in-stream. CIP Header doesn't include
  *	valid EOH.
- * @CIP_NO_HEADERS: a lack of headers in packets
+ * @CIP_NO_HEADER: a lack of headers in packets
  * @CIP_UNALIGHED_DBC: Only for in-stream. The value of dbc is not alighed to
  *	the value of current SYT_INTERVAL; e.g. initial value is not zero.
  * @CIP_UNAWARE_SYT: For outgoing packet, the value in SYT field of CIP is 0xffff.
-- 
2.51.0



