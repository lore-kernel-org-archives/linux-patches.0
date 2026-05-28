Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1AD2EF652;
	Thu, 28 May 2026 20:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000999; cv=none; b=eN4W2JaXGYZdjMfYgMfyyhM+erU2rDJ6ogjxXGZuOkPQXxh7s7vfh4VhB1NwCXoM/EQ8PPdVIkgMv8AF4SbAPTmBleEY/o0jbBSp5PHc+yJRaQ6JGwRr7BsulvbHdwdtIERfa3GbF+39ReQcgogDATMSJ7gTAa4THLaVmAZdRUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000999; c=relaxed/simple;
	bh=fvBpg8xixQ84CnGiCGbLobzDjrvCob0JF+GealTZvQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmGz/8kHCXTV06tbOpCH9L5CB8WbMflzbfjIV3gvXg60w8iftN1WyrVf61Q98QQkunoswqXcZzjO9YfjPlghR70dMLQjsjZP002OT7D2eSaheNjTYRoxkA+NznlFgdzor61RIn/mKTkhzNhVKqdHg2khNqMThonhZtYW8zaBP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGDpR4g4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGDpR4g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD0D1F000E9;
	Thu, 28 May 2026 20:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000998;
	bh=+Y9dByTESdEjxcC/2J991HzJp+siXogqO0at63APwOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGDpR4g4cSU3gtoYQEr/Ui2fI6X3VwEk7HWWGZEpYYPt9k58q0l3VcpW5UhrTEqWQ
	 3gDXya++HDT3eE/LVOB8fwDnF4udDs7hUFPzkPjprtYigVqLvWsui/Qw8bI8W5N8rz
	 aoEPFg34IY/zjPiv4I21uK12E24t2qVb9mUTjJMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	=?UTF-8?q?Viktor=20J=C3=A4gersk=C3=BCpper?= <viktor_jaegerskuepper@freenet.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/272] kbuild: pacman-pkg: make "rc" releases adhere to pacman versioning scheme
Date: Thu, 28 May 2026 21:50:17 +0200
Message-ID: <20260528194635.944232855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dca706617adc7..e7a077d483347 100644
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



