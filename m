Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3718955E5E;
	Wed, 21 Feb 2024 13:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523482; cv=none; b=fuxkckxeeZ3WE5dQ1wOmHRApSQ41txj5tYwFkgoN1p8U+JZCFstNPPJhb4Smq2Obd4pNwHnjm3yJrD4j8XlPwmJIA5ZglweySuSx+PxPiKFDFSia1hu8cP9gojAzs6tP1qMnroHZ6Kb1XrJ6y27Jd4HrvQHoSmpn+iOhquZk/SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523482; c=relaxed/simple;
	bh=alihBCFHwDb8S6TNCbtX9Y1wJIzdRfJB5qiVkSOykpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgYFFMHoexDncAJHmNkVlBkcm0IE0NxckSXySo511I+omHC0cF3Dw02IIkKA5kGbd3YSE1A1r/oLproyUKbbgmco0k38MvPar+0YSU1qFQ/wghvgJZ3uuGMDuGMaAk6wOHt/rBzgjxMwP4Umf6W2KJpVa4nD2n//s+h3oc9qnC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8TQ99Wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8TQ99Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5CDC433C7;
	Wed, 21 Feb 2024 13:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523482;
	bh=alihBCFHwDb8S6TNCbtX9Y1wJIzdRfJB5qiVkSOykpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8TQ99Wv/UahedH7hNpMeFSB8YxXyCxqKQxuMV+7d9aldSFoD8wxKqNaTxt2oEu5J
	 Ma0GEV0mK6FDO+KhqjaB0yVom8+MgFRpwwF+e5VZB16joWli7gI6qWw/BN3ECuGC2r
	 53SvYN4fwjMp1IOyqTQvnri5z8bKpC6Y6oWmldbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Saravana Kannan <saravanak@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 420/476] of: property: fix typo in io-channels
Date: Wed, 21 Feb 2024 14:07:51 +0100
Message-ID: <20240221130023.559347042@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1270,7 +1270,7 @@ DEFINE_SIMPLE_PROP(clocks, "clocks", "#c
 DEFINE_SIMPLE_PROP(interconnects, "interconnects", "#interconnect-cells")
 DEFINE_SIMPLE_PROP(iommus, "iommus", "#iommu-cells")
 DEFINE_SIMPLE_PROP(mboxes, "mboxes", "#mbox-cells")
-DEFINE_SIMPLE_PROP(io_channels, "io-channel", "#io-channel-cells")
+DEFINE_SIMPLE_PROP(io_channels, "io-channels", "#io-channel-cells")
 DEFINE_SIMPLE_PROP(interrupt_parent, "interrupt-parent", NULL)
 DEFINE_SIMPLE_PROP(dmas, "dmas", "#dma-cells")
 DEFINE_SIMPLE_PROP(power_domains, "power-domains", "#power-domain-cells")


