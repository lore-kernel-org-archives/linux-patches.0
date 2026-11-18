Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017940;
	b=UWOl8iXqOw2H9m4BkOE2Ye1n2tllZSyfuvtdgfB7L9C/sVTnRLuhd4Bq1+Tzm35MpGcO
	 jORtM8qgISk/YDID4ps4IemuAwNSGcjDnbCsMAutkVykWJCIdaDqGhnnhN12RNKICUG1Y
	 H1YeR2z7wal7seVL80mehVBYdTWL3Lxf447gKsznFesK4S55tJytoEMOGyXRlL46Jnrt+
	 CGzlCycsAmuB8KNbxLGkDeTnu24RsKRj7YUep3wdrwdPgDvwW3RAdBmqfyGTtEfs5hcnt
	 WcaFNRNfrPKN0cXg8ri2ErJ9nDqTTlmkhZ/yDEhY0KvYrip0Fel9NU6uj3UvnGXOrhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EpJczYJ7hag1T3SEWL4o+iPSSG7gsvJBbAWP52Qt/Y4=;
	b=W2uaH/Xa0UXPfiQyYGrciOzO2yhdeoZUNEKaL1x2tgwI3bmqxtMNiKHXQCWnf/9+oE+l
	 vk2tJmKt2o2n3llJvBEJ2jqXOsKBGwygHvHTQscxqjgiO/9saBGHGZ8ox8trByMQuLg4i
	 W8acdWRM/802UM8qy8n7iEtZ372i8xcJmXHlYlES1pyWC9wbkA2AYrgWnbAZSur5YNjrO
	 I1e2y1Kml5Z9UL5CO17bVdL3X16rHQrofJzLai7qiF9yQGc18hdfQp1O4WkrKTmRTxFxw
	 GIm9uO4VqrduCDKsP0F5KpB8ATVOQmOtAq4IVKKENcpnknX59T6f6CFaXGVQ9EdckKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEHdx+1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF46606A31C;
	Wed, 18 Nov 2026 16:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEHdx+1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5DD1F000C4;
	Wed, 18 Nov 2026 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017940;
	bh=EpJczYJ7hag1T3SEWL4o+iPSSG7gsvJBbAWP52Qt/Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEHdx+1jCP7ui3fXDADfwy8IdEY4mSk8HUW4ApID3HRT43N1Vh/LUrSV5ZIaNocoR
	 XQsgwTlf+6up1mKr7gwo6eJqx3vc4pxxwjEW7ma8ZVOJOxabc7n2UFOYZI/81Yxc85
	 UGNnPkFvV/1uMBPcqrLP8htOhOwqSI12t/sEtvdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1063/2651] kconfig: tests: Provide defconfig outfile for savedefconfig
Date: Wed, 18 Nov 2026 15:38:23 +0100
Message-ID: <20261118150326.251854284@linuxfoundation.org>
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

[ Upstream commit 09bd92ba15bd00d937deea38a10a439458393043 ]

Let kconfig test framework's 'savedefconfig' forward the requested
output 'defconfig' filename to 'conf'.

The original implementation was calling 'conf' with '--savedefconfig'
but missed the mandatory filename for the defconfig output file.

While at it, honour the 'dot_config' argument which points to the input
config file.

Fixes: 022a4bf6b59d ("kconfig: tests: add framework for Kconfig unit testing")
Reviewed-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Nicolas Schier <n.schier@fritz.com>
Link: https://patch.msgid.link/20260929-kconfig-tests-minor-updates-v2-2-c5902bee1d0c@fritz.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/tests/conftest.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/tests/conftest.py b/scripts/kconfig/tests/conftest.py
index 6fb391ac8fa9e..1f25de43128d3 100644
--- a/scripts/kconfig/tests/conftest.py
+++ b/scripts/kconfig/tests/conftest.py
@@ -235,7 +235,8 @@ class Conf:
         dot_config: .config file for input
         returncode: exit status of the Kconfig executable
         """
-        return self._run_conf('--savedefconfig', out_file='defconfig')
+        return self._run_conf('--savedefconfig={}'.format(out_file),
+                              dot_config=dot_config, out_file='defconfig')
 
     def listnewconfig(self, dot_config=None):
         """Run listnewconfig.
-- 
2.53.0



