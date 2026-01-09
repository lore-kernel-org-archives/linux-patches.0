Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E95533C53A;
	Fri,  9 Jan 2026 12:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962009; cv=none; b=jrkcDSbrCuDE2MVBv0ZeQmRxDho40zYXWi78fqJDAPUNefGdp9RePy6g32OWjJxbmDv8zabZ00TzWfnWGHLFBAdVPlBcMMgNiAAHKl7kCrNZjHekToAfb5jg6iMssiYBBioiEDoxRT6Y+/v2uBrn1F+f9C0DRnwlpTMvzsxE8W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962009; c=relaxed/simple;
	bh=GOM9yPlL3KzW8LeWkdyt2mrLTYboOrY73vDk6mP8eIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kG7oQNTPlwvHZZtXCPAZVb0dRfQOt7wlcWlVzjlIjFRQIQTRGSNp/+CqfD/pUkwIE0OA1kK4omZIeH2cKo47dGA0SYPYqV643aykMjUzRKMHpo1QL2dT8xeTMaxL/UtwTpOZgMidf7VGtrhcVKtfSfxJsEf3weMNdsvRkDofS34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Z6SHGt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Z6SHGt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC48C4CEF1;
	Fri,  9 Jan 2026 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962009;
	bh=GOM9yPlL3KzW8LeWkdyt2mrLTYboOrY73vDk6mP8eIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Z6SHGt+V9R5q7AAi4aXtxge9o551ufKcA34t7p0r1bbD4oDilZXJsjmLfoxjC0Jr
	 CbY75hXUI5rVtwoydPAediJzhYNbHNOBr3Rs7fiKswbGhSlgz/xmFeQhxPrB8rl1jn
	 UFzFdsJtU+K8s0b9nBB/1YRINslgqjZmyl/V/80c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/634] efi/cper: Adjust infopfx size to accept an extra space
Date: Fri,  9 Jan 2026 12:38:13 +0100
Message-ID: <20260109112125.525225578@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



