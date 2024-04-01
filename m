Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80A01DFF4;
	Mon,  1 Apr 2024 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990377; cv=none; b=qrfw6BKs7pj/eYOY7PEqZhxk/NR4gdEJTHg5KE7AsiIV2rhL1SEzwhOVATIvlo6O6wdvxxc9gh8roVvq7p6M+7scH4LSJ4ZjVtFN6NKl0HiekBWTBGcBlz/71MI7AmZ8VDxj4hc/CU4/0Cu6PmDZYPWBGb4cw1eEW/q810fTSyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990377; c=relaxed/simple;
	bh=mJF2MajvLzGeRXIxs5G58TpOwnqIodoERyG4qR+XnII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkzpE39T7ks3TCrXNBnSXBIuMoxTqDJaeYg4/5e0Ta6g0Jcsin9mOInZwF220tmBzBdWF8Objc9yWRUcG9RYnW0YwHkU6mFY/iLyA6QFroMLCBBS5uNnmNLqycIM2YQVuwfvQaMPc7vnqaf4pXyFCB3z8VI3aYh7n9uz6hySqwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1ySDvPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1ySDvPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D488C433C7;
	Mon,  1 Apr 2024 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990377;
	bh=mJF2MajvLzGeRXIxs5G58TpOwnqIodoERyG4qR+XnII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1ySDvPGftOkj/1PTabthSCj0pOL6IU/+OL7+kGtW+AD84qdiGmDo5WYq31fyyJtx
	 9sQAGdhbRqhvjcKL4EHcKNSN4g/JuDsqp2cG/C6QrjfonrVkVFNfofOGismgx0Ut2C
	 +i+R4ntd3YDQ3MmBrywWvwEfaQ0A6GBE9F9XHZNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 332/396] mmc: core: Initialize mmc_blk_ioc_data
Date: Mon,  1 Apr 2024 17:46:21 +0200
Message-ID: <20240401152557.812897079@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


