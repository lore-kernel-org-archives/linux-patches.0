Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7811A1CA8F;
	Mon,  1 Apr 2024 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987525; cv=none; b=C9IK06gOmvJpuoRoJdp5EVVhHofmopIrVv1CbfMd2T+KVE32Ig8stKArqc9y32j0I5eONRoEnYtF6MLtoS8peHcMtopqJwIOsYOqXacMOu7Cj3SpyWTmt2XBamtcp5XiUBGeDOCTukBkZ/PUiXOAEKMZiZIfQFHIU+VOGB5GL5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987525; c=relaxed/simple;
	bh=GDnCiMSqD3r10FpoacodxMFhCAqV3r7pYu8OyZLn7eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbKLpVzUxF8Yq52zPKTAiB9Idu1nC0PsZdWUMyVvdpMM7oB9xp9rBV/N8r/RafHOv9GMtk8KXOYyOVx+iwRHEkjfw0WRA+rrZR3KSBSNoZ/BzeuBgaLgRPy7tP/G3zGGQYqmnzF1El+7jnKywS6PncIg/+y0z9+7YRwW8oaaVDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzMVtQFq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzMVtQFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED988C43390;
	Mon,  1 Apr 2024 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987525;
	bh=GDnCiMSqD3r10FpoacodxMFhCAqV3r7pYu8OyZLn7eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzMVtQFqGbXdndeK738tVLradPjvORGjqyeafSlcqbis29OzmJf5Gxn1RSCdP57bC
	 DVfFmj9hzCFvv6SU7ozCOKWn5YPSMS9hkdj+Na94LsRe0fFkqXqQFZQzfeWzhrzvWU
	 hVZ9XVDe590UhTcn9qczYAnUZ9cTOhgzSqXETy2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.8 313/399] mmc: core: Initialize mmc_blk_ioc_data
Date: Mon,  1 Apr 2024 17:44:39 +0200
Message-ID: <20240401152558.529677870@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -413,7 +413,7 @@ static struct mmc_blk_ioc_data *mmc_blk_
 	struct mmc_blk_ioc_data *idata;
 	int err;
 
-	idata = kmalloc(sizeof(*idata), GFP_KERNEL);
+	idata = kzalloc(sizeof(*idata), GFP_KERNEL);
 	if (!idata) {
 		err = -ENOMEM;
 		goto out;


