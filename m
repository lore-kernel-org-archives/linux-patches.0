Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D6327AC57;
	Fri, 21 Nov 2025 13:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733542; cv=none; b=kklJ5VgMuU4GiKPgZDJY0MhVoM8KjIbGvKWopm6sKGWLRThJelSlQk3hcsWOv090nKogJeM5EWf7OhT5kwFH1QqxC0thLzpU4/MIGF4Fs2YHsHozXJgGr6VeCKA45VWBB6dPGTYyHcTpqFlcRVYE47QFkGzQUwIqoUVJ9INY8Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733542; c=relaxed/simple;
	bh=viU9RAWvF9dXJZ50uWgHA31SLUMRFbY/WnMv5cS9U2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNXJvbFct/fTE2o+nQHkVmB4Fa0vXGz33bdjrygkQAj2Qkh4kmTle1P5TtC4+9FtcZAmW2XeIww3TGNhujmT8yNAZ9evJBv3PZTcriMcb+k/bCmmR/6//3LWb3e56HIXCmD9x9Z9wiZIwOyIHFpBySXXj33FAC845Po7IDGfXE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1OX1LZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1OX1LZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227E4C4CEF1;
	Fri, 21 Nov 2025 13:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733540;
	bh=viU9RAWvF9dXJZ50uWgHA31SLUMRFbY/WnMv5cS9U2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1OX1LZJ2xQuM9pC12VCe74qsK1sGo4q3B4dmM+ypS8GRF3wJF+BJ8o4dPTp5gSo+
	 /0OlA4307CVYERDDkqGWnMhZIs6lYoOFm4ncd+lgNCXxWjpcImF0LzHOjBoUbsC97b
	 V3jQcRD/ln6ZZujTFcAX3IVWPyXZwj9GtPH4je88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Eric Biggers <ebiggers@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 504/529] scsi: ufs: core: fold ufshcd_clear_keyslot() into its caller
Date: Fri, 21 Nov 2025 14:13:23 +0100
Message-ID: <20251121130248.951889449@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit ec99818afb03b1ebeb0b6ed0d5fd42143be79586 ]

Fold ufshcd_clear_keyslot() into its only remaining caller.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20240708235330.103590-3-ebiggers@kernel.org
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d968e99488c4 ("scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd-crypto.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -95,8 +95,12 @@ static int ufshcd_crypto_keyslot_program
 	return err;
 }
 
-static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
+static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
+				       const struct blk_crypto_key *key,
+				       unsigned int slot)
 {
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
 	/*
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
@@ -106,16 +110,6 @@ static int ufshcd_clear_keyslot(struct u
 	return ufshcd_program_key(hba, &cfg, slot);
 }
 
-static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
-				       const struct blk_crypto_key *key,
-				       unsigned int slot)
-{
-	struct ufs_hba *hba =
-		container_of(profile, struct ufs_hba, crypto_profile);
-
-	return ufshcd_clear_keyslot(hba, slot);
-}
-
 bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	if (!(hba->caps & UFSHCD_CAP_CRYPTO))


