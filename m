Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615853BD659;
	Sat, 12 Sep 2026 10:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210454; cv=none; b=pTYLhouUd35gGSiJW3VgARdfX1JCgMNA4TIoOeMYOm/8Rz2wxkt2MeihsvjVsPA9BFrsGO2qfKz4nbraGlEcWGTHgENfJ1FUwmf+gwsede1z7GE2KbaMRekDldpiJ1lV/8yOy9R9VI7WNLzkTIBMp94QCTIK5fkmoTB8K9Gr8+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210454; c=relaxed/simple;
	bh=/mdDidgkhIDMERQPSmjkelUGVIFQ1T8uepgM2n6KoHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJglHYKGsXxpOUbYoraCMXZV+uUw7F626pfeAo/5hFYgJEuQell+jbrN9t1IG7Mqa4arCtmXpCh6OF5PycRJpFsMY0CQbaZU1pLu5h8asOJNvEVSsBfinPXd9+W6uJfwZFf9UV9jQP7HOW6ab7bM+1eQ2YCupdIwdX2FCJ9jmKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZKW19+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZKW19+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEA51F000FF;
	Sat, 12 Sep 2026 10:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210453;
	bh=7zKd3RZC7+E+r7B/vQAqCPbx+An20EvWU5bLxQeLr7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZKW19+NrBUH6ORZvLgjRHFfxRwYalYJ4wgtX1sFjGD+d9ddP70YA5LFBoTbWpjz/
	 5Zh0IV7EsTOavawmIXjuKtcb3BlGHF/f2/uyU+yYXEUpJWFg32HgpMa+PZ7Z9AKXgt
	 +ImlwLVqdGSfDC5cW5gxDnUeBIHNMAJ4O9ThN0A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1029/1518] mmc: sdio: add MediaTek MT7902 SDIO device ID
Date: Sat, 12 Sep 2026 08:53:18 +0200
Message-ID: <20260912065646.728050949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit cde32a92d4562b686f730fc08d4d558ecc99d516 ]

Add SDIO device ID (0x790a) for MediaTek MT7902 to sdio_ids.h.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: b0c0b3794011 ("Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmc/sdio_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 673cbdf434533..dce89c1106910 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -111,6 +111,7 @@
 #define SDIO_VENDOR_ID_MEDIATEK			0x037a
 #define SDIO_DEVICE_ID_MEDIATEK_MT7663		0x7663
 #define SDIO_DEVICE_ID_MEDIATEK_MT7668		0x7668
+#define SDIO_DEVICE_ID_MEDIATEK_MT7902		0x790a
 #define SDIO_DEVICE_ID_MEDIATEK_MT7961		0x7961
 
 #define SDIO_VENDOR_ID_MICROCHIP_WILC		0x0296
-- 
2.53.0



