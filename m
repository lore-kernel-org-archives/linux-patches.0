Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D86F4315A;
	Sun,  7 Sep 2025 20:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277571; cv=none; b=o/kj4xMwkpZ1PGCnfEUFtbQoWs+u+DrTjN6esbKQTluCncqOTl/EQ0I9RHSacrY1pZaD4M9gk5rvHrXydvG16HSB/SYjydhTfAldRJvfrK3MHxYX0pLKhAiPyoQ4f+Nm0Xm10cPxIwbsWY1zwDv3BrOXd5//BPvSs1cpZC27/u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277571; c=relaxed/simple;
	bh=VHPdX9JHW/KaVqWfuWeBzvWDxq2sRLB7kaPtEhkY4LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYaQ7Mh6k7awMKrqfRIaeDR7MP+DGLV5qnxliDZNdTRCWABn0WnqhpduDzvUEKG9ErfGu+hvi5ngzS5v0kpcuFkRqpdwVTXAo0x9U82vq96ZQr9W4VL5YF896gyzba6WJitKUExveJcjTa3PQ7eyQv1bZXArpQVEAwQMh0nezug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vL6XPgN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vL6XPgN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4022C4CEF0;
	Sun,  7 Sep 2025 20:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277571;
	bh=VHPdX9JHW/KaVqWfuWeBzvWDxq2sRLB7kaPtEhkY4LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vL6XPgN7Ucf2SZScqVDZAJfmXFt3mX+W2NrW0Gg16FpCW1433fTRqGQJDJHvX2vdW
	 qC6xTBRswcmn+Pz7nNL7VWMUAlGeukfUBn2i+5CgN+C3Q5PGKFVzU7MX3DLYZTkFRC
	 5JJyylr3pSRYdoD0urhMUvkBr4Py8smYEHcYvEwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 055/183] selftests: drv-net: csum: fix interface name for remote host
Date: Sun,  7 Sep 2025 21:58:02 +0200
Message-ID: <20250907195617.093037031@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 49c2502b5946ebf454d7e16fd0189769a82b6117 ]

Use cfg.remote_ifname for arguments of remote command.
Without this UDP tests fail in NIPA where local interface
is called enp1s0 and remote enp0s4.

Fixes: 1d0dc857b5d8 ("selftests: drv-net: add checksum tests")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250830183842.688935-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/csum.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/csum.py b/tools/testing/selftests/drivers/net/hw/csum.py
index cd23af8753170..3e3a89a34afe7 100755
--- a/tools/testing/selftests/drivers/net/hw/csum.py
+++ b/tools/testing/selftests/drivers/net/hw/csum.py
@@ -17,7 +17,7 @@ def test_receive(cfg, ipver="6", extra_args=None):
     ip_args = f"-{ipver} -S {cfg.remote_addr_v[ipver]} -D {cfg.addr_v[ipver]}"
 
     rx_cmd = f"{cfg.bin_local} -i {cfg.ifname} -n 100 {ip_args} -r 1 -R {extra_args}"
-    tx_cmd = f"{cfg.bin_remote} -i {cfg.ifname} -n 100 {ip_args} -r 1 -T {extra_args}"
+    tx_cmd = f"{cfg.bin_remote} -i {cfg.remote_ifname} -n 100 {ip_args} -r 1 -T {extra_args}"
 
     with bkg(rx_cmd, exit_wait=True):
         wait_port_listen(34000, proto="udp")
@@ -37,7 +37,7 @@ def test_transmit(cfg, ipver="6", extra_args=None):
     if extra_args != "-U -Z":
         extra_args += " -r 1"
 
-    rx_cmd = f"{cfg.bin_remote} -i {cfg.ifname} -L 1 -n 100 {ip_args} -R {extra_args}"
+    rx_cmd = f"{cfg.bin_remote} -i {cfg.remote_ifname} -L 1 -n 100 {ip_args} -R {extra_args}"
     tx_cmd = f"{cfg.bin_local} -i {cfg.ifname} -L 1 -n 100 {ip_args} -T {extra_args}"
 
     with bkg(rx_cmd, host=cfg.remote, exit_wait=True):
-- 
2.50.1



