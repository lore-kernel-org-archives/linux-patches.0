Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AC3332EC9;
	Mon, 27 Oct 2025 18:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591595; cv=none; b=UL1R+uiSfx+jm7jv/X/yHpb7NazwiLWS/MxTgfVX0JK+Ujt2rS0OFYvFKQd3VeeTr+bgh+ICXg18e/xtfDcCWPKjKVWOMQs1E0dfJDcprUInN+cfg7ZQwLW1+Hln52OR+qAfE3+/NVEDbR2+X5EKmgUrwFiJN8XCwOpawrib18M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591595; c=relaxed/simple;
	bh=w5XeRXujR4BL5YhrNSYmmrvt6n4JG+s+qA+qVhrc+Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXcRPTvY6YeLi2/k6qjb49tsaYChSioCj7Cu0VJ94Pdf0/Wewb3ewgNfhCWpUtZlRIeP0yocc7RStGFW3ohH4TqujfAWfEM9ThiM6g+kuFPPdWNNNF7FlLQ1N1uOxtezv1NLdAse0gq8kxVRJNGzzvRfyUeBHGD4vytuWG0DmOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2BGLHL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2BGLHL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2467CC4CEF1;
	Mon, 27 Oct 2025 18:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591595;
	bh=w5XeRXujR4BL5YhrNSYmmrvt6n4JG+s+qA+qVhrc+Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2BGLHL6pCGN2F/ypOMAHA+cZAhpZapxMz3Ddf9h6mW1sIoHJXR8LualUPucjH2eD
	 AxkwQlvpCeGb/NIuFsM1hBcVXyVPZKNh3DAZ6CETxqXuJI11rLZEcxlDYGC2byaJlX
	 ++xv6Tto9Yg8C/KOavNDa8UUjchzTX3xhCYDfdAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/332] ALSA: firewire: amdtp-stream: fix enum kernel-doc warnings
Date: Mon, 27 Oct 2025 19:35:09 +0100
Message-ID: <20251027183531.603408706@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2ceb57d1d58ee..1332089683da0 100644
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
  */
-- 
2.51.0



