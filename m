Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A0620F090;
	Tue, 17 Jun 2025 15:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174707; cv=none; b=H+P3y9I9IGmcpvy+AxF02JUQlPoWeyNRIOHafWqAT+8cyU5O8dgrGhg8bfwVVECZxf1nzekRMGtbnZJ7Mlaz6bGN8vhduNfU8eUG+0SHThG/dDl7opogpvKt4TNkwwuNZY5Q7x1TeGVjxjDhMDDXXPw33f+ohTg4GPZmgrWdgD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174707; c=relaxed/simple;
	bh=c9iv2fMY4ia5rlA9QYFdy/bs6tPCFc6vNsY3ITh7IOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p64UQr+8VJHhvpR6vc6hIc8sEHX96Q+Zq9oqO7UMCmGCneWDMooyQ+1CUwpMo5iBZKtOOm9nHLFtKPrpB/N3V3XTxI6PvftHqGabhky7819VYbhlrxO0Yq6AnVUFvq09YB+6kvwO9PgqAHrmsa2WSrC/JTiJ1GC3ZIKIOrokzpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suTVccIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suTVccIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517A5C4CEE3;
	Tue, 17 Jun 2025 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174707;
	bh=c9iv2fMY4ia5rlA9QYFdy/bs6tPCFc6vNsY3ITh7IOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suTVccIg5++pxp35imuEAl68k68+Th7TsyYADz0yToyoq9cqprg68h/2TH8y0toOL
	 EFuGmkFTQMOg/SVwoT6KG0JyIgy7MM5Ddft/c5izHGSwyzq2PQ2QcJVFhGwc+g/kfA
	 3I2dIvoLuzI7wMItmS0pggmXQlsEQy9Avrsy9Vqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 010/780] kunit: qemu_configs: Disable faulting tests on 32-bit SPARC
Date: Tue, 17 Jun 2025 17:15:18 +0200
Message-ID: <20250617152451.915389746@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



