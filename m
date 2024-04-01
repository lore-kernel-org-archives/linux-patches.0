Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AB645BE4;
	Mon,  1 Apr 2024 16:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987259; cv=none; b=KH+kTwu3K7gep+DfKvtA86QFpmlfbIQg9ueH99t9uUQSteni3Cc5llp+nJI/orzcRy5rW5loRKltbj+mL5DC8YO9eZ9A8t+87BwazAubCzukQqC8DOEc87KVd3wVY0+vHG6JT8e4dJay9gJqRBjS6lvlfb64bW1OeCdDdaeWbVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987259; c=relaxed/simple;
	bh=f1BYO/xKYvMegQPmWuA5imjoQGwBA06AO4HWP/joQ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqCRFHHCVPgqAOLx/N81Mg7T+tBRy9hWzsdIL7fxwIOoDpfgyOFXu4MLYFBYlNnRDgQmcevVdpnqBnn0D0309B3ggjT52KBkCtDDbkNfMZinXyuZ5ObEeKyPxowESpjg5bksV8/IS6BVgxRXxtHy9/FpjWbeV3O5WajVRrzkLSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqrnBZpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqrnBZpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F44DC433C7;
	Mon,  1 Apr 2024 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987258;
	bh=f1BYO/xKYvMegQPmWuA5imjoQGwBA06AO4HWP/joQ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqrnBZproYrreWg5mkDBtEXyH3yfb96WgalwxDVJX6R7yXHqBd23qNx5X22JeZDol
	 kEp3VCkadBT7B/6J4/E32NmD+vxBzoHM8TZ6QdX2TTOo1Tgx1QS/UUVxqjuvEFH4NF
	 tXYws0XSIp1TwCYMZreupSoIskGd1Dt3hQG1RbWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 203/399] wireguard: selftests: set RISCV_ISA_FALLBACK on riscv{32,64}
Date: Mon,  1 Apr 2024 17:42:49 +0200
Message-ID: <20240401152555.243048107@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit e995f5dd9a9cef818af32ec60fc38d68614afd12 ]

This option is needed to continue booting with QEMU. Recent changes that
made this optional meant that it gets unset in the test harness, and so
WireGuard CI has been broken. Fix this by simply setting this option.

Cc: stable@vger.kernel.org
Fixes: 496ea826d1e1 ("RISC-V: provide Kconfig & commandline options to control parsing "riscv,isa"")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/wireguard/qemu/arch/riscv32.config | 1 +
 tools/testing/selftests/wireguard/qemu/arch/riscv64.config | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/wireguard/qemu/arch/riscv32.config b/tools/testing/selftests/wireguard/qemu/arch/riscv32.config
index 2fc36efb166dc..a7f8e8a956259 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/riscv32.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/riscv32.config
@@ -3,6 +3,7 @@ CONFIG_ARCH_RV32I=y
 CONFIG_MMU=y
 CONFIG_FPU=y
 CONFIG_SOC_VIRT=y
+CONFIG_RISCV_ISA_FALLBACK=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
diff --git a/tools/testing/selftests/wireguard/qemu/arch/riscv64.config b/tools/testing/selftests/wireguard/qemu/arch/riscv64.config
index dc266f3b19155..daeb3e5e09658 100644
--- a/tools/testing/selftests/wireguard/qemu/arch/riscv64.config
+++ b/tools/testing/selftests/wireguard/qemu/arch/riscv64.config
@@ -2,6 +2,7 @@ CONFIG_ARCH_RV64I=y
 CONFIG_MMU=y
 CONFIG_FPU=y
 CONFIG_SOC_VIRT=y
+CONFIG_RISCV_ISA_FALLBACK=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
-- 
2.43.0



