Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AA47D085;
	Mon,  8 Apr 2024 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584841; cv=none; b=AqWXvHrbQn23Zb6s8I6CiCP4S5xoYcFWiA4EEvrjJozACdJcrUSONM6x8eK26Lu3QhnLWRaEZOAs6WiV4Aafxah6E7rVY3sR/f4vGmFjqwyzjyNx0NhKbh0KYX3RYwjFRcF9+2kHcHpCFMcMFnCCpMwh7vgpBDFisNnTZdIfU4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584841; c=relaxed/simple;
	bh=GhBr9hAirzDcs5quPhdh/G7RMEE5u+Fmm/+b34wDhtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2I3A8r5GKpBQ+0g3KO7MjORyfQxh5dhd7+koNZfqpf0jhemUbCeriUn41bTUPENfcgbOs63rHn/e6cSpsU8X2zIlj5z9qyUM8ACZsYvb3gtNhSYL111ceFnAJb3PyIMRJTc3MYsFnDQZCqWFteXaKZtrWz9fo0StbnWHvv64IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8/VYX3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8/VYX3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBF0C433F1;
	Mon,  8 Apr 2024 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584841;
	bh=GhBr9hAirzDcs5quPhdh/G7RMEE5u+Fmm/+b34wDhtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8/VYX3WNpEa4gju0WwpmZfS/C56EsJk+bPPFE4N6Ev5LLcX1z8HcDGY3Kjxo0wJY
	 gnmpJQAC01pkfWZN5dXXIBH8m38MNEFgcHjzpP2XK9A4yZ2u5XfzHVX/9d/2Nhf1eU
	 1yNBpWDVtDCxnRmUY5/lC8CRMf7/4++T+SHjvEhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 575/690] mmc: core: Avoid negative index with array access
Date: Mon,  8 Apr 2024 14:57:21 +0200
Message-ID: <20240408125420.437278241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Mikko Rapeli <mikko.rapeli@linaro.org>

commit cf55a7acd1ed38afe43bba1c8a0935b51d1dc014 upstream.

Commit 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu") assigns
prev_idata = idatas[i - 1], but doesn't check that the iterator i is
greater than zero. Let's fix this by adding a check.

Fixes: 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu")
Link: https://lore.kernel.org/all/20231129092535.3278-1-avri.altman@wdc.com/
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Rapeli <mikko.rapeli@linaro.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240313133744.2405325-2-mikko.rapeli@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -485,7 +485,7 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	if (idata->flags & MMC_BLK_IOC_DROP)
 		return 0;
 
-	if (idata->flags & MMC_BLK_IOC_SBC)
+	if (idata->flags & MMC_BLK_IOC_SBC && i > 0)
 		prev_idata = idatas[i - 1];
 
 	/*


