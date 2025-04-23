Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B5F101F2;
	Wed, 23 Apr 2025 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422201; cv=none; b=CD5kwVvlhgqbAXRzWYcIcPQJ7ZSd9rmqSIt6ISHezi/ZBjcWtXpabLlhBx4szx25j8ez+jWigdxAOHyIGY7mECvarBAYG0XSMe7MxEmUD9FE2pq1XyCXM3akc9RtFhadhQgNDrZdfegOZWuKqsqICWg6BWqlfaZdeq0GyoQtOUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422201; c=relaxed/simple;
	bh=SpCnkjln4i3UXYSHfFM2Vwn9m3RRNUDNCKqFxx77Ig8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObdnekY7+o58vPsTZ1PSzJlrdsWqcJP/8O+aOhxtSq9OpBgm5fdggPZDyzE40xWMChmVOVoGsom+aHCzPMT3RXfIpEhPkgLEIU0NrzGq9Djeq7j7T/gSGZXy3Xtic1gIxYv36GRSgKYajoXtzt1xi0SctZ45TKL63FXKu5xZ6ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/kerI1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/kerI1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A322C4CEE2;
	Wed, 23 Apr 2025 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422201;
	bh=SpCnkjln4i3UXYSHfFM2Vwn9m3RRNUDNCKqFxx77Ig8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/kerI1t5+bZ/wify00qQe9uvv5lwSBqHkzvYw2hGQwHaBcdFeXvT3Og35QFWoSnx
	 8/6C2Wa1puQgnH21RSpcKlcJT1yFNl3whjZCqP1D9hrMPW6JBbDFtPgVDeHPsLVIxK
	 tb2pXdCf+g3xdHeaG1g91TbTBGSTgDkO6TghYVkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 296/393] kunit: qemu_configs: SH: Respect kunit cmdline
Date: Wed, 23 Apr 2025 16:43:12 +0200
Message-ID: <20250423142655.568855298@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b26c1a85f3fc3cc749380ff94199377fc2d0c203 ]

The default SH kunit configuration sets CONFIG_CMDLINE_OVERWRITE which
completely disregards the cmdline passed from the bootloader/QEMU in favor
of the builtin CONFIG_CMDLINE.
However the kunit tool needs to pass arguments to the in-kernel kunit core,
for filters and other runtime parameters.

Enable CONFIG_CMDLINE_EXTEND instead, so kunit arguments are respected.

Link: https://lore.kernel.org/r/20250407-kunit-sh-v1-1-f5432a54cf2f@linutronix.de
Fixes: 8110a3cab05e ("kunit: tool: Add support for SH under QEMU")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/qemu_configs/sh.py | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/kunit/qemu_configs/sh.py b/tools/testing/kunit/qemu_configs/sh.py
index 78a474a5b95f3..f00cb89fdef6a 100644
--- a/tools/testing/kunit/qemu_configs/sh.py
+++ b/tools/testing/kunit/qemu_configs/sh.py
@@ -7,7 +7,9 @@ CONFIG_CPU_SUBTYPE_SH7751R=y
 CONFIG_MEMORY_START=0x0c000000
 CONFIG_SH_RTS7751R2D=y
 CONFIG_RTS7751R2D_PLUS=y
-CONFIG_SERIAL_SH_SCI=y''',
+CONFIG_SERIAL_SH_SCI=y
+CONFIG_CMDLINE_EXTEND=y
+''',
 			   qemu_arch='sh4',
 			   kernel_path='arch/sh/boot/zImage',
 			   kernel_command_line='console=ttySC1',
-- 
2.39.5



