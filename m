Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDAC7C08D;
	Mon,  8 Apr 2024 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581205; cv=none; b=evnCtnuPzGO/ubbfH4WuDAWvncPH6LCzznOeyqdVW2AHSt1ro7dlTSjhNaLa7wbfZhAsN7AwpQVgJJiNzIZNBoLR31Hu2Vce7ov9JP9GcbyId3xMk6xqcw84eYBtBVoxbUbQlBt7Gse1XIMmYH6TADjq2DWEfkfG4mzkCRxNR38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581205; c=relaxed/simple;
	bh=BFOR5gPK3wqCkVlH7h/XnLoxwzBmTybqnJTf2l0yQZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc6qhdxOzfmhlGxZq4MzvKw5JQ8XvQuDKwuEtB3+fjPWA1lVJhciXlu68XcEsdhtJ/8LVWOxyOBjQXN1SDKRxN0B1MUKygot/DjnzbP68LqALPe//Ba2kGJiEkJiS8+qUtnCOxn/awDw21FpfXQTDWawJ0fFxnhOiz7vYCWaC5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvjBLVkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvjBLVkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6E1C433C7;
	Mon,  8 Apr 2024 13:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581205;
	bh=BFOR5gPK3wqCkVlH7h/XnLoxwzBmTybqnJTf2l0yQZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvjBLVkjONn6S/7KV2f/xfy0h+ldrFFFtPOCNvMmhE0Bs3OyWTIQTs8wb2w0XDPTV
	 OsgiF7rLq/6ft/NNOSG64Wkl48Rc04VT+Ni+FkAoeoGkV0w6JRgaquBO/afjB0jpjk
	 PeGlDXWkdh1fk25wtgBXzs6wZm6TFobZ+u/hQiqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Hofmann <mhofmann@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Alejandro Colomar <alx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 001/273] scripts/bpf_doc: Use silent mode when exec make cmd
Date: Mon,  8 Apr 2024 14:54:36 +0200
Message-ID: <20240408125309.328782158@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 5384cc0d1a88c27448a6a4e65b8abe6486de8012 ]

When getting kernel version via make, the result may be polluted by other
output, like directory change info. e.g.

  $ export MAKEFLAGS="-w"
  $ make kernelversion
  make: Entering directory '/home/net'
  6.8.0
  make: Leaving directory '/home/net'

This will distort the reStructuredText output and make latter rst2man
failed like:

  [...]
  bpf-helpers.rst:20: (WARNING/2) Field list ends without a blank line; unexpected unindent.
  [...]

Using silent mode would help. e.g.

  $ make -s --no-print-directory kernelversion
  6.8.0

Fixes: fd0a38f9c37d ("scripts/bpf: Set version attribute for bpf-helpers(7) man page")
Signed-off-by: Michael Hofmann <mhofmann@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Acked-by: Alejandro Colomar <alx@kernel.org>
Link: https://lore.kernel.org/bpf/20240315023443.2364442-1-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/bpf_doc.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 0669bac5e900e..3f899cc7e99a9 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -414,8 +414,8 @@ class PrinterRST(Printer):
             version = version.stdout.decode().rstrip()
         except:
             try:
-                version = subprocess.run(['make', 'kernelversion'], cwd=linuxRoot,
-                                         capture_output=True, check=True)
+                version = subprocess.run(['make', '-s', '--no-print-directory', 'kernelversion'],
+                                         cwd=linuxRoot, capture_output=True, check=True)
                 version = version.stdout.decode().rstrip()
             except:
                 return 'Linux'
-- 
2.43.0



