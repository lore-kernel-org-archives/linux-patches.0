Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5A73B1ECC;
	Tue, 21 Jul 2026 20:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666663; cv=none; b=KYwC51mdWjq7SsMRwxNyqe2x0n+0F8YrXKi+oxsMg7ynroT7fgndsgFdsgh6QZDq/C1tzCoI2O+euUK/bF8pKmdaBZzIBBRWx+wBWGWX07NqUeWfG2iiHsCw9HxNY58mQ0JzgIPqvlb37QH4ojMkwl1uQOOyYoJw9Jrh8kuwzac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666663; c=relaxed/simple;
	bh=KtJlgnvAB9Tu+NYQE7CQEVk6smq1p50OX4VNqkBnBKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogfJbRW3uMfnLQAe/PJ0/ucpNROxIRIUn9ia2E0JPkGl3cGmsA3H3qv3wIuud9jWk5FYKokCUlgNjRPRdO8gBGJ91u29plTjoAapn369VNI+tmrOtWDhi/5RoORk+CZQWBI3gHy/k/mm5U0kCEem+4duuFmmd4YblOM4ezQAkq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6lITWlG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6lITWlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005DF1F000E9;
	Tue, 21 Jul 2026 20:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666662;
	bh=cnJqHkWXa5jk7ZJGpIZY+ofXwU9mi4hu0A9kgC5Cz2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6lITWlGSCyOW+34sVNdw3f2Vpsjg9qiIptT4Yk0hagZ6+CfiGh/OCdPzES9U2hnD
	 N7EG9WQlppYx/QwxaH0Aofz4Y0+Kncwlwq/bH6z4Q7dFyWImQQXzb1DikIV7WyXOxt
	 HkJ4F1cUSe8QSOVOR4kith+B0IQKvC7hohjMPdBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0767/1266] i40e: Fix i40e_debug() to use struct i40e_hw argument
Date: Tue, 21 Jul 2026 17:20:04 +0200
Message-ID: <20260721152459.025304071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit 798f94603eb0737033861efd320a9159f382a7c5 ]

i40e_debug() macro takes struct i40e_hw *h as first argument. But the
macro body uses hw instead of h. This has been working so far because hw
happens to be the name of the variable in the context where the macro is
expanded. Fix the macro to use the passed argument.

Fixes: 5dfd37c37a44 ("i40e: Split i40e_osdep.h")
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_debug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debug.h b/drivers/net/ethernet/intel/i40e/i40e_debug.h
index 27ebc72d8bfe5f..8e650ae035d1f6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debug.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_debug.h
@@ -41,7 +41,7 @@ struct device *i40e_hw_to_dev(struct i40e_hw *hw);
 #define i40e_debug(h, m, s, ...)				\
 do {								\
 	if (((m) & (h)->debug_mask))				\
-		dev_info(i40e_hw_to_dev(hw), s, ##__VA_ARGS__);	\
+		dev_info(i40e_hw_to_dev(h), s, ##__VA_ARGS__);	\
 } while (0)
 
 #endif /* _I40E_DEBUG_H_ */
-- 
2.53.0



