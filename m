Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015240;
	b=M+/qq7xjG2dIB1nOGTI/400f6t28nbGOAsVPjOx0yrvgICIvnuHc4zhuzhbS1hRf1U8x
	 t/vi/LI4DTIliTHWWBo48GOGRTfAxm3ZHTVa06FE6W8LJvbUcxvfTkS3xn+5uBfsKgOy9
	 wsks8yLc+/RctSqyYPR/EHvuZEK7Ybh6t+z2ox/MxjEOm38awqR2vLOPu26SGq/aPcX6T
	 BLzrYMk/uo7vqDXkP4xGpF40PvvCdNbw734O4i73hrpmgn1/VxW2zAmf+0LG0vZsZipfh
	 62DFqotp1D8A4Pth8UCQ39H/LlvR0Q/jvbu6BWSeF8N1CwlLum8r4xGK6lNYM1Wz7yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6RPH2LO8P+6qKFM2waOGQH/xWZJaQIPHYMwH9bfz6EU=;
	b=BOjZHjlu4TXNlSsPHKDb66EWHK7Tg0g7M7onydie5qe6CCmQCDU7GsWw6ZQoUF9eAEl7
	 H28RZQBJ5EQ5Sn1VHGTJDGRxpmuQ8ErHMVxf0KQqEcLH+Y1lt1C9VTh19sxWZ8eOB/3Ih
	 T3PuRttExI8nG35QHwOI5TfnmEkEmeXhqKzyEtUVaFk9WDEpaTiQcbMvj8bUB4rANKsZb
	 x4vFjKRmrqcPs8w52YxjhSBjG+1fW3d0KlgENS2/4s7RdLjXSFmS5vAw7LROins4eJSkP
	 TxCs2jKoFjc4glJ372ra6vVXKZu9M9Qc5lHUCEGshdrqX8LHhTMpgfdfYy/7OIwbXrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GfUVtriC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B290E606A336;
	Wed, 18 Nov 2026 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GfUVtriC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CE01F000C4;
	Wed, 18 Nov 2026 15:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015240;
	bh=6RPH2LO8P+6qKFM2waOGQH/xWZJaQIPHYMwH9bfz6EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfUVtriCOEO/j7QSClW4DmARwwVTq70ueP/4H/9x+/0xhvjDX8Rs1KBIMn0WT9j7N
	 LaBLgDElAZZzHsTEpeVFlxwIVw1QNAuvipQURvsL/ITaHv2amQSBZXbTRB2muSmOhF
	 FdIJuQFbet87HRkI9SZCBDTr44YsqeQP7NOSQBBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0102/2651] selftests/filesystems: Add .gitignore for fscontext_ns_test
Date: Wed, 18 Nov 2026 15:22:22 +0100
Message-ID: <20261118150251.563593878@linuxfoundation.org>
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

From: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>

[ Upstream commit b573f7966695470dd9f5659d32681e7e2821d426 ]

fscontext_ns_test is listed in TEST_GEN_PROGS and is built in the
fscontext_ns directory, but the directory has no .gitignore. The binary
is thus left untracked by git after being compiled.

git status lists:

  Untracked files:
    (use "git add <file>..." to include in what will be committed)
	  tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test

Every test directory must include a .gitignore which contains all the
generated objects, as per the documentation and convention.

Add .gitignore to ignore fscontext_ns_test.

Fixes: d64ba78b749a ("selftests/filesystems: test completing a context from another user namespace")
Signed-off-by: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
Link: https://patch.msgid.link/20260819161738.3517-1-mahad.ibrahim.dev@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/filesystems/fscontext_ns/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/filesystems/fscontext_ns/.gitignore

diff --git a/tools/testing/selftests/filesystems/fscontext_ns/.gitignore b/tools/testing/selftests/filesystems/fscontext_ns/.gitignore
new file mode 100644
index 0000000000000..a632905257a33
--- /dev/null
+++ b/tools/testing/selftests/filesystems/fscontext_ns/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+fscontext_ns_test
-- 
2.53.0



