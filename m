Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050879;
	b=qstRUJhr3L4KMcqT5NtcQ9A2X5mq3TkbMF1EL8ZocpjEHukKxTXhh7VWemp7YiElu2mR
	 iIMJrQrQOZ+t4xnWSJeFA9iSRdwj3NQRFFRlnGGyJlj6C//HNNG+YQlGswkIZdpLTdW93
	 7QOu6wI0jeon+G/6NPrKWuA9ZppQFp0IzSiq7E1VLI2F+83u/rWX6O7SSF6g5LeftryBm
	 LPQjzevvhlu4hSMwi9DOh/0xb0ABcOhfy1h6dTMMV/1LkoX8tHu/14oK4HOpcJx4yFGZT
	 HNsA7mayvrLAlHYNuzkRv+DCv4eEs2a0QA1rdvCONZveO8r06bYLGvrA8o72f1/PFJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zCF8Woild3maizSLr0wF6KHTesWGQNJQ/TmpWEUwA/0=;
	b=yihaX6/yK5TK3myNQU27eJ2UrngT2JUD2qy/lsmfbwqPAV/9LB2Ao9xy9uuIkiDeuqX7
	 +lH5LQZeUpJjPTClJs5zk6awCGcSQVYblhcVi9RPJlq4miRQCHiZz1HGiWBaQgL4X83cr
	 0yU/JxGgtcElylJSe2CxiKGL66SkYqxpQNQAEliOBGWZtYJFQMNHysn7kyZFNB2jVEZ3X
	 xB4XUJ+dnmjFds0YSzq8ac/gtLYf4PR1/WrWFFroTVhJvCFT/ftszP7vIHTL6/OORKHky
	 7/21NiSaJUblBaHlzFOjSq/VXDFv8Yd8bzICsJM7HzNbMgINLt3iEWIa1AQ8byiUKQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dQBFpp7s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D90606A320;
	Thu, 19 Nov 2026 01:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dQBFpp7s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F521F000C4;
	Thu, 19 Nov 2026 01:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050879;
	bh=zCF8Woild3maizSLr0wF6KHTesWGQNJQ/TmpWEUwA/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQBFpp7sExlNREEcAJuL217k/xPiePhR2UEFLXwFkWhREf7SvE//BaT+XXovqAoAl
	 z3o5OMGiWxhW0hgBGNegiEdTTRgjrAeIvGH00/Xk/0LEyto9HacX7IIA1OUUX5QEJA
	 SGdcVKza+489mzNFrHG2Hcno1eAB7QYmouyvt7Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.1 2840/2857] remoteproc: imx_dsp_rproc: Only reset carveout memory at RPROC_OFFLINE state
Date: Wed, 18 Nov 2026 16:04:34 +0100
Message-ID: <20261118150343.825051421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -921,9 +921,11 @@ static int imx_dsp_rproc_load(struct rpr
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


