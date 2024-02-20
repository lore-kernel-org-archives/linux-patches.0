Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED6F14AD12;
	Tue, 20 Feb 2024 21:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463180; cv=none; b=l52k3ohaIQe8D4grxIdLpvyixmxE3sW3glmxnjS0gtM+LNpzbgm/D5dPhVdus91jRBmUNlTImncEI7mMwo6G97hdJLFhBbZBdrI4XRn5sbK7tQLHAstKaLWqMq6KIBR9Dhc1rN4rragiI4G2lYaWTEhJ6W6+FpZ5+yBVmPbxfic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463180; c=relaxed/simple;
	bh=TRx8DOdngnaTgzJjNoZBcZG7QtDGI+1jLmWRDg668sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVWHnswco3OwwhF1pjcaSqCZAN8fBPlWsYAAcVkXrkMpAJOYZpVsJGBv2xd8q3ryyq8KeK9ze0T/A8GrDIXgnuLEN3FQPGX/EhqP705RH5pv6t6U/tFYNd+NXAUuFmRa5wEGZlU8HIPd+eAqyLJbj9flJohAOdZuto/iGQRco9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRd/FRA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRd/FRA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDA7C433F1;
	Tue, 20 Feb 2024 21:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463180;
	bh=TRx8DOdngnaTgzJjNoZBcZG7QtDGI+1jLmWRDg668sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRd/FRA5ZWDpVpceU8sUADc2UsVPngw2hsPr/Xd/1SkMADs0lPJVw51WSpVS+r82M
	 4q4Anl+0kriq4zrhMs8QBiavxPCblHlIq0HmO3BiocFTH6EAs+/kj2PAn5pmmuSXp7
	 2ern74u4/MpFTpwV/evXMQhWdAkDJ3kzmOe1E4os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Saravana Kannan <saravanak@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.1 160/197] of: property: fix typo in io-channels
Date: Tue, 20 Feb 2024 21:51:59 +0100
Message-ID: <20240220204845.862652557@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1243,7 +1243,7 @@ DEFINE_SIMPLE_PROP(clocks, "clocks", "#c
 DEFINE_SIMPLE_PROP(interconnects, "interconnects", "#interconnect-cells")
 DEFINE_SIMPLE_PROP(iommus, "iommus", "#iommu-cells")
 DEFINE_SIMPLE_PROP(mboxes, "mboxes", "#mbox-cells")
-DEFINE_SIMPLE_PROP(io_channels, "io-channel", "#io-channel-cells")
+DEFINE_SIMPLE_PROP(io_channels, "io-channels", "#io-channel-cells")
 DEFINE_SIMPLE_PROP(interrupt_parent, "interrupt-parent", NULL)
 DEFINE_SIMPLE_PROP(dmas, "dmas", "#dma-cells")
 DEFINE_SIMPLE_PROP(power_domains, "power-domains", "#power-domain-cells")


