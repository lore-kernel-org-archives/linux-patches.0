Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C01B4409;
	Mon, 23 Jun 2025 22:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716105; cv=none; b=RG2bdT0KwuImHUA3+aIK6xiS6NKjj7kydckd+y+d/SY78bBOf67mnkJF7aR+MNRAnPdkmmeHLNkwXs8aFnWfslDlAkYqbvdcX/HquMWtcF8L8NypI09T6bmJlLxNgDh39uyMnmpWQcNlvTkjpP9Z5NLUp7VrzN+KslPUfudQYpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716105; c=relaxed/simple;
	bh=dQuF50X8fPcqKn9+kJ0GW0QM2vB3QIslsyld30FW1O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMsz5XloVOhK8tp0r/d8PeDbtKcXPhmsf5l1ZSsRvxvEfsZpCjiHOge/zAAMqnjZC0yEuNddqdBLxJeOg/zVlsH1M7+9C00YRl96gch/wIknxTx/rUYu62iDpqAdNMRiTBd93uDhgguV712uL8ro5q/mCl0A3KuBbcgrFvbwFRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Moeh76n+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Moeh76n+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B59C4CEEA;
	Mon, 23 Jun 2025 22:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716105;
	bh=dQuF50X8fPcqKn9+kJ0GW0QM2vB3QIslsyld30FW1O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Moeh76n+FAE/Mzsu0j5PhjUgh+keTn7gUzwrQW2Tu5Onr99JwBTKq/6nxSDG7Evdo
	 xFvdWj/Q2dIM8EhRo8o/jvjCUrfWWEISy6lCyTU81mUO8I/eE3akoCM/DZlE73RuGu
	 kjYxLt49FSvAb8+sy0fjmLRqxKU0dnnspb2VqBec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.15 502/592] drm/xe/svm: Fix regression disallowing 64K SVM migration
Date: Mon, 23 Jun 2025 15:07:40 +0200
Message-ID: <20250623130712.374242998@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Maarten Lankhorst <dev@lankhorst.se>

commit d6fb4f01736a1d18cc981eb04fa2907a7121fc27 upstream.

When changing the condition from >= SZ_64K, it was changed to <= SZ_64K.
This disallows migration of 64K, which is the exact minimum allowed.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5057
Fixes: 794f5493f518 ("drm/xe: Strict migration policy for atomic SVM faults")
Cc: stable@vger.kernel.org
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Link: https://lore.kernel.org/r/20250521090102.2965100-1-dev@lankhorst.se
(cherry picked from commit 531bef26d189b28bf0d694878c0e064b30990b6c)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -750,7 +750,7 @@ static bool xe_svm_range_needs_migrate_t
 		return false;
 	}
 
-	if (range_size <= SZ_64K && !supports_4K_migration(vm->xe)) {
+	if (range_size < SZ_64K && !supports_4K_migration(vm->xe)) {
 		drm_dbg(&vm->xe->drm, "Platform doesn't support SZ_4K range migration\n");
 		return false;
 	}


