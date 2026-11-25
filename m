Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623782;
	b=gyirnJpsQ3leZCNrpm8BMxr+ZJ0EDSkf/5XdO62HShRf7D31fSgC4M3BYXZwxz+i6lqu
	 MgbrzbDWB3L84MiLFcOnzwShtr5Eh4Pt4lB+5hes/R8IsW46/Z6mXoEvnaDu6r8kGnezL
	 WQ6kf3vDmpv+sMEcm1kXttPCGTurIz9TLM4qPCgCyV46ee0TZGCdwujNcFeNr8SAbRfVP
	 Eh/Vh+ICwB+HjbqzhDY2Ulh24sSIY3OOAiGmSNsjQGPxyg1cB5/pKovLpR3033s8vrSA+
	 14+RXNKGf/1JEvYr39pcC/Mo46/ulHOWccFjhTKv6MtK1/dW42CpKXT6e/R5Wc6Mybw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N4u1QG72aRtxdePCp70i25dEemOAvQ2KExsAIaXpMJ0=;
	b=aDyZlRq9jwK+7KfGNi+JoAoa+nWSFHrovkE+R7/7IZYNczrZDeZIIC/vmbx6J0Kbe4v7
	 ViS07Zoph2pcEUwMejVssYx8nI+X11OF5OkdtXEFP5jaOtJ6BNoE2B7e3+2fKpTYI1B2p
	 k2CjdJnxOygNudysbTAc+RJFMilellT7INAKSmKx4BKJ+jzpk2yIcbsbStJ3XnDkdIqn8
	 +tiszWElAvXYnJU/XIG8NyY59lb9oRKy+pmJvk5F7vx0DHaLr3wc+HlZ5hmQMP4pLsDpb
	 j442V3WOY1Jemld5yQo2Sz5wIMsNqC5sjLzJrtw1F2Ih8XUXGZhuPlxWRPJ7w5B1Erg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=esdDsVvb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D70606A321;
	Wed, 25 Nov 2026 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=esdDsVvb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0657C1F000C4;
	Wed, 25 Nov 2026 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623781;
	bh=N4u1QG72aRtxdePCp70i25dEemOAvQ2KExsAIaXpMJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=esdDsVvbsyMtrK5Z+r6dXdmaFuJ3gnaFwfE/EOloDqQk696upzntnTdY2X4Z8euaa
	 l7mmb61up3YWAiEGlJDYILdlABarDegxKi47zxlZSJG2UYmaCOIlRknFcHDraZAYyA
	 AIArjOdEoR6KlR/3b1FjLHX4EsTW6MfFnIExNKrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 967/990] iio: trigger: Return an error when the trigger has no free irq
Date: Wed, 25 Nov 2026 15:38:54 +0100
Message-ID: <20261125143844.634382827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit dff701806ab6252f6a0fccba880c47cd09602625 upstream.

iio_trigger_attach_poll_func() prints an error when all
CONFIG_IIO_CONSUMERS_PER_TRIGGER irqs of the trigger are in use, but
returns 0. The buffer of the extra consumer is enabled without a poll
function.

Disabling that buffer calls clear_bit() with a negative bit number and
drops a module reference for the second time. On arm and arm64 the
clear_bit() goes about 512 MB past the pool bitmap. That is an oops if
the address is not mapped, and a bit cleared in unrelated memory if it
is.

Return the error from iio_trigger_get_irq().

Fixes: 995438233579 ("iio: Fix error handling in iio_trigger_attach_poll_func")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -292,6 +292,7 @@ int iio_trigger_attach_poll_func(struct
 	if (pf->irq < 0) {
 		pr_err("Could not find an available irq for trigger %s, CONFIG_IIO_CONSUMERS_PER_TRIGGER=%d limit might be exceeded\n",
 			trig->name, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
+		ret = pf->irq;
 		goto out_put_module;
 	}
 


