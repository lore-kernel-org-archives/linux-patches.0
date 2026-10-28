Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215899;
	b=n67PCx5n4YYEYzMYepSkaUk4VDsx4EhyTaSppKY/5ImXPGkXvU2mFGwcZMVd46q1wrt4
	 l97t5cYOhNv6myhs3M45BGUNEpxg8492moLVr/riABU7dOVYOy+lAfp2DLjY6caJLV3KL
	 MgPlBJqV9RhrBDbL1v8tYfLLj3hk6b8GkTP/YKJYOGZkgvF/eFqTuXJ6fLAG81yb2S83x
	 Ixs6ZuF3llSXe/OOk1NTzqgiOXoDeebPJrqBhXzZnpzwut2ABKK8s3XcY0WkxLNHtblEQ
	 1VG2wl3bMZ+kcu/j25pqcOvBjUloOX5uR2VbZxcufi2dhss4vjPgf3HKDA9ccIcOyQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kbPplSfCWLLhW+eHXvgllCcPPAlbBsH0gvXHjQAgxXY=;
	b=shutUHQ5SjPBRMBFZ8fsj5HeJoKG0WiOKmOnnO2ERY/wqGYmdGbkkz3VkIgW8CG6u5QI
	 pJoJ0Ok0INBbu1Z41H8znRdCTYW3nrF1JjYOF9TmamxsD1UL3dA3xtpVOZqXpBEXoCrUZ
	 3iOeFL7XFCUUl9NoBJXjNsME8CkhHZBQWtiwYO5HAH3vAV8IrL9MSotiqamfaxPgFiTfh
	 BLYCWKiuDspNC6D3cekBhaj9RL/09c2D3qb3yFfR7BE2e9BEUUYpKiVBDXV4dZFwwDkkc
	 TvZobYMjDT0fiXyM7FULCwRPSLOzaEVS0+x7ZbzYIwBjvLWmte9A3sx4mju/WjHuknA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0P1mCN1s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842F0606A321;
	Wed, 28 Oct 2026 19:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0P1mCN1s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833261F01825;
	Wed, 28 Oct 2026 19:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215899;
	bh=kbPplSfCWLLhW+eHXvgllCcPPAlbBsH0gvXHjQAgxXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0P1mCN1sOmtOerV5YcVtL6XoPT/8vejf0XxBZgijdN21LMMPWLpK/rNLZioNx607f
	 KgrwJhEbzBj+IPJnMvUmT8CklsFY4nudD6hmLcccWSzSTDSYDdQ2Cy+T+x2O1CCcPh
	 9zmcckQ6w9EqpagBjmzgZnKa5mdV0KWefFTt1UHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	lihuisong@huawei.com,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1317/1887] ACPI: processor_idle: Mark LPI enter functions as __cpuidle
Date: Wed, 28 Oct 2026 17:56:53 +0100
Message-ID: <20261028170529.400140041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 956ca5d72c76504824c8eb601879da9476973e15 ]

When function tracing or Kprobes is enabled, entering an ACPI Low
Power Idle (LPI) state triggers the following RCU splat:

  RCU not on for: acpi_idle_lpi_enter+0x4/0xd8
  WARNING: CPU: 8 PID: 0 at include/linux/trace_recursion.h:162 function_trace_call+0x1e8/0x228

The acpi_idle_lpi_enter() function is invoked within the cpuidle
path after RCU has already been disabled for the current local CPU.
Consequently, ftrace's function_trace_call() expects RCU to be
actively watching before recording trace data, emitting a warning
if it is not.

Fix this by annotating acpi_idle_lpi_enter(), the generic __weak
stub, and the RISC-V implementation of acpi_processor_ffh_lpi_enter()
with __cpuidle. This moves these functions into the '.cpuidle.text'
section, implicitly disabling ftrace instrumentation (notrace) along
this sensitive path and preventing trace-induced RCU warnings during
idle entry.

Fixes: a36a7fecfe60 ("ACPI / processor_idle: Add support for Low Power Idle(LPI) states")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: lihuisong@huawei.com
Link: https://patch.msgid.link/20260616072617.2272-1-lirongqing@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 8df8e789a0dbe..90b9e8d725d41 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1183,7 +1183,7 @@ static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 	return 0;
 }
 
-int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
+int __weak __cpuidle acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 {
 	return -ENODEV;
 }
@@ -1196,7 +1196,7 @@ int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
  *
  * Return: 0 for success or negative value for error
  */
-static int acpi_idle_lpi_enter(struct cpuidle_device *dev,
+static int __cpuidle acpi_idle_lpi_enter(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
-- 
2.53.0



