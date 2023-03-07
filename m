Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B456BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BFFC433EF;
	Tue,  7 Mar 2023 19:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215713;
	bh=MDrfGfSgoBEGqplHjaBJsPg8MbP5AfXhL9GYLigsNlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtmnWyvWYCZVoS3O3v03oDVXz0FSXzwzaFQ+294b0PWIAT3UlvPnytQu5Tgpm9OgT
	 Zykd5xS1WsflOyTu2Wcsyz2ekJ0IVdkvZ/YKRPd0KPhxPQNIAZVJA5t0RvAcfw+UvQ
	 +ijktRrsO3i9zTqswxLgSsf+/DJu9MaUrd0GZvGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastian Germann <bage@linutronix.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/567] builddeb: clean generated package content
Date: Tue,  7 Mar 2023 18:01:26 +0100
Message-Id: <20230307165921.029141501@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bastian Germann <bage@linutronix.de>

[ Upstream commit c9f9cf2560e40b62015c6c4a04be60f55ce5240e ]

For each binary Debian package, a directory with the package name is
created in the debian directory. Correct the generated file matches in the
package's clean target, which were renamed without adjusting the target.

Fixes: 1694e94e4f46 ("builddeb: match temporary directory name to the package name")
Signed-off-by: Bastian Germann <bage@linutronix.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/mkdebian | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/mkdebian b/scripts/package/mkdebian
index 60a2a63a5e900..32d528a367868 100755
--- a/scripts/package/mkdebian
+++ b/scripts/package/mkdebian
@@ -236,7 +236,7 @@ binary-arch: build-arch
 	KBUILD_BUILD_VERSION=${revision} -f \$(srctree)/Makefile intdeb-pkg
 
 clean:
-	rm -rf debian/*tmp debian/files
+	rm -rf debian/files debian/linux-*
 	\$(MAKE) clean
 
 binary: binary-arch
-- 
2.39.2



