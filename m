Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF192FDC23;
	Tue, 12 Aug 2025 19:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025339; cv=none; b=tl/6TysmgvF+DxT8AHvSoKBmScuMBxPTeLs9NaUhiv5+/y88m5D7OB3SVebghhd/JOoY5AvbiFUFmZwie9kW7A4CyA0oA5BPlNszLxZmforEt8y92Dgn1ZyjMGmoKE17MgvxfZmH5jaSeDdW2NcA+h5jWpvZU4y7CvfWKllMbuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025339; c=relaxed/simple;
	bh=ucW8weobP6M0lse0dO+jYibc9wcJQrOGd1P7Hx8QpC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V1r+1b9/nH959VW9LuaBi2GQ24R1wEoE+KYyfolRY/TltjC07aoFj9NI99y61K8QmzgvgeCkTI2S+bxxpSlUiu6db7If4OXaTKK1lPgckZ4ulxEgPAFq6/sLT45mMI599JwE45HHnoXGidfXwIjDWinzMLutLhKnwPXzM7QZ4DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inLOff1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inLOff1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAB1C4CEF0;
	Tue, 12 Aug 2025 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025339;
	bh=ucW8weobP6M0lse0dO+jYibc9wcJQrOGd1P7Hx8QpC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inLOff1gLdHxkAhjusKddJ0+5y5GmliDWWQYG7L5Acjg82+Ema30N2UcNGKht+mG3
	 shNriK3r5jHcYXmyvMz0rxN7kfkrHPqX1mjA1VYX4d0bm33k5liDd10Auuvyv11RgF
	 BdijN1eFB/Qoiqy25QgzoZplJyQVy9FygwSngPnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 013/480] selftests/landlock: Fix build of audit_test
Date: Tue, 12 Aug 2025 19:43:41 +0200
Message-ID: <20250812174357.853552054@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

[ Upstream commit dc58130bc38f09b162aa3b216f8b8f1e0a56127b ]

We are hitting build error on CentOS 9:

audit_test.c:232:40: error: ‘O_CLOEXEC’ undeclared (...)

Fix this by including fcntl.h.

Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20250605214416.1885878-1-song@kernel.org
Fixes: 6b4566400a29 ("selftests/landlock: Add PID tests for audit records")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/audit_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/landlock/audit_test.c b/tools/testing/selftests/landlock/audit_test.c
index cfc571afd0eb..46d02d49835a 100644
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -7,6 +7,7 @@
 
 #define _GNU_SOURCE
 #include <errno.h>
+#include <fcntl.h>
 #include <limits.h>
 #include <linux/landlock.h>
 #include <pthread.h>
-- 
2.39.5



