Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380347461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F71C433C7;
	Sun, 17 Sep 2023 20:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981199;
	bh=dLuQlRInJK+YRELW2Uf3eIp76RyqlKUDWoi3TGwr9xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YwGetfnuRqkJP9Di+wH1BEpOYMqVdjAJUUL6cB8HG/O6+n+CLVn+S+uCVozJ4Uf/
	 bHR6MrpaYKieNp8ZvOWBUt6H/eVjtMs1R+ZjdaoFC6VK0Yaq1cP3uc8FTZeNqX3h+H
	 UpsJXRZ3iJ6DSYSUrSd56MyHX9JOdcXap7Zv8Dis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/219] kbuild: rpm-pkg: define _arch conditionally
Date: Sun, 17 Sep 2023 21:13:03 +0200
Message-ID: <20230917191043.038880642@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 233046a2afd12a4f699305b92ee634eebf1e4f31 ]

Commit 3089b2be0cce ("kbuild: rpm-pkg: fix build error when _arch is
undefined") does not work as intended; _arch is always defined as
$UTS_MACHINE.

The intention was to define _arch to $UTS_MACHINE only when it is not
defined.

Fixes: 3089b2be0cce ("kbuild: rpm-pkg: fix build error when _arch is undefined")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/mkspec | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 70392fd2fd29c..f892cf8e37f03 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -51,7 +51,7 @@ $S	Source: kernel-$__KERNELRELEASE.tar.gz
 	Provides: $PROVIDES
 	# $UTS_MACHINE as a fallback of _arch in case
 	# /usr/lib/rpm/platform/*/macros was not included.
-	%define _arch %{?_arch:$UTS_MACHINE}
+	%{!?_arch: %define _arch $UTS_MACHINE}
 	%define __spec_install_post /usr/lib/rpm/brp-compress || :
 	%define debug_package %{nil}
 
-- 
2.40.1



