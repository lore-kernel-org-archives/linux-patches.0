Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0978A385D7F;
	Sat, 12 Sep 2026 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238524; cv=none; b=To/0JY0AmPJWSYbFjGNKZz0sr1Jy73uwQBi/W320Yn3KFCC5YuwFtyV7dWETe2gJz4LiKSOGR6jOK2oIFva5o2JdRd74VljyAss3h20B/iGlDgI9NbMObV9VHnfMOqsAwQt/o3REDc9+RvHwp2ooJlDdYjTwEaKVLE92zX6w6ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238524; c=relaxed/simple;
	bh=Isi6miIG5lmYAdeRBDSB5UfMBp6DNTu0ozfXqkXcCJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsqRYwXv35Fv8SqHf9+R17vOFKIrsWHQD1Vp+hvNsphtp+yxQraISWmVd+6+LWpeQWGCrWvEiimU9ovi6J89hwMoDOGZW8gztBT5bTy1zat9kuxavczu8Iri06wBA0AHqXoBgud3JpbIf4RQZZ7/7y+KnTM4j+zd3juF7I3+kw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wk2knrmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wk2knrmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4F41F000FF;
	Sat, 12 Sep 2026 18:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238522;
	bh=3fN3W82S/AQN9LEum9+fxVBsHO3SpxDTBCbp4XblGlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wk2knrmPA/LW7OqK0XT5Kgky2MUYrYZeXbtV+0NWfJ36udqoGORTjRk1AVMlveNMz
	 rAAg9ZGb2bHwnHYvrzmxLaEFoSwtTrspWJK7pTlzhDBxv7C3KkihQ4k52Zkyh3UAwD
	 FgZJPZzP7y+zcZkOC7YiuuTuOYumVhVsF/DKK/7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 478/935] efi: fix stale reference to efi_recover_from_page_fault()
Date: Sat, 12 Sep 2026 08:58:28 +0200
Message-ID: <20260912065537.788645712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 718ee46ba4d95d28d50d3f6437afbbe2be531175 ]

efi_recover_from_page_fault() was renamed to
efi_crash_gracefully_on_page_fault(), but the comment above enum
efi_rts_ids was not updated. Use the current name.

Fixes: c46f52231e79 ("x86/{fault,efi}: Fix and rename efi_recover_from_page_fault()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/efi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5d832ff22dc28..1dfce63532c58 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1183,8 +1183,8 @@ extern unsigned long rci2_table_phys;
 
 /*
  * efi_runtime_service() function identifiers.
- * "NONE" is used by efi_recover_from_page_fault() to check if the page
- * fault happened while executing an efi runtime service.
+ * "NONE" is used by efi_crash_gracefully_on_page_fault() to check if the
+ * page fault happened while executing an efi runtime service.
  */
 enum efi_rts_ids {
 	EFI_NONE,
-- 
2.53.0



