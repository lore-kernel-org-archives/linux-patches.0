Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE0A1D0173;
	Wed,  2 Oct 2024 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876360; cv=none; b=Bh/g3noTUvTMVUAZpcLIi3/muyJt4brza36/IuYyWCsozWugfMoHAPModVprCowyibEw3306g4OfXgx/1HmgJtqIfPP5bXgfHz27MMT4T0ZnhSSxCSOUDm+tXVob7uO98lcP7z5XxBuHii1RfEUeGNhsI/2IuPnyo3X2CoLBIgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876360; c=relaxed/simple;
	bh=SZ+OA+YqL3UcSNS0Q5mYT4RMkT03vqCqxRINPOXW0yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKDubJeqd47BvMaEzsQL0/ZauVaj7+p9dvjjuy2oaNi4YbGHV3QmNDOp0GD2TPr1N4Nr+mCLMKN6B1uMXg9VScxqAcjUvLFEvHM/A+X/KRDXmwz9nVCGOk9RYzJ0a2B8ZcZ+WJ3eptKGrtO+Ewu8pGmSiuuX8u9XlKd4rJ6K5uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeoresIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeoresIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F638C4CEC5;
	Wed,  2 Oct 2024 13:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876360;
	bh=SZ+OA+YqL3UcSNS0Q5mYT4RMkT03vqCqxRINPOXW0yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeoresIQNm7LXfV0WCyYCISLKk2BWayttszpwZH3PvTHHTyOP1GDW3n/waqMWO+xw
	 SFmWyTnXDhXaLrKbHYhCHS435k7GidlLoLNIpWoWXaqmHX2rrI8qo3G+GVipWS612g
	 G6TBUBpfb4CtviRORJpJLDWk/xpuWvpzDj6LY9pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 390/695] media: imagination: VIDEO_E5010_JPEG_ENC should depend on ARCH_K3
Date: Wed,  2 Oct 2024 14:56:28 +0200
Message-ID: <20241002125838.022471321@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit afe6ec667e8846c8470d32789cebbc435588972d ]

Currently, the Imagination E5010 JPEG Encoder is only present on Texas
Instruments K3 SoCs.  Hence add a dependency on ARCH_K3, to prevent
asking the user about this driver when configuring a kernel without TI
K3 SoC support.  The dependency can be relaxed if/when the encoder
appears on other SoC families.

Fixes: a1e294045885 ("media: imagination: Add E5010 JPEG Encoder driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imagination/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/imagination/Kconfig b/drivers/media/platform/imagination/Kconfig
index 7139ae22219b4..a302c955483dc 100644
--- a/drivers/media/platform/imagination/Kconfig
+++ b/drivers/media/platform/imagination/Kconfig
@@ -2,6 +2,7 @@
 config VIDEO_E5010_JPEG_ENC
 	tristate "Imagination E5010 JPEG Encoder Driver"
 	depends on VIDEO_DEV
+	depends on ARCH_K3 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
-- 
2.43.0



