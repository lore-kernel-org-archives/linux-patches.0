Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619449;
	b=s5TmREurdEx7wAU+6R1z2txKFTQCyzzJMkJ4M8LU1W77NpguSI7IanKZaMIHAj0iuB3P
	 7Iv6aM3w6NPwz2/vBu1ssu8V/74XPpDrUcVMbZBHF7vZAA55RVeK5UjaSviq1xgGLqrI+
	 Fa8C3+WZyt6eBws+n94SRU5d+78HY+qyl9XdqFgYQ9kEt/+h5Pgudt+TsrVKr4WDwOZIy
	 7ziHBXSXA2mpMWUt/jt5R56c7nWpwde+rcJ8czYgiR7axm7Lr6IW7zJuHNXxYGeTOdrbU
	 Hec113Kr9V/eaRMByE0D3Qq/O/EDXzXlVtR8kFAzqpiOrWMQT2S24hFyzuTRAZ9UpKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFGRP9SfIN7eFxqXILZgR9BzB6e6RiQ2ISJ2IiMEUaQ=;
	b=o+2G51nukESNGjPjxckBAa1P2fF0RVGrtiY5+IOVZe2H+GQGK0veYjTh5swhGUMtMpN/
	 9g0asJzaJ56KZABZ0wx92NHritu+dBLDkV/SZPdJ+1xYSWi9qzRqteYfEkCJHUYa7q5uQ
	 RKwr22IXKmRVR7mzlsip+67+Su1KaIOSw8HRoMc5Osh8FlKTQ69+KD3hTrbyJL6WVP9ee
	 sDQUmM7gR9ldCgLR7gYZ/cTXF0xckypDlMnzHBJmnMS+9fbOCCBvXMJ7g8BZ+9cyYz/5s
	 E1R/OYV2TgTqCAcVw10KvlBpTnprpD5xY7Phcq8z7Jtp6TOzRXqUl6MejT60dqO56Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NW27bNwB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A8F606A326;
	Wed, 25 Nov 2026 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NW27bNwB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FDB1F000D1;
	Wed, 25 Nov 2026 15:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619449;
	bh=gFGRP9SfIN7eFxqXILZgR9BzB6e6RiQ2ISJ2IiMEUaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NW27bNwBm1hgVi5ZhyoEkHhV+fi9Hke8mmLzeU8AROqyteGxY24ivga0BsCvUE2Xt
	 625MnflqKsdEXq81ZwtAyr5cfaHRRnsm02Zn11zPCZw0h4CcDDEEYU/Dmkh/p75dnY
	 ymtLNZ8K79opekTStuLCPnTnjr9iT1Vac0gNe2DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0555/1005] docs, kprobes: Fix bracket
Date: Wed, 25 Nov 2026 15:31:33 +0100
Message-ID: <20261125143834.748471642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



