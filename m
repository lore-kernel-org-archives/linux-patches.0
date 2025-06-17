Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5749A2FA624;
	Tue, 17 Jun 2025 16:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179040; cv=none; b=G4U3G/rLTDc9tZ0V7u+bKqSxZi/k8A0azJD/qSwlWo8OEKKYOOzrbqADvEn+EAWqYBfkZGGXh7i8s+ZJGQyGM4bqzj0lo4ii221tLUO4Edry2mYIQsGzHJRXq8QhKzXg8TNGbgIIVSC8cZGVMudizSwAgKebk1ZTGo44w5dPYxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179040; c=relaxed/simple;
	bh=eOwLZ8ZDWuzc4LdFgN3c/RpwKTVqu4usey1RcgSkSdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F10fJjjogJ6c8CFlxPxPWlhElK4d7Ju1Va3Tqvko03JeLmXdv1yCmmDAHiAn2zomBXSFChU8S2Mvy3/PPaxrlMPACtJN0lz0hm1Ffw5cfqjjWAaAqeE32up4PJFRkmDJubhwMixT1RpJGMyPXi8mv/wiVflUf65ZXSyNssLOYcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0X5uIna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0X5uIna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AF6C4CEE3;
	Tue, 17 Jun 2025 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179040;
	bh=eOwLZ8ZDWuzc4LdFgN3c/RpwKTVqu4usey1RcgSkSdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0X5uInad6vmvuJdBVP6hbV/KFXKGTkkPKx62nVl8NmCT/WyfMRv28RBVDT8hnx/B
	 cz/5KeDhSeesZlHbEefVxUFh5i6rebvpkF3XbCWbqiDylzTb8E8v8mZ8EBpCrwAKmC
	 RqkYIs9yecWQ5UzQQj+z58U+X0nTDEfbFIH6zaNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 629/780] drm/xe/pxp: Use the correct define in the set_property_funcs array
Date: Tue, 17 Jun 2025 17:25:37 +0200
Message-ID: <20250617152517.090842716@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 6bf4d5649230ca65725ec4793333fb5eba18d646 ]

The define of the extension type was accidentally used instead of the
one of the property itself. They're both zero, so no functional issue,
but we should use the correct define for code correctness.

Fixes: 41a97c4a1294 ("drm/xe/pxp/uapi: Add API to mark a BO as using PXP")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://lore.kernel.org/r/20250522225401.3953243-6-daniele.ceraolospurio@intel.com
(cherry picked from commit 1d891ee820fd0fbb4101eacb0d922b5050a24933)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index b98526d271f2f..5922302c3e00c 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -2396,7 +2396,7 @@ typedef int (*xe_gem_create_set_property_fn)(struct xe_device *xe,
 					     u64 value);
 
 static const xe_gem_create_set_property_fn gem_create_set_property_funcs[] = {
-	[DRM_XE_GEM_CREATE_EXTENSION_SET_PROPERTY] = gem_create_set_pxp_type,
+	[DRM_XE_GEM_CREATE_SET_PROPERTY_PXP_TYPE] = gem_create_set_pxp_type,
 };
 
 static int gem_create_user_ext_set_property(struct xe_device *xe,
-- 
2.39.5



