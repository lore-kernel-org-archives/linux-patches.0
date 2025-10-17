Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAD232C93E;
	Fri, 17 Oct 2025 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715261; cv=none; b=bbRsrDku8a+gJhzlS037EZHG+r7BAzKX6nI5pjr6oynOy+c1UNKPpvVittvUhE11KBIJPHOJPos6wJ3fOT3LzK87qeqYaaWYRvyqm60DZVBbnCpSPOSDeVStDypV1KKE1vLozBs/QLdDRdT7rRMH98VnCTHcE62J+mjH/bSSyw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715261; c=relaxed/simple;
	bh=vyg+jOriZ6ashjFAkExDWCqMJKboJZqZ7t/hzCqe02Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdlGSNHrcGLl+ZKTwMjtPV1hRJgftTjwkQJUBbucv8uqf5PCXMhvnbKKSFMp2r8NRuAH4OZtOIsWUeqs7S1fBZxAuCVVo6R1eJNd1BKhQXMRTdV3+YBCt/cFAwjsqHAzeokValVVV17QnuPcIFSUxF968g3LfqCb0HDj5fcGEuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tId/1dRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tId/1dRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22547C113D0;
	Fri, 17 Oct 2025 15:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715261;
	bh=vyg+jOriZ6ashjFAkExDWCqMJKboJZqZ7t/hzCqe02Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tId/1dRKcTtojzmZgwGv7s+TInE83d9LV+3sgk7cVRGxGKjOp7iLLdkTIpYXJupPx
	 c09gZKNTI46ceFMGNoz3BaiUPuV3v5N85yq8HiYzi2SsPtiO/avcp+ma26uNN+b6lq
	 2q3a1KtENNCknlijuAiNmawLcNNnuiKGtrPREuUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 127/371] tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single
Date: Fri, 17 Oct 2025 16:51:42 +0200
Message-ID: <20251017145206.527712096@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Gunnar Kudrjavets <gunnarku@amazon.com>

[ Upstream commit 8a81236f2cb0882c7ea6c621ce357f7f3f601fe5 ]

The tpm_tis_write8() call specifies arguments in wrong order. Should be
(data, addr, value) not (data, value, addr). The initial correct order
was changed during the major refactoring when the code was split.

Fixes: 41a5e1cf1fe1 ("tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant phy")
Signed-off-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Reviewed-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 4b12c4b9da8be..8954a8660ffc5 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -978,8 +978,8 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	 * will call disable_irq which undoes all of the above.
 	 */
 	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
-		tpm_tis_write8(priv, original_int_vec,
-			       TPM_INT_VECTOR(priv->locality));
+		tpm_tis_write8(priv, TPM_INT_VECTOR(priv->locality),
+			       original_int_vec);
 		rc = -1;
 	}
 
-- 
2.51.0



