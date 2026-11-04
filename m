Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831473;
	b=Rv63GwSM+yVW1A+VXsldwLq/4uz39F50rfOtekWAn8g2ZvY58kVJX6F+yBC/LpNU7Qhh
	 o0Z6K9yqcgGwWOKOqkafxeaZvuEGPTCojKrdAL0sl3P5pwUX1elnG3GtHWM77AJjMulcz
	 qZvXrmEfxowi7oeaR5YxyKEqAzOrCCtJnOalrxOVuzaWJuKtxGJoaheb4p+AM+bAhm1xz
	 dYx6mt4ejngFQwKOENe0AEFKaYjDABI5XP3resNTYuiMvwOSsouwGmaJ1HJbgQKQLU2ff
	 PKc6sLcD7HehaITKgq7ps5PZqNvKsa1uZeHkvGnInEHX7D/4Y/lAYh8M9dajz1NBhnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5/MJbmCeg7aem5QeBOo6FkEb0yJHWZl1tCkt6mVO66g=;
	b=DyMKLfwh1vkcqMdsZF7qnIO/EjuXU1VnKgk2FeTQbmOrfJuxjJxVq16A8NaOJXn0vZxf
	 easYeUBHdAXdR+0j5RHeDeAIstZhNkZSqnCUN7SbJc1asfn6ypznBdRzer1vr6adFd/MO
	 53WViPAMwNcc4Gq4gaTsrDeHfnF8wIThFrlQHu9/QR03cKpDatqsiCei7tjJHuyifxAmb
	 tT1jvzHrOp0Vc5oE2lzqh3UGQQlkoVPxUAT2f4DMqRsMPrfpvbAPB6oiE2y3xEJ3EO1JI
	 Z7uO/h/NXEm932L01oGlcwQemiAko6NlxeUvapHKtNzYQzpK8dFWVcGbDKBZm8c+6MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ga4Ep5N9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61DC606A335;
	Wed,  4 Nov 2026 22:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ga4Ep5N9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739301F000C1;
	Wed,  4 Nov 2026 22:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831472;
	bh=5/MJbmCeg7aem5QeBOo6FkEb0yJHWZl1tCkt6mVO66g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ga4Ep5N9M3asVEin+wSjW4w6hfHsfdNy1mN1nMWG8nCtNCfH2zvifY3MgV27rOtV8
	 +i3wbbkipbP69o9cr+PKrigx6fMnK+aI42LOjDWh3sRo2utr0r2vXKyyx8dZmd8coa
	 fseUPlec2dLujYf6XXM1iuaeHC0mTGn9g4NsiJRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0725/1005] media: microchip-csi2dc: fix async notifier leak on probe error path
Date: Wed,  4 Nov 2026 16:07:38 -0500
Message-ID: <20261104211103.813756555@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit c7528789244ce7329ca883170fb9315d739ae985 upstream.

csi2dc_of_parse() ends up calling csi2dc_prepare_notifier(), which
registers the V4L2 async notifier with v4l2_async_nf_register(). The
probe error label csi2dc_probe_cleanup_notifier is reached after
csi2dc_of_parse() has already succeeded (e.g. when media entity init,
csi2dc_power() or v4l2_async_register_subdev() fail), but it calls only
v4l2_async_nf_cleanup() and never v4l2_async_nf_unregister().

The notifier therefore stays chained in the global notifier_list while
the enclosing struct csi2dc_device is freed, leading to list corruption
and a use-after-free when the list is next walked.

Unregister the notifier before cleaning it up on the error path,
matching the teardown already done in csi2dc_remove().

Fixes: 2de0b3c0f678 ("media: atmel: introduce microchip csi2dc driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/microchip/microchip-csi2dc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/microchip/microchip-csi2dc.c
+++ b/drivers/media/platform/microchip/microchip-csi2dc.c
@@ -736,6 +736,7 @@ static int csi2dc_probe(struct platform_
 	return 0;
 
 csi2dc_probe_cleanup_notifier:
+	v4l2_async_nf_unregister(&csi2dc->notifier);
 	v4l2_async_nf_cleanup(&csi2dc->notifier);
 csi2dc_probe_cleanup_entity:
 	media_entity_cleanup(&csi2dc->csi2dc_sd.entity);


