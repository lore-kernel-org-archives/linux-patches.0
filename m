Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208E155352;
	Mon,  6 Jan 2025 15:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177945; cv=none; b=u4Z12Weoa/PXvRyc9H3Ke+vXY2BTWpGRK/ffy4dpk8WZc8j83s/M4I3vMw3xNEHsvr95jbRHdV3eEfGq/nwunmu4H8u0N5LAGWiFwj5Gc0e7ESgr8GI8ZLAF6sDmE3t8FxmjKPb4Tfc3ovoalVZNB0KgDe9/ZAA0PKMzLPSgFuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177945; c=relaxed/simple;
	bh=8xnX6lzT+zuu5m6aJe96Cf7pkGRciPydmfpWMs3mkBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5XU9H3ZV/XgApO2gWCVlA4pyARuhv5rZ9GrlU8/paCjr/dv7qmYHeY/HtuCavn0DzzWgM22JTZxLpJP47vpLdq5Hi4I6ZIaixjjAoNR3QmKjxQuXQx8+8KEbzmH1/ZmaPg5RoJh7EZOJoU5mHVHykQSSvO/z+smke8fC34iemE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwMkkA5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwMkkA5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FBCC4CED2;
	Mon,  6 Jan 2025 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177944;
	bh=8xnX6lzT+zuu5m6aJe96Cf7pkGRciPydmfpWMs3mkBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwMkkA5YuuIVx6eFQ/bIDT1sDlmIzwpwIhNZq/Uf+PHWJ2cJsbFk5rGBHDCCgvJY2
	 1u/xnF5U3aghf++5sN+1gkBCKbbppQltovx6L8XnEDtckHUAWyNGmJ80XQ6wHOjtnL
	 KTZCiemUpGbieo0wtA/ECM4T8nl1zL4IgjYFiOq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/156] kbuild: pacman-pkg: provide versioned linux-api-headers package
Date: Mon,  6 Jan 2025 16:16:35 +0100
Message-ID: <20250106151145.833430706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 385443057f475e775fe1c66e77d4be9727f40973 ]

The Arch Linux glibc package contains a versioned dependency on
"linux-api-headers". If the linux-api-headers package provided by
pacman-pkg does not specify an explicit version this dependency is not
satisfied.
Fix the dependency by providing an explicit version.

Fixes: c8578539deba ("kbuild: add script and target to generate pacman package")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/PKGBUILD | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/PKGBUILD b/scripts/package/PKGBUILD
index f83493838cf9..dca706617adc 100644
--- a/scripts/package/PKGBUILD
+++ b/scripts/package/PKGBUILD
@@ -103,7 +103,7 @@ _package-headers() {
 
 _package-api-headers() {
 	pkgdesc="Kernel headers sanitized for use in userspace"
-	provides=(linux-api-headers)
+	provides=(linux-api-headers="${pkgver}")
 	conflicts=(linux-api-headers)
 
 	_prologue
-- 
2.39.5



