Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622259;
	b=u7xJSh4wj7lyzmYAOs+XFWWUTdsUm+D4lxLESfonhfZoyqGWgsxPE46nFrfS8YjPVw43
	 dii8J8JwbczcKgC+esOvfa38LOhs5Z1R6/H4ak+bDaiEPUt+dREwYxvFOY9chengX/jYW
	 YVt9TV9ogP22eFwa44HJLD8NpOaWwoPCqwcJpMBJSoWSVU2Wbrc4BcwWII66lMlV1sxhS
	 wdJIyFNtSS63P/ZIT15UObi6q3cUAFQqzWF6ZBelxG9EnHBAb7pfDZR8yNe+CMUdsJYZB
	 gQIxIDH3+JxlQOxb2Nn6RHGWycpiCXR6ju9P7kizKEOFcLElAT/xJPGLcFPu2botLtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XCl2GQSbR0InOwE+m2HoizLUtG5/UOYZzKC6FMfaK1k=;
	b=olgByY8EA5JEt4cbWopq4C1H+OzghnGUM2PmBjCizqYfLPcC6lRJ0avkqXVrY4FErgEe
	 vnfkqGF07RBmqvuVNUXtWQxLdD7QNeO/hEUDqwDGNwM0cg/dhQp6H5rECjOhlGrAOP/wg
	 HrgRPld9KDTmwH+/iyin92bBAl/2YoJtGJxZi/P599OO44La25HBkXIj4MBb94VrTAUyh
	 +MATIkJ1eGAUIPtqyb6P6hBcIRqsMD5henAtYJPxNR2HJyK2bpt/b9A/jMQJlMGYmIRuR
	 Y3eiAKGyGkrLHWlz2Cn0NlTQpxbe2cj1YdtawFOAX6P7OhzKENJj4WbBIDtFMfZe6Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dLs8hdVJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A00D606A31E;
	Wed, 25 Nov 2026 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dLs8hdVJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820661F000C0;
	Wed, 25 Nov 2026 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622259;
	bh=XCl2GQSbR0InOwE+m2HoizLUtG5/UOYZzKC6FMfaK1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLs8hdVJLWpel8fBS7/I0BJxKWWrUKBGmDEf9uhJ9cTlS792Ly0fmVNlqz6QgHyj8
	 BoD4LJ41YLAm+dnETLz801y8vEm7on1NBC0npmrdrJkXMEIdRZUZYbAIQ9NkehSASe
	 blon1EweohE0H2kn/pItTZrpKZeAq/Pyaua5eXyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 479/990] docs, kprobes: Fix bracket
Date: Wed, 25 Nov 2026 15:30:46 +0100
Message-ID: <20261125143833.315895124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



