Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FE7627EB;
	Tue, 23 Jan 2024 01:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974953; cv=none; b=ui8pNSTsNx1Mk0nJiQbUD65onBTnSzLD9vGCDoDBK5XWbTMek+HFIrc46Hf2MN15mEL1NUbkTZ2rKwknTx6hvDlIRJ8lYQVdAgqTErhqldTNagu/ZEyctjI9SP05WriJwB7KmZKxFjdbiAfCB7vbG/aNAaxF9P/qHEpvoo3aK7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974953; c=relaxed/simple;
	bh=OGXQ1+ZDoppg4UyrwhBlmbEp1YpgtRzNKMqROaLsdTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiby5GBVtH6hYah5go5pbDq3EG9Xfv6FxZfoJUYcsRcQZCim0Xw5daCeuCGLtn082X1z1AeAc4ddkCTieZtGta0Kx8hNe/Ht5cpePYZ3iNNYdQ9e0DVnUkGbgI/UulMMczlYy7dZ2sX91Sgepu1jr2Fge4NC99TSgU+I3LhoHOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC+u3aQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC+u3aQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA9EC433B2;
	Tue, 23 Jan 2024 01:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974953;
	bh=OGXQ1+ZDoppg4UyrwhBlmbEp1YpgtRzNKMqROaLsdTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC+u3aQzGV3x7gLl4TlpmA8VR2w1DkvGRY6crX02lW+hWz+bVna0WSQV5F0EElR7L
	 4yBDcf4QmpIt2Ty2zw1zWeVnJuILqZTlDuf09pql4mqWUasCppgx8T7hLC6W006vYs
	 BEoVk27OJLyk7GF4+Xathi3LK5fOCoCu++x21AFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alex Vinarskis <alex.vinarskis@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/374] mfd: intel-lpss: Fix the fractional clock divider flags
Date: Mon, 22 Jan 2024 15:59:10 -0800
Message-ID: <20240122235755.010694922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 03d790f04fb2507173913cad9c213272ac983a60 ]

The conversion to CLK_FRAC_DIVIDER_POWER_OF_TWO_PS uses wrong flags
in the parameters and hence miscalculates the values in the clock
divider. Fix this by applying the flag to the proper parameter.

Fixes: 82f53f9ee577 ("clk: fractional-divider: Introduce POWER_OF_TWO_PS flag")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Alex Vinarskis <alex.vinarskis@gmail.com>
Link: https://lore.kernel.org/r/20231211111441.3910083-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/intel-lpss.c b/drivers/mfd/intel-lpss.c
index 0e15afc39f54..b1a0cd34e8a9 100644
--- a/drivers/mfd/intel-lpss.c
+++ b/drivers/mfd/intel-lpss.c
@@ -301,8 +301,8 @@ static int intel_lpss_register_clock_divider(struct intel_lpss *lpss,
 
 	snprintf(name, sizeof(name), "%s-div", devname);
 	tmp = clk_register_fractional_divider(NULL, name, __clk_get_name(tmp),
+					      0, lpss->priv, 1, 15, 16, 15,
 					      CLK_FRAC_DIVIDER_POWER_OF_TWO_PS,
-					      lpss->priv, 1, 15, 16, 15, 0,
 					      NULL);
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
-- 
2.43.0



