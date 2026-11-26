Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705509;
	b=TRtjmSAqhE374YgfdmLKZk4kzAhMb/VJpsGm7VCen7HYkrwPsfU9ZzPdiq2C200cY55K
	 76dyHk+gQEBXNR6epMRBANnOrYx2BDaY98E9mtfXDRseom+WCR01YKA2S/aUnVIVGiOzd
	 g8UKs5jUlIz64LVKWcDzIVNLXdr03bn1evq4wVFtKlkePD9h+qePRYlYiGlc35avm0cAB
	 obZOVLx1IYBTn45QGk2wewNfn5lnD3kY0X4fVbsSu/wQnib+J4LgZPKibz/O2lawuyDKC
	 MszHO2tIY/pnRZ8pyqnqP3EbzpklBAqQCMCJy4SkmFNhRzmW6kwmdU9IPzTMjyp2LmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NPGgn4gWqPxUbqy+1b/WMagfzheldGJFVEfJi4AdqqY=;
	b=BB2TvFOVS18YCvZTE30uLLoaPwhq9OJSbFrOdbvaoQhihfaTxF/0JOEf8DX49oWqqOUL
	 QgCWlWytwHPC91Rk1oC5L9zJuomM0sRejyEz+u/EsqCOSbrTnX5m5/PyinI2VvzBCP5U+
	 FVVCRUAiiTCG2h317jSlFUel8plDZx41N+WKnPf6dhasl0Ks+FtBHG7l8lqtNmH+84lmO
	 S1vXarKpFmmD+UrbzlFrrKbaS4hmN1K+O5cuO2RZ2pMF3ZDE3Lf1r9l7j7ovMgX61W5+E
	 g/rg2jqd4GuWlM3+J63Fx/rQFUaP/VCaya/jSHmOx7j+Vum8Cme8YPt1iFDkFUqoUDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUfboSFt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C4A606A6B6;
	Thu, 26 Nov 2026 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EUfboSFt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7067F1F000D1;
	Thu, 26 Nov 2026 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705508;
	bh=NPGgn4gWqPxUbqy+1b/WMagfzheldGJFVEfJi4AdqqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUfboSFt64p/Sycr7IOuazHjk1O4n2D3iHIPnvwT5sYD/BG1GotygP4f3/mnASDP0
	 9dWluExs7CkwAf7oVqOpuq5orxImWdWrvY+4EY9vvyIAxT3verG2U5z65TEBFryC7d
	 DSeLWjQqBYegFG9iJs6kxEoomlRzcHOIHPcEyTsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 177/319] mmc: meson-gx: name the limit of the CMD_CFG timeout field
Date: Thu, 26 Nov 2026 15:39:05 +0100
Message-ID: <20261126144010.741647777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

commit e1644210d15f7f8adbe6315199b4b73bead63a2c upstream.

The data timeout is capped at a literal 32768 ms with a comment next to
it. Give the limit a name beside the other timeout constants.

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -123,6 +123,7 @@
 #define SD_EMMC_CFG_RESP_TIMEOUT 256 /* in clock cycles */
 #define SD_EMMC_CMD_TIMEOUT 1024 /* in ms */
 #define SD_EMMC_CMD_TIMEOUT_DATA 4096 /* in ms */
+#define SD_EMMC_CMD_TIMEOUT_MAX 32768 /* in ms, 2^15: limit of CMD_CFG_TIMEOUT_MASK */
 #define SD_EMMC_CFG_CMD_GAP 16 /* in clock cycles */
 #define SD_EMMC_DESC_BUF_LEN PAGE_SIZE
 
@@ -209,7 +210,7 @@ static unsigned int meson_mmc_get_timeou
 
 	timeout = roundup_pow_of_two(timeout);
 
-	return min(timeout, 32768U); /* max. 2^15 ms */
+	return min_t(unsigned int, timeout, SD_EMMC_CMD_TIMEOUT_MAX);
 }
 
 /* For R1b the controller waits for busy to be released within this timeout. */


