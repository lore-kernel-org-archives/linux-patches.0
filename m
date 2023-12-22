Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1F02C199;
	Fri, 22 Dec 2023 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izAQVBW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5E5C433C9;
	Fri, 22 Dec 2023 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703269627;
	bh=RcUyy7qwp8so5FArzTYqCU+Gu3SpQPIskGdhHY8DPis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=izAQVBW4Aai6eB+H10IJeUuzx9ivHo5Frxghd/PDjQ/RS3WiTey3aHLDKqy32Ivgm
	 /vaZPHkYnVJgKS+X1iYvvFvZ4pULfLFBqE/+RW32rmWGQIlo3Pyml+XZT+1WU0d4AM
	 wG855lEOLdjZVBWtB/vDCNS0dlq/KRPQchv5gHrxiljsx8a/xnOUCrEaeZTiXFUx/f
	 O0GWNA1RujHt4JcmrQbGG1iVObgc5JRYzi24UQfhQLzC4uurdkyKATBZzPbtrGDwq5
	 A0LVDL+DChI00dZV42zQDvsJPoBKuNHqlEdaroy6KDQ0xlDfMvonAUq+i5AQY5L4yD
	 uJHSAtIC8WGWg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 22 Dec 2023 11:27:01 -0700
Subject: [PATCH 1/2] platform/x86/intel/pmc: Mark arl_d3_fixup() and
 arl_resume() as static
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231222-intel-pmc-missing-prototypes-v1-1-3f0d47377d4c@kernel.org>
References: <20231222-intel-pmc-missing-prototypes-v1-0-3f0d47377d4c@kernel.org>
In-Reply-To: <20231222-intel-pmc-missing-prototypes-v1-0-3f0d47377d4c@kernel.org>
To: irenic.rajneesh@gmail.com, david.e.box@intel.com, hdegoede@redhat.com, 
 ilpo.jarvinen@linux.intel.com, rajvi.jingar@linux.intel.com
Cc: platform-driver-x86@vger.kernel.org, patches@lists.linux.dev, 
 Stephen Rothwell <sfr@canb.auug.org.au>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1713; i=nathan@kernel.org;
 h=from:subject:message-id; bh=RcUyy7qwp8so5FArzTYqCU+Gu3SpQPIskGdhHY8DPis=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmtV34llTDcSBT6GP371Eaxdrnen37ymvrSX2e2xnD8n
 /Rw1e2WjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRXTyMDOtjdm3+e9I3nWd7
 UMf8yfdV2hakmFfaxfzMf7r2XhAb0x6Gv3KLWT5sP9HpaaiTeOWK3oUu3tNrarr3HZuXr/O0/KD
 LDAYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

With -Wmissing-prototypes, there are two instances flagged with no
prototypes:

  drivers/platform/x86/intel/pmc/arl.c:680:6: error: no previous prototype for 'arl_d3_fixup' [-Werror=missing-prototypes]
    680 | void arl_d3_fixup(void)
        |      ^~~~~~~~~~~~
  drivers/platform/x86/intel/pmc/arl.c:685:5: error: no previous prototype for 'arl_resume' [-Werror=missing-prototypes]
    685 | int arl_resume(struct pmc_dev *pmcdev)
        |     ^~~~~~~~~~
  cc1: all warnings being treated as errors

These functions are not used outside of this translation unit, so mark
them as static to fix the warning.

Fixes: f34dcf397286 ("platform/x86/intel/pmc: Add Arrow Lake S support to intel_pmc_core driver")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20231222135412.6bd796cc@canb.auug.org.au/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/platform/x86/intel/pmc/arl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/arl.c b/drivers/platform/x86/intel/pmc/arl.c
index c20506a9f4a6..9d873e02c412 100644
--- a/drivers/platform/x86/intel/pmc/arl.c
+++ b/drivers/platform/x86/intel/pmc/arl.c
@@ -677,12 +677,12 @@ static struct pmc_info arl_pmc_info_list[] = {
  * Set power state of select devices that do not have drivers to D3
  * so that they do not block Package C entry.
  */
-void arl_d3_fixup(void)
+static void arl_d3_fixup(void)
 {
 	pmc_core_set_device_d3(ARL_NPU_PCI_DEV);
 }
 
-int arl_resume(struct pmc_dev *pmcdev)
+static int arl_resume(struct pmc_dev *pmcdev)
 {
 	arl_d3_fixup();
 	return pmc_core_resume_common(pmcdev);

-- 
2.43.0

