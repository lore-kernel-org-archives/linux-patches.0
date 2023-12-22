Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2952C194;
	Fri, 22 Dec 2023 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgLS30tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B821C433CB;
	Fri, 22 Dec 2023 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703269628;
	bh=dS7mL9HhRhd3rfeEYnNgAVuQItdNhZxOHpOgKsRwE/0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SgLS30tPAiW6hJyUQ8uudxG05tAUc2wALMP3HrW4TjiRkJenslv47r3OQhHkX7u+T
	 MBKu9x6HiL5H4etyXmjzFNJS5Wy94IXMWgVboiRixqfkGv7Gkj778nWIXmta1bdJkn
	 gHChM3qHA+GsQbzTGSIJ0OnBK+soBs9GZa/aZYjr7mKPEhtgkPe38iZmXMbhkOQcEu
	 t8DNjvalBEkVhKQFVNPpQ41/xlifpcbNh8I8HWPjMRso6Dy3y0X4ZgRGgH06iryH28
	 NRHnbFSVv7UwEbludONdg68AkQB9cgRcz7quLu/2wiw9nb54eMDV17ULsaYl6ga5MT
	 DygcGFet1Y5DQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 22 Dec 2023 11:27:02 -0700
Subject: [PATCH 2/2] platform/x86/intel/pmc: Mark lnl_d3_fixup() and
 lnl_resume() as static
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231222-intel-pmc-missing-prototypes-v1-2-3f0d47377d4c@kernel.org>
References: <20231222-intel-pmc-missing-prototypes-v1-0-3f0d47377d4c@kernel.org>
In-Reply-To: <20231222-intel-pmc-missing-prototypes-v1-0-3f0d47377d4c@kernel.org>
To: irenic.rajneesh@gmail.com, david.e.box@intel.com, hdegoede@redhat.com, 
 ilpo.jarvinen@linux.intel.com, rajvi.jingar@linux.intel.com
Cc: platform-driver-x86@vger.kernel.org, patches@lists.linux.dev, 
 Stephen Rothwell <sfr@canb.auug.org.au>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1756; i=nathan@kernel.org;
 h=from:subject:message-id; bh=dS7mL9HhRhd3rfeEYnNgAVuQItdNhZxOHpOgKsRwE/0=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmtV35d51tyYvuM84cX5xtZnll6nzmUo8J95b8HZRaHD
 yuGOu270VHKwiDGxSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAm8nQ+w//yfq+pbh7VR14f
 +n/k8MPiO9c3rpsl8D4nn+n6Kzv1pZ9jGf77rfQqddRz03LfYap8KYLffObS4J6yxKUHXjW3Lfl
 +ZCsHAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

With -Wmissing-prototypes, there are two instances flagged with no
prototypes:

  drivers/platform/x86/intel/pmc/lnl.c:503:6: error: no previous prototype for 'lnl_d3_fixup' [-Werror=missing-prototypes]
    503 | void lnl_d3_fixup(void)
        |      ^~~~~~~~~~~~
  drivers/platform/x86/intel/pmc/lnl.c:509:5: error: no previous prototype for 'lnl_resume' [-Werror=missing-prototypes]
    509 | int lnl_resume(struct pmc_dev *pmcdev)
        |     ^~~~~~~~~~
  cc1: all warnings being treated as errors

These functions are not used outside of this translation unit, so mark
them as static to fix the warning.

Fixes: 119652b855e6 ("platform/x86/intel/pmc: Add Lunar Lake M support to intel_pmc_core driver")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20231222135412.6bd796cc@canb.auug.org.au/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/platform/x86/intel/pmc/lnl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/lnl.c b/drivers/platform/x86/intel/pmc/lnl.c
index 88b35931f5df..b5de569e6662 100644
--- a/drivers/platform/x86/intel/pmc/lnl.c
+++ b/drivers/platform/x86/intel/pmc/lnl.c
@@ -500,13 +500,13 @@ const struct pmc_reg_map lnl_socm_reg_map = {
  * Set power state of select devices that do not have drivers to D3
  * so that they do not block Package C entry.
  */
-void lnl_d3_fixup(void)
+static void lnl_d3_fixup(void)
 {
 	pmc_core_set_device_d3(LNL_IPU_PCI_DEV);
 	pmc_core_set_device_d3(LNL_NPU_PCI_DEV);
 }
 
-int lnl_resume(struct pmc_dev *pmcdev)
+static int lnl_resume(struct pmc_dev *pmcdev)
 {
 	lnl_d3_fixup();
 	return pmc_core_resume_common(pmcdev);

-- 
2.43.0

