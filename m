Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9313594E;
	Wed, 16 Jul 2025 03:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752636868; cv=none; b=c4rJEX6kO974TCs7JHddnBIFfFTbLMZEqGv0SuD8yyVDFgkYGAZNRgEmNK8SO6BzRz9oPds6/ilhhLTxY4tU72PXEaywOCEUrrPG0PkHoUx+9EPB7FxbzZnthgeGv0/UorfCVpQqHYmAm+PCSWBDJgGWo5haknicqR4kgaidUOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752636868; c=relaxed/simple;
	bh=JX9lPvW29HuWuNG0xMribnwysoHenlRGseyEaBMLynA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=heqx2Eofdu0/guYuBccRPV2yjRrx1uEg60a2IcMRT5bgIRfs/v1UKzYCihYxkIna1McVFYlNHG7TVE4gUFmP9EJ/nBe5twvUTkhPto3zWXcqaq7J/MwG9y8R629tSgXGdcCJirGy0GyHx3kBDoBe8aDtBoEFan0e+DeF8blFtws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNn0DBeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNn0DBeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4A6C4CEF0;
	Wed, 16 Jul 2025 03:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752636867;
	bh=JX9lPvW29HuWuNG0xMribnwysoHenlRGseyEaBMLynA=;
	h=From:Date:Subject:To:Cc:From;
	b=JNn0DBeG2jhiv8pTK0H87VAQoIEjSIt+i59xFsck7j531KjD6xtnpADiy8Bl+pa7R
	 YvWnNhD6AgMh3/uggiDs77HaJfOLzgB8ugNi8n5iEJGV46EWLfUKgjFeOc1j8lMvXN
	 WGrG3vxtiCxFCpg2xEjvmHk+hTBPTIm/VC17uqKRc/cSq90bEcMsgUe7RVZc6TXKS2
	 7EdM03dG1WJsz3AgwDF0moBdnPgWsSerkgwkkpfOaO/Pj2GJh+CvNGWpUjMeCpaiex
	 Q7Slwt5OVRUUZBxJvwOmzq9w7WXDZK+uXtLmy+xT5t/yQlgsySSs5eSU1ElvxyOzUF
	 8xZ/z1QHXfOjQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 15 Jul 2025 20:34:21 -0700
Subject: [PATCH] ASoC: SDCA: Fix uninitialized use of name in
 sdca_irq_populate()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250715-sdca_interrupts-fix-const-uninit-warning-v1-1-cc031c913499@kernel.org>
X-B4-Tracking: v=1; b=H4sIALwdd2gC/x2NQQrCQAxFr1KyNjBTWkSvIiJxJtZs0pJMVSi9e
 4O79+Dx/wbOJuxw7TYw/ojLrCH51EF5k06MUsOhT/2YznlEr4Ueoo3N1qU5vuSHZVZvuKqoNPy
 SBUxYhvq8ZE6FEkHMLcbR/q9u930/AJNRFh16AAAA
X-Change-ID: 20250715-sdca_interrupts-fix-const-uninit-warning-c4db91e0ca0a
To: Charles Keepax <ckeepax@opensource.cirrus.com>, 
 Maciej Strozek <mstrozek@opensource.cirrus.com>, 
 Bard Liao <yung-chuan.liao@linux.intel.com>, 
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
 Mark Brown <broonie@kernel.org>
Cc: linux-sound@vger.kernel.org, patches@opensource.cirrus.com, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1744; i=nathan@kernel.org;
 h=from:subject:message-id; bh=JX9lPvW29HuWuNG0xMribnwysoHenlRGseyEaBMLynA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnlsgfn3Lz8uC34ka9IKu/PJ9zcYQ8lvjk894hasP/o3
 9WpPrJHOkpZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEdh9kZNh0fvUkrsrzk7ar
 cUrZ7JM+3X1fc5LOkSrX0LlCbn7Pt15mZOgS+7qyVjFsj4iH0OnHqoIV0ext8wsnP/ba/ysy/GC
 2CAcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent change in clang to strengthen uninitialized warnings [1],
it points out that name is used uninitialized in sdca_irq_populate():

  sound/soc/sdca/sdca_interrupts.c:388:6: error: variable 'name' is uninitialized when used here [-Werror,-Wuninitialized]
    388 |                                         name, ret);
        |                                         ^~~~

Remove name and use the name member in the interrupt variable, as that
is the proper string to print.

Fixes: b126394d9ec6 ("ASoC: SDCA: Generic interrupt support")
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/sdca/sdca_interrupts.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sdca/sdca_interrupts.c b/sound/soc/sdca/sdca_interrupts.c
index 2f85fcc6e544..6df3b1a4d599 100644
--- a/sound/soc/sdca/sdca_interrupts.c
+++ b/sound/soc/sdca/sdca_interrupts.c
@@ -342,7 +342,6 @@ int sdca_irq_populate(struct sdca_function_data *function,
 			int irq = control->interrupt_position;
 			struct sdca_interrupt *interrupt;
 			irq_handler_t handler;
-			const char *name;
 			int ret;
 
 			if (irq == SDCA_NO_INTERRUPT) {
@@ -385,7 +384,7 @@ int sdca_irq_populate(struct sdca_function_data *function,
 						      handler, interrupt);
 			if (ret) {
 				dev_err(dev, "failed to request irq %s: %d\n",
-					name, ret);
+					interrupt->name, ret);
 				return ret;
 			}
 		}

---
base-commit: 6bd62e3ffe865ddcd9866856f7112dd3a7484b65
change-id: 20250715-sdca_interrupts-fix-const-uninit-warning-c4db91e0ca0a

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

