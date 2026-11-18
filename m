Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033381;
	b=U5rZQHzeknjWNJoGz8HC25ukAsOFZ7l+VomKAM/BTeSyE0CQrvN3OWm/aXxiapqgW5ru
	 SdLXI8cYuaHCeUKGrA1aUuqm4kHfdmoHkD4Jhw6eezMfGUEJQk2niXIbkDcojG+LzJ8tj
	 XZPQnNJhCyL0co1BKM5s+hxfnxmxqx66s54JIpW5tH+7id4Zb/Bw9P4CMkZhht1Jw4ZzW
	 6wD7LQuTAqvvKu00uXh3CPVAbpUOYGhv79nlIHeyP7aTCSW98yx0CIz0F/2TUSltbrptn
	 5AGBPpKkQ0Ad5JtfmGneJHn1htG0hupDbqyBRIuCCkMl/vFasMEEldmmG6wAi8Iiuvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kSa7+8kVVV8tqxSnsnt/p+zvzAbJkPLrFl8tetVoxB4=;
	b=EN8sRsmUUu3wWevW/8+ycxzTp5L7KmHTFqMuZ8JoyqTBvQY+9zNz84RCvwfeCsfFHIsE
	 Rk+h0pCLu7bH2GZAr1rhhdF+1hLsvTWECHY+e+iCtQl4AOeCpA37FKlCr7TBAuHm8EsHZ
	 feiMlipqy6ORCwBRJ0/+z1fZKaEDgKAbcxKO9nprKIpaB1Cvos1LJVaR55Ujuccw2dCvq
	 6Whe8l9AYhSX6toPchkExIsAjVu//yk3bgJXb3/cNaOGPq3gDtA/QRS06Yq8hY2L7Obyn
	 FNfPMBn+nq8pWaNtpmcjG0PuVICmeAGzfRqNoWCxKfNGssnlqxSPmCBLlR6NxYau0/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e/WrYoFR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF6D60A261A;
	Wed, 18 Nov 2026 20:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e/WrYoFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FE61F000CA;
	Wed, 18 Nov 2026 20:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033381;
	bh=kSa7+8kVVV8tqxSnsnt/p+zvzAbJkPLrFl8tetVoxB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/WrYoFRzpPxgYD9Uxz38Y7vqTSXGHRAQehWsdEnmgK/94M3x5xLh+mch8f+npGoT
	 0OUe0zkEZ9hr861DI9j9NWJivWo8MCf/IQGrSIrDgS2L7adLxK8UK4KY8LeCwAD/7v
	 f/38IzbC+PQ6L1PVNrq1vwVCBMFVA4RD0gB7JPXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.12 1749/1756] remoteproc: imx_dsp_rproc: Only reset carveout memory at RPROC_OFFLINE state
Date: Wed, 18 Nov 2026 16:04:36 +0100
Message-ID: <20261118150119.162195133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
@@ -935,9 +935,11 @@ static int imx_dsp_rproc_load(struct rpr
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


