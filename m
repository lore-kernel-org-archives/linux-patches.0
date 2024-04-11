Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1F4140E3D;
	Thu, 11 Apr 2024 10:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830777; cv=none; b=PSo9uqAc39CVoJ53JkUBgfj57O931G+ygeI6lg+Pg6noM6+FCgZ6cduAtcXHvtWHETVuQOsYbokrhUGD3WNKACcunJgus+2QlY86hg6Uw/OPVTEOBgruDQutMZNMD7ThuAFgyS5NID77cWNgbhd0MlOywfBQW0jy/lfotJbseEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830777; c=relaxed/simple;
	bh=DDqXugtvpzL6/5HuD3alSaeFq4hnRi2EjhwDbuoEF88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYmnezt4iV7KYmb2xzGLc77b6obwi5htyaDqyxCaRHOKk4DHykZGltslN0Nvc+GRDsWh6wzEnhu2wqXMDfL/O9hR2oQFatGJMw2ZFdtsyR3sO/0texqzXiiF7EWCJof9lNJUg1Hk3RVZBPdTpArxzeU8R8vyREdGXyl7NJl72S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06e5b76M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06e5b76M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F1EC43390;
	Thu, 11 Apr 2024 10:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830777;
	bh=DDqXugtvpzL6/5HuD3alSaeFq4hnRi2EjhwDbuoEF88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06e5b76MHvsvyhQrBIdMH3Gq12xMbU01x/CUskmSLVWksGIH/ivv1E1UdYjwVIYWn
	 poKnRh1Yyb2l4R3YvlRGCawsJp8VxTKwJjCpdlRl1wbnuG6efWKttgnm6r/pXLWOcd
	 v5f+A1OWK4HiaP8qNO69259DW5r2EF5gPPlU5jGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 115/215] mmc: core: Initialize mmc_blk_ioc_data
Date: Thu, 11 Apr 2024 11:55:24 +0200
Message-ID: <20240411095428.362570257@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Rapeli <mikko.rapeli@linaro.org>

commit 0cdfe5b0bf295c0dee97436a8ed13336933a0211 upstream.

Commit 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu") adds
flags uint to struct mmc_blk_ioc_data, but it does not get initialized for
RPMB ioctls which now fails.

Let's fix this by always initializing the struct and flags to zero.

Fixes: 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218587
Link: https://lore.kernel.org/all/20231129092535.3278-1-avri.altman@wdc.com/
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Rapeli <mikko.rapeli@linaro.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240313133744.2405325-1-mikko.rapeli@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -358,7 +358,7 @@ static struct mmc_blk_ioc_data *mmc_blk_
 	struct mmc_blk_ioc_data *idata;
 	int err;
 
-	idata = kmalloc(sizeof(*idata), GFP_KERNEL);
+	idata = kzalloc(sizeof(*idata), GFP_KERNEL);
 	if (!idata) {
 		err = -ENOMEM;
 		goto out;


