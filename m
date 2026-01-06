Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C5E35E550;
	Tue,  6 Jan 2026 17:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721678; cv=none; b=gZYBd8K6ny39vtB5JP4EyT6WrRCpEHNwYV8JxPI+lb3iNnCZtM3zjXDcwkituq8zUuTydIH3XLUtfjhfq2Du+AQj9RrxXgJuOY8qk9pbjvmntlQQCD2e/1wRbvTTjcMsSYGQ1Mnsl/uuwCCyluq4SMys0B0GtSMgcBuRN6SzqKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721678; c=relaxed/simple;
	bh=5wzrzI8Oz9MpefXG7x0Q/1wN4vMeXfke9hC5TCfTwLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/oJWdrsdSlo2+rOdDrN011QMVJ7yEBCkxRkBRyd9K3Zf17cIxUGQ9BSEdY5wZhcji6RQY3FMsvc2y1kcsyIvrcpKEuc+vo+2VQ+tXJpdGbzF234kK8Yc8pfgigg1nf+OFcIc73Z0YRwy9S9GRuwu+Oki/2xu7yj+ORFIGstDh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mJqprsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mJqprsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0524AC116C6;
	Tue,  6 Jan 2026 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721678;
	bh=5wzrzI8Oz9MpefXG7x0Q/1wN4vMeXfke9hC5TCfTwLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mJqprsQXx1rgR09z+5aX/hXCBJsAgBUtnWv61Roo0vX9ZpRIhIfTFDbIa0YI7BCR
	 yjdPciNNDlb2PnC9uFhoO4QOO0Ob3jVBT3WgUaZ0LqBVK5rdzXRFwAh8nIujnbFKEQ
	 z0+y6AnIBJTNc+LiZLoNWboC54M+HvmZpjmfCZt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/312] selftests: drv-net: psp: fix test names in ipver_test_builder()
Date: Tue,  6 Jan 2026 18:01:53 +0100
Message-ID: <20260106170549.269321220@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit f0e5126f5e55d4939784ff61b0b7e9f9636d787d ]

test_case will only take on the formatted name after being
called. This does not work with the way ksft_run() currently
works. Assign the name after the test_case is created.

Fixes: 81236c74dba6 ("selftests: drv-net: psp: add test for auto-adjusting TCP MSS")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20251216-psp-test-fix-v1-2-3b5a6dde186f@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/psp.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 827e04cc8423..473573e216e3 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -570,8 +570,9 @@ def ipver_test_builder(name, test_func, ipver):
     """Build test cases for each IP version"""
     def test_case(cfg):
         cfg.require_ipver(ipver)
-        test_case.__name__ = f"{name}_ip{ipver}"
         test_func(cfg, ipver)
+
+    test_case.__name__ = f"{name}_ip{ipver}"
     return test_case
 
 
-- 
2.51.0



