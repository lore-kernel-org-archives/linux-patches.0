Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060598;
	b=3NINvHhFlS+M+tlS8tRVlxKWMI09vvSxEX1djO8/gXk8+mmJwAe4BfcA+3nHeMCL+14j
	 u0NLFMFZVwZSgaAcD5tN6YvgyffTHiVrfDi4hYSPeg5T14dHe1FLF1f+/pMJUhN6ywvef
	 HIKux7OBy13es4Ts4KwjXAQ1CPyRqCvQfLNOSEfij95pJqS5yZCEoTtLPdtnLaUvVfa/Q
	 B1U0BQjQLtyLJ06zO5TANDimm4baE7vlaIkTR1+HQC5XavhA0XUdhQ12LP8v7dRnIYjRq
	 EVkGbMEkC/ZOVpCD5mt+7CAtQJ1kkTrnHAy08dBGCOwr9dvJfAVwqP/8UvKLvIYaJkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JpsgVBE4MKJoA8L6Q8ej7+10qZO10emy7As/T+4Y7F0=;
	b=eHy6CQiXDvhG/e6qic2KsXD10FNIfGUzqf+/3LN85U/YEq4NtspDngbW/P+llLPA2KTg
	 LEAPIIpH77lhxGRgCyQk0lIwSpLUqQCbpeCA4LTxdKtDPGUssGoeLbWOcv4JC+PiGLJ9T
	 3GXW068qUK75cPWLR9PC/LC6osgxclDjsTI36GMan1B60KutIV5IfWJmBncQif93HwkkM
	 lwjUW66gBJZ0lzd73MtpI2xqI+iKXOvTD3RRGMQxpA1cwh6T2R24BDYDFd/rZQxXYtn+b
	 Jq7U+7lbe7EM8EtTRLMCgtCIwrD4mFqYGGzZ9dXSay/aW4saaVPbAI7iCLemT/Q2BLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArI4gIkb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C12606A320;
	Thu, 19 Nov 2026 03:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArI4gIkb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668721F000C4;
	Thu, 19 Nov 2026 03:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060597;
	bh=JpsgVBE4MKJoA8L6Q8ej7+10qZO10emy7As/T+4Y7F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArI4gIkbFMhgPoDE32SEhMWXclalM0WB2iD4vW6wbDxQTkjVqWviOiEY8z3fd/FIt
	 GTKFrQJ7HheWC0CgeYDu/o0IjdHrdQdxx/VasyS2yknm5wqAMY0KXj2HzvvsgN0OFd
	 MRWTZBjlDKGwB17tGG8pCbYz6SNL8B+KAWqSW1rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiele zhao <unclexiaole@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1257/1848] security/loadpin: Update the changing interface in the source code.
Date: Wed, 18 Nov 2026 15:54:55 +0100
Message-ID: <20261118150012.365605850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Jiele zhao <unclexiaole@gmail.com>

[ Upstream commit 0860b72d535f869e26252df66d4f634e1655f84a ]

Loadpin cmdline interface "enabled" has been renamed to "enforce"
for a long time, but the User Description Document was not updated.
(Meaning unchanged)

And kernel_read_file* were moved from linux/fs.h to its own
linux/kernel_read_file.h include file. So update that change here.

Signed-off-by: Jiele zhao <unclexiaole@gmail.com>
Link: https://lore.kernel.org/r/20210308020358.102836-1-unclexiaole@gmail.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Stable-dep-of: eb0b0d222a83 ("loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/LSM/LoadPin.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/LSM/LoadPin.rst b/Documentation/admin-guide/LSM/LoadPin.rst
index 716ad9b23c9aa..dd3ca68b5df18 100644
--- a/Documentation/admin-guide/LSM/LoadPin.rst
+++ b/Documentation/admin-guide/LSM/LoadPin.rst
@@ -11,8 +11,8 @@ restrictions without needing to sign the files individually.
 
 The LSM is selectable at build-time with ``CONFIG_SECURITY_LOADPIN``, and
 can be controlled at boot-time with the kernel command line option
-"``loadpin.enabled``". By default, it is enabled, but can be disabled at
-boot ("``loadpin.enabled=0``").
+"``loadpin.enforce``". By default, it is enabled, but can be disabled at
+boot ("``loadpin.enforce=0``").
 
 LoadPin starts pinning when it sees the first file loaded. If the
 block device backing the filesystem is not read-only, a sysctl is
@@ -28,4 +28,4 @@ different mechanisms such as ``CONFIG_MODULE_SIG`` and
 ``CONFIG_KEXEC_VERIFY_SIG`` to verify kernel module and kernel image while
 still use LoadPin to protect the integrity of other files kernel loads. The
 full list of valid file types can be found in ``kernel_read_file_str``
-defined in ``include/linux/fs.h``.
+defined in ``include/linux/kernel_read_file.h``.
-- 
2.53.0



