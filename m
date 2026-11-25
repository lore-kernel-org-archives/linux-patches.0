Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625482;
	b=MZ7wOkV2Wq11ybLkMNU1uQLWw04o8uOZCActvg6SIkwviViIpeUE/H20NzkD2w7A4brq
	 ZqsxIK2X9A85UYg0hDmufBn2OARWcu6fJ8WT8uQ37T0WIBGwCqQxHBHfocBBqFyJ8cLFV
	 LRCK6yscqrKoV40kh8rqySfVoEjbHR7qLcWeQRuuKe4F5YTFy/od0DZLDyzx9WrLPUOmr
	 D4WHx9nqwkCBiA4WCBBHyxsm8m7SCZs603fOXt/51zr7bGdmzxhmYacajK8B6hOHK0DPm
	 E9pFX+Yjw773OkD3SUrZksGdY+cZPlpupz3diXZMbt1g8iuh3/YtINEoFG4VZIbMEAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iMzfgUDGKzDLrOXohCYTUpDoYAMUD/hlfAP1U+sjOwE=;
	b=ZlYRRpSKNj/UGlYfFgCdkN7n7JASl/zTTp4h8IPCd7RvBgFXCWcpcwZwydXREOTMfDmJ
	 5T8lIu5MO6QZiCmZ6fCgG85d7ezatiJCWH2t+UvBlpQGV0y6GfzUpjGxqJ39Z1R/UtUBe
	 SYq4pXxlYMPmHlNLEjifqB5vYCQnqoUowu942vL8R600dM+iiHsnJatL3y+g1XrspTWij
	 +AzmR8lYcQVXIicAyy+MjmtNIu21NEvbTHIXRDiWMX20bjZkGwjXKIIBmWSgZDdXIQyOC
	 TpZt/3nXGgO2KP2P4nxlICzebK8ey0QVlg1pSoVzakFp8c5HoI6Ayv0drCRmtvii/sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ec1gY+hi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C856606A321;
	Wed, 25 Nov 2026 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ec1gY+hi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546561F000D3;
	Wed, 25 Nov 2026 16:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625481;
	bh=iMzfgUDGKzDLrOXohCYTUpDoYAMUD/hlfAP1U+sjOwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ec1gY+hiayFFwUI0o/obTIKrsQk38oz/cCCd6DdQOeJWL+iV9qke8atlTdKvABLW8
	 +LAD4c2Q6a5zJPRws5wPkYmvmBdNaSQY+GinkZmZ58M38J8EFX/yeaE845uV+FahFD
	 J//fcob3/uVd448bOBbcdUTWp0OhI2hZfooSNhYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 6.12 531/816] selftests/proc: proc-pid-vm: fix unused variable warning on non-x86
Date: Wed, 25 Nov 2026 15:34:39 +0100
Message-ID: <20261125143901.483361986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit c4d9005e7e1ee6ce277f47cf53d44fc5b90b287b ]

g_vsyscall is only used by the x86_64 test, so clang builds for other
architectures get:

  proc-pid-vm.c:224:21: warning: unused variable 'g_vsyscall' [-Wunused-variable]

The vsyscall strings next to it had the same problem and were marked
__maybe_unused for it. Move all of the vsyscall variables into the
__x86_64__ block that uses them instead, and drop those annotations
along with the local __maybe_unused fallback that was added for them.

Link: https://lore.kernel.org/20261012115330.3777115-1-sashal@kernel.org
Fixes: 17415606f9d8 ("tools/testing/selftests/proc/proc-pid-vm.c: test with vsyscall in mind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
[ sashal: Kept this tree's #include "../kselftest.h" and skipped the __maybe_unused removals, since that fallback and those annotations were never present here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/proc/proc-pid-vm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-pid-vm.c b/tools/testing/selftests/proc/proc-pid-vm.c
index d04685771952a..2ec6e0fd20e01 100644
--- a/tools/testing/selftests/proc/proc-pid-vm.c
+++ b/tools/testing/selftests/proc/proc-pid-vm.c
@@ -210,7 +210,6 @@ static int make_exe(const uint8_t *payload, size_t len)
 
 	return fd1;
 }
-#endif
 
 /*
  * 0: vsyscall VMA doesn't exist	vsyscall=none
@@ -226,7 +225,6 @@ static const char str_vsyscall_1[] =
 static const char str_vsyscall_2[] =
 "ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]\n";
 
-#ifdef __x86_64__
 static void sigaction_SIGSEGV(int _, siginfo_t *__, void *___)
 {
 	_exit(g_vsyscall);
-- 
2.53.0



