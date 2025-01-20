Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9CE2119;
	Mon, 20 Jan 2025 13:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737379984; cv=none; b=P0ifWhmQ+CDuUr59p6Ok3BrXJIaRJVcrLEFjhoxOh545csOUQkZ4qWykVuOeM2VpSwTt3yimqmSaVAN9yktnDxYevwsGvp/GL2xAhwOjYUhQ2I4PcsJX016MabdoHm5qwKcrqnxYmgFg94vZ974RTUMCe86S13Njo10fH9ZCaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737379984; c=relaxed/simple;
	bh=AQ8MQPAZDf06Ml3eXK2rCSVVh7IqQd0DOGFAg/AG7zg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=du8c9KHaG/52o+VXvCsHEj0Kg6HDJ6F88jbBWqCKPgINV611jZbOyXDNhUgR3oXFDDlqlnYdywLDJnLZAi4+Fstu0kqRXGz+XQ05cEqwFbfXQ6LAH3tmj/pWfaLLc+nJ6pPTAgdGIpwLj0apw8IFTdD282YX2BOg2nxo5g88zcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHvmmVit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHvmmVit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA19C4CEDD;
	Mon, 20 Jan 2025 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737379983;
	bh=AQ8MQPAZDf06Ml3eXK2rCSVVh7IqQd0DOGFAg/AG7zg=;
	h=From:Date:Subject:To:Cc:From;
	b=fHvmmVitwGskqqtbQRF/vdvjg3sm0PPqMPX1/0D3rVc3LwvWnrWEGcnF+kUE4x3GL
	 d7BaJBHvNK088RTCEKMu5DN7YZprvj4aWgfOIIe5XUF5rm0+ewGmBwpTMoFy+rNZzR
	 escTxjkKWFqh7jZTpr/TnrxXC37MJiWYtuCk/29FSMO+Nt8/W572AK8YWKnsgYL+RN
	 1R6womc0j5aP3qvWwnIj0gG9mN8CZDHbIhFgBLxybEhl5BMhIMcp5h24nvUtpCDejP
	 8oH617UAv2xAtqTPBLFINwLfH210GGsM75bJ2RBnlaJE+6En6ZSME8kcsdS74tBsEU
	 9o7eLiOOeQ6sg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 20 Jan 2025 06:32:48 -0700
Subject: [PATCH] ALSA: hda: tas2781-spi: Fix -Wsometimes-uninitialized in
 tasdevice_spi_switch_book()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-tas2781_hda_spi-fix-wsometimes-uninitialized-v1-1-d7fd104aa63e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAH9QjmcC/x2NXQrCMBAGr1L22YUkKG29ikhZmtV+YNOSjT9Ye
 neDjwPDzEamGWp0bjbK+oJhSRX8oaFxknRXRqxMwYWT88FxEQtt54cpymAr+IYPv22ZtWBW42d
 CQoE88NXIR5Gx7zV0bYxUk2vW6v93l+u+/wCeJrSkfgAAAA==
X-Change-ID: 20250120-tas2781_hda_spi-fix-wsometimes-uninitialized-4aac99e287dd
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Baojun Xu <baojun.xu@ti.com>
Cc: linux-sound@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2533; i=nathan@kernel.org;
 h=from:subject:message-id; bh=AQ8MQPAZDf06Ml3eXK2rCSVVh7IqQd0DOGFAg/AG7zg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOl9Ab3/QvxnSJnK7+5Mf+jFJJSWsLmnUa+YcevXwwcC3
 tyRFirrKGFhEONikBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABPxyWf4Hr+wbE7J0WcOuTNX
 3flwPPPNo53iSkrrXOde/iK14679ToZ/WuduMRzQT1R8cl7Xq9aCU9oulj2HPSkywW/OzLBZCxd
 yAAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  sound/pci/hda/tas2781_hda_spi.c:110:6: error: variable 'ret' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
    110 |         if (tas_priv->cur_book != TASDEVICE_BOOK_ID(reg)) {
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sound/pci/hda/tas2781_hda_spi.c:119:9: note: uninitialized use occurs here
    119 |         return ret;
        |                ^~~
  sound/pci/hda/tas2781_hda_spi.c:110:2: note: remove the 'if' if its condition is always true
    110 |         if (tas_priv->cur_book != TASDEVICE_BOOK_ID(reg)) {
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sound/pci/hda/tas2781_hda_spi.c:108:9: note: initialize the variable 'ret' to silence this warning
    108 |         int ret;
        |                ^
        |                 = 0

Sink the declaration of ret into the if block and just return 0 at the
end of the function, as there is nothing to do if cur_book has already
been changed.

Fixes: bb5f86ea50ff ("ALSA: hda/tas2781: Add tas2781 hda SPI driver")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501192006.Hm9GmKiV-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/pci/hda/tas2781_hda_spi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/tas2781_hda_spi.c b/sound/pci/hda/tas2781_hda_spi.c
index 8068c70b7014..5be71b538ce0 100644
--- a/sound/pci/hda/tas2781_hda_spi.c
+++ b/sound/pci/hda/tas2781_hda_spi.c
@@ -105,18 +105,17 @@ static const struct regmap_config tasdevice_regmap = {
 static int tasdevice_spi_switch_book(struct tasdevice_priv *tas_priv, int reg)
 {
 	struct regmap *map = tas_priv->regmap;
-	int ret;
 
 	if (tas_priv->cur_book != TASDEVICE_BOOK_ID(reg)) {
-		ret = regmap_write(map, TASDEVICE_BOOKCTL_REG,
-				   TASDEVICE_BOOK_ID(reg));
+		int ret = regmap_write(map, TASDEVICE_BOOKCTL_REG,
+				       TASDEVICE_BOOK_ID(reg));
 		if (ret < 0) {
 			dev_err(tas_priv->dev, "Switch Book E=%d\n", ret);
 			return ret;
 		}
 		tas_priv->cur_book = TASDEVICE_BOOK_ID(reg);
 	}
-	return ret;
+	return 0;
 }
 
 int tasdevice_spi_dev_read(struct tasdevice_priv *tas_priv,

---
base-commit: e576e7843c0d65b82d4092e5b386d9fbf5bc10c3
change-id: 20250120-tas2781_hda_spi-fix-wsometimes-uninitialized-4aac99e287dd

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

