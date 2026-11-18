Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048857;
	b=n6pdIuMLhLn+xbMQ7s46Ze0glXcff2ARK6ha7bitrXffEfwo430SJXC5Q2fwllU6tPIK
	 LlIjXnXkOdg0sc+XC+X0ezVkfyDXWOt9sACsTLF7MZcOWy1z8cjrrLJczQn18zdURT1Jm
	 5Thci2r4mUhHUC7pRV4CAaeT/MZa3oHQqSSS8Jde0nFuSdAVepYB+huLEgycqdDY8z7ek
	 x/dOh4XSpjtCYC821wJ+BdHjgg8gIgWwipGmCG5oPdAm3OOmBZgR5mbyXZM4Ek1iuzkv7
	 j+GOEjgZAyOcFUvFdj5t3QnSzbcKFHA6q8AD46gXifcqCtZEwHM1cJXDBZKTdls2ECQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6rmdHvkJY6wEHHU61Rq9auLJMDKLFbXlQHGaYePDhDE=;
	b=4Dw9flfVGRq0UMYO144Huhqgc7GWE5qKDm2pCKQtq5AMZORjvOESPjv/8n29SL4vyOxH
	 Hm+MjkieWjln1WyyUy+g5X3sVyMGhkOKg/9OPvugcTCImSfvym7kRDczfjLE2iVD/XXyi
	 j8DLl8QFLub0C38O0m3RIcePDZKOT5o1hyCByM7ZQjYreTBzIFYTIXsPnmMFMLnwLT2vJ
	 CjpWsmJn+1q5F+yPK64DkyZSfMc3SZvGFO0QADfCSsk+5Of7gZYUG2VcpiiWTZ+YQowE0
	 YHVcV/ln9nzoKTODipSbmXL/zsdLpgpe4y/viSEjTa8O2BjDedV//puXkEvNvbGRztA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=17XeguXj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D825606A31C;
	Thu, 19 Nov 2026 00:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=17XeguXj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723431F000C4;
	Thu, 19 Nov 2026 00:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048857;
	bh=6rmdHvkJY6wEHHU61Rq9auLJMDKLFbXlQHGaYePDhDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17XeguXjgdQ5NaamfLgkSI5ZV0IYcotg2fQXBO4QlPCeiAi026bgu+1GVIg65N00p
	 4bZQ3IYOwDBnTZ04u4o+PVH0tB8Ll8HUOQblcTvs5aviKx21wshGiv5BI5gC0/UL27
	 BL6I6V+63QtGnp7aHp+KGRehF2twu6Xm3Rx8GH9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2144/2857] kconfig: tests: Provide defconfig outfile for savedefconfig
Date: Wed, 18 Nov 2026 15:52:58 +0100
Message-ID: <20261118150318.597815276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3d75025437a70..0bc635f840a9e 100644
--- a/scripts/kconfig/tests/conftest.py
+++ b/scripts/kconfig/tests/conftest.py
@@ -209,7 +209,8 @@ class Conf:
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



