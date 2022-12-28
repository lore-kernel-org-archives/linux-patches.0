Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5E11863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3135C433EF;
	Wed, 28 Dec 2022 15:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240248;
	bh=NRPKHk3u4TgHIlrVRVUc/Qx93ttIyR+OcxlN2OrSFD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Opp/3HuPcZvUrs2NY1XxCxp6dQu6fAaHZTUHxjMg8DCfsxS9mhwk/TQwLYKNhq1mx
	 a9CtKqk3gLb7zBK6DnDBLT8eJ38EpGlzEltxnRj8oBGAMBHHta8NL1bm2XFDk3RxaD
	 19+/e04rm9o6AZmfg35gm6Lc0yD8vcInST+fzTs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Joel Stanley <joel@jms.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0100/1146] tpm: tis_i2c: Fix sanity check interrupt enable mask
Date: Wed, 28 Dec 2022 15:27:19 +0100
Message-Id: <20221228144332.859637635@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 561d6ef75628db9cce433e573aa3cdb6b3bba903 ]

The sanity check mask for TPM_INT_ENABLE register was off by 8 bits,
resulting in failure to probe if the TPM_INT_ENABLE register was a
valid value.

Fixes: bbc23a07b072 ("tpm: Add tpm_tis_i2c backend for tpm_tis_core")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_i2c.c b/drivers/char/tpm/tpm_tis_i2c.c
index 0692510dfcab..635a69dfcbbd 100644
--- a/drivers/char/tpm/tpm_tis_i2c.c
+++ b/drivers/char/tpm/tpm_tis_i2c.c
@@ -49,7 +49,7 @@
 
 /* Masks with bits that must be read zero */
 #define TPM_ACCESS_READ_ZERO 0x48
-#define TPM_INT_ENABLE_ZERO 0x7FFFFF6
+#define TPM_INT_ENABLE_ZERO 0x7FFFFF60
 #define TPM_STS_READ_ZERO 0x23
 #define TPM_INTF_CAPABILITY_ZERO 0x0FFFF000
 #define TPM_I2C_INTERFACE_CAPABILITY_ZERO 0x80000000
-- 
2.35.1



