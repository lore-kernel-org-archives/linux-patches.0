Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042816;
	b=KHKLk+7D2+oTuDCosLMseTOgd4yuHSlsP9Fqr6iROgnS0pfzZXs8WE/Coy6Ft27J9Oy1
	 /6K/o8Ocv55NAC4qjj4cpgFO320s4cTtgxlspBQquk7aYNx3cHPNzceFPoQ+sD4S16Rmd
	 XKC+l7Khg4IlAe28G/3lhw0MfSA/roahfSyPACXrMi2dWzuqgwJNvKx7KbB/H/tnJYfy2
	 sGM1kNYaTKTaLqTIQu3aR1GjU7Ilnn179vGlIBfNbehCsM1hZmOFjKYCNCVOnd01IwY1z
	 obMEP/AiuQB5b/5RBh1rjt5bER/yIJQduwZEzEG6s79KqJMuDBMfDdZ2hxtBL1mhlnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tGZOcbwUCBPvQfYIu7Z2x+X7KDLsbKPXbBmktWmLme4=;
	b=vXlimFd+h90pgdcuU7wWEk+SgHXbgDOKpJL9LqggGy93bLI/adEd/pttNUIaWYv92xZq
	 vJjRiSnx+cO6GcWHauJ0SkyFNU0z8QlxA0awzDnoO6kBtv4nBhVz4mHU1g7NaBQUNdlva
	 dGxMa0lYdzEboInn8NpsDxim1p8WnIA84/0Jl/7p40LdWiNVhHZpUlchzdrQvOyASrfsc
	 fqeOzUvQOQNJndvYNOlVzX7KFzGdCAnio+zr0gpGxhruzcHq2qhuamiI8hc8UiSQbznMH
	 GIMy4h+R4Ux2KoAFUhgb6pWej9OM79csbJ5vjc5F53qNmRs97gnvUZqgteSESwhApcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPxuVZeC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79DC606A337;
	Wed, 18 Nov 2026 23:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPxuVZeC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C5A1F000C4;
	Wed, 18 Nov 2026 23:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042816;
	bh=tGZOcbwUCBPvQfYIu7Z2x+X7KDLsbKPXbBmktWmLme4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPxuVZeCmBhrZZUaO/QK5RkKXgSYBMhkHpyhWXIwrzO5ZdmcW3lFkcuBgm7T8j8wP
	 jY//MiJQrmwim4yB8hNbwSWNMZNWbep5/x/0pShchKa7Voik9faP1YwG6ASTBO8jZF
	 xiqOpNUsC2K/kT3G+bHi/IG1wXQTVQ9nXwRF+TJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.6 3305/3318] remoteproc: imx_dsp_rproc: Only reset carveout memory at RPROC_OFFLINE state
Date: Wed, 18 Nov 2026 16:05:27 +0100
Message-ID: <20261118150458.740925939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit b490ddf27be28e64a39c08ae643d7b22561beaf6 upstream.

Do not reset memory at suspend and resume stage, because some
memory is used to save the software state for resume, if it is cleared,
the resume operation can fail.

Fixes: c4c432dfb00f ("remoteproc: imx_dsp_rproc: Add support of recovery and coredump process")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/20251218071750.2692132-1-shengjiu.wang@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_dsp_rproc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -939,9 +939,11 @@ static int imx_dsp_rproc_load(struct rpr
 	 * Clear buffers after pm rumtime for internal ocram is not
 	 * accessible if power and clock are not enabled.
 	 */
-	list_for_each_entry(carveout, &rproc->carveouts, node) {
-		if (carveout->va)
-			memset(carveout->va, 0, carveout->len);
+	if (rproc->state == RPROC_OFFLINE) {
+		list_for_each_entry(carveout, &rproc->carveouts, node) {
+			if (carveout->va)
+				memset(carveout->va, 0, carveout->len);
+		}
 	}
 
 	ret = imx_dsp_rproc_elf_load_segments(rproc, fw);


