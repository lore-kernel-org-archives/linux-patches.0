Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621FE272E7C;
	Tue, 21 Oct 2025 19:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076530; cv=none; b=nB9Kg/tfxdwkrjUXOlTj91+i70z1R9LsPqIJHNFdGH0VQlQTeVrHFEhNivMNVqPEtZK4jU/cxHwsgmqOUSVDknSMbS8rSeAQnvVXtlqHkqQRsSpLHe9QIWVlvlZHKLfaNeRd3uJYjcJRfUPK7BBAz8TvB9XKWpaIje/LgZZaYvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076530; c=relaxed/simple;
	bh=Q/YylmwiiBytdigT3QfTyn9ORvPnCDNc4xEtErrMIUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y36w4zfajqvJcJfcjbHSf39R/sR7lGjvj+17//6pnyF26k+z++eyaQC3p2PkIM1wf+228YMIA2N1VN1WdRhcYyX9NhsggkKJYd63J3P9D4bWgj1x0clcPyse2h0e99acoVdNIcWnQ9uMXYK1fcO0OQ02SwLuR73eYRMxkbEMEIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzK7lt09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzK7lt09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB21C4CEF7;
	Tue, 21 Oct 2025 19:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076530;
	bh=Q/YylmwiiBytdigT3QfTyn9ORvPnCDNc4xEtErrMIUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzK7lt09ccAmzKSINw7hXsYEls4Zi1EUH1FEOZZlMzLTOzyGf32VS7L/O4tAfS3qS
	 CMKIoIZJWPfXg2NfVFrWvMNtcP17iS3DjCUOZLNihpit0Vs/l7eMpcaPZVO6capmRK
	 yALNIxVcS4tphGafvThDXGaF+t7Lyrx1+vQFmUzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/105] ALSA: firewire: amdtp-stream: fix enum kernel-doc warnings
Date: Tue, 21 Oct 2025 21:51:13 +0200
Message-ID: <20251021195023.189607641@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 775db3fc4959f..ec10270c2cce3 100644
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



