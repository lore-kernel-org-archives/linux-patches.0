Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D8BA27;
	Tue, 12 Aug 2025 18:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021812; cv=none; b=W+vg2Tz04Seb3KdgoiebtbFqUDIPRkCGP6TqmddfiCEsNO9yRKc22tR4vncaMXK267X/k3jKCz5WflEdxUhRp+twim/+/nQ5WGbkYYg3qVrBi0YWfg0DwaxtgCVdPQaiYVYM/sd6kyy0cf01NpuvMfm7ZZ7wqz+yxg6lzW9paGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021812; c=relaxed/simple;
	bh=twM+nb8VF6nMbGenMpK7K6HuONn4lyEMIaxp86ipGpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drwfq9yTDphWz7WZW1wy143ChV6jm8q6Lx/z19x+ZmbBX9zlC54hFQTJw8hQyxOexjmEWkuMaa61fuKukUDH2BNs3UEcZWdvn67jypMwGxrdeU2BlwQRY5xlRpqetvwwFfvBVeJHbXRpaxON6AeLHVWSxenSr+CZYB4iAVVarog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubSBKiId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubSBKiId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBE7C4CEF0;
	Tue, 12 Aug 2025 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021812;
	bh=twM+nb8VF6nMbGenMpK7K6HuONn4lyEMIaxp86ipGpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubSBKiIdPZypZN/U4VJXahoS8QnyzsRl6mVGqGDey+30yE2AzvxnaENnSLynUVjNT
	 rJBdzF7Rpswp59ILtSaHc0MPfNWjqhwUuuGWNrjx8mZAHpA5tkfuylkz1OaSJwyzAh
	 U0ytokELi1qTe5VdWQrgvgSE5mi1Ud/r2Few9+gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/262] kconfig: qconf: fix ConfigList::updateListAllforAll()
Date: Tue, 12 Aug 2025 19:29:37 +0200
Message-ID: <20250812173001.178327908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4f3ba3debc08..119997c8bf1f 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -480,7 +480,7 @@ void ConfigList::updateListAllForAll()
 	while (it.hasNext()) {
 		ConfigList *list = it.next();
 
-		list->updateList();
+		list->updateListAll();
 	}
 }
 
-- 
2.39.5



