Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CF63FFFAF;
	Tue, 21 Jul 2026 17:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655968; cv=none; b=crjN0nqQYFkDp1o81zDM7nl6AZG+J96/Nejl3ywHDrolPkDJDBNTOk2+UDpDleTVlPFHUflVk7oGsI6YXor5zHYsed7RutLlQW4Gkn+IQFfA7PaNjcIJDX9p4kllflK6pVHNBr7nr6Kuqmf7JVn02QublFodko2zE7Q1rgPnybI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655968; c=relaxed/simple;
	bh=1vSthWRLVIYu5Zys5/gKK9y+PrlTezTkRkRibmQwZAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLw2QLLMtYr1LHlsIgcx9FZ1y/+fsCerA7LflgrHG4LR+ewecHzu9DTXDMhOfpP12yMVAe4GNDX5CrCD0DYIAN8y/GmKDVhYdeXSO7ng0lvEz2CrfkwtQuByDvlJIYZZWk3D0T0C/p7gFQbvxclGw+c8lZghRENkJMWuO3lRfRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s19XKzRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s19XKzRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7803E1F00A3D;
	Tue, 21 Jul 2026 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655967;
	bh=MdIE8Qwh5N31doYGMupXa8qgpzlDOzwLsWXliqU+cv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s19XKzRZRx3nfjaf6PvcEWnu1qOE5PGuceZZcqeRVuTvteEUVHu1WKznFfDE16+YK
	 kHyoZABGNgoGTxBjAEIEGqTfMBjyv6UUO/mXqeBwFDszrFxR37UXKzRLudqqDd02Dm
	 b4ACvYhFvZwCtPiI2uTZrzRAtX9ePkc5DXSTF/qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0209/1611] gpu: nova-core: vbios: stop scanning at BIOS_MAX_SCAN_LEN
Date: Tue, 21 Jul 2026 17:05:25 +0200
Message-ID: <20260721152519.670073848@linuxfoundation.org>
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

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit fc7c1054b6f983ae2f3e100a24cc87908ae9f4b7 ]

Current code lets `current_offset` go to `BIOS_MAX_SCAN_LEN` which is
one byte too far.

Fixes: 6fda04e7f0cd ("gpu: nova-core: vbios: Add base support for VBIOS construction and iteration")
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260525-fix-vbios-v5-1-e5e455251537@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/vbios.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index 71fbe71b84db9d..b19c577e3a2320 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -146,7 +146,7 @@ impl<'a> Iterator for VbiosIterator<'a> {
             return None;
         }
 
-        if self.current_offset > BIOS_MAX_SCAN_LEN {
+        if self.current_offset >= BIOS_MAX_SCAN_LEN {
             dev_err!(self.dev, "Error: exceeded BIOS scan limit, stopping scan\n");
             return None;
         }
-- 
2.53.0



