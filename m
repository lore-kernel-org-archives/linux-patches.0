Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EFF305E13;
	Tue, 12 Aug 2025 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024857; cv=none; b=E65bEZF3uJB+5RyT2601vKY6ztsxte47fQ3xUElejSKWC1BRd41wHmzIHPybgGaWuHO7ko6kzETX4nt1SAWA5m+fYhI/y2/X+nmZdyGu7EVVAZ3InuEmnxC7PTjkb1DD2EDO9fh1L14iG96ESPEK9qU2SYtYwR2IhKBqJeSgE9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024857; c=relaxed/simple;
	bh=YcbAyCD8iiKZDSC3cdOyRxFdiWcHgxJpXRystfPFgjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yri7QBhY6O92PPWO2MLDxxC5O5JKe/Xq0pC0mpdn9XM4730gumGEPmOARdjv3suoJ/cmEtxNAsh85kAJ67Ox+RDO9rFsUl2d7jr907tw/Kr2UvP95jEG6suqCt77e7l5XQUD5UHfArEfo02Y1XJAo6ROGn/9/qnbpVAJMvgCj5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQrYMKsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQrYMKsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46F4C4CEF1;
	Tue, 12 Aug 2025 18:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024857;
	bh=YcbAyCD8iiKZDSC3cdOyRxFdiWcHgxJpXRystfPFgjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQrYMKsqiYYsEqyXpgnyXnVGWKnVNTOHlsaczu0FRPFjZedB/teAs4uXJ5rGerXzv
	 mib93S2i6SdC1orsGYmi9PYBTGr5Fz+6tTqLI+kiyuqiEWr4qYA0mMEemtevpt0R0e
	 LZTQCDznsgoaWO0vpcpq3DNKdCsd58cs1maIrSis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 498/627] kconfig: qconf: fix ConfigList::updateListAllforAll()
Date: Tue, 12 Aug 2025 19:33:13 +0200
Message-ID: <20250812173446.734166052@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index eaa465b0ccf9..49607555d343 100644
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



