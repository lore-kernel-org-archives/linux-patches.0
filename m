Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED90712DDA1;
	Tue, 11 Nov 2025 00:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822103; cv=none; b=NI2WoMj9w9b0XZzQHmDIvGRRsTM0s9qmh3qeWyvVv7srNIvAj3pz5pa5n9siRVZLBKorPSAvJcP9FuqSe/5KbxL66grMKYf4eEieQqGvpWsxNDr2+fexp8sk4zLLRZzEoQ1xl+Yn0AwHe+Hmps17AOAF7u4PdEB3ndWUPukH0VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822103; c=relaxed/simple;
	bh=b/xctJCwAkBMchwqbtKpCtIf+Nc2hz9bvdgcS7QaDPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POtRWxPuKOXkn6whDaGPw0Jz6LFtDVW1O2fqsDf0NnCErhNjfi05rFr2kpHD4cQ1OiuvrFjkTA0tRZYuAh0zKkH5CHFdJQ4p7NBfoqg3JZug7x8tgIdKzcpaxEVMh7YZN5L3lKXTZ0xI3ZYVUrER/+212iCyeRSJ+RpDbvFszqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Klq3MiQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Klq3MiQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1F4C4CEFB;
	Tue, 11 Nov 2025 00:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822102;
	bh=b/xctJCwAkBMchwqbtKpCtIf+Nc2hz9bvdgcS7QaDPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Klq3MiQnkbwvZxfznu7Y+ayyH1yWH68fGaJLeExvQ8hNpAHw4hdQUFecY3ZY/NdaO
	 n0Ld46z4KilLzQP8ancGsLRNY+SvpSfBN5QMMvmVIKI76y9oDBwhz5zmpJE6dct0up
	 Uu7RlvAUwBUhSKh6jQTg37AtbPE1rz7pB6SiPgzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.17 018/849] fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS
Date: Tue, 11 Nov 2025 09:33:08 +0900
Message-ID: <20251111004536.897729524@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

commit 5f566c0ac51cd2474e47da68dbe719d3acf7d999 upstream.

Commit e24cca19babe ("sh: Kill off MAX_DMA_ADDRESS leftovers.") removed
the define ONCHIP_NR_DMA_CHANNELS. So that the leftover reference needs
to be replaced by CONFIG_NR_ONCHIP_DMA_CHANNELS to compile successfully
with CONFIG_PVR2_DMA enabled.

Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/pvr2fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -192,7 +192,7 @@ static unsigned long pvr2fb_map;
 
 #ifdef CONFIG_PVR2_DMA
 static unsigned int shdma = PVR2_CASCADE_CHAN;
-static unsigned int pvr2dma = ONCHIP_NR_DMA_CHANNELS;
+static unsigned int pvr2dma = CONFIG_NR_ONCHIP_DMA_CHANNELS;
 #endif
 
 static struct fb_videomode pvr2_modedb[] = {


