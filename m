Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040483;
	b=t+rF9ZJiQNXEgSDIEc+EU0z3f12147K9nQMueJZ0ABpSOmiTIvHWe5PTxezCuJ6Kiya5
	 mbb5X2PiBHiAkyFUv7y5Pv4Uh9BiMOLw/3OoG7xEMcOCufTsrAUVipdJt6p1pcJFEHke+
	 J0xdZLws2Q9JQk2Hc9Bn5cACCjJgb7JCZcFYwTBptQ0lU217+Q3p9l9H28sTOR0axTN+c
	 vBQ2u6B/3DRhIcq8Be3MQElDOJw8Iiz38L51mbWyzlm7B/YpjPTlFhxcIaMbP4LFYgL0R
	 Ltqnpyq0XK1IsZrOj7+GiXSa8aWfmFuAwADi8wr/ShouJwDn5UeSKdvztcd9GwmAlJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MW5knB6hyVzWi1Rz/6YzWC5fRVDPL4bq2X1skS69yEY=;
	b=agqpVQ9hV8PEl5YIyCqh94Jbf9tMurkASngX9JHNyASkGODLioU+fi/gqu7zGhLijEMw
	 4TZBwdWxtuZULr8nCd+rA67jo0Cc4TZ3jJGFOADDod7Gmn1fBmUwzFd4ZXwaED3BRWIiT
	 mqLMt1YabiM1B7CdvYepcyWlhAfzLUXrNQvTm+SZ/QQN3C/yix7G1q7/SbubafMNMXmeU
	 N9WmtmP5AoY1jehE7sBVrn8O/q5JMoT6L7Yc7v4FEOQWfg70LIjTrJklnzHKhSOp8Oqua
	 ULw+/Dupq/PXsDhv6jPLEm4Yh83FhnvnCyxNS6WFfIfXhMB2/Na+rDOAIVgdYqvBnVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFq9cO2H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B30606A325;
	Wed, 18 Nov 2026 22:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFq9cO2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B698F1F000C4;
	Wed, 18 Nov 2026 22:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040483;
	bh=MW5knB6hyVzWi1Rz/6YzWC5fRVDPL4bq2X1skS69yEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFq9cO2HyoKy/7itDl1hS7CmyZZfNPVZnX9oKU98auUkFTiGaskR2UDJCKIwCyEQn
	 cNynVJqoc0ZC9w7HFEz64p8MbJtG4bifcCT2yad1jZ83DPp4Af437zZLOh/wy0//xN
	 0q5fhc2lOvhkkJhnDSlOimIvn6AFTnkHXfuP9KyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2473/3318] kconfig: tests: Provide defconfig outfile for savedefconfig
Date: Wed, 18 Nov 2026 15:51:35 +0100
Message-ID: <20261118150435.600960989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



