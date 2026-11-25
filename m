Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624962;
	b=TB4iLeWKFUZjAna9a7Lx1vxJSPQx2N9YnL/4KDmppGS9YrkI9nIo1fghUI5Fue1ccdRo
	 /iRgWrjarT89Z//arbS19UwcHDaU+SU9HzQlQxISNcU6fTDS0JlnVGkI+B3UFMfji6sro
	 eWwtxAjRD/554TiGW8no9SkGbITPWuTtDCN6iMmGXNK1OZqwKM0VFa873xDMChFN3uA/W
	 l5rrZrimx1Nz0SeL5/Vco8asP+qM1VGwlUWuCIVK2oQulugPvl5XsjL1nv/KOwfgTibHu
	 p3Alv3r1CEYhEB6gi0ZE5HB3n9spTMvh01XfPEO+FsNyNSX2StdT9CuqfG1Kom4IeCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eBjvK8rRNChDIVAYS9+3/VHYVJcf/C2jyGSORS4xKms=;
	b=FaDxjBbYRnkQHD5oNeEJtXrAPvJx1fYVplwpC+IWmUyGYfVcspqOLex0EIkM+u87KZWV
	 sVQEK72e8uo1a2uSwzkf4clQVnMGsCU1Ovjzsqd9NSqLYZ+GDrECKihQJLfOPjqiDMETh
	 lc0JYc6Idz/P2Qytwa/b4yUvp/EkZk7lbbj3ivtYLxvjdTz+qtrKK3TSp/8ZHc+WDbebo
	 RxtrgTVZi2PjIbB/lVgLkSSzUTDvsbFM8LBImH4hVgJUlNls7md1ylHm9Zy5OBXAgweMu
	 V4BhDE0g0KPrJp6Gh7wWoYSHkMnpkfV7n6+s0ZPKu60CDxr54SlI1pdoffVkW9qXK6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfN397Ox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDB7606A32D;
	Wed, 25 Nov 2026 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfN397Ox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6708E1F000CA;
	Wed, 25 Nov 2026 16:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624961;
	bh=eBjvK8rRNChDIVAYS9+3/VHYVJcf/C2jyGSORS4xKms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfN397OxDgo+6cKENd7BRgoc4uu0tVGhKhoshg/wX+MFf9RHTvk5Wv4JscUYoz1Qi
	 MZFPGXsODxGi/ha2MeoE1UdnXO5kNo/Jvb7q1kVptgD4pzwlnF776XPaK6LuA3dR2y
	 /HYhhJvQKbeaWUAFVuAqZU1U4BMZ4nGPgJ5k9MCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/816] docs, kprobes: Fix bracket
Date: Wed, 25 Nov 2026 15:31:47 +0100
Message-ID: <20261125143857.508743650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Ebner <manuelebnerli@mailbox.org>

[ Upstream commit b91a5c16996d089cd07ceaf33b5a621cb94c2c2f ]

Remove needless ')'

Link: https://lore.kernel.org/all/20261112085511.690900-2-manuelebnerli@mailbox.org/

Fixes: a1dac767622c ("kprobes.txt: standardize document format")
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/kprobes.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/trace/kprobes.rst b/Documentation/trace/kprobes.rst
index 5e606730cec63..0b19d82d7d4cb 100644
--- a/Documentation/trace/kprobes.rst
+++ b/Documentation/trace/kprobes.rst
@@ -31,7 +31,7 @@ can trap at almost any kernel code address [1]_, specifying a handler
 routine to be invoked when the breakpoint is hit.
 
 .. [1] some parts of the kernel code can not be trapped, see
-       :ref:`kprobes_blacklist`)
+       :ref:`kprobes_blacklist`
 
 There are currently two types of probes: kprobes, and kretprobes
 (also called return probes).  A kprobe can be inserted on virtually
-- 
2.53.0



