Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023684;
	b=jLftw/x2c4DigO+Z2MyQ42MFhlf1BFzhecfwJ1IiU0ZSEj7G+4cl7rXIFlmurfj1E1Iu
	 YnsStKZfFZu6QsliXEgiqKMseCpCQ8hSIKLSSbQwAoVFBFRMfxKcolqGkUK8p/Be9roZB
	 j9VzAdMgPOP21Hftz5d+k2wUKTIs0EVO5JrlM1tTRzX+1aUGpG2emS9AxXtuHfbOfDNfK
	 Y3Bd2kJCzK8p+ib5D4I75nU1Iy29ljcybdDJKgP0miTRHWrNSWlR0cmPa9b1jo73ox6ka
	 tOOgmBPMO8T0zqEGACHZJw0YCz3a6Ur8/c2aZsSsf9u+2TIDGFlcEpiy7sMXN1Ng9cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AsVoYKedI8xT1YyltjdqN1B1zSmaV3BS9HiZYAZKOXw=;
	b=lUDvmK1XfgVuB6YW92YRdfUTueATjqVpXlYtIuucb2D5bt8czS7CIAAQX1qJhZ6TjWj0
	 xlR0zLGD2uc/EL2etChhFiUNLGpvFLAOZmSwb3XrFhDx6O1z+nFg47NRc8CJ8FLAecqA8
	 vnwvilX+UeXBlMpsvn87LXhPpNNNvDlrB5+FFHwX/8cUCPr5YZr55qNrWD5bBIG8QIxHt
	 7NzVrjFEtHFG37+sfT86ev5QN1OQEsgsqXAvsJ6pVAFsRHjcbsEjAvzW4xYto51D5UQp9
	 HUL00HXFE1CEGeFU1PGruMOici3qAQInhQUnDSq0h/bbB53B3IftNAheKm0Tckua9Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4xInRr9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE7606A32A;
	Wed, 18 Nov 2026 17:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4xInRr9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A121F000C4;
	Wed, 18 Nov 2026 17:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023684;
	bh=AsVoYKedI8xT1YyltjdqN1B1zSmaV3BS9HiZYAZKOXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4xInRr99tEJ4hwv+26GONnUMjWdrfbTISscrlyVWzq8PdHLdEMWY3Qw901154X2v
	 +gLFXXPnsSkXPtoHu5LZpBDu/NO7doZj2yIFZwZtsgGxM2+iNBXeGBig5tUQeq/gaW
	 7RtRYyDTPbmRiN/Lzv9T3p1SxTiATE+PSmuNkYMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0456/2151] loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation
Date: Wed, 18 Nov 2026 15:36:31 +0100
Message-ID: <20261118150138.637710266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit eb0b0d222a832b6ec851e56d4922a775ac762955 ]

Commit 99d5cadfde2b ("kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG
and KEXEC_SIG_FORCE") removed CONFIG_KEXEC_VERIFY_SIG but left the
LoadPin documentation pointing at it. Refer to CONFIG_KEXEC_SIG instead.

While at it, clean up the grammar of the sentence.

Fixes: 99d5cadfde2b ("kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260905013655.58665-1-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/LSM/LoadPin.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/LSM/LoadPin.rst b/Documentation/admin-guide/LSM/LoadPin.rst
index dd3ca68b5df18..a90fd9dac9606 100644
--- a/Documentation/admin-guide/LSM/LoadPin.rst
+++ b/Documentation/admin-guide/LSM/LoadPin.rst
@@ -23,9 +23,9 @@ sysctl allows for easy testing on systems with a mutable filesystem.)
 It's also possible to exclude specific file types from LoadPin using kernel
 command line option "``loadpin.exclude``". By default, all files are
 included, but they can be excluded using kernel command line option such
-as "``loadpin.exclude=kernel-module,kexec-image``". This allows to use
+as "``loadpin.exclude=kernel-module,kexec-image``". This allows using
 different mechanisms such as ``CONFIG_MODULE_SIG`` and
-``CONFIG_KEXEC_VERIFY_SIG`` to verify kernel module and kernel image while
-still use LoadPin to protect the integrity of other files kernel loads. The
-full list of valid file types can be found in ``kernel_read_file_str``
-defined in ``include/linux/kernel_read_file.h``.
+``CONFIG_KEXEC_SIG`` to verify kernel modules and kernel images while
+still using LoadPin to protect the integrity of other files the kernel
+loads. The full list of valid file types can be found in
+``kernel_read_file_str`` defined in ``include/linux/kernel_read_file.h``.
-- 
2.53.0



