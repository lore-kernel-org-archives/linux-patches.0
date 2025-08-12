Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8CA2E3B06;
	Tue, 12 Aug 2025 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022059; cv=none; b=SdcMDTlcdjWD9nKvX86wZR1CtWTtk4T9RWHgsszxu1RctUWnYHQDRxNG7a0hJA6ye3JGueKSj39IoJLYqEarmq1Cs/Q9+dHH9/5YcGkxHdwmA/FtPWo+lJL5fTyRp9utxbTrtaGkdm4UKZ2UDAA+1V4rqqe7CwC1ggzTF5+nNIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022059; c=relaxed/simple;
	bh=9t+FDXPyKwPUEb7Dw1MR65ivZ3Xezy8TsiaffxTH8Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dCqPTtc23KU/osWo8Qjj7qG0cik7LrDGB49fHB7E5o5kutl9y29Eifje9gfA7oMlmQ2Bdw2eoPmvvelaSN3S9fH/SNcfa5H0TOU8dsgTriX/C0YO0VntBMPnFHyEDZch+SZUL9y26nseznpXYgaj019TfbUC0HPruVVqvD0/rAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qpi7pxcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qpi7pxcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC3BC4CEF0;
	Tue, 12 Aug 2025 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022059;
	bh=9t+FDXPyKwPUEb7Dw1MR65ivZ3Xezy8TsiaffxTH8Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qpi7pxcfJUyRncTiLdmypR7bqHQuij6Xydw0dTM9RO5TZm2qr3VV+ytLBxnUgLCql
	 2sgWsL0OpZQappZy2HJ/dmB8CTAdt/iVfIAd0GRshr0jogVzFK6QEZdX0DEimaF6aD
	 Yyu4ezZTmgVPea+UQsMb5/6ObNzg+u2MdSrO/KBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/369] selftests: vDSO: chacha: Correctly skip test if necessary
Date: Tue, 12 Aug 2025 19:25:41 +0200
Message-ID: <20250812173016.418886926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 2c0a4428f5d6005ff0db12057cc35273593fc040 ]

According to kselftest.h ksft_exit_skip() is not meant to be called when
a plan has already been printed.

Use the recommended function ksft_test_result_skip().

This fixes a bug, where the TAP output would be invalid when skipping:

	TAP version 13
	1..1
	ok 2 # SKIP Not implemented on architecture

The SKIP line should start with "ok 1" as the plan only contains one test.

Fixes: 3b5992eaf730 ("selftests: vDSO: unconditionally build chacha test")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/all/20250611-selftests-vdso-fixes-v3-1-e62e37a6bcf5@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_test_chacha.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vDSO/vdso_test_chacha.c b/tools/testing/selftests/vDSO/vdso_test_chacha.c
index 8757f738b0b1..0aad682b12c8 100644
--- a/tools/testing/selftests/vDSO/vdso_test_chacha.c
+++ b/tools/testing/selftests/vDSO/vdso_test_chacha.c
@@ -76,7 +76,8 @@ static void reference_chacha20_blocks(uint8_t *dst_bytes, const uint32_t *key, u
 
 void __weak __arch_chacha20_blocks_nostack(uint8_t *dst_bytes, const uint32_t *key, uint32_t *counter, size_t nblocks)
 {
-	ksft_exit_skip("Not implemented on architecture\n");
+	ksft_test_result_skip("Not implemented on architecture\n");
+	ksft_finished();
 }
 
 int main(int argc, char *argv[])
-- 
2.39.5



