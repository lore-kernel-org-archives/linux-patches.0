Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96141863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0D1C433EF;
	Wed, 28 Dec 2022 15:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240274;
	bh=j8xY4JdpcEhaOIVnUbLgo/a5jPXdEx8Rio+crTjylc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=op5o8KCYxqiExq4Ai+e30/rW6ISz16c+MFibUchjwlwAUIEpaRcO4BUP8vXwaZFdI
	 7HytS6rGTxvu0ZMJ1w2xSQ4QoD9xrbc0E3n2kpJTbEZR6YTtOwjMDfeih1qrZbOax9
	 xJup7KKdxjwwrn5Z7sO8s93EoJ7pXjnp7DWYixfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0103/1146] tpm/tpm_crb: Fix error message in __crb_relinquish_locality()
Date: Wed, 28 Dec 2022 15:27:22 +0100
Message-Id: <20221228144332.944319944@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit f5264068071964b56dc02c9dab3d11574aaca6ff ]

The error message in __crb_relinquish_locality() mentions requestAccess
instead of Relinquish. Fix it.

Fixes: 888d867df441 ("tpm: cmd_ready command can be issued only after granting locality")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_crb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 18606651d1aa..65f8f179a27f 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -252,7 +252,7 @@ static int __crb_relinquish_locality(struct device *dev,
 	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs_h->loc_ctrl);
 	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state, mask, value,
 				 TPM2_TIMEOUT_C)) {
-		dev_warn(dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
+		dev_warn(dev, "TPM_LOC_STATE_x.Relinquish timed out\n");
 		return -ETIME;
 	}
 
-- 
2.35.1



