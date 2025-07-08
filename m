Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B023E8F5B;
	Tue,  8 Jul 2025 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992932; cv=none; b=mPnzEz730wrARW7iHQS0Felh07KsSKXoJbSQ3xpre6RGBBsmvu82VPSRR+WNo2TsVignKjjjIYPvAae/S8nU/RzRUDdavK1JASxO/R6SDtTu2DTKRm6sFdb2WGwOTF7qDEcQ8uUTiE8sO2aEOZqJv0DLNncJ+k+mzonPpS6eEjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992932; c=relaxed/simple;
	bh=3RiUaKOdku12fg5cy8si584xlKI8WY0mUI5DXbqoVCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayej//CTecTFaIy0XDDp/CWboOHb647lTpkXrkLLeZ2vvR/SEBkFf8VafTucG9o9LUiV4hveu+26NKiQUKDp0J2w4RSXvvb+5uO134214ryA5CdAF0J9ljGTMH2QLWeRvjbSSEG73cfn+s4vQx7Qrma+2H34O0YU0doXlYpYa+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W10Eiilz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W10Eiilz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362E1C4CEED;
	Tue,  8 Jul 2025 16:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992932;
	bh=3RiUaKOdku12fg5cy8si584xlKI8WY0mUI5DXbqoVCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W10Eiilzti4lMjMXRNaiEcZjm5PmdUuHB2hHmZJ8e4J8lhU5iRsa0dEr2p4UvamFf
	 dXHFcMLjjHvUALY8xsqQz3bxu6pw3/Tl+KdP8UXVI/sJt7oVnda7IbjtIzlQxHajdN
	 geyATdT/U5JQ/XQUQXyVCbsjxvuXIxjqN/EKyETU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/232] kunit: qemu_configs: Disable faulting tests on 32-bit SPARC
Date: Tue,  8 Jul 2025 18:21:36 +0200
Message-ID: <20250708162244.061982050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <davidgow@google.com>

[ Upstream commit 1d31d536871fe8b16c8c0de58d201c78e21eb3a2 ]

The 32-bit sparc configuration (--arch sparc) crashes on
the kunit_fault_test. It's known that some architectures don't handle
deliberate segfaults in kernel mode well, so there's a config switch to
disable tests which rely upon it by default.

Use this for the sparc config, making sure the default config for it
passes.

Link: https://lore.kernel.org/r/20250416093826.1550040-1-davidgow@google.com
Fixes: 87c9c1631788 ("kunit: tool: add support for QEMU")
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/qemu_configs/sparc.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/kunit/qemu_configs/sparc.py b/tools/testing/kunit/qemu_configs/sparc.py
index 3131dd299a6e3..2019550a1b692 100644
--- a/tools/testing/kunit/qemu_configs/sparc.py
+++ b/tools/testing/kunit/qemu_configs/sparc.py
@@ -2,6 +2,7 @@ from ..qemu_config import QemuArchParams
 
 QEMU_ARCH = QemuArchParams(linux_arch='sparc',
 			   kconfig='''
+CONFIG_KUNIT_FAULT_TEST=n
 CONFIG_SPARC32=y
 CONFIG_SERIAL_SUNZILOG=y
 CONFIG_SERIAL_SUNZILOG_CONSOLE=y
-- 
2.39.5



