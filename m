Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C879B29D26D;
	Fri,  3 Oct 2025 16:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507648; cv=none; b=rt+aUsXZJ0BFcBrM/CrvmXtuAld2LslInCTb5K1SnRTtTI4dPylfrOfJwihfQdl5wahN4OHeL/7yUEMWdLRcoUHM5jQB57MIxf9ZuvQ35R4Heti+OkMEULWEvMvxuP/Lpysf5uNuu6pgMoa/NpGDcqo2xmHIiDt+YlFSQz2RNH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507648; c=relaxed/simple;
	bh=xjGF0mGFEBfJrXwz0ZgKemdIJvt5z3YSsJKOaCGhYeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXPbywdYVI37rn3/bqfG8UE03U/R06aSbS0h66sAdJW7AP/F6lGRLOOqxjT4FbrWwKrBJihDBUnuOsGA2zNIoFOINmf9azjj6pu4f3HXuG8YwRvI1pinbBy22gRwKlrH7mYWMo+yqA6bo0Pto+Ktr/mKNvKwkvFMaDGsItBlIRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTOILtIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTOILtIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CABAC4CEF5;
	Fri,  3 Oct 2025 16:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507648;
	bh=xjGF0mGFEBfJrXwz0ZgKemdIJvt5z3YSsJKOaCGhYeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTOILtIkaudIaV70B4LVwySND2DL8hsf/MzEROfRMWxSdtR01Yh8GORm3UKklh0jK
	 Fu+ZEfGzNF27YGMVxa77Nqh+uOE3SW34zibz4+cCcQbqIuR/cvVagU4tq8r3WrQcRq
	 7CT+IzLwnFeCFWBP1KRyic3MpMcb4Vh7YLce3l+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.16 11/14] wifi: ath11k: fix NULL dereference in ath11k_qmi_m3_load()
Date: Fri,  3 Oct 2025 18:05:45 +0200
Message-ID: <20251003160353.032278880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
References: <20251003160352.713189598@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

commit 3fd2ef2ae2b5c955584a3bee8e83ae7d7a98f782 upstream.

If ab->fw.m3_data points to data, then fw pointer remains null.
Further, if m3_mem is not allocated, then fw is dereferenced to be
passed to ath11k_err function.

Replace fw->size by m3_len.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7db88b962f06 ("wifi: ath11k: add firmware-2.bin support")
Cc: stable@vger.kernel.org
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250917192020.1340-1-matvey.kovalev@ispras.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2555,7 +2555,7 @@ static int ath11k_qmi_m3_load(struct ath
 					   GFP_KERNEL);
 	if (!m3_mem->vaddr) {
 		ath11k_err(ab, "failed to allocate memory for M3 with size %zu\n",
-			   fw->size);
+			   m3_len);
 		ret = -ENOMEM;
 		goto out;
 	}


