Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3E67D413;
	Wed, 21 Feb 2024 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524873; cv=none; b=dIkHcOvxXECt3+BYcmhA8FgiTV2anNfGHzMGHg2k8bBv2wbRCXmrsKD8dADx/qB8nTen2f1KNW93cSKkNQH4UNxLkSYpBYnQJb3+bVjyt6mdpiX03wqyQ9fnkD1v45pO9oecKyr0EkrxILAQRRYHvsyyAdJvSV20rsNui9eLXW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524873; c=relaxed/simple;
	bh=OyPYW328tcEqUyTMButanUf/dbyy4Wa1OZjgP/4qfJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYcASWMWGoO4DHh2nmDLoA4ZiVCTSSlRpjlRRXJYlSlgV5lLnPdQNqu/2lyj+fRvoY7LzRA/BoSCJUjGS8qChy0MzDMY8SOKxJMYXrDTIIdXFwsviAzJvJduuxMB2xrPshoEuifkGijlU4fZ1LUDvxwkQ6qk3BYOcKkMDfaBtBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc0pWEpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc0pWEpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFE5C433C7;
	Wed, 21 Feb 2024 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524873;
	bh=OyPYW328tcEqUyTMButanUf/dbyy4Wa1OZjgP/4qfJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc0pWEpRjjGf2ke3B+iuC5UnmLRJtrgGYnedDrPoK96SgTym+y8lHuCEFcSB1A76b
	 Bgusn4SGsn8yj819BfgbRQYTaHV7x0ZmwXs3+WM9nPU80ljGTkpoG6UIs8QVkvGVmI
	 fhjB3ZT/bug58Ol0SGFF5g5rheqZOKKdmP7dkpiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Saravana Kannan <saravanak@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 5.10 345/379] of: property: fix typo in io-channels
Date: Wed, 21 Feb 2024 14:08:44 +0100
Message-ID: <20240221130005.194681583@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit 8f7e917907385e112a845d668ae2832f41e64bf5 upstream.

The property is io-channels and not io-channel. This was effectively
preventing the devlink creation.

Fixes: 8e12257dead7 ("of: property: Add device link support for iommus, mboxes and io-channels")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240123-iio-backend-v7-1-1bff236b8693@analog.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/property.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1306,7 +1306,7 @@ DEFINE_SIMPLE_PROP(clocks, "clocks", "#c
 DEFINE_SIMPLE_PROP(interconnects, "interconnects", "#interconnect-cells")
 DEFINE_SIMPLE_PROP(iommus, "iommus", "#iommu-cells")
 DEFINE_SIMPLE_PROP(mboxes, "mboxes", "#mbox-cells")
-DEFINE_SIMPLE_PROP(io_channels, "io-channel", "#io-channel-cells")
+DEFINE_SIMPLE_PROP(io_channels, "io-channels", "#io-channel-cells")
 DEFINE_SIMPLE_PROP(interrupt_parent, "interrupt-parent", NULL)
 DEFINE_SIMPLE_PROP(dmas, "dmas", "#dma-cells")
 DEFINE_SIMPLE_PROP(power_domains, "power-domains", "#power-domain-cells")


