Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E308F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BBAC433C7;
	Sun, 16 Jul 2023 20:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538680;
	bh=sWBueieJqdX6m0TbcW81A0xTvN7ScSLN5EVttWTB0Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GufEFlAxgaDuL8jlNpcXukKMZfjf20A8eiDGGhyswQT54seWpT+sOz/EjcGAHvOLR
	 jQNmkchR1bJP3h0cnqA+wWqI/k5d73i38xpzcdevOduSbup/+6Mz7rppBxneCaeI+9
	 MZaD/2amzmTES1q6ZSWlZxywX5zjjGlw0xCUDEec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Triplett <josh@joshtriplett.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 538/800] kbuild: builddeb: always make modules_install, to install modules.builtin*
Date: Sun, 16 Jul 2023 21:46:31 +0200
Message-ID: <20230716195001.589520199@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit 4243afdb932677a03770753be8c54b3190a512e8 ]

Even for a non-modular kernel, the kernel builds modules.builtin and
modules.builtin.modinfo, with information about the built-in modules.
Tools such as initramfs-tools need these files to build a working
initramfs on some systems, such as those requiring firmware.

Now that `make modules_install` works even in non-modular kernels and
installs these files, unconditionally invoke it when building a Debian
package.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: 1240dabe8d58 ("kbuild: deb-pkg: remove the CONFIG_MODULES check in buildeb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/builddeb | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 252faaa5561cc..f500e39101581 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -62,8 +62,8 @@ install_linux_image () {
 		${MAKE} -f ${srctree}/Makefile INSTALL_DTBS_PATH="${pdir}/usr/lib/linux-image-${KERNELRELEASE}" dtbs_install
 	fi
 
+	${MAKE} -f ${srctree}/Makefile INSTALL_MOD_PATH="${pdir}" modules_install
 	if is_enabled CONFIG_MODULES; then
-		${MAKE} -f ${srctree}/Makefile INSTALL_MOD_PATH="${pdir}" modules_install
 		rm -f "${pdir}/lib/modules/${KERNELRELEASE}/build"
 		rm -f "${pdir}/lib/modules/${KERNELRELEASE}/source"
 		if [ "${SRCARCH}" = um ] ; then
-- 
2.39.2



