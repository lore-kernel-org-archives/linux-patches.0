Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA63B33FE23;
	Tue,  6 Jan 2026 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721675; cv=none; b=ZYV5aB609wk8s+Y9VRjc+/vwoAC9/cJdDUeiDoZsCuscLr2EtvJAiDX0TtekwWLw2pSFrMLoLeun9N8jv3IXSOXwRMjgoICMmDk0hxX4t6V2COG/SC/y8Kcz5rOUBCziKwgwaz39coTG9vfAbKu5CpTbUEu/7TtFSD4YD29b5wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721675; c=relaxed/simple;
	bh=o4FVd+REffNTwMtmwh1RUHzlein/eiVvuzpOQeWdpFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NO/z0cYF4nU6lG6a2OLYsO1k90rOsdj6bzuXsstzgiuD0AHYH2mUl44sJ2FH96vTMXS7YcrnflUaeAEOeyjWKmCSZRBlUhca+3hL+Fq1DBobzyhakKk1MUgB7mJO8bqzWDKqFm8B5m5LR+bnng8MRKjr0KfI0I2W1O3R+cRfzj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWo0p8Dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWo0p8Dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ED8C116C6;
	Tue,  6 Jan 2026 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721675;
	bh=o4FVd+REffNTwMtmwh1RUHzlein/eiVvuzpOQeWdpFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWo0p8DdYo2QIEyXHMh9a1Hx3TMwSmCW74MsqbC0EkP35L9VQSAFJg9kWOtA5uTjl
	 1Ij6m5PkoxGuxVtekuorvYNquDo7LaCHi0qGNUx64GIyksXolR4/FtdXQkLShklPMD
	 kJBggrr6igtgGaaxHZKBLjv7N2JTxttwM5LfIPUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/312] selftests: drv-net: psp: fix templated test names in psp_ip_ver_test_builder()
Date: Tue,  6 Jan 2026 18:01:52 +0100
Message-ID: <20260106170549.233373893@linuxfoundation.org>
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

[ Upstream commit d52668cac3f98f86aa1fb238dec1320c80fbefea ]

test_case will only take on its formatted name after it is called by
the test runner. Move the assignment to test_case.__name__ to when the
test_case is constructed, not called.

Fixes: 8f90dc6e417a ("selftests: drv-net: psp: add basic data transfer and key rotation tests")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20251216-psp-test-fix-v1-1-3b5a6dde186f@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/psp.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 4ae7a785ff10..827e04cc8423 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -560,8 +560,9 @@ def psp_ip_ver_test_builder(name, test_func, psp_ver, ipver):
     """Build test cases for each combo of PSP version and IP version"""
     def test_case(cfg):
         cfg.require_ipver(ipver)
-        test_case.__name__ = f"{name}_v{psp_ver}_ip{ipver}"
         test_func(cfg, psp_ver, ipver)
+
+    test_case.__name__ = f"{name}_v{psp_ver}_ip{ipver}"
     return test_case
 
 
-- 
2.51.0



