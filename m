Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09C8352FD0;
	Tue, 26 Aug 2025 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217484; cv=none; b=W2LxR3lOmvqp1jNpfQ3TGwjyTgrp95wVWOlGfxAbdNhBl6F+6tf26YYkziYKJQrvYvVaLDPD2TbN5VmJVF7KAO44s0IgIrQoUemvdA/LaWPs1DtMdI+uzR1nGoGeypwUj2Fu8toSS8nFyWrXpP0QkcWyxAQJEoxyijRGgBXlJ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217484; c=relaxed/simple;
	bh=lyssxg1o8H/1VoV0c36cdNB6CtmV06aJFl7tHHLPx8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kq82fwgUp+4W0EufBfnWVSWd1uC0XeAnEuAOWTj2f76Cqs+XDIn4rNOcAEH636jr8xWKbalXMU7PBMcU4r24dkpX/mxD4WYmN+gmHFFeAWiSDqpa292dkoYAlHgA+LwaAJmS9+7EIPQMhZT/lBkd1JZeyt6ey3VDys3xLn2Jqso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDur+hcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDur+hcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAE5C4CEF1;
	Tue, 26 Aug 2025 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217484;
	bh=lyssxg1o8H/1VoV0c36cdNB6CtmV06aJFl7tHHLPx8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDur+hcHw0tE1+c6Ix+w26ELI8rqUUSpOSnznfT0q4f8oDyCzQkhQnighX5zHDTzR
	 joOO/N5yIB9Zj4YuUe4CcqiREHRlDpKBVfwYrllZaYumfMviTEaAkf4PIaTnkj6UPz
	 0nyDJD0KknxmpRVguqHcJFiwl5ld8lARuADufLkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/523] kconfig: qconf: fix ConfigList::updateListAllforAll()
Date: Tue, 26 Aug 2025 13:06:10 +0200
Message-ID: <20250826110928.420957235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b889fe604e42..1c44c83f61a6 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -476,7 +476,7 @@ void ConfigList::updateListAllForAll()
 	while (it.hasNext()) {
 		ConfigList *list = it.next();
 
-		list->updateList();
+		list->updateListAll();
 	}
 }
 
-- 
2.39.5



