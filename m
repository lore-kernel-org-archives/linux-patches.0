Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029743;
	b=aU8yKIO7kIj9hWUOIsQzomO7PRS0WGz9IAV81jHgtUWCwwPJCfRGfJCVJCd3wUuWTrHJ
	 miUCa6ji9p+1OZIx2XK919ZFS2xoRsGI7cASxuI2nbQ2wUufNuGGZkAqnL/7CjjoSKk/Z
	 utnhDkgcjS1SYz0Y0Q5Gp8Nw6bbNjz2wz5XX9syByzjULEHMCyNwzGrKrCeYilN5/iXMl
	 1o95izNSE7NJ7OgEWzoR9k1Zqv32+dmQGzq9QbgeurOkF1DpdD2PiUGXVlLjapZ1uW50W
	 ZTy1sK1Xjhi+cuIBnTgV9T+LpPqfLj3/5YvL+ltwjNnuiby41xX+VGfrXY9Tpvs32Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ynkkFlZk6SJsAHsHGKRIff4heZ3ydOAMDHOoRyEFJLA=;
	b=ljTC9Xc4hY5ftyd3iPQ1KUm4kkBGOK4whRS1EFsRQgJ5tB+2qHS/JXF7ajw2DIp12bZE
	 h9toQ0iQ7QZHxtQncVWIkmy95Zcdb1rgxnYu3pPKKNmrOVACn1kqbDNUvkcMXDCKLQGcD
	 tImO4TMPI8kc/Qq+LDMyKxHBvYDZta3ieyeAlyHr69wRKv4VDsmlrG+e9XyU9XNNMGdvf
	 9+kvilMa8loh1xnvizzxjM8A1aOSg0oXBsputHK/D8HNIkvLmFO0e6FuefdRyHDaUUmIc
	 YIqN7zDXz4lbt9099xlHksEqqaPo0AZslVi2bvqtbnfhudl+JVnfGWF5fEFpZGqUXbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xgtHdlRe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3255606A335;
	Wed, 18 Nov 2026 19:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xgtHdlRe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D791F000CB;
	Wed, 18 Nov 2026 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029742;
	bh=ynkkFlZk6SJsAHsHGKRIff4heZ3ydOAMDHOoRyEFJLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgtHdlRebTXwbIYpdn/8RrKNsfvXEu66rFBu2tnasFyeyF7dhwwYvzXe1fW6x+KGL
	 FHHwtkj4HEO2qut5sYLX82HN5nHgKvUWQft+VPV03x/9aM8hKfQaGYhCkvaAdDTIfH
	 cnCeF/2b3ixJuHXl12iFySyuc9mr8RPYjXmYo//o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0457/1756] cxl/port: Fix uninitialized coordinates reported for RCDs
Date: Wed, 18 Nov 2026 15:43:04 +0100
Message-ID: <20261118150026.966717523@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 58b2b1ef28024093063de536c05aaea792226e24 ]

cxl_endpoint_get_perf_coordinates() returns success for a Restricted CXL
Device without calculating coordinates, so the caller's output array is
left uninitialized. Callers treat it as valid and can expose the stack
residue as access coordinates.

Initialize the coordinates to zero before returning for an RCD. Zeroing in
the helper rather than at the caller keeps the @coord output contract the
exported function documents.

Reported by the Sashiko review bot.

Fixes: 5d211c709059 ("cxl: Fix cxl_endpoint_get_perf_coordinate() support for RCH")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260831092216.540644-3-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 5b586c60c77fe..e78f8ebe50e81 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2198,8 +2198,10 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 	 * Skip calculation for RCD. Expectation is HMAT already covers RCD case
 	 * since RCH does not support hotplug.
 	 */
-	if (cxlmd->cxlds->rcd)
+	if (cxlmd->cxlds->rcd) {
+		memset(coord, 0, sizeof(*coord) * ACCESS_COORDINATE_MAX);
 		return 0;
+	}
 
 	/*
 	 * Exit the loop when the parent port of the current iter port is cxl
-- 
2.53.0



