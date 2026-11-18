Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031391;
	b=xYuCpmXFYMS7xJNGa9ZCkPqBoMDjryookF7SAvoDke8Rfu0DS4xQLCpaHwgwroW20jqs
	 mH/RPUyPDv+CFqM5YLepdQjN5jyiKjVuucz/aGac1IqissWvYMtN9pXQeQXGOUsP2VJf8
	 qFsdsqIXpTl34BhYZn/t9XlII2xvRIi9hsSij/W9HVaefy6tvPfjmhnXOyLdRfaXw0Wyn
	 5ONkoiolrrkWKFSL+iwxIek+8npA196fyChlRPmsayMwQRVXuylAj5QK2edvOOwXDuR24
	 6Pfw40zIh23R1XGWDrqhCCGgmOfgckreS8aSsYzcGLus+90EEu1eCKGv6o32V9WnHUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j/26G/+4TwabNRPJfC7JmErRdS5+cGZixJgFl85kOag=;
	b=DjZWtQyPGPIijYko934kJcPGs5QIcDrsMRx/6dbbZvb8QpYPqbbXans1KOrvoVe6NhYm
	 doJCGh2kmophn+0rBqTu4yLOEEQosTBjEQi93fd5h+9HD1fifEICJzqqrjOx504hjfitU
	 mUEPZoevyVhDCz2WsLzFXjLnEOZBMrIQP0QbMxW0nFhaAPsR0XFMRSJAUCReWnuh6vRZW
	 2mWxbiM6imxCtXANABJzxND28/n9G9QtQD2tuwI8pFMmsDULkSt51kMwuLtZxDqAd6zhJ
	 iwOip++TxKNeivO0Nl1oHkaPsjrqjQpM3yqT9XD2E3gsgM2vdHFqE6e4f76tfcbcoXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=shD16wrs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5921E606A32A;
	Wed, 18 Nov 2026 19:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=shD16wrs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4F71F000C4;
	Wed, 18 Nov 2026 19:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031391;
	bh=j/26G/+4TwabNRPJfC7JmErRdS5+cGZixJgFl85kOag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shD16wrsMEHe/ZxgGf/xdwxXbwqAHVhTpo4sHNWOJgUUjbMfNlrHcOcj2gkGINKAF
	 W7TeHJGQDhN6Ce+A2PIuuKyAQol9Sayawe0SLrPMlnfUdEBVxtwYVu4vW8pXP/Lv0F
	 xgo4J5gIkdz4T5+z9V3SR22wr8mTAm9KZAesIPUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Simon Glass <sjg@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1041/1756] scripts/make_fit: Ignore schema checks when decomposing DTBs
Date: Wed, 18 Nov 2026 15:52:48 +0100
Message-ID: <20261118150051.493634846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 4a1bb2f55861a..6ce44a5597078 100755
--- a/scripts/make_fit.py
+++ b/scripts/make_fit.py
@@ -240,7 +240,8 @@ def process_dtb(fname, args):
 
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



