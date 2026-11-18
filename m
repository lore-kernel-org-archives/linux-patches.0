Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061052;
	b=LNqE4OG2rojg53f1vpnIlQbZq/BMDhuwqdJ7MjytOAoMnFPCEw+fjqbk5eXtLZBneNM6
	 G4hNPnaFZBUd4nW0maeYB4JfF2ZGFq84K5utfhD3iEG6I95aRWEV5NiKPtWATv8ACkYLw
	 9ery7IxpeCn362H8W2Vkiiik9ubwPvqZv7TeYvx75Y32J7ZLvGsyJhRk8qrcPt86LGisB
	 lwfM84Iuma9d1CEHYaXdaFPeGSUJ9pv4eYcaNrFvW4vXumPKCNMerEogISWURJmtatFnq
	 RkMoqcpeY96mY0zfUIdPqHqkN6whO0aGnbHgXWRk9RBnPa7vfKYTQesDkHmnJR98Omw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SB7CRaFtmEuAENs6jmMf3VREQQ5QylgKtF7xiBJzfco=;
	b=Lw2kYTHKs0rhD30svkoUGrJRHkKfVXR9adVRphL7SdnhKvFJeqMougrtVcqTJeZ+gJLv
	 PIAfPPWtFp6VxV+Ra4FdBqRBvBvILwWyPaNNAO0k4y3zv0csjpgtDLhKD7VS2EZXfgoxa
	 HxmE+VJwMMnVxrY9BypoQ4cDkEdsp/369wxwPUxOffhoQWwIP6SPajwlJcrGfLUrVpwET
	 oWWwc/Xfdy37EAOEpbVV2N4WzbKyn7qNcDGPUe/A25nUd1tp9hl0osGQ9yOmkqUTg7/fE
	 r5TL5t8xuW380PTshpdMg8gmV4HxBx9u/2oFwFJDGbSYZa7HH6g06t2oGcDNoLyt4+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zxv73/0r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA763606A32C;
	Thu, 19 Nov 2026 04:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zxv73/0r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8031F000C4;
	Thu, 19 Nov 2026 04:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061052;
	bh=SB7CRaFtmEuAENs6jmMf3VREQQ5QylgKtF7xiBJzfco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zxv73/0rZK78e9u3K10bdq9hHrMNHhg8EcOloci/Ys2OV7OJZW79/nt5+6bGDOrFq
	 FwsLqEm5fmm6GCljiktFuQZGTaovOTMdU8cRj1vYdHpIJADPh1YWfx2ghglp/EnMHN
	 bIHKPnx5AIuK16GAbb+uFpwMJ9bW4O6/do5G8OII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Nicolas Schier <n.schier@fritz.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1414/1848] kconfig: tests: Provide defconfig outfile for savedefconfig
Date: Wed, 18 Nov 2026 15:57:32 +0100
Message-ID: <20261118150018.693808930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



