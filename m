Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619547;
	b=hw7u380tf5fQBPzoyO9/eOZVgyACCnv0rPW6/SAfWV/eo8WMROcOxWFudIao5sghErD0
	 AdgESKC3sS+tUVESDQ2u5PJxlDC2trkYurD6NY7KpWv3hLC1HJSz22bI/Ya+RqaqiX9uL
	 KcKrDNDwBMA6B/zhuAepsXstbVXQ1zeS9+EFWqWBgUT4IZLfXqVgYiZ9VPxpaxrDycudu
	 kUPxBR6U1Ui6sMw0ldS3FZ2o3i4YTXP98tgI+3GOQsJcNUtVTv4dnj1yH/z6NZ6zzta+v
	 rONJHSjPF5+orp/1KrvvhbxJ4YXLP08LC83L/WOH2td6CREZPGiI/9PVJl0hLerOJTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qab9GaeJ7vBfW8Ma2Mf7byvodvhH8M2kQwV+LQnfD+k=;
	b=3EwzP+jAh6YNNi3WoJflDFLcB6NPzUtXnrcDMeG14GwdXGwAYmfK3zfwrOQ4+EFREUxV
	 J+jFuOCrbHrvWKo1oksBmxXtDobUeiX+TMANxr4pWvliK3VDT0VwKbSgx58kaDAjGIH1a
	 p+ERN4OXklig316k0tSr0F6hXB+iKCmncNC9xX9MuvmvK0XxzWNPuniVHL3euWgBbliH4
	 KS5YUH01f0KD+9V4FQExcZzJNJN+6Zt/2v6wEyX0irtrMbDwOrZQQUxAa7POo1G1/uWRm
	 E4fumBq6XljjBBUCzy3Yuio/H4lip6JFGjDV6SB/4+2TNog1qLXzzjT3ZSaGlzB4qJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8wwCD3C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF9606A31E;
	Wed, 25 Nov 2026 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8wwCD3C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0451F000C6;
	Wed, 25 Nov 2026 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619547;
	bh=qab9GaeJ7vBfW8Ma2Mf7byvodvhH8M2kQwV+LQnfD+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8wwCD3CmiGp5HQ5kyMgOGA5r08KulNWjJv8AVDwfHJAXuUsDYGQYUHtgbj46HOUW
	 Ijc/AsjIDmRxWixFIueq4ojvPqo5irfEDK+sSJPcA/Jlyk1kv9hWdzrUj0tYFyQVE5
	 h0Y3Fbr/6/g8ntvg9uytQs9aD+QyhLorrGGxGbUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <jjc@jclark.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0631/1005] net: stmmac: ptp: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 25 Nov 2026 15:32:49 +0100
Message-ID: <20261125143836.529488612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <jjc@jclark.com>

commit b66fca408bf85bb40f48a689daac75421f5283f8 upstream.

Commit 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to
ptp_clock_info") modified the PTP core to validate the supported flags
of external timestamp requests, rather than relying on each driver to
check them.

stmmac_enable() and dwmac1000_ptp_enable() ignore the flags, and
neither stmmac_ptp_clock_ops nor dwmac1000_ptp_clock_ops was given any
.supported_extts_flags. Since PTP_EXTTS_REQUEST2 always implies
PTP_STRICT_FLAGS, the core now rejects every PTP_EXTTS_REQUEST2 for
this driver with -EOPNOTSUPP, where before that commit the same
requests succeeded. Only the PTP_EXTTS_REQUEST ioctl still works.

Tests on an NXP i.MX 8M Plus (FRDM-IMX8MPLUS, GMAC 5.10a) show that the
auxiliary snapshot inputs timestamp just the rising edge. The reference
manuals for the STM32MP13 (GMAC 4.20a) and the Cyclone V HPS (GMAC
3.70a, which uses dwmac1000_ptp_clock_ops) say the same.

Encode this in .supported_extts_flags. A PTP_EXTTS_REQUEST2 for the
rising edge then succeeds, and one for the falling edge or for both
edges fails with -EOPNOTSUPP.

Fixes: 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to ptp_clock_info")
Cc: stable@vger.kernel.org
Signed-off-by: James Clark <jjc@jclark.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20261104052504.1886335-1-jjc@jclark.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -277,6 +277,7 @@ const struct ptp_clock_info stmmac_ptp_c
 	.n_per_out = 0, /* will be overwritten in stmmac_ptp_register */
 	.n_pins = 0,
 	.pps = 0,
+	.supported_extts_flags = PTP_RISING_EDGE | PTP_STRICT_FLAGS,
 	.adjfine = stmmac_adjust_freq,
 	.adjtime = stmmac_adjust_time,
 	.gettimex64 = stmmac_get_timex,
@@ -294,6 +295,7 @@ const struct ptp_clock_info dwmac1000_pt
 	.n_per_out = 0,
 	.n_pins = 0,
 	.pps = 0,
+	.supported_extts_flags = PTP_RISING_EDGE | PTP_STRICT_FLAGS,
 	.adjfine = stmmac_adjust_freq,
 	.adjtime = stmmac_adjust_time,
 	.gettimex64 = stmmac_get_timex,


