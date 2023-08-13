Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD799443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8374EC433C8;
	Sun, 13 Aug 2023 21:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961926;
	bh=f6hOcH6sqcmI3pLUn1O+n+ZNVlJQVZVMHIwOIbjTj4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJ1EoUKL8x2p8J0KerKa+6yD1QXd8DuiyuIvtpPV3rj9cmx7gGrTINh5eXEfWv7Jp
	 eiRKmxVUFU/7PdnG7NUUorO6sVtjDZAjQWzQrv0XVSkK1goJbJlSjTnI3wPZ/QcDxl
	 tRrs+Af1zx1JSmrtjFgvkJqkXyo1GtBZt9cv2mzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.4 048/206] tpm_tis: Opt-in interrupts
Date: Sun, 13 Aug 2023 23:16:58 +0200
Message-ID: <20230813211726.380823441@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 6aaf663ee04a80b445f8f5abff53cb92cb583c88 upstream.

Cc: stable@vger.kernel.org # v6.4+
Link: https://lore.kernel.org/linux-integrity/CAHk-=whRVp4h8uWOX1YO+Y99+44u4s=XxMK4v00B6F1mOfqPLg@mail.gmail.com/
Fixes: e644b2f498d2 ("tpm, tpm_tis: Enable interrupt test")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 3c0f68b9e44f..7fa3d91042b2 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -89,7 +89,7 @@ static inline void tpm_tis_iowrite32(u32 b, void __iomem *iobase, u32 addr)
 	tpm_tis_flush(iobase);
 }
 
-static int interrupts = -1;
+static int interrupts;
 module_param(interrupts, int, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
-- 
2.41.0



