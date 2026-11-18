Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024930;
	b=Di7+MzhnTncLSQ3iHFbHN0feWKob13XSw4cjqFP4hJCiLOnEwqql8vAGlt9mm9Xdyutn
	 Wm7A6XCQGXSXUSuwNt71CpXGdChMkPjVQgn4BBY88njfozPEULeKyjB0kkU58WEBw/1GA
	 3BrijWRLbWj6D4kP8Slopn1Ed/T4SAH/Ua+mwdofXG091z8FXxRKfybCQLFwvwwx2gZBd
	 hME+hPTrvTbW+9h/ysk82k7XC7a+t4A4aYOUw32cVttFGAek/OmrHD+/+fUeSGdr94wEO
	 7IxhCvuo7vRBIZ8QSMheWVH/2sxjVkwqi9iAQCLAKN/nbEQY8jzil4FoYOIpFsCgEgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vKeYGoA09mxW+0q6ySQAKZJSBtg6Dr4nSDZQNGDyS/4=;
	b=W4MFa7EE4FKP2XfpfCtnF4C9ybM/p9LCuorVC0irfEd+V+p15I1KtG9MLMORv7nBrfYZ
	 r/5e8RX7r6eMpptjgg2+r1HYGllPaj8fY9RGvbqLg9XvVuUa1wNncKlQkku+ck9d3F3oi
	 YZk13BdW/Aw1fFYRu5G5CpogVZsiX31HOcwhUYrvypt+DWd+wwN7u72aye4gSJdHJDvne
	 rJNx3bkdeDctDYLq1pyrx8G770d464NK8a7ed9xzv/SyDouUIqUy9ORYuBykiaQ9YXzkx
	 I3NdflEPWBmrflVW11J4/yiqDDDD0linzBpplwGoaqzaKByTxAWu4Mlsnj7f75bJ0ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7gMN7AR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E49606A31C;
	Wed, 18 Nov 2026 18:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7gMN7AR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2255E1F000C4;
	Wed, 18 Nov 2026 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024929;
	bh=vKeYGoA09mxW+0q6ySQAKZJSBtg6Dr4nSDZQNGDyS/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7gMN7ARkifCZ8kTXnLWKIM2mHR0fFvby/OMnssMCxqefWpDoGVLlLIY455nv2GKM
	 i4TkCkNLHv147hwzXq92V0dmKwrtCM/WjM/1p8aHYJq8mnfy6y0aV6Q17gwhhEzbUL
	 cdoyR/THMjywOjgX/OoJQ3/5UF0hThJ6qgb/iU/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0898/2151] kconfig: tests: Provide defconfig outfile for savedefconfig
Date: Wed, 18 Nov 2026 15:43:53 +0100
Message-ID: <20261118150155.006157451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0d8a8b0efdd67..fa09cf32b4e8d 100644
--- a/scripts/kconfig/tests/conftest.py
+++ b/scripts/kconfig/tests/conftest.py
@@ -228,7 +228,8 @@ class Conf:
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



