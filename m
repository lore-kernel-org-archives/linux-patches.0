Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18768BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BF7C433EF;
	Tue,  7 Mar 2023 18:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213422;
	bh=65L7r7KkuKdNh2+PpDwe3TFSMNcLF7zCCeHEDyVM7io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJtmgJKsYQ/HGyr2tYVzbrHE7NEWLhazHJQMmhu/JbnFkcJHkQUKUd5Xz1Vh717QF
	 d/BBwdTntGwYMQqmNJqgJz8775it/soKP2rwJruD3ypOBRlqpsYCF0VxDPOPI4tASH
	 IVQzjaFm9kqhg8bhn9aOUhX1Q0p7Nqdo2g22TBxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastian Germann <bage@linutronix.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 500/885] builddeb: clean generated package content
Date: Tue,  7 Mar 2023 17:57:14 +0100
Message-Id: <20230307170024.182721485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index a3ac5a716e9fc..5be7e627e7513 100755
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



