Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD7B305E24;
	Tue, 11 Nov 2025 01:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823345; cv=none; b=BfqvKgNeN81231xyUnzBUvkZTVO1AB47pGEsBLwjokA2s4wpDkddA/5HKFAzoyUUU5fYZI3zu94871tLWpCGPy0F+swZzXLJNAbxHTd8Cb039KUWeWDIi2zhKo232sMZyteQLfC9LahUlgVs2/uYup5z2dGreEs3kPU7B0lPwao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823345; c=relaxed/simple;
	bh=GlxAvpcG/DKO8CeJsMKG+nYLKQrVGXeyzM10E9a4eeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7meKqs13H8qXJ3itCpUp+2nAbyDT3xNqoE9RM19I/KVftpNq7iOAlpAa5e05Ze1+oOcSk7u0+RGfFCoEoTJo5fAPZbxhn5OSDn9kdHZMXC87kncTaTXjCFJYeogFtqYN/ZumKVSgRUenwvqJ+YZOdY7tKiv/Usy/+rsfpsB09c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7hXS6Pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7hXS6Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EE5C4CEFB;
	Tue, 11 Nov 2025 01:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823345;
	bh=GlxAvpcG/DKO8CeJsMKG+nYLKQrVGXeyzM10E9a4eeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7hXS6Pc0jHfFjU+5/0bbofC+y923BV8gjiwOcFWfsERAEMVfSWgDGI45JaLcTxSP
	 Hgz2op+ok1AW2uiWYM4sDCDg46ntrqX5cSU0TFVVfXzeKTrE1M/wf8JFDGTRjD+HQq
	 e+dpMtUuz5JCsi1H7Zsz4jtkeY7LdqbbbL2iZ0Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 280/849] selftests: drv-net: devmem: add / correct the IPv6 support
Date: Tue, 11 Nov 2025 09:37:30 +0900
Message-ID: <20251111004543.193897731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 424e96de30230aac2061f941961be645cf0070d5 ]

We need to use bracketed IPv6 addresses for socat.

Reviewed-by: Joe Damato <joe@dama.to>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250811231334.561137-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/devmem.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/devmem.py b/tools/testing/selftests/drivers/net/hw/devmem.py
index baa2f24240ba5..0a2533a3d6d60 100755
--- a/tools/testing/selftests/drivers/net/hw/devmem.py
+++ b/tools/testing/selftests/drivers/net/hw/devmem.py
@@ -24,7 +24,7 @@ def check_rx(cfg) -> None:
     require_devmem(cfg)
 
     port = rand_port()
-    socat = f"socat -u - TCP{cfg.addr_ipver}:{cfg.addr}:{port},bind={cfg.remote_addr}:{port}"
+    socat = f"socat -u - TCP{cfg.addr_ipver}:{cfg.baddr}:{port},bind={cfg.remote_baddr}:{port}"
     listen_cmd = f"{cfg.bin_local} -l -f {cfg.ifname} -s {cfg.addr} -p {port} -c {cfg.remote_addr} -v 7"
 
     with bkg(listen_cmd, exit_wait=True) as ncdevmem:
-- 
2.51.0



