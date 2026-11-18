Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025189;
	b=0p+pa/0mlhy6zf/nGIXr0YxLt5qG59vylncfmV00CsXXXR0YUqgnL2GznPIpMPUUUMvG
	 u4RE+7dEfTUdT9klrSRYsadBqs/95I3AIo3gg5jD48N+lL9Hsah2sK4/u5SqJuJCNQ9Di
	 IsyA4/O5XPBldilQd8CLRv4x5U2JO90S67sJKIHy7WG2qpv2pqeqfw+F8Ye9MW6JylcNI
	 Uoqjps9ToFQBzeJJTkPecGt7fYKnx39IY4i5X6fUuewFjtM252Q98uMlMUSBhmPOzQk+s
	 T6nk9u5AjmEXg287JI5gx7qL5p5Tcu387zi5zXkm3abGGkIrOTuaV1LQYZY2r0y97Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IuSyd8XScYRHVOZhyKvsR3Ss6eAUF+qmpN16mfd5UIs=;
	b=JtGKE6CGevdX2U2VoCkAwu6dOWq/pixFPoZZVlImi1HF1eLsfDaltwcYEATXVZtVphPV
	 69jGSBe5USV4XX/Ig7tT8eO+jyc8JgxGQIeatDIDQL9nwY2EUSg91Dm4sM3K3/77pBvGx
	 4KzpfM/GQ+2D0H2AFO0TDnKMt6im5R2uM5oTiYwW+FQ6rxhh5WOK9yVw4iP9+sZ9lfeWF
	 +bvJuUjVimGNO4zvmTp3/8an9G4zlqlHq0YVRWyrryAKIaCbWxskvEDkYqi7HfO21O4RG
	 mMrc5R4e7YQGkg4WFICPEuE5UOXal3b3Ny45+rDhvXfroBCVShFsNzz07iR9pJMM93A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gVduFjFx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129E3606A330;
	Wed, 18 Nov 2026 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gVduFjFx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691481F000C4;
	Wed, 18 Nov 2026 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025188;
	bh=IuSyd8XScYRHVOZhyKvsR3Ss6eAUF+qmpN16mfd5UIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVduFjFxC4wC0c9COpPgv+zDo+MMZSQURXRvCKDS6g6dOurwbWhWNvuRi9Chiku/v
	 ZVS+gjw6U2bITyrrGBo0UjATOwOvgyLDqMWvj4dTcTCDPFW5X1B+ffqNNgKHGjF7zr
	 5ysql5Eoao5R8F5yVzKnOJ9OXleeSTGqHIL8bYVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0974/2151] perf build python: Dont leave a.out file when building with clang
Date: Wed, 18 Nov 2026 15:45:09 +0100
Message-ID: <20261118150157.978619687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 6090e612cf24393335e709105db31b6d6e36d6ef ]

Testing clang features doesn't specify a "-o" option so an a.out file
is created and left in the make directory (not the output). Fix this
by specifying a "-o" of "/dev/null". Reorganize the code a little to
help with readability.

Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 2ed38aa8a52d ("perf python: Track linked libraries as extension dependencies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/setup.py | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 9cae2c472f4ad..b65b1792ca056 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -23,10 +23,17 @@ assert srctree, "Environment variable srctree, for the Linux sources, not set"
 src_feature_tests  = f'{srctree}/tools/build/feature'
 
 def clang_has_option(option):
-    cmd = shlex.split(f"{cc} {cc_options} {option}")
-    cmd.append(path.join(src_feature_tests, "test-hello.c"))
+    error_substrings = (
+        b"unknown argument",
+        b"is not supported",
+        b"unknown warning option"
+    )
+    cmd = shlex.split(f"{cc} {cc_options} {option}") + [
+        "-o", "/dev/null",
+        path.join(src_feature_tests, "test-hello.c")
+    ]
     cc_output = Popen(cmd, stderr=PIPE).stderr.readlines()
-    return [o for o in cc_output if ((b"unknown argument" in o) or (b"is not supported" in o) or (b"unknown warning option" in o))] == [ ]
+    return not any(any(error in line for error in error_substrings) for line in cc_output)
 
 if cc_is_clang:
     from sysconfig import get_config_vars
-- 
2.53.0



