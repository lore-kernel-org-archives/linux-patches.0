Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C619FC19;
	Thu, 25 Jul 2024 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918912; cv=none; b=i3IbXawNJpO+sCF/lGi34Wnxp1dbQFWtXil5tqu12J7cmvj9hmqMo6GJDQq7lBGbXRxv0ekIXKpV8Y63JBnZwD9e1YY+tq+XdlSU1aIViqaRke2HiRHBdHAbG51Q39bjrbRQyviBIU+bC17mXvj9gAyMcMsYazwhkmmAH0nV7zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918912; c=relaxed/simple;
	bh=G5yGq0y8UKf7bMigFZoW+NeIn2FVHkPIch+hgMSbYd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kJU6ZLyD3dTWnPncf2a209kBvZoRXOLw5CqsEuDA+9YqkXHtIrvDdxBgSZABqjfmS58uuRcCyUaxzMZ1MJnWQwr7e/fFlOJejhFGSLaTqyl6NE2dGh2UVi9m42aTRnGE5lbkyUq5Xc0wyD5B7ADlzIUsnEvZra5o2eL2vJvC/BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knAolHKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knAolHKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5DCC116B1;
	Thu, 25 Jul 2024 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918912;
	bh=G5yGq0y8UKf7bMigFZoW+NeIn2FVHkPIch+hgMSbYd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knAolHKpQamCVnQze3ZjTY3/TA4XDTRySBTzeuiSJwezOSLI1J7puqZpIOZoCJh+1
	 CYmya/1+QvUZsU+VJnlVtvi2hNemEYIcHMy79wC8t5Y/fMKR4nbuTYjVjhUUVkNmhf
	 GaogXSuXkIuOQo3tKf3VTLr+puCH1TZKH4on1vGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/59] selftests/openat2: Fix build warnings on ppc64
Date: Thu, 25 Jul 2024 16:36:58 +0200
Message-ID: <20240725142733.579431284@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 84b6df4c49a1cc2854a16937acd5fd3e6315d083 ]

Fix warnings like:

  openat2_test.c: In function ‘test_openat2_flags’:
  openat2_test.c:303:73: warning: format ‘%llX’ expects argument of type
  ‘long long unsigned int’, but argument 5 has type ‘__u64’ {aka ‘long
  unsigned int’} [-Wformat=]

By switching to unsigned long long for u64 for ppc64 builds.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/openat2/openat2_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index 453152b58e7f0..1045df1a98c07 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -5,6 +5,7 @@
  */
 
 #define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__ // Use ll64
 #include <fcntl.h>
 #include <sched.h>
 #include <sys/stat.h>
-- 
2.43.0



