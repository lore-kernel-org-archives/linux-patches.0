Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C4E29BDB7;
	Tue, 12 Aug 2025 19:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026662; cv=none; b=VGCNrDPySN32rDcygOyhdHS4FatG1kPxpAMgnH7jZgbIQM3NY6mZaqHNvw8gqv0Lu297e6o0/72RD/7c2hC1Q4uI7fXj3Gt0czZfQOkB8Jc1nAn0v/K7ii++7GbV10hjo30dn2Iefb+/VMY4xtCPzFvMsFsceQuAfgwUJIcAfCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026662; c=relaxed/simple;
	bh=HtMlyEkhbERkla+AvLrTXpLbVDcUraqlTQOOttK+FWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6DEBOlxpJSSaTYVCIZ2wcA9r3j2gO2s4dzWzwnWS2/YN6iMn+LIJZVWpAo5R9FPpidylByYy/nRpuJgtaENba3N6V/SRQcVlCJB7CH1x1Aldl2b0SOQB86YbKtLjJC13ju7UfM27myfeoBaxkaBHdS8RYXb+wED1wKdeCHb730=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anTjKzav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anTjKzav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A38C4CEF0;
	Tue, 12 Aug 2025 19:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026662;
	bh=HtMlyEkhbERkla+AvLrTXpLbVDcUraqlTQOOttK+FWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anTjKzavR0T2lr4emedEeTKOC8bzaTZtMxCAicPvQAO5WeDMzTf6RDE5lrcYFPJmW
	 kCua3y1XujEGtT2/rJj91bWom2nQPPun9Qn9sie6noLVqG2yG3RpmNqWyKZIc9o5kI
	 v3H9H2X8R3o2lzDl/y9dXYGFCUVJbvwAxFop+U1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 370/480] kconfig: qconf: fix ConfigList::updateListAllforAll()
Date: Tue, 12 Aug 2025 19:49:38 +0200
Message-ID: <20250812174412.690065929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



