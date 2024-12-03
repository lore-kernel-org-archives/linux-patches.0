Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BCA1F7064;
	Tue,  3 Dec 2024 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236486; cv=none; b=CE4rvalldS9NmOSM1FT9NqBvGnxLnUUVagtxpFUTskrXe1zPEsggoFMkq8vxMupYZ7PrleECWKtdR0EbuZN1NvzoyuiuFXv7dTMc7x15G4RVzrS+J+Diz57FOXwc/F0qbXhVDZUxgYArGYyfbdLz0WVfkjqG8YL3Sqfu49URv7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236486; c=relaxed/simple;
	bh=S+wlBRhjrJjlZ32G4L6Ck6WIEJxlsM4dFE+3khxukJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYwE4vKvoj5gA4GGkJxsBiDDtgQFt9+g9wnj3+qO8BJTw9j5Y8rBS/XDGLMwhjCuCdFq2FxPs/waBwySVlXcQKcG068kSm9rC4cZo4/G7ZZtyjPffgFnTj9VV9r7j1dKytUdF/VJBYMhYh091NXyX9Lwr57+br38WgBwQz436Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmhdJEYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmhdJEYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F68C4CED9;
	Tue,  3 Dec 2024 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236486;
	bh=S+wlBRhjrJjlZ32G4L6Ck6WIEJxlsM4dFE+3khxukJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmhdJEYUCYS5J/9JT8dsPxXAp1KX+igMBO+fe1HB5Q2vn6krEShg73KlMEDMaXpGa
	 US3DuiuopAPp7NMSkSsV8bNdzH5Y0Zkkh6JzdKFx9crZ8qFF7mzvLnvSV28ui2m27y
	 WNkuplt8QqtSRtn7/MDzS/APFZ526X+gFvd9x7Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 008/138] kbuild: Use uname for LINUX_COMPILE_HOST detection
Date: Tue,  3 Dec 2024 15:30:37 +0100
Message-ID: <20241203141923.856818701@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -44,7 +44,7 @@ else
 	LINUX_COMPILE_BY=$KBUILD_BUILD_USER
 fi
 if test -z "$KBUILD_BUILD_HOST"; then
-	LINUX_COMPILE_HOST=`hostname`
+	LINUX_COMPILE_HOST=`uname -n`
 else
 	LINUX_COMPILE_HOST=$KBUILD_BUILD_HOST
 fi


