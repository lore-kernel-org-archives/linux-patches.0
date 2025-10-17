Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D223370F6;
	Fri, 17 Oct 2025 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713102; cv=none; b=KpYXMqBFQfnY29jNEkHz4vNewo9QHMxg+Cekpnu8FXHNQeuevKJz/zyGUabQLELyOW0ubU+VrM6JgqELqUX8qtd7tS41VArJ5Eo1kRZA/87FfBrdXfZngnLY8yha2KYXpOiH8B6iU5T/7YyCS4gKZUBfHIqyoL9BrMmHHdbUphU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713102; c=relaxed/simple;
	bh=JLOD5OpUDghzSjL2W132UPza7QWjVkaqVaNCPcH1cA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJahwbF8Di/K4kgPH8VLCgSp26g3e8VET9naph1F4cfj1CDj7NoG1iqdUyxj4CBnxbe/Sctf57+T8aKdDQuxSduCNwQOzZ+DgzuoqwMuUnocEGrks7LT50fWHH5S6w+DG/9IBl95WjuJGYn/fadz9mvsaZeRRjZeulR3myGzPXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwnawvbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwnawvbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F44C4CEE7;
	Fri, 17 Oct 2025 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713102;
	bh=JLOD5OpUDghzSjL2W132UPza7QWjVkaqVaNCPcH1cA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwnawvblWByz3IrYT1G6K8RY+VFt0cXpnOJ5UumRVOmDTRw4rQnXuzpXEBWseKrD7
	 i3G02SI8J3JjaeLi+x009u79N8XUubCDxatvmAyiymSZJePFxLugkumlrEf/o9QcOB
	 bvVJsRKxCfKxH1v7xMOYfiC+xr9kmHa5IkUSC5kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/168] tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single
Date: Fri, 17 Oct 2025 16:52:06 +0200
Message-ID: <20251017145130.751338534@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index caf9ba2dc0b13..968b891bcb030 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -878,8 +878,8 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
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



