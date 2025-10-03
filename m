Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB6B29E0E1;
	Fri,  3 Oct 2025 16:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507602; cv=none; b=MHAAG1Yc9Nm4BMxd4QsQiGIDJeBlikmHL9Yj7FApT0n4qh1QrIJggnm5Xn2PRpgW8nufB5/+EJD6fKX3ufYT5w46M6LH/xVickXT10n4GFCOXw5HeFEeicddCHm5bzrYgPp3zDBtoEx9E4nGetD/k4KycfqLCqsDPO1cDw3FlAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507602; c=relaxed/simple;
	bh=pBbUHsnhIYTRbKwRpZiKVGT7/aQCl7yW7sojJmEfG8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZDJBkOLz8MN7WAyHOOU9u6GcI3vV6jC98jnNWyOg05DSlPVEpwkuWPiHip5aIYIvGw052X+RPJj3tv3zcB6KGNEfCq2kfzRKUOA9AinVzyVH0U5GaA3Oc1/sWjS1pnaC4Ka/8cFEFQb8l5Rd5L0BWa2Cvb2dfIlv05q7V60bP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdPBOJ2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdPBOJ2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FD1C4CEF5;
	Fri,  3 Oct 2025 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507601;
	bh=pBbUHsnhIYTRbKwRpZiKVGT7/aQCl7yW7sojJmEfG8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdPBOJ2gX1CBFuLZTI1BHQwpKKCypHoOlZtqZluKgQJz1frMBNJKliN4JtJVNMKIq
	 eJleY48EiKCI9jol6bRcjp1Un7obn1WvPkt2I8zmW42qIzvFKjMhQPqqCHanrTWoXN
	 4doZ6wUIIZgCQbnb7CkCGQhFSG6fQCVsKHbnRNOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.17 12/15] wifi: ath11k: fix NULL dereference in ath11k_qmi_m3_load()
Date: Fri,  3 Oct 2025 18:05:36 +0200
Message-ID: <20251003160400.347316135@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2557,7 +2557,7 @@ static int ath11k_qmi_m3_load(struct ath
 					   GFP_KERNEL);
 	if (!m3_mem->vaddr) {
 		ath11k_err(ab, "failed to allocate memory for M3 with size %zu\n",
-			   fw->size);
+			   m3_len);
 		ret = -ENOMEM;
 		goto out;
 	}


