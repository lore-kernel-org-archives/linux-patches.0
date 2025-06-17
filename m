Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672A52376E6;
	Tue, 17 Jun 2025 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177048; cv=none; b=N4ntStlvG4vHJvU7kpmEQ680N9ghXfPnZaGna+P4CWCo3H4fwDcgeOy/HtA+jqWCBRKWWE3CttLNpK3YmNRrgI9g0a1/PALpCZSFvLRTFabggeaOoav3dnctBmnNF48SHdOhw2Gn8w2WV4bBY1ZsJuLa2m3PfZIc9e+vMhrwxwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177048; c=relaxed/simple;
	bh=ippKz0n09RNMG2hQCOcUO80ddmqPsYeKN9o7QPyL4aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOMSDdyP42/jRGoIP2AL+71GeoAs5iQzEZpRMR1P8h+G+zYGfqjEKqOX/X4DSzWOf3zNiVwp91Gh2Vd/6PoOUO0mI0vIfDteWYKWv6xxDZM8lXE9gKdIgn4lcedv0l46X8m/rxCVd2JJPHmS+GNwZFNeOsSE9R41gfd2Oxj8Lgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xno1w6LT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xno1w6LT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83C9C4CEE3;
	Tue, 17 Jun 2025 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177048;
	bh=ippKz0n09RNMG2hQCOcUO80ddmqPsYeKN9o7QPyL4aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xno1w6LTWg697LKJ0YPkBow9wV5hEOcNkEC/NTzI8KAIknj/XCE9bxvimAspawU3i
	 PcxYJt0brAbes5ITLuNVrSrgBCyXqSsRvUkk75Ny19XkT2hw6a6xV+xffNmdFPRw53
	 zhN7I3Qd0QIfY+FB46K+hNAXr9k18zgGVn75Z0PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 252/780] efi/libstub: Describe missing out parameter in efi_load_initrd
Date: Tue, 17 Jun 2025 17:19:20 +0200
Message-ID: <20250617152501.721510866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit c8e1927e7f7d63721e32ec41d27ccb0eb1a1b0fc ]

The function efi_load_initrd() had a documentation warning due to
the missing description for the 'out' parameter. Add the parameter
description to the kernel-doc comment to resolve the warning and
improve API documentation.

Fixes the following compiler warning:
drivers/firmware/efi/libstub/efi-stub-helper.c:611: warning: Function parameter or struct member 'out' not described in 'efi_load_initrd'

Fixes: f4dc7fffa987 ("efi: libstub: unify initrd loading between architectures")
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index fd6dc790c5a89..7aa2f9ad29356 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -601,6 +601,7 @@ efi_status_t efi_load_initrd_cmdline(efi_loaded_image_t *image,
  * @image:	EFI loaded image protocol
  * @soft_limit:	preferred address for loading the initrd
  * @hard_limit:	upper limit address for loading the initrd
+ * @out:	pointer to store the address of the initrd table
  *
  * Return:	status code
  */
-- 
2.39.5



