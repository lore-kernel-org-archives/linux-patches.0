Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8459D30FC27;
	Mon, 13 Oct 2025 15:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368964; cv=none; b=YsA6v3IRgY/OSBJhxkvxKezsGAWxlOgIrDq/JaXtywX68cGEa8STAGUroXG1jG7Tw2ej7MCuN+K6E04p1HZbTzmpLEaQ2nAcpVEJHaO3XjPs90SiZkp+9om7Kl2qQxvKkj3GmttN9AnK6ztuXeA+ChFzM3dGJHu7VUN40fHPPkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368964; c=relaxed/simple;
	bh=hRZgqEv8OJYKRvlCgje4fPESnNCqflQbe0EVTnB3QKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swzqwi8ACVZAtd/Hz2cpxQchhRBxd6IBUjsweO6/ZX7x+YYfs8Vb2eaRS8FSuYnKy0ktsPqYZKFTmjrqBz4LG3BaQDDImaUBLDBeIDArBWR5nA0MDLhC9LsRNXXDly6lwgqNQw6fBh1pZkSJU6XzGr/qvd3SryVwWmBpfxUQ0qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHLzq0Sk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHLzq0Sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF6AC4CEFE;
	Mon, 13 Oct 2025 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368964;
	bh=hRZgqEv8OJYKRvlCgje4fPESnNCqflQbe0EVTnB3QKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHLzq0SkA9QPey4lDhC30fSChA9gcsPnj6gkem1rTWoB+NvN/ARKVS445omcwIUY7
	 HF4HlBoEZeKO8hYMjXobJp89OyPnFUW9Wi/o0Py7NgLYPy/hGhzhYPFzNW6qEDPL5Z
	 gF8c7mQbe/b0RuHrrCB3ODv2mS11zcw8AJomJjMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 080/563] selftests/nolibc: fix EXPECT_NZ macro
Date: Mon, 13 Oct 2025 16:39:01 +0200
Message-ID: <20251013144414.196203409@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 6d33ce3634f99e0c6c9ce9fc111261f2c411cb48 ]

The expect non-zero macro was incorrect and never used. Fix its
definition.

Fixes: 362aecb2d8cfa ("selftests/nolibc: add basic infrastructure to ease creation of nolibc tests")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://lore.kernel.org/r/20250731201225.323254-2-benjamin@sipsolutions.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index cc4d730ac4656..d074878eb2341 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -196,8 +196,8 @@ int expect_zr(int expr, int llen)
 }
 
 
-#define EXPECT_NZ(cond, expr, val)			\
-	do { if (!(cond)) result(llen, SKIPPED); else ret += expect_nz(expr, llen; } while (0)
+#define EXPECT_NZ(cond, expr)				\
+	do { if (!(cond)) result(llen, SKIPPED); else ret += expect_nz(expr, llen); } while (0)
 
 static __attribute__((unused))
 int expect_nz(int expr, int llen)
-- 
2.51.0



