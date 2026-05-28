Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1806B2D9787;
	Thu, 28 May 2026 20:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000166; cv=none; b=OtgFYKrJqY7BjUiOP6qzk/itjPM5p1haOJwCZcNe2Cmiv/BKEdz8EsMt+cPb9prnZBwncDUzgF/TRoPZ0RBHhy3kEYO3UkHTffsM65ksW3tddmsI460CA90VsaTwdMf2vwtz9TesUn0NH10iUJjZGBixODEQtsx99d3p+9Ol9tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000166; c=relaxed/simple;
	bh=bh1dw5SpoMPPohMX6hHT1GxH5nyq/n2DISX7F0MJkzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GxY5+tc1SEFO6aOZAsuhF0tPL7r0DN2HHjLJXg0SRva5uwe303AsZ1tQqvuEdghqGLu4edL0q3KXZfGxveHFlAm8ss8OTHSBhQ0G+G+n8QDsm4Ap1ZSSUl+YNDumFAFLwX6J6AU4/hE6VF8qFNjWd6OAjMbPbhFaQu9nYO9bCTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PllSdfd1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PllSdfd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760A31F000E9;
	Thu, 28 May 2026 20:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000165;
	bh=+ntc8T8TZdT3Kqr8qlmzMB46rBYB0iN5ZSlbZqUCCmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PllSdfd1TMHoQTJ8zauoldfDxcjriPWB287rgZgcoONbGdIlrTySuMubz87vWM0wB
	 CU48Vg/7/bzP4aN8h3ykHhUb8O6FIG+CugAB7UCU5xAxeWZiPTOwxtGg7pnFDhV733
	 NWQDKmYyn2VRvtF6dePL847AloSMdW4L27rhgJNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	=?UTF-8?q?Viktor=20J=C3=A4gersk=C3=BCpper?= <viktor_jaegerskuepper@freenet.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 326/377] kbuild: pacman-pkg: make "rc" releases adhere to pacman versioning scheme
Date: Thu, 28 May 2026 21:49:24 +0200
Message-ID: <20260528194647.848496458@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>

[ Upstream commit 202550713128da20d9381d6d2dc0f6b73839f434 ]

The package versioning scheme does not enable smooth upgrades from "rc"
releases to the corresponding stable releases (e.g. 7.0.0-rc7 -> 7.0.0)
because pacman considers that a downgrade due to the underscore in
pkgver (e.g. 7.0.0_rc7), see e.g. vercmp(8) for an explanation of the
package version comparison used by pacman. Package versions which are
derived from said releases (e.g. built from git revisions) are
similarly affected. Fix this by modifying pkgver in order to remove the
hyphen from kernel versions containing "-rcN", where N is a
non-negative integer.

Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260515215913.92481-1-viktor_jaegerskuepper@freenet.de
Fixes: c8578539deba ("kbuild: add script and target to generate pacman package")
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/PKGBUILD | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/PKGBUILD b/scripts/package/PKGBUILD
index 452374d63c244..1213c8e04671e 100644
--- a/scripts/package/PKGBUILD
+++ b/scripts/package/PKGBUILD
@@ -10,7 +10,7 @@ for pkg in $_extrapackages; do
 	pkgname+=("${pkgbase}-${pkg}")
 done
 
-pkgver="${KERNELRELEASE//-/_}"
+pkgver="$(echo "${KERNELRELEASE}" | sed 's/-\(rc[0-9]\+\)/\1/;s/-/_/g')"
 # The PKGBUILD is evaluated multiple times.
 # Running scripts/build-version from here would introduce inconsistencies.
 pkgrel="${KBUILD_REVISION}"
-- 
2.53.0



