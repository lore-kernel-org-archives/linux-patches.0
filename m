Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A3739524B;
	Sat, 12 Sep 2026 08:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201070; cv=none; b=DYwN/wnpnmWfegRIXPaQYJ3xmGoFjxucjHATO+/KjV2A9/55GN8DkWe27F6PC9JFj/5JUKuAkA9S80/HT7TDLDkehvTFYUPeBlB6LjqD7jZKFY5p9UDvA4IxT15ZQNRr7AzANkq+8HcOaaDEw3mSrCClUnEdMvCKbVMEH851pho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201070; c=relaxed/simple;
	bh=Qt05maT4crT7/YZz95TwnEUM5KadaLBIfCLvKrjOUm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Li4Y2JBoS7P7t+V7lnqza8BGAxoDfpUZBlgWpPd07f8WyJ8+VPvwcyLkZqPD4D5vT5q5rrsx61JAfrh0miw6eoriEeEX+TItCfdqLKPlhuHDX3pODXn+EddYE9Edf3XoA3Zg5PlUNBl9NXDLFQr1pZ3v07KCG1zLClfG/m25hC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DghaFyQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DghaFyQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17ED61F000FF;
	Sat, 12 Sep 2026 08:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201068;
	bh=uSAfdGWtuPegkF3NEmEipKpwRvDf18GmOiahgv+ENvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DghaFyQx/SrPW4SE/fMqWTjYljsJyq4vSb/JgsEHqtTKVVkH6GJUeu0N0Uf1Zvfui
	 IhB+ivXkWnamTlUEuKoZW+doC+3/gn8iIQcX4GNx2berW+g0OaitivYszveBzUqhxo
	 11k06cb10KkGWQmUhX2KgELpbuMCIoZQT1Evid9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0921/1815] ASoC: SDCA: Add missing stub for sdca_fdl_free_state()
Date: Sat, 12 Sep 2026 08:44:31 +0200
Message-ID: <20260912065710.552825615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f6970d8535a95c137f05e9ca825072de3b217b88 ]

There should be a stub for sdca_fdl_free_state() for the case FDL
support isn't built into the kernel. Add the missing stub.

Fixes: 0880082c27b6 ("ASoC: SDCA: Remove devm from primary IRQ cleanup")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607291304.FE3mOcJF-lkp@intel.com/
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260730130602.3747053-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sdca_fdl.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/sound/sdca_fdl.h b/include/sound/sdca_fdl.h
index dc33927b82bde..bc3600cdd2ec8 100644
--- a/include/sound/sdca_fdl.h
+++ b/include/sound/sdca_fdl.h
@@ -83,6 +83,10 @@ static inline int sdca_fdl_alloc_state(struct sdca_interrupt *interrupt)
 	return 0;
 }
 
+static inline void sdca_fdl_free_state(struct sdca_interrupt *interrupt)
+{
+}
+
 static inline int sdca_fdl_process(struct sdca_interrupt *interrupt)
 {
 	return 0;
-- 
2.53.0



