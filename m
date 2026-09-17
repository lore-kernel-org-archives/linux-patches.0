Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298B14AD4D4;
	Thu, 17 Sep 2026 18:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671314; cv=none; b=iZ6uQ22XUOOKKoWLN4TJvAUuCEYIL/wy+/m+MU+p8jIIJTX3Xnx4EYkli0LB3m7qcJ9OiFhTolWMFD+wyusKWe2MQsehofS+4GXi1QBhlV4kMukYuaU8B5S0YihaytNv70u0j5S7E0qnrIRRjcMZQsyeOQsMxh4B2+MOS8CwpEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671314; c=relaxed/simple;
	bh=KbYk9YhP2L7Sx9o55g4D6zXWcHvsmunWrj1n1BucL2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiavrbzgB0X2/LcMT8C1L52V/q7Ib/JpHXi/fZq27pNAteNuDEQ6DDNlaf0/fbpouWN7HYLqALwBMOgPbJFJs35qfFuFXpHmkg0Ck/5LLiYAA9m/6DnfEFWfMcjttC1w4SRflAqJAkKIG4iGhmu+1cR9arXDMk561hZ1qwJMMSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaDjBXSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaDjBXSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDE71F000FF;
	Thu, 17 Sep 2026 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671313;
	bh=kp3bFcD9/XkSJVK2ynYe6fPsp9e7chEyhgIrIEO2KPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IaDjBXScxPWYaorKVSjjOhNGLCS+Mk5IsQE9ktucR9CdPw8A7Qbgq0Ww2gFh7SwB/
	 E+wHg7rjXdVEZJxx92idutOYJ34zeG9kKlmMC59g97HbeQD5wugVXalO0pry/9hxv1
	 4JZ4Jd2r36ne5JTS/kkitfjUlDEU2LHJH2Bphvew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0936/1102] Revert "selftests: harness: Mark test fixture objects __maybe_unused"
Date: Thu, 17 Sep 2026 16:14:39 +0100
Message-ID: <20260917151604.140288206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit c3aa2187da64a59aa425c3d489241dc417ab3833.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 4c652d2a80766..cdf1e75ef0f73 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -467,7 +467,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		} \
 		__test_check_assert(_metadata); \
 	} \
-	static struct __test_metadata *_##fixture_name##_##test_name##_object __maybe_unused; \
+	static struct __test_metadata *_##fixture_name##_##test_name##_object; \
 	static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) \
 			_register_##fixture_name##_##test_name(void) \
 	{ \
-- 
2.53.0



