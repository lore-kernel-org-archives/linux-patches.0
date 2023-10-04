Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D164A1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A91C433C7;
	Wed,  4 Oct 2023 18:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442775;
	bh=yLw+O/qkAs3XZ/ccoI/cO/ZBA3JZ4q+5WrQa5HoPens=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xxhm++H2kNPiuWKuvz3OUGvgCUaJzeynbjVKX5Ge3LZvgrRi1ywEBz9Zg3hYJsGSu
	 Ig4k0Xp9czqQGLMT9TPf06SBCjt8+TlSsFJmX7gPBReA0jRgp1s85FKCdBFTf1fBbC
	 +BozpuS3usLwkzVC9k5eroAoulonXIjmREMs/e4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/183] xtensa: boot: dont add include-dirs
Date: Wed,  4 Oct 2023 19:55:36 +0200
Message-ID: <20231004175208.282400266@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 54d3d7d363823782c3444ddc41bb8cf1edc80514 ]

Drop the -I<include-dir> options to prevent build warnings since there
is not boot/include directory:

cc1: warning: arch/xtensa/boot/include: No such file or directory [-Wmissing-include-dirs]

Fixes: 437374e9a950 ("restore arch/{ppc/xtensa}/boot cflags")
Fixes: 4bedea945451 ("xtensa: Architecture support for Tensilica Xtensa Part 2")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Message-Id: <20230920052139.10570-15-rdunlap@infradead.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/boot/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/xtensa/boot/Makefile b/arch/xtensa/boot/Makefile
index a65b7a9ebff28..d8b0fadf429a9 100644
--- a/arch/xtensa/boot/Makefile
+++ b/arch/xtensa/boot/Makefile
@@ -9,8 +9,7 @@
 
 
 # KBUILD_CFLAGS used when building rest of boot (takes effect recursively)
-KBUILD_CFLAGS	+= -fno-builtin -Iarch/$(ARCH)/boot/include
-HOSTFLAGS	+= -Iarch/$(ARCH)/boot/include
+KBUILD_CFLAGS	+= -fno-builtin
 
 subdir-y	:= lib
 targets		+= vmlinux.bin vmlinux.bin.gz
-- 
2.40.1



