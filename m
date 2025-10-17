Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1476330B17;
	Fri, 17 Oct 2025 15:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716356; cv=none; b=a8kOrdBgqf8pJ7XqmGZdfk3Nk4hBzsTIWOnNt0p3Hh+VM2v/29VJiS+jmIrX6xU6V8tN8X/b7UhMXiHHRzDUT+NJmlvXj9GUtbc/ZcgruzM3QCGgL/WY/yIClQotajhjHuOJqKlrglmR4NGQw63E90KTitsUdyp4m19/pbYEaO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716356; c=relaxed/simple;
	bh=quoAO5GwoGjrn2HzljXCEKhRiDtLzVpgSesePwTo51o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/UTtOA81fPeHuk+0FR8TTnQeiC8YVOLBRnVY3hyk5IOsNllBtlOYelI7S3LHQmfB+MTHyHE8h9JJ+sDfbubr7owQWfkVTTCzcuvFr+NrAZr5yLkV08xYmTjVsyFVwttNE5UIvA5JF02mVPBuWB1D/RzkWB5U70yX29C7roXIMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gleA2YA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gleA2YA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F267EC4CEE7;
	Fri, 17 Oct 2025 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716356;
	bh=quoAO5GwoGjrn2HzljXCEKhRiDtLzVpgSesePwTo51o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gleA2YA/u9wrqQVO0CF8oYtqX42js9MQx+M1HMnGDrAzW6PvDoqo9ubfKMjxlDSrF
	 SE2+K9wx2W8+C7ZIP8lKF2y/kjb8Sse6kYYrJar0cXsW3iRe8uNehWoxxybr3+stfH
	 ddqgurJwk2AdYlCFu7LB+zFu0rL+jhjpuF/VHQ3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/276] tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single
Date: Fri, 17 Oct 2025 16:54:15 +0200
Message-ID: <20251017145148.387254899@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b3452259d6e0b..c8c68301543b2 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -831,8 +831,8 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
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



