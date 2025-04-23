Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B76E27CB12;
	Wed, 23 Apr 2025 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419916; cv=none; b=na3xk0RYHEW7RLGpSqCW+7SrUCMGEUGENKFbTvkhHGYKGfYmni27xsglDJlD93PTcz2zZTBVVcasccFYIZpryoKsAisnVtZrR3GOXD+p/+NBBOdxkkMeoUlWCYapmFxBgVTs0k3f8AoWuBrpMOzHvXcZ30Jj6jRCSxQNpKR0SJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419916; c=relaxed/simple;
	bh=TW80RM4tD6tCYlDs6x8/EXYKHLMrGtoLxk6VYn2BO8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tc/vc7KDv9EMqL2d31IMfwEnJh9Nli3rfR63qKQzQ3HkDZNcd2gXKyR6ZtRzaRPcbjpgDKBAzKqNJWLW873M6XnO+cHnzZeoLhfa3YoKl9uawm6ir6FYdBIiqJ1lvwvcD1sZRrR+1H3qkpew7T/jR9jieQLcBdUn5HToZ0OEFRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wra56rIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wra56rIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36BEC4CEE2;
	Wed, 23 Apr 2025 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419916;
	bh=TW80RM4tD6tCYlDs6x8/EXYKHLMrGtoLxk6VYn2BO8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wra56rInW9XFwjNFSK/uhbs5k9mf93NcMjwStn/ivNPUTc+vDS+7d0w5fhmDAZaxs
	 dUfh0k/DgPrqCT9hbK887qPOg//vuRvNqwUw7mulJCRAm/F7hzI10Pkp8H7RKiAqMI
	 RBvZvN7PaV0AS8IKVV5cLGlUriH3tyYqhV/lfwUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/223] kunit: qemu_configs: SH: Respect kunit cmdline
Date: Wed, 23 Apr 2025 16:42:31 +0200
Message-ID: <20250423142620.339759258@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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



