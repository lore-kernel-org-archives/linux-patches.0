Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0483415696E;
	Thu, 12 Dec 2024 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025057; cv=none; b=RdOq34o+TrkqumDKxozL9LUF2dD/zWqG7n6lTv3cZNQeq2pBtdZ7KMsfo2jEo4rutb8mgn/JMXiphMGkF7QshsZkulT9iFKNLrAY64nq3ItjH4XrlzgL5ka1yQUU40G6OrvHeXsu5eIZaM8tDV/Tpqz78EGJLYn5MFzsKIXyrTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025057; c=relaxed/simple;
	bh=XF78K/OpJC6b7MBW2Py19Wda77QU0OLrYFKZXr+c37k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PneaA6PTTIpEbtT6oxn58v48EL3dqmeT4mxwB6B1hXfG7G6YBG4v0Yos7xuuHVpxATF7UdlICO+B7k/r1/wAy/6blIQQ6AyPor5iHC1b7BnVmHJsm/5z1PmBuH1dO2PAJrcBmjQedcfNzbPYlo8DOSu5zv21KYaur9vqN+2jS84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpGY9c8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpGY9c8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4B0C4CECE;
	Thu, 12 Dec 2024 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025056;
	bh=XF78K/OpJC6b7MBW2Py19Wda77QU0OLrYFKZXr+c37k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpGY9c8ekXktjwcLFLrG/0ZKejFR6bQpH/xpqaA/CmEwfRp3UXN7eS+X+EL1jGzdj
	 /Jw5ituH8tJ+OL38k1iBsXpgXMDQT+lqIy0VZTHxwXBNEpVOLuqklxLVdNaxeEnXhU
	 5MJHA7GLPh0uHONz5BHO/EOCx8b8Ai5oI0AMtpnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 011/321] kbuild: Use uname for LINUX_COMPILE_HOST detection
Date: Thu, 12 Dec 2024 15:58:49 +0100
Message-ID: <20241212144230.093284824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Down <chris@chrisdown.name>

commit 1e66d50ad3a1dbf0169b14d502be59a4b1213149 upstream.

`hostname` may not be present on some systems as it's not mandated by
POSIX/SUSv4. This isn't just a theoretical problem: on Arch Linux,
`hostname` is provided by `inetutils`, which isn't part of the base
distribution.

    ./scripts/mkcompile_h: line 38: hostname: command not found

Use `uname -n` instead, which is more likely to be available (and
mandated by standards).

Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mkcompile_h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -45,7 +45,7 @@ else
 	LINUX_COMPILE_BY=$KBUILD_BUILD_USER
 fi
 if test -z "$KBUILD_BUILD_HOST"; then
-	LINUX_COMPILE_HOST=`hostname`
+	LINUX_COMPILE_HOST=`uname -n`
 else
 	LINUX_COMPILE_HOST=$KBUILD_BUILD_HOST
 fi


