Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC71344DAC;
	Thu, 28 May 2026 20:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999033; cv=none; b=qrIxszbOvigijqk50vglLLiyzLUyVdhKACqZTNxAG2c6x7RDvD2g4EFed3MpQQWovcW/2iB7V4Jzbl/kqJqpQYRYn1R9oapIVUCA4R+aq4CoaVP33BAvEjYOul7aSVWNg8zxloP/LBhE230ttw3TJo7dS9SvH0UuC97rbTbIwjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999033; c=relaxed/simple;
	bh=N/gxprgtxFCuZqvV7v3B4b3FpxZSYr3ywO4OsHtcmkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kFX0uC598jDaNEFEhsp096J5jlHn2PrJY7+C8I6YFn3E4jhTQDm4LCIctzxn10Y2r5CX3s3RPN0aRiDCROP+3xkSN6YUxJ2k01QItFjsWzs3T/rjxCfxWXiAwUooKtYtaSkKlLxSGqX9ZsxDouAX1MSAI48jJFFKWNM0a9k5UIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1J4Rc8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1J4Rc8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0F61F000E9;
	Thu, 28 May 2026 20:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999032;
	bh=pSg25hCTduxgMzlzTuwhGkqE80MkfIrKIj/Dd8ByjMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1J4Rc8Ihkxj9CO+I2lBbwRQs2wZLITdh9hkXeSbPgpwD/0TMynwctyUhOkRDsEom
	 Xi0XJZKSgljiyur7glgJ8Bcc1IZzn3PzEjDJTWWUNyTJw05faB5N1vSYW3v6X55fhj
	 P60MGd4JSx2p46yOEUB22+sOdWoHE4w8pkYMKsMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	=?UTF-8?q?Viktor=20J=C3=A4gersk=C3=BCpper?= <viktor_jaegerskuepper@freenet.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 383/461] kbuild: pacman-pkg: make "rc" releases adhere to pacman versioning scheme
Date: Thu, 28 May 2026 21:48:32 +0200
Message-ID: <20260528194658.542735620@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



