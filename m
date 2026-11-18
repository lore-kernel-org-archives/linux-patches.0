Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030459;
	b=DcLQzFSXJclenjvkk5yfSoBBQwNv2X7DUnVIoHJ9DsxjYUPfXeemay1IdfoacEBt+lZG
	 7GSSFkD160TWbj0nQtw8XtmJm5en5rkFviUmtoe8tG5AdiPoF6XWVZU3IaoldL4N2Un8D
	 T01mTffJsbIPUOD38bfdVNRlFaSmJ9lyMG27Mi9CeLeA9QBlRmXhuXhfJjwioUEP8OdlK
	 Yh9ineV2ZqSYJ/Y36se+tdlgdzvO1uz2hwfejKvdUpQ9WcIZcGAP2J1iTMgmHRbcNhYtS
	 5POSClBl6Dmt49R8nFDMk/J57V5sbieIezSEk++Y4I2IWzp91QAbvxyC9tpxJzQ2NMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HVxXbNdPq0vBcyWyXILwq+u3g1Q8KlQ8MJhZcnIx7WE=;
	b=cRbnFb597P6tdv3xqyZTvaR9NjIYDfxBwyOEi84LXLT/7o8wXeXCmW/tUkB6JFtX8ugq
	 zVH+aktBslJ8mF87HV6mGepmDPcJQBgWn0Rh8rt9tvYzxvevyEnoiugv+ksSF6iQsl3OJ
	 94PCJnn/1LgdgsrduRm7/mMUjvbjm4q2pXF/hLsK8MvxiOuVu2LC6Ep7bQvsZ21sKHseT
	 8tvprlhK3aGkrHRpO7/+5MNHGL79R5awalE/1kx7wK4UGuOvdudtGcUn50wE+++ncnMUv
	 xmen7EsFFBmSYsaRx2RM755Gf/AM7N0NrDn3linSHXLctaLay/wbtVHTs9TjdHo7nGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XqEH9BZW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05C8606A33D;
	Wed, 18 Nov 2026 19:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XqEH9BZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E761F000C4;
	Wed, 18 Nov 2026 19:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030459;
	bh=HVxXbNdPq0vBcyWyXILwq+u3g1Q8KlQ8MJhZcnIx7WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XqEH9BZWcEFhFzUSaMwS1Ye5Xz92TC9g96BPUEH/FJAXt96iHXTdi8orRLCHRwNQY
	 qi9ei7IdoLVH+OoG9TQj6lxKbCqDe/LycNBHH94B+IOb3/meKW4NhXckfy2kB7Vg+M
	 dPdL6eyQh44054wBhH/R1746YQ/UogGkRqbhRJXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0712/1756] kconfig: tests: Provide defconfig outfile for savedefconfig
Date: Wed, 18 Nov 2026 15:47:19 +0100
Message-ID: <20261118150037.719292272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 26f194ed2d400..a6d52684036c2 100644
--- a/scripts/kconfig/tests/conftest.py
+++ b/scripts/kconfig/tests/conftest.py
@@ -213,7 +213,8 @@ class Conf:
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



