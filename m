Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016306;
	b=loLP/PrDQ8eSlO/nDbZbMZcN64Avzn0dkHjbPk03tFmUfYA3XoTLbSPe8YNDhfh3OVnx
	 Gagk5zDfWhfJBWSinX7uxzUXDpP2XXYsab0uWRvR5uEv9tgTsvqmLAKDSWr0892lI5d8f
	 PHkJfVeZYD5lI4AT2zpLVZOUvcmiEzpJ+5GBGN9DzhZMDS8usJXlG74hVyO1Bb6+x+ysV
	 g/tDvDa7Smb6ISrrtaH1MIb4BmuuOaWfmhfPvFl9xHLW0H4BPz90V/UGKbFmJmO0noOQk
	 0MtOiR1wgP54LzyW4Lhu5zUXADcILD27UxiBRCulQGQAPDWzeFdvFgE5Ut7OqhOazWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g7dplGtWn3l74hH4eMq/RvtM0tkIf5Sm0Int2wCZJHc=;
	b=k3M8JgV0oCf9/1Wjdy2qAHxmgLPDj2vi3C3qOwRldGXMdw1fkjJiLpMkZxF79KVaHsjT
	 OFZ0tYEdxygmakFmjDiJUw+SG/tz4/TLiQ/VkpGykjOXiJt3/qX640ihMxDzD7SSvg7iu
	 ctmqtySJ5TPGtj+/iZ7Rh205eP8Te9VDvJv+DC2oK1Qtr4rcX06krz8sYP8Yfydzm1VnC
	 z2B/BNQEPwUEn+XTWmO3Bs/GQdOMaF9YwPWTI6F4x9o5BguPrx11gm6dki3SiDyHmIi6s
	 1p6OWrH7tsJt1IUGKhQ1k1u5U6GSXV6DTiZoMnXx/jWckzgII9jBZinjz3jNjhhmLnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyHnukEt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807BB60A2637;
	Wed, 18 Nov 2026 15:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyHnukEt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E9B1F000C4;
	Wed, 18 Nov 2026 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016306;
	bh=g7dplGtWn3l74hH4eMq/RvtM0tkIf5Sm0Int2wCZJHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyHnukEti0JGSs5trHn0JlLM0RaEeMT/jGZnJEJj/v0NBdkQ7NYT3fqjb/jkPLJX0
	 6IorzhJ9F1Y+10J4Gl7R1B1RHPP50Xf2q9V0yusoTSEjKrR2sRYR1gPXush02PfwSf
	 2TAMG6+W3CDDOp3sbO8YataccuCuZz7Cm94pCoQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0483/2651] loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation
Date: Wed, 18 Nov 2026 15:28:43 +0100
Message-ID: <20261118150305.168416188@linuxfoundation.org>
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



