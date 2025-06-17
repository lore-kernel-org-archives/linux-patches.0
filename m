Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DD12F2346;
	Tue, 17 Jun 2025 15:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175772; cv=none; b=LnOTY8/qKKdeJlYaqWtE2F3wiJD2EMJzg32XXikdkk1EcpYEVarPYEdMv5HwozUCYJ709/b2jYWsbTibhnhadgS8SZq00mT2OeDcqsPrzYbgf1Q6kcXESA5gRfPE0IwUxEZJOCjGQd64f5gVxqhWnjNOZFAXc5vQDRCPZY4/kbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175772; c=relaxed/simple;
	bh=yottoYGwNWGNh/ki21ZopTNP0atZI8aQ80nMzAdYDI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXM+YaHafvWHiBeT+39sXg19lzq3LduZho5HgZW2/9Ag9m9Rv4BI3bIop5GoszsvLO3b4UXHKOgn9Bg1Ekosvnhmyw5HcJm5oBJR/3G/DYg25avLXEAY166i9FV8ybCazR/lNYdVE7eEJMtjVPmnlMRWmIUQyfDQeTrqmis/Dpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaX8+lze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaX8+lze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65AFC4CEE3;
	Tue, 17 Jun 2025 15:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175772;
	bh=yottoYGwNWGNh/ki21ZopTNP0atZI8aQ80nMzAdYDI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaX8+lzewZ+U2k3q5qVGxudGZX6sjdCEy/rACTe1ANMoAorQ912r45A6e4fS1Xq2N
	 JDX2AkRLI0DPl20j/+2ZlKjCiVdUj09XyG8APzjJACgMWXUQTTVCEmCpCtYSysidy2
	 eInO8wShu/le1M0Xm+YbU0QA0qcab+7EnQMwgdBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 121/780] kunit/usercopy: Disable u64 test on 32-bit SPARC
Date: Tue, 17 Jun 2025 17:17:09 +0200
Message-ID: <20250617152456.428683519@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 0d6efa20e384a41a7f4afdcd8a0aec442c19d33e ]

usercopy of 64 bit values does not work on 32-bit SPARC:

    # usercopy_test_valid: EXPECTATION FAILED at lib/tests/usercopy_kunit.c:209
    Expected val_u64 == 0x5a5b5c5d6a6b6c6d, but
        val_u64 == 1515936861 (0x5a5b5c5d)
        0x5a5b5c5d6a6b6c6d == 6510899242581322861 (0x5a5b5c5d6a6b6c6d)

Disable the test.

Fixes: 4c5d7bc63775 ("usercopy: Add tests for all get_user() sizes")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250416-kunit-sparc-usercopy-v1-1-a772054db3af@linutronix.de
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/tests/usercopy_kunit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/tests/usercopy_kunit.c b/lib/tests/usercopy_kunit.c
index 77fa00a13df77..80f8abe10968c 100644
--- a/lib/tests/usercopy_kunit.c
+++ b/lib/tests/usercopy_kunit.c
@@ -27,6 +27,7 @@
 			    !defined(CONFIG_MICROBLAZE) &&	\
 			    !defined(CONFIG_NIOS2) &&		\
 			    !defined(CONFIG_PPC32) &&		\
+			    !defined(CONFIG_SPARC32) &&		\
 			    !defined(CONFIG_SUPERH))
 # define TEST_U64
 #endif
-- 
2.39.5



