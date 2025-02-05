Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB9218D621;
	Wed,  5 Feb 2025 15:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768301; cv=none; b=kJChtriXVrkpGoh3FOHqzVWwGMjlq8l4vfkVwC8yQj3MgCmFoHEXiAlesdXYbDZe4d32QNl/7dLQQ2dXAGx3esqRJBajRhCHDn6+cKda4GtX+MolI+44V/i0ThWle4IOIAQKdCVOwbKvZXFit15N0p+iOt0xAqtDpXvd5jkxTCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768301; c=relaxed/simple;
	bh=UnUitE+wq+O4muRtjKnH0PO19ioY1tXmW1ZEEY1isdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuMTFHW8oRuQi4YRZehd9EaKKkxyR+4tkNSd2eB1cYm48WNYiJfMslwnKB8G4gIzK5XOP8IZt6Pi+ncVg/Pp6Tt+fWv0ANL5np+/4jAoyjD2l/nQQsUc2XJqrTrFfbCYmuXL2X2yL+5tFUsEHtXsfWZwrN0ydvADWNxDhB+YHCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T21xexfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T21xexfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E4FC4CED1;
	Wed,  5 Feb 2025 15:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768301;
	bh=UnUitE+wq+O4muRtjKnH0PO19ioY1tXmW1ZEEY1isdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T21xexfCnX0QWhVEBnb8GllKpRspB9ylwsKjr2JSWqypKd10Ud00LmTwdMz12BhXv
	 fqgkif6iguGIwzeD9oBwSRYhnL2i4Yehtj8oW+BgYunsKvikx7L9JnRyGXQl2Yyhcs
	 OUp+2voem9xuuH43skEHKteBm7ebanjE1KVZUSWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 581/590] phy: freescale: fsl-samsung-hdmi: Fix 64-by-32 division cocci warnings
Date: Wed,  5 Feb 2025 14:45:36 +0100
Message-ID: <20250205134517.492276038@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

commit 739214dd1c209e34323814fb815fb17cccb9f95b upstream.

The Kernel test robot returns the following warning:
 do_div() does a 64-by-32 division, please consider using div64_ul instead.

To prevent the 64-by-32 divsion, consolidate both the multiplication
and the do_div into one line which explicitly uses u64 sizes.

Fixes: 1951dbb41d1d ("phy: freescale: fsl-samsung-hdmi: Support dynamic integer")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412091243.fSObwwPi-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Link: https://lore.kernel.org/r/20241215220555.99113-1-aford173@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/phy/freescale/phy-fsl-samsung-hdmi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
+++ b/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
@@ -471,8 +471,7 @@ static unsigned long fsl_samsung_hdmi_ph
 			 * Fvco = (M * f_ref) / P,
 			 * where f_ref is 24MHz.
 			 */
-			tmp = (u64)_m * 24 * MHZ;
-			do_div(tmp, _p);
+			tmp = div64_ul((u64)_m * 24 * MHZ, _p);
 			if (tmp < 750 * MHZ ||
 			    tmp > 3000 * MHZ)
 				continue;


