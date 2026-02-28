Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A635A3B7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300912; cv=none; b=YGPnknfuvLEDh7G2Izt8eLeGCNRALyP+9WqO9lupMh+3apDntyMmouMkxXNIqDz7MlR/2/xLRkquqs6duBT3m9CHcNX00AZU6DEF6tnIPlEfD0bwFku7kqWpir7HMtlyS/tb+IvhE+BTmZ6AhyJex/KipCcIkS2Ie36vYsUgIFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300912; c=relaxed/simple;
	bh=uh5vMZZu0wmCiPj396XXx6Lbu8bmBqqs0/+o6Ks378M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8TLj9AamKMRWgyYF95kaqMIXAKTfA65aSIyJB9WKF9rna+5PQkgXgkmm4V5+3ynzbE9kuL/YBDiK1ktVRxDrScd+NlNDc2APZCbVXU8c9YFB8bzEB3jjSdeE/fXq9LaLp5Iym26XjQtzyYl2pomlumJqkuHbrtCc0FYjDzHfUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JEBhUbia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEBhUbia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF14CC19425;
	Sat, 28 Feb 2026 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300912;
	bh=uh5vMZZu0wmCiPj396XXx6Lbu8bmBqqs0/+o6Ks378M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEBhUbiaMYs0qd4RSxqbC/UCOtLob0zm+jVpxy+kzHAgRqiy7WS+L8ca2En8KAONs
	 T2MU9W6ul62Ty6Z1dSX1b+ZkCnQr+wjtSVLoGQ0g0BCLMf7YIg0TJI7w7MwaB70H0U
	 lrrC5pVywETCto8r8PwcReMPO7TdfH7jni4k0sN6G1s6c01gfWE5IfhJYRlL72x4q0
	 R9y3XejEFXoMJnmCmJOdTeBvO2Cm7JDmqjoLBN4gpMbUb+vTNR2lPCDC0HIE3B1/MW
	 NzukK6dc2mZGJ0FYL4EmUkKACQqJYlW+wJIcVsAaVATOfVYelwdyKKywi8CBpOVcjD
	 DgaOWTqUnpetA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Clint George <clintbgeorge@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/752] kselftest/kublk: include message in _Static_assert for C11 compatibility
Date: Sat, 28 Feb 2026 12:35:38 -0500
Message-ID: <20260228174750.1542406-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Clint George <clintbgeorge@gmail.com>

[ Upstream commit 3e6ad272bb8b3199bad952e7b077102af2d8df03 ]

Add descriptive message in the _Static_assert to comply with the C11
standard requirement to prevent compiler from throwing out error. The
compiler throws an error when _Static_assert is used without a message as
that is a C23 extension.

[] Testing:
The diff between before and after of running the kselftest test of the
module shows no regression on system with x86 architecture

[] Error log:
~/Desktop/kernel-dev/linux-v1/tools/testing/selftests/ublk$ make LLVM=1 W=1
  CC       kublk
In file included from kublk.c:6:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from null.c:3:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from file_backed.c:3:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from common.c:3:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from stripe.c:3:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
In file included from fault_inject.c:11:
./kublk.h:220:43: error: '_Static_assert' with no message is a C23 extension [-Werror,-Wc23-extensions]
  220 |         _Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
      |                                                  ^
      |                                                  , ""
1 error generated.
make: *** [../lib.mk:225: ~/Desktop/kernel-dev/linux-v1/tools/testing/selftests/ublk/kublk] Error 1

Link: https://lore.kernel.org/r/20251215085022.7642-1-clintbgeorge@gmail.com
Signed-off-by: Clint George <clintbgeorge@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/kublk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ublk/kublk.h b/tools/testing/selftests/ublk/kublk.h
index 1b8833a400643..39839c711c797 100644
--- a/tools/testing/selftests/ublk/kublk.h
+++ b/tools/testing/selftests/ublk/kublk.h
@@ -220,7 +220,7 @@ static inline __u64 build_user_data(unsigned tag, unsigned op,
 		unsigned tgt_data, unsigned q_id, unsigned is_target_io)
 {
 	/* we only have 7 bits to encode q_id */
-	_Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7);
+	_Static_assert(UBLK_MAX_QUEUES_SHIFT <= 7, "UBLK_MAX_QUEUES_SHIFT must be <= 7");
 	assert(!(tag >> 16) && !(op >> 8) && !(tgt_data >> 16) && !(q_id >> 7));
 
 	return tag | (op << 16) | (tgt_data << 24) |
-- 
2.51.0

