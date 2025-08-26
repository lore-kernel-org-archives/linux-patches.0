Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95582BEC45;
	Tue, 26 Aug 2025 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215929; cv=none; b=Xh7ce7NaiBWh/U70wN3bHGaZdGZBuQH72yOHe2WxDxWXMWCixLx3Il2UUYnf5ktlHywisXhU3WfcOUwK+jxm/Rh7q51sQcutIy0PjdeBbsec+wyRW+WIutEQKV3XFJYhfjNbyx/Dm0Fd7gyQDTNrgXcjrykEgdh45fYIssN+zm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215929; c=relaxed/simple;
	bh=8OvbNbfE0Ss6xhCrFskhLG9kPzS3Ky0IPp74pg4Rghs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8VBj99Y/arBiNOU1XTUiH6rcAfdXUfrYAuAvdr0XVAUJBWAJzR/Qx3aRtHp+0pdVCbkhwxU3ERC6gxQ4VQz5uHKjZBhmm2DZlIcdqATu5AJpXnBmZ2FzOJ7Z1Ibo3f/pY+slC7hKEIe4kuag+DDdKLE2IVHIJAzZUNCsDo4cz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtquXOeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtquXOeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B961C4CEF1;
	Tue, 26 Aug 2025 13:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215929;
	bh=8OvbNbfE0Ss6xhCrFskhLG9kPzS3Ky0IPp74pg4Rghs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtquXOeYdFfxfuorwBeJ4Yg7+Ch8pRiWQ7OUrIDbaNwMbXuEuUh4Y+S8+mqbg6F1j
	 c43z0a419b+ZKuHhuk8CYlJsAv4U3uDTXQc/1J0ZG9tUUMqPF1YdfZ5Cd4FDDrDdDV
	 HRWDVqJD0emX4g1IZnr1/YDZi9GpwFDgWuHqcNLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/644] kconfig: qconf: fix ConfigList::updateListAllforAll()
Date: Tue, 26 Aug 2025 13:05:10 +0200
Message-ID: <20250826110951.854503838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 721bfe583c52ba1ea74b3736a31a9dcfe6dd6d95 ]

ConfigList::updateListForAll() and ConfigList::updateListAllforAll()
are identical.

Commit f9b918fae678 ("kconfig: qconf: move ConfigView::updateList(All)
to ConfigList class") was a misconversion.

Fixes: f9b918fae678 ("kconfig: qconf: move ConfigView::updateList(All) to ConfigList class")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/qconf.cc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 61b679f6c2f2..c31dead186cc 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -478,7 +478,7 @@ void ConfigList::updateListAllForAll()
 	while (it.hasNext()) {
 		ConfigList *list = it.next();
 
-		list->updateList();
+		list->updateListAll();
 	}
 }
 
-- 
2.39.5



