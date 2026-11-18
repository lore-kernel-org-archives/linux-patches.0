Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019397;
	b=SQxT/QvWIDXWAERL+4sBGh0NIn519XVJ6x/K+dk2ZT3TdoHEvoF+keK5nyjgJebgD9ID
	 Q8EU/gLDe7TrVlByvfrBtpwpSo7oifLSDRo1E/4SdJfPZgNoNQySqHPCB2J9nXR43qFj3
	 Lbzj17TemjSuCiklyPkA57FtHrHRMDNtpwhgvRDE8YF2JgEbu2TRnlWjxAJCC3xTd11NG
	 9blZ71q7dODFKNmq/onPngMY1Obhf8R0f++lv/M6nbmejsTw19t72ZHd/EqKGtfwZPulw
	 UW/GQ+AzRgPGTh/B8udPAETcZteSBZKgIpgBOpP567MXjLvbZvQGMlSaXLhHlgMV3eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KlPUIeY4+poPwsgUDjlmDq2fhDtZ/FgkttnUy2+1yik=;
	b=2lpFZYLEePSj1FpLFk2fSSG6g3AaMq4ll+pdGyXLdxqrpw+CUo5eS6w5aZAMUmCq1Dvw
	 mJc5fBOBYbgpJzWiEy+MCd7Qr9OKCy1R4xZaFBCvGI+PhzP3K93AbwwQ1yqt5LbfAK8GR
	 hcJBmivFERR8xO6amCs0CnXfyikvHP63NXo10gF/BNuUtrj+yPdbgZ9CVOmSUuA5tw1Xu
	 LUMPd+rf1EhQ7Cj+uKVv5g0AM2pyoNaCA9ykkMg5zyh5qn4mmgNupnsIItX9A/uvJMrMQ
	 5qL71NCl0Q/Ao/ka8hrBtQQOoReGn2+gDTgErljDuAWcQgo8POhEpm6ixnWdz92bIZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KpvR8fT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB1A606A332;
	Wed, 18 Nov 2026 16:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KpvR8fT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B391F000C6;
	Wed, 18 Nov 2026 16:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019396;
	bh=KlPUIeY4+poPwsgUDjlmDq2fhDtZ/FgkttnUy2+1yik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KpvR8fTdDXsqjyPQXJrucENCYuCxAtYvfE64oGY66dPLarYQCqnOTnA1Iky4soZk
	 adBlfuQzYDOS+ECeox5oOVDWsUi0edtn21RgOpxvOj/CpoTuQ4xnKauiwQD520Yuyo
	 Kci9uIoJVnv+yDNtZHF3SGbRGYe47mVO9RGTTBck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Simon Glass <sjg@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1582/2651] scripts/make_fit: Ignore schema checks when decomposing DTBs
Date: Wed, 18 Nov 2026 15:47:02 +0100
Message-ID: <20261118150344.869224959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit 3bf2237f59af842e546fa4b2c146198db95d1519 ]

With CHECK_DTBS enabled, Kbuild appends a schema validation command to
the fdtoverlay command saved in a composite DTB's .cmd file. When DTB
decomposition is requested, process_dtb() treats every word after -i as
an input file, including the semicolon and the validator arguments.
FIT generation then fails with FileNotFoundError while opening or
checking the size of those words as files.

Limit the input list to the fdtoverlay command before extracting its
arguments. This preserves the base DTB and overlay order and ignores
the subsequent schema validation command.

Fixes: 17c31aded9a1 ("scripts/make_fit: Support decomposing DTBs")
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Reviewed-by: Simon Glass <sjg@chromium.org>
Link: https://patch.msgid.link/CA+NtrhQBK8uW32qO3dXxVxO1GSN-0EJfyJ16tnyx0o52T17WtQ@mail.gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/make_fit.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/make_fit.py b/scripts/make_fit.py
index 15ba26974fd72..9bd35aa721191 100755
--- a/scripts/make_fit.py
+++ b/scripts/make_fit.py
@@ -292,7 +292,8 @@ def process_dtb(fname, args):
 
         if 'scripts/dtc/fdtoverlay' in cmd:
             # This depends on the structure of the composite DTB command
-            files = cmd.split()
+            # Ignore any subsequent commands, such as schema validation
+            files = cmd.split(';', 1)[0].split()
             files = files[files.index('-i') + 1:]
         else:
             files = [fname]
-- 
2.53.0



