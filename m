Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D10A2D73B4;
	Thu, 15 Jan 2026 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497764; cv=none; b=a4xmlylQuZb3DumEooX1Hm8Fsq6K37ri0nqbijlqV9s4oL/ceGQME+/doCzoL3KBrKfBCK0SKCNLxFxF4W67cJgrM+REIEOb9VO/wF6W2bchjn+gjRjYfOmf6pTTMog0aFgSq5WQBwVZ6hF1WgbvmQKDlBjpB447g/e0q1/vliw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497764; c=relaxed/simple;
	bh=geKlD3RBHy+kK1nhp65DuO37yFzg6aP0tw0S4m+Uz64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYoDDUecSgjcd3aqIhCDEBgH2SQFwyZaIkV303Jm7CjPvXd2hfNqZsThUO3IZsMPPbbEfHD9dVTGStbH+z55jPxlhdxYIjQ5IVCI5X+tJWvUBxSMq5/wOSvo49+xbT1WH/BDGIAJ5cIFEUM7nLPSi73jtzyZfWeh1HxFMrNI0oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZrMTGF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZrMTGF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1828FC116D0;
	Thu, 15 Jan 2026 17:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497764;
	bh=geKlD3RBHy+kK1nhp65DuO37yFzg6aP0tw0S4m+Uz64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZrMTGF4duBGfguKjDXFd0aRsd/lQ4NzSPpLVbIEU6sT1Nhm3pgS0MQ5aC09lRkK+
	 zOErpkSoPIt/3lBbGbPCzXc74g+or0SSy4+SrKSEnkHIkRzUAF0CHB5Ur2X2wJoa1m
	 L5hWRxujF9V0xg4wHqstoQRq7n1oGJfU6HlykcGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/554] efi/cper: Adjust infopfx size to accept an extra space
Date: Thu, 15 Jan 2026 17:44:21 +0100
Message-ID: <20260115164253.316900460@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 8ad2c72e21efb3dc76c5b14089fa7984cdd87898 ]

Compiling with W=1 with werror enabled produces an error:

drivers/firmware/efi/cper-arm.c: In function ‘cper_print_proc_arm’:
drivers/firmware/efi/cper-arm.c:298:64: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
  298 |                         snprintf(infopfx, sizeof(infopfx), "%s ", newpfx);
      |                                                                ^
drivers/firmware/efi/cper-arm.c:298:25: note: ‘snprintf’ output between 2 and 65 bytes into a destination of size 64
  298 |                         snprintf(infopfx, sizeof(infopfx), "%s ", newpfx);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As the logic there adds an space at the end of infopx buffer.
Add an extra space to avoid such warning.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper-arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/cper-arm.c b/drivers/firmware/efi/cper-arm.c
index 36d3b8b9da47e..f4b7a48327fbb 100644
--- a/drivers/firmware/efi/cper-arm.c
+++ b/drivers/firmware/efi/cper-arm.c
@@ -241,7 +241,7 @@ void cper_print_proc_arm(const char *pfx,
 	int i, len, max_ctx_type;
 	struct cper_arm_err_info *err_info;
 	struct cper_arm_ctx_info *ctx_info;
-	char newpfx[64], infopfx[64];
+	char newpfx[64], infopfx[ARRAY_SIZE(newpfx) + 1];
 
 	printk("%sMIDR: 0x%016llx\n", pfx, proc->midr);
 
-- 
2.51.0



