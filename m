Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBB52FABFF;
	Tue, 12 Aug 2025 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021057; cv=none; b=fk8S97aHC8j2FIcYXVTUFjX0tFVlwT2HlA17CbFXBotxLtWQOg3fIkXSIiknWPL5z72ex00y42+8sDm/trL2qvRcjO/ACtjHEyLAT1+QTzkZBZlRc9X8JSfGcc/skILvkcOnKifh03sBu3UUnuiUPEGSZ5QZieSXSkHjJRyJqpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021057; c=relaxed/simple;
	bh=f6gSJ0DZTqzeD5x2LSye1HoC2eeFBEUzr1j5kYCvwjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8H+Bg5Zfk51JOuvN6A0ROgYaGIqfdK9RZqqJBg70BHD4LwW3czJ+BdI0jlLW8C2wMtYxblmnw7qWA2ENNy66F/k1RYCJ0LqNARrbH/SexFUNYiPXKfxJJy1smA0XmUnvcsjiXYWXrgQ4qb2Yt8pOB8EM/Dl1NLlqjLbvhpvHoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EtOfDFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EtOfDFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3698C4CEF0;
	Tue, 12 Aug 2025 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021057;
	bh=f6gSJ0DZTqzeD5x2LSye1HoC2eeFBEUzr1j5kYCvwjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2EtOfDFZ3Y8VomexEkZ9jingA3c11Ux7kSX/PRpdaVL4RgxGYn/YFXveX8pcrIF+y
	 p5+zo8pHETL5243lAzK0ofR/+lBIwtj5no23bhPZ1EFZKk3T86VHiLugr32Xtj/r+w
	 PNpPyk+gqddc+89W55iIiColZiPVBdrBIcmptkTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/253] kconfig: qconf: fix ConfigList::updateListAllforAll()
Date: Tue, 12 Aug 2025 19:29:53 +0200
Message-ID: <20250812172957.549340869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



