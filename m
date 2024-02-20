Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560C72DF9F;
	Tue, 20 Feb 2024 21:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465350; cv=none; b=pW1MNCZFQmWkHwqFc8rTyjm0k/mAG6S/sZ/WIf7+tWVDmrqaIcXaCXnrallTjgBUCZjFtoCOiqkG1udMHjsEG9flUAVjVEPk7EmMgPjO/LwDTXoujXmBkvu0WtM9JYCFAjJ/gaCF2WrqtH47BGiq32B/lhpfR/DUp1ry+iNZLFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465350; c=relaxed/simple;
	bh=zSBEeqUpZdiBRt3997HQ2VdtHVGX6D1M4bqWmqamHbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgjFIeQ2sB0fTrx6rTdnWvwlAN8FSX9VTs6etaELAtoj+Rqz1pW0CwtCHxbwaMX1UcdTAkKs/iieKDSszMIyXvN9t3Edcf1AeRupncuNnqcaj/AsXk1HKBaX9UFuswaun96pWDHVjTdDAATbTzJL5iSgkhJVi0A1ljdfY9jlbsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhAnltf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhAnltf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA615C433C7;
	Tue, 20 Feb 2024 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465350;
	bh=zSBEeqUpZdiBRt3997HQ2VdtHVGX6D1M4bqWmqamHbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhAnltf+YVOMGyP6u4JD98aqbFKpIYddRlUB9BfkcpViYeyEpFlJ7e0JxwOh9XGy2
	 hInBnYv0k1a9nyEJNoSzqghgjCSlc4Cj6VhDgjj4yNEuSgQyLAsQNayyJo9Cdpk8z5
	 2uY6oyLEZ0eBS9lLA3UlgEqmstxNUho8Ebt5S22g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Saravana Kannan <saravanak@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.7 294/309] of: property: fix typo in io-channels
Date: Tue, 20 Feb 2024 21:57:33 +0100
Message-ID: <20240220205642.296289194@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1213,7 +1213,7 @@ DEFINE_SIMPLE_PROP(clocks, "clocks", "#c
 DEFINE_SIMPLE_PROP(interconnects, "interconnects", "#interconnect-cells")
 DEFINE_SIMPLE_PROP(iommus, "iommus", "#iommu-cells")
 DEFINE_SIMPLE_PROP(mboxes, "mboxes", "#mbox-cells")
-DEFINE_SIMPLE_PROP(io_channels, "io-channel", "#io-channel-cells")
+DEFINE_SIMPLE_PROP(io_channels, "io-channels", "#io-channel-cells")
 DEFINE_SIMPLE_PROP(interrupt_parent, "interrupt-parent", NULL)
 DEFINE_SIMPLE_PROP(dmas, "dmas", "#dma-cells")
 DEFINE_SIMPLE_PROP(power_domains, "power-domains", "#power-domain-cells")


