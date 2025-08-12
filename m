Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05AA1E500C;
	Tue, 12 Aug 2025 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023456; cv=none; b=uI9dQ0u9XvOBWgM81OWyX6dfJN5RhflpmB+yfuAukdHaFdbom2EdhvHMV/TwOCST3/Nnaj3p/ieAQkvPWVzYhxO9kJ2brbdpnt3RXW650Xnzhb7QK0WdAwLr+H1feqphnugtHheTmgIrPi4bg07Za6wGQdwESx3Pgvr8LAnLdwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023456; c=relaxed/simple;
	bh=4J3smR3aviQpFZkIODGICT/HQo+Sw1/lkrygLPkHts8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qaFV5+EaxbZSTtpRZnSEKPL8sV+aTdGhebPmpPgovcVGcBmSSaKs+uLGzlCsNH7GGnhF6n3Da6x7Ki5V3vvqGXwNnzbHj/Kl7g3fF01HX4ZbDJmW267EwvOULQOewpiL8L7wlRnxjcFsHmgE+8L9QyqKoshHvpN9LTFD/nVZk5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBJmGkdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBJmGkdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF50C4CEF0;
	Tue, 12 Aug 2025 18:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023456;
	bh=4J3smR3aviQpFZkIODGICT/HQo+Sw1/lkrygLPkHts8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBJmGkdCEsKlmOk/U0VYjKN7jnpwZ27/GHVPDl9/HSvTIFeAz0KcPp9lrwqvhgUay
	 eAjquMzGfzD4kqY4UEPw1HwAKZXnZE6Ph/pcEgKaQOfrTAgPBkwQD8oRC/aXCQWktC
	 WEakKdxmURQt4FXh2aGbxRmQCEf/iphibjtOIncc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 085/627] selftests: vDSO: chacha: Correctly skip test if necessary
Date: Tue, 12 Aug 2025 19:26:20 +0200
Message-ID: <20250812173422.539820442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



