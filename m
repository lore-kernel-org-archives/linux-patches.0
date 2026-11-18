Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017937;
	b=S0OWAS25d1JC607GRmXli+ioZ/eCtif/b8Y9bqqu9afnoEOokxkJp+fvrapiS/kPzpaO
	 3wdISX75+VWaNyMD5nlNtFF8iT+MZ3NeHD1i7ljbqemTG9pP65AsTrpK6NJHjNU4r0XcR
	 69gU302VNC5hCApKpKLILq1DbUqHDVBvdTdFJXulrMmSXxQtbq5Vi+NuHb+6w4pZF1IQR
	 DoacqNUnlyl1VdWVIw3s2oPK5SmdOmVEwPvuGfWvpaYXL4jhkJMwddIEWmXcidvf3NNWe
	 SrbHhHp03WA0D6FDLPmxg+vQwom6HZ6pvnIbfhjGRJRWkB5tv9iNaM7kht/DVatscrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mg1MPy6t/7BApboLtzzGH+XNJnMW6LPZvL7Vr6cZAa0=;
	b=M0AFsQbEJH97zkfx3Wv9rRimRwZbOGTO/lNBXl/oZCTepeyHTkvMrZ1dTnthp+DSg5w2
	 BMAgDPJ7AfDEuk5/zOplKQ30BiY80ZK//D0QobOsN6fNAxUitGQWfL5mZwzqdBrRh2Q7y
	 fB7E69mzltVsiPN83mziEki9/pDcizjvry2/yEBCMeb2lHl/iWMKPWyEqBeBxMPpM73qX
	 KVYRLQnUFq9YLr9tNLAusv8F63Rh0CgKGhF+THFa25Vomey5XWv7JiJXPcLjlX65bl4t7
	 XNGqv7VszeVMRUN6hOgva8FeXS0LfQjK7QifeorFD+nM1CqNYwHrxl4IjweS7LPojWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rs5pmhTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B90606A31C;
	Wed, 18 Nov 2026 16:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rs5pmhTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8381F000C4;
	Wed, 18 Nov 2026 16:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017937;
	bh=mg1MPy6t/7BApboLtzzGH+XNJnMW6LPZvL7Vr6cZAa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rs5pmhTRVeGjRuhXv0z1UNCHm2kI8ZTX4YBCVmNzXBaRC2jgBfMK16iOm4tIQco6m
	 rIjiCd3W36SsANvVI0Xb5v/uqjrVOxyCxezYmsHSg1/alcSQOJsFufcsoZ/Mf7pOyu
	 J4IsS5nHnNzsMfTUKQfelOcBpdnEaAQB9FS4VSlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Schier <n.schier@fritz.com>,
	Julian Braha <julianbraha@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1062/2651] kconfig: tests: Reset all KCONFIG_* env variables by default
Date: Wed, 18 Nov 2026 15:38:22 +0100
Message-ID: <20261118150326.215125111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Schier <n.schier@fritz.com>

[ Upstream commit 8688f0b29d021cad8188b11d5664b4a1f595691b ]

Reset all environment variables with names starting with 'KCONFIG_' from
the user-provided environment.

This fixes the 'warn_changed_input' test on systems with
KCONFIG_WARN_CHANGED_INPUT=1 and ensures a cleaner test environment.

Fixes: 645323a7f4e5 ("kconfig: add optional warnings for changed input values")
Signed-off-by: Nicolas Schier <n.schier@fritz.com>
Reviewed-by: Julian Braha <julianbraha@gmail.com>
Link: https://patch.msgid.link/20260929-kconfig-tests-minor-updates-v2-1-c5902bee1d0c@fritz.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/tests/conftest.py | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/tests/conftest.py b/scripts/kconfig/tests/conftest.py
index 2263bd2a3b3ac..6fb391ac8fa9e 100644
--- a/scripts/kconfig/tests/conftest.py
+++ b/scripts/kconfig/tests/conftest.py
@@ -57,9 +57,12 @@ class Conf:
         # Override 'srctree' environment to make the test as the top directory
         extra_env['srctree'] = self._test_dir
 
-        # Clear KCONFIG_DEFCONFIG_LIST to keep unit tests from being affected
-        # by the user's environment.
-        extra_env['KCONFIG_DEFCONFIG_LIST'] = ''
+        # Clear all KCONFIG_* environment variables
+        env = {
+            varname: os.environ[varname]
+            for varname in os.environ.keys()
+            if not varname.startswith("KCONFIG_")
+        }
 
         # Run Kconfig in a temporary directory.
         # This directory is automatically removed when done.
@@ -75,7 +78,7 @@ class Conf:
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE,
                                   cwd=temp_dir,
-                                  env=dict(os.environ, **extra_env))
+                                  env=dict(env, **extra_env))
 
             # If input key sequence is given, feed it to stdin.
             if in_keys:
-- 
2.53.0



