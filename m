Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704475;
	b=0Wz3aolZ/H070KYBlylx4VN+hZaBjmtvY0wouYfpSL04+AwSeMdbUPTk2hko1LqHS9L9
	 X/LgossYDO/HFNZKzLxZ8NKKAhwFxhZAu193LZj2bbd62/PbRy0qzsAzzusXtphD+t+fa
	 bw2F+dqjCpVY/aKaY/LRnDDRd1MXQmUMJuf82JJIi0/wyt63BIQVquGXHHvYLIYjqqSRb
	 dhWaSOv4yGbK3rxzGi2IqrirWwxsp77BsqJctimW2xagK1NCRzQdQ/pHocZtS7ZkthO06
	 yULA9LXltJYaKfyQoMk+pyR3gwpQJdKTimp9UFzmnLNwhuUJt6jRMr63mNjs2dJsXWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uZA7kQv8mM7bdSMOXzpRRmC3y0fnkjcp9lVnCVR/awE=;
	b=u9M7Sek+hq8U7d+buxxCUjKOLBMDFRYWEJHF4xZO+wIkg5g14S2Pwdn6LA4Oq+2swzAu
	 Zhi9mVnjUKblBE2XPXjXg5CtruCcSrPVcu72t4oaTvlpveRYkDHLUt21Mips25dEjAnSD
	 dTK01iBA8ywkufnbRXYBunTfqyMTwKeSYG+eZIpp9x4JFuwZXkVgPz5zCuOFZeNKz2LlU
	 oGmuXz+Xtbfdzcs/D1jpxWah0PpQpWLovuiU9Dyw7XwB+ylbPBNUuPSECHkxBC/qqwbvl
	 DDIGHeQFjozLW2ZywhkOHAbT+QZwRQ5pcIu7X0K2oNf8bnJW5YXAEo/gVnfYM84UOjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3bMQYww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E70606A327;
	Thu, 26 Nov 2026 14:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3bMQYww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621871F000D4;
	Thu, 26 Nov 2026 14:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704474;
	bh=uZA7kQv8mM7bdSMOXzpRRmC3y0fnkjcp9lVnCVR/awE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3bMQYww524FhyfU/kbPrRWZeuJOZfjQvf3c5slgpYznV2UCxwCAdytnWQ2w96MrU
	 ROjUWKvE996n6R9od+ZmJBGphBHZCSrJmzWKMPb+Z3Dz+nU2Ohhrwv6lI6Vi80/tkC
	 /S6Y9YOdHM2IDtf2YzpYJ7mIm52WeQqjJBBoJbE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/265] docs, kprobes: Fix bracket
Date: Thu, 26 Nov 2026 15:37:46 +0100
Message-ID: <20261126143614.547275466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b757b6dfd3d4d..341b4eef9c6c3 100644
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



