Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0603A6BB5B;
	Tue, 12 Aug 2025 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022838; cv=none; b=czxsahkLQpHL0T+2iKvLqcyqUEzdZFoZ5lIR/+y3SkuEPeBYruIReN3BelHJa/kO20RvyXmakhxxSwmgrYJAP9YRXdlHxE9L/QSDObIbg5a/+rjAnQCkNHSgP3R8eDERDrieee2DRz+U+uUQpg8Xtww3sOwGnaUFz10q/uA3mGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022838; c=relaxed/simple;
	bh=IOtoA3qcHhtfcBZCESWCO8ZhsUcKrRvPWl11LqAD3R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKH3fxbb95LbDHvI+s7bw0cwqP0cQrO/4JWa4qQm0E9CfDCWLSqfimnhP36vluRgZhy51bmIyTbE9TuZpqnNROeyx3WcgbEOdtrMDQRqfGt6/ioDEYvzEeOefR+otsP6vYqVvXhS6zkX3qs5PQdyRXmg1H6Ar7oU1VTQcilQu1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gb62gLXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gb62gLXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C45C4CEF1;
	Tue, 12 Aug 2025 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022837;
	bh=IOtoA3qcHhtfcBZCESWCO8ZhsUcKrRvPWl11LqAD3R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gb62gLXquQnyczYh720eotu4aI84FX1vf6M0LeCi7AmHO3Tx7+SMv+9d32xL2UenW
	 6du6qP/qs0LmYqSTqrX8O6TowJO0tzTZFO2rUZ3UtNj6aAbY+Kz7auUOFlxHRQnf3N
	 TiCtA0qfJ4/MZ3vBXXq1oFMDXoRpnRekiPvmCt90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/369] kconfig: qconf: fix ConfigList::updateListAllforAll()
Date: Tue, 12 Aug 2025 19:29:30 +0200
Message-ID: <20250812173025.244480681@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e260cab1c2af..4b375abda772 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -481,7 +481,7 @@ void ConfigList::updateListAllForAll()
 	while (it.hasNext()) {
 		ConfigList *list = it.next();
 
-		list->updateList();
+		list->updateListAll();
 	}
 }
 
-- 
2.39.5



