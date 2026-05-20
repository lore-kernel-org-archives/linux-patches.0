Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7793F23A4;
	Wed, 20 May 2026 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297763; cv=none; b=OKXFbIpbtfLE+Jz47/jsz+G6zcwsG/GgR328pRA/idHrLrs28eb+GuD8XFGbSktefVPW+gG32v0Fi7QGctFoDsRI4e4IR63QFpdjrargGzeUOVV/7NTpmIOVPzHtE5cyXkdHfDnZuYOxchAiDC/MjuWln8EwMnP8Jz4KXnR0EFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297763; c=relaxed/simple;
	bh=9bxDNSZEdBeba8wwRcrZlvcQ0Oypi3PF8bPBZ7D7l24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=in8qQjaghR/tUhq7F9HdKQ/xp5fY5gJFE1tiUWtT8V/XfGW6exOnq7E6grEhWWgD2Xn7wflFPcW7c6pzpf6yuthxJjqTMhSFmcE1GYrk7ifVBUzxwfBJIVDdYBxH5EzaQPNMeC/ezdYrYyD0FxwUR9T2mOinjRhEuprqzoZXYdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVlycmVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVlycmVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828DE1F000E9;
	Wed, 20 May 2026 17:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297762;
	bh=7JZqfJjoW3PyPr4gjed4yMzOIGz41uxBrcYhPpQ33eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVlycmVjN7go77Vty7AEg7YDXBYu+K8FVH4fMiumnTsUDQgHkke5AyjvXSoAlII5L
	 hi3qqeohuufvRaA5hFJOfWgeZQ20npu6Pcts0pqXfSWY0CvgOypCVewyZ6eaLVWRcD
	 L80U3mDnBoFUqArLfoxj8olhrPreOgNuhtm8hrSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/957] selftests/bpf: fix __jited_unpriv tag name
Date: Wed, 20 May 2026 18:10:37 +0200
Message-ID: <20260520162137.890826189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit cdd54fe98c00549264a92613af6bb0e9a5fd0d1c ]

__jited_unpriv was using "test_jited=" as its tag name, same as the
priv variant __jited. Fix by using "test_jited_unpriv=".

Fixes: 7d743e4c759c ("selftests/bpf: __jited test tag to check disassembly after jit")
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260410-selftests-global-tags-ordering-v2-1-c566ec9781bf@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_misc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_misc.h b/tools/testing/selftests/bpf/progs/bpf_misc.h
index a7a1a684eed11..25172ca74b204 100644
--- a/tools/testing/selftests/bpf/progs/bpf_misc.h
+++ b/tools/testing/selftests/bpf/progs/bpf_misc.h
@@ -137,7 +137,7 @@
 #define __msg_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_msg_unpriv=" XSTR(__COUNTER__) "=" msg)))
 #define __not_msg_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_not_msg_unpriv=" XSTR(__COUNTER__) "=" msg)))
 #define __xlated_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_expect_xlated_unpriv=" XSTR(__COUNTER__) "=" msg)))
-#define __jited_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_jited=" XSTR(__COUNTER__) "=" msg)))
+#define __jited_unpriv(msg)	__attribute__((btf_decl_tag("comment:test_jited_unpriv=" XSTR(__COUNTER__) "=" msg)))
 #define __failure_unpriv	__attribute__((btf_decl_tag("comment:test_expect_failure_unpriv")))
 #define __success_unpriv	__attribute__((btf_decl_tag("comment:test_expect_success_unpriv")))
 #define __log_level(lvl)	__attribute__((btf_decl_tag("comment:test_log_level="#lvl)))
-- 
2.53.0



