Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA31F47127E;
	Tue, 21 Jul 2026 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657769; cv=none; b=EBwh7miIH8tbg26RY9WphKRbwkFLb9Mi8X602ke3jg0VwQhVRp2tXgcniGQpjFCtYiHLTf9aJB1BZq42iSNCeNu/UyhP7SstzcrvC/d28x06T9j3wRo4X4BfmM0H41/yBLBkYFEBrl2YttxJOBOXQipkciywRO970Q93dsvCO9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657769; c=relaxed/simple;
	bh=S1U+KZbyRB+cxvxSyu/iqwhMMzHncfy5dLvksNZ1TTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3rQC6poJLD3eOAP8F042xGwKYvDjSAdJRRnjOfGO9qDBQrto5gEWloWs9anXWQ4bCpreF2qJ6lony1uE312DR1hcU1s2SYfv1fE1Qgw1zyKfUJZKglmUFTPByt9OfaIo1paDDg1wdeGyh252qQrk1E+ARpNLRg++CXB0M24G6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLIcp1vA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLIcp1vA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647DA1F000E9;
	Tue, 21 Jul 2026 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657767;
	bh=d6r2v7rpMbTQVqCKMvuFExknzfaeSDUe8piYxxFmJGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLIcp1vA+7DKbTLJu1ZXrwwcY7BGA1Kwy3C/o1rct6iLywwnjk3ycSUK/vq4rUc+U
	 ZMdGliPYEtIkfg1MdVoPa5H17W2HvX2YW9LiSFM+guqHJ/uGWr2jFslo2+qsmkHHHc
	 aqaQ+Cnp+ZsdLyvTGFxGfTzeX3VgO/dRuXw8cvik=
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
Subject: [PATCH 6.18 0891/1611] i40e: Fix i40e_debug() to use struct i40e_hw argument
Date: Tue, 21 Jul 2026 17:16:47 +0200
Message-ID: <20260721152535.431843130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e9871dfb32bd44..01fd70db908666 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debug.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_debug.h
@@ -42,7 +42,7 @@ struct device *i40e_hw_to_dev(struct i40e_hw *hw);
 #define i40e_debug(h, m, s, ...)				\
 do {								\
 	if (((m) & (h)->debug_mask))				\
-		dev_info(i40e_hw_to_dev(hw), s, ##__VA_ARGS__);	\
+		dev_info(i40e_hw_to_dev(h), s, ##__VA_ARGS__);	\
 } while (0)
 
 #endif /* _I40E_DEBUG_H_ */
-- 
2.53.0



