Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A354F19FA7F;
	Thu,  6 Jun 2024 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683140; cv=none; b=iJw/nxphv0KQjADroYUBskvFaAF1zvmoBqinzz+TluKebpqWdO+p+/aCQfdmYH9Z9zUOvyA1ZDfVu/ph4CG5hQedFDwDRBv8CVGsiw2S7d6ugTHbG1Ilnz95mkDfmjnx+c6viPc9VEiRibIzw31pqSTVjAA1VN2mCvhcIAftfwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683140; c=relaxed/simple;
	bh=ykGS/1Y4i5JXeuV/HKQu50IsP8/RyVt6QUotbVmAP1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD94efZSvvWPFytmUpFlaL54UQ2XJq/gjpNPYSr/CC/SiG4atENnXQGYRdG8WYVGtLWWpwtL9gjJ/rbb+FLsV1nIVxw0N0TC+q45yFOwPrcrr4bb2lCQxBZi18sM87BUploBwgjWq4IlljFwCEOpmPzisgvePv9FtPr4U+LMP5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNzFdrHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNzFdrHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79226C2BD10;
	Thu,  6 Jun 2024 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683140;
	bh=ykGS/1Y4i5JXeuV/HKQu50IsP8/RyVt6QUotbVmAP1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNzFdrHtNOYJbLF7Mj7XrapiGdYMpYKBnu3ZaRCMmFY5kukMEeEpVf+TulNJ5qz1C
	 iRHmJNjNxTXFtBCEr13WNuetvj++A0j0sLZRLo1XnN6EJu54gW4lF2/2n0Tpu7uzfB
	 yV1p67E1+47JZ07xHi0IG2m9jh67KptH/B0X+wq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/744] nvmet-auth: replace pr_debug() with pr_err() to report an error.
Date: Thu,  6 Jun 2024 15:55:58 +0200
Message-ID: <20240606131735.163746379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 445f9119e70368ccc964575c2a6d3176966a9d65 ]

In nvmet_auth_host_hash(), if a mismatch is detected in the hash length
the kernel should print an error.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 1f7d492c4dc26..e900525b78665 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -284,9 +284,9 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 	}
 
 	if (shash_len != crypto_shash_digestsize(shash_tfm)) {
-		pr_debug("%s: hash len mismatch (len %d digest %d)\n",
-			 __func__, shash_len,
-			 crypto_shash_digestsize(shash_tfm));
+		pr_err("%s: hash len mismatch (len %d digest %d)\n",
+			__func__, shash_len,
+			crypto_shash_digestsize(shash_tfm));
 		ret = -EINVAL;
 		goto out_free_tfm;
 	}
-- 
2.43.0



