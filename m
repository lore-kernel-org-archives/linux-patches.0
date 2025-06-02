Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905472288F4;
	Mon,  2 Jun 2025 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877195; cv=none; b=IliNavWzsYaiOX3/dANTOq3XlBICSqzBZcjxtOcLy9/9HyEoJNa6GFV8aCdAeMZEzrfkXMBsRcPB76RiT54pBGZTl/xbyzqTRjaHnoLszzh2hC9lx8BHbDmyriGTPmW0VYM/i5ESF66rRFSPNXH3Jysv1eBeH/E7Tly2tSqBqfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877195; c=relaxed/simple;
	bh=gTCgi4AxJQog4MxJat/Isovv3gR+RauP6nqrJL2vXC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQJ25CuovggoRAP/YBqynBWAMSWTNX+oZxFZtLVTJBHSfIKR0UesX86bh4TQqbz89YbADhi/XLz3yRutOHtEuMXukutruE0BrlsCdekVUXMSp01USnamznX6tcOkI6b/mqaRk9v3WOW6Tf3xlsFRbCX7u+MOlrlsisnyg1sC9D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMhrsbUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMhrsbUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32DDC4CEEB;
	Mon,  2 Jun 2025 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877195;
	bh=gTCgi4AxJQog4MxJat/Isovv3gR+RauP6nqrJL2vXC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMhrsbUr5pYVp4x6bd6ltIZQHLccjgHhRBEPYrHo1mQU8+/ELXVyrXq/I+iA4JsES
	 g6CELxytEkinl7TyfLzWZ+ZANaQDeg6GZp/bsXw8vkGJgB9dL0SGmK8YO21095iqVi
	 3Syzy9h2R/xdHqLFKASt6WJzrOs5TEG+0BagoN0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Jackman <jackmanb@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/325] kunit: tool: Use qboot on QEMU x86_64
Date: Mon,  2 Jun 2025 15:47:30 +0200
Message-ID: <20250602134326.892756308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan Jackman <jackmanb@google.com>

[ Upstream commit 08fafac4c9f289a9d9a22d838921e4b3eb22c664 ]

As noted in [0], SeaBIOS (QEMU default) makes a mess of the terminal,
qboot does not.

It turns out this is actually useful with kunit.py, since the user is
exposed to this issue if they set --raw_output=all.

qboot is also faster than SeaBIOS, but it's is marginal for this
usecase.

[0] https://lore.kernel.org/all/CA+i-1C0wYb-gZ8Mwh3WSVpbk-LF-Uo+njVbASJPe1WXDURoV7A@mail.gmail.com/

Both SeaBIOS and qboot are x86-specific.

Link: https://lore.kernel.org/r/20250124-kunit-qboot-v1-1-815e4d4c6f7c@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/qemu_configs/x86_64.py | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/kunit/qemu_configs/x86_64.py b/tools/testing/kunit/qemu_configs/x86_64.py
index dc79490768630..4a6bf4e048f5b 100644
--- a/tools/testing/kunit/qemu_configs/x86_64.py
+++ b/tools/testing/kunit/qemu_configs/x86_64.py
@@ -7,4 +7,6 @@ CONFIG_SERIAL_8250_CONSOLE=y''',
 			   qemu_arch='x86_64',
 			   kernel_path='arch/x86/boot/bzImage',
 			   kernel_command_line='console=ttyS0',
-			   extra_qemu_params=[])
+			   # qboot is faster than SeaBIOS and doesn't mess up
+			   # the terminal.
+			   extra_qemu_params=['-bios', 'qboot.rom'])
-- 
2.39.5



