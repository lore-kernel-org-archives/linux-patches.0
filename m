Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752C046AA8B;
	Tue, 21 Jul 2026 15:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648171; cv=none; b=GVfrs2AUeF63UaYDO1XUrPQLHXlQq+e8ryMj7dKSwZ1seEbdJVPj3+taOaOkZThOlJMob3T6/cMsBUL+M+plGteqlxU0FZz9H9A+CsuVB300lfBiW7lqC18/GKELlcya9gh/W+kGFDEtNuU0PEp2NVyQ7Zfj3sS8feEXRVp/9vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648171; c=relaxed/simple;
	bh=UYkMkJQ4p5fdPkv9qiBJuAlCYelSYAdH4/3FKKm7EkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2yNaEboftYcCECfJBe9FJMG1Oq7ghj//skKwnfnzMxCmgqjiAFXtqxR3B1GlVHxrQoN7gW5Hc4Tws2vMIGTaCsWi8Eun3A8VNvCFL3Gn+GHFhq+osKPPC62v3aBhryGN0VWmhHeFXLQaZLyZ2gY7qI8Aqb/EVBa2WpeE6N7+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb9Sg5/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb9Sg5/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21C11F000E9;
	Tue, 21 Jul 2026 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648169;
	bh=SN8gS+tAo13VqRxHoypS5rVsLj/kBg4c0/Kh9csCcY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sb9Sg5/m9kN9ikzj0qgXhX0R4EXEFAMzcQhK+Gzb6qMAtsLr07vHE0djXDmSCj3jR
	 +aOXWEPXr2YYcV03iuRegLf8tQ48M+ONO37Xkiba7P5Epw8Ngdl2hdD2IPmXj6dN4V
	 noL6wR1Xi2BzOsVO7KAlesVZ2Q2AFBxvYGqWltrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Gary Guo <gary@garyguo.net>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0099/2077] gpu: nova-core: use correct fwsignature for GA100
Date: Tue, 21 Jul 2026 16:56:12 +0200
Message-ID: <20260721152555.027087416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit c1dca0cb0e761568c448a6007855fe5879ad4d37 ]

Although GA100 uses the same GSP-RM firmware as Turing, it has a different
signature specifically for it.

Fixes: 121ea04cd9f2 ("gpu: nova-core: add support for Turing/GA100 fwsignature")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Eliot Courtney <ecourtney@nvidia.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260417191359.1307434-2-ttabi@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/firmware/gsp.rs | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/nova-core/firmware/gsp.rs b/drivers/gpu/nova-core/firmware/gsp.rs
index 2fcc255c3bc81b..c423191b21f018 100644
--- a/drivers/gpu/nova-core/firmware/gsp.rs
+++ b/drivers/gpu/nova-core/firmware/gsp.rs
@@ -138,8 +138,7 @@ impl GspFirmware {
                             ".fwsignature_tu11x"
                         }
                         Architecture::Turing => ".fwsignature_tu10x",
-                        // GA100 uses the same firmware as Turing
-                        Architecture::Ampere if chipset == Chipset::GA100 => ".fwsignature_tu10x",
+                        Architecture::Ampere if chipset == Chipset::GA100 => ".fwsignature_ga100",
                         Architecture::Ampere => ".fwsignature_ga10x",
                         Architecture::Ada => ".fwsignature_ad10x",
                     };
-- 
2.53.0



