Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEB736C9E2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302331; cv=none; b=AwbLetCCr0cs7OUAyRge8IN3CiteQbaZkq7Qn/Y17YaZTTxxLkStFe+T1vVocA2iqKndbltIetD+ApYUOQVez9Joyc+V8aVQ897LY2O8pvo2KB4Z7ca+sb+Cok7HFe8YjfktM7x2UTaNopF1mnYFk432EmfLdcuqIOLnOaqBraU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302331; c=relaxed/simple;
	bh=ex585FaLr/MIVeOUnmRcMxc2onEOLUPNLiaFi7fW6Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FghIWezUfPu0T3GNaVGiCbijmSqbZDwm9WwDuqNM9loOjLJs83KtoUFF7XV7VXbvET/872Q8EKT3CbvteimOCqSdRsjt6zq6UVkyZNzNWwk0cYEHC+KnAxqJ/eRV+mPYejXXbGfgMvWeW8QkM3eDP3V/8EpX/is8EQH+k9TMHGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SrHUxL2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrHUxL2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48757C19423;
	Sat, 28 Feb 2026 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302330;
	bh=ex585FaLr/MIVeOUnmRcMxc2onEOLUPNLiaFi7fW6Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrHUxL2ZSd4QfyHp3aFfdX0Xk0IB8vUBjsJub+eQUo4OU6nt9H0b7M8sUFj0xKz13
	 NNZHDq6podTJRMKi1458XBIFbZ0urKZyL+Nn8cdNBDm/LUaqMUkeFl27BkgzFF+Tfw
	 /+ZmiBN7lCJE/f0BZAhc0Q6hFUG9yCWY7GrlnlER5CBB+DwrYyIVy4+zC2c8CbFO4i
	 nQQaN/BR/YIS2O052asnee8ggDmwc7r7lTJSsqtvqImh8E2tD5asFwTMi0d9/gbHim
	 6hYCtS8ZF3nHnelYLTViHnO+dqDv4YqNHBdk0ftxwowbnUaCW+6hr7w04RW1kh7tsA
	 Ad++Ab6xaUoKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/232] EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 13:08:24 -0500
Message-ID: <20260228181127.1592657-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7b5c7e83ac405ff9ecbdd92b37a477f4288f8814 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But the limit calculation doesn't take
the first 11 bytes that we wrote into consideration so the limit is
not correct.  Just fix it for correctness even though it doesn't
affect runtime.

Fixes: 64e1fdaf55d6 ("i5000_edac: Fix the logic that retrieves memory information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/07cd652c51e77aad5a8350e1a7cd9407e5bbe373.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5000_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index ba46057d42207..3d82ab8eb2c71 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1111,6 +1111,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0

