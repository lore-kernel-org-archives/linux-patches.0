Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055199;
	b=WKJWFeFK9/n7h2gkVp4mJqXK7/vJKLxtQPHer18+C1w2pafRVxcTOI0CoP9y/NRidMYo
	 HCxKr9BIabW5Qk78go74uwl8mqWyworn0wIonjW3xRMBn6KkJVI/sgqYz3AdvoLwwNqju
	 ED0wznOCG9hNGX11PuGeURFwNp+3RR9ALnaE/CfleFqoZSa/0RPjFoVXuA23Mb09/EaFf
	 xqdSS1+EBobAEbHLAHkjcWmanj9JNDnrA2jObl7sBXzmHP947fyQCHkmBQUTUhMu+Yn5E
	 QVGw0SQykzanXk6bxmHQ0xbzfLmRiTYMY6uMqwCssONnoYQ7ZdY9PAC3ZFK/AWg5F3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y4zcYQo6vqy2+x6grBx6Qv+TOhU+7gx+Oi6+3dJuWIA=;
	b=Rgq50jXdbXG3puaMIwA8z4bfGYS6kH2ucM06LV0IUO19qQcKsjQCJLzT7fflK4le+9Rn
	 WhRw497KpMT82D6AUYlqigAdrv89J+E32F7HoUEmrRfDjFT99Wa66X3PFxmVUw6NFa1Zk
	 FkMAH0h3vGc92bx3Ny11cst55I116IerTptutsnnOHCsS3MeopV1S8U0hVVyENMl1mdeE
	 /u2Ys3UAFVgo0lKdeqx4f7GwqzwgaqaIcwr0Vsi5v6u0cqYCb7zbTmVK+hVtawJOBz8Ko
	 knu4PfKtJHcXgmoVdNMNBjZfKuUM+aGIO2TXUvqyv4VwCmZETSDNiuhPP4UKmC5ol1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILeBWMQo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE970606A31C;
	Thu, 19 Nov 2026 02:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILeBWMQo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54C01F000C4;
	Thu, 19 Nov 2026 02:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055199;
	bh=Y4zcYQo6vqy2+x6grBx6Qv+TOhU+7gx+Oi6+3dJuWIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILeBWMQoGDaqbB+gM/dDFXUCmtR+cdATRT7858BLGGok2VYdUWlKQ8WujSVvRpof+
	 b7d92Q7R1wmQOUn4XxerX1uGj/oB+S2/1nQT25FxIASXf6HSLZtYznE/7Ft7IGdrKo
	 UD/SYQrUvvh0YU4iXVLBSO5gm3ZbVD5eQK7ZYBII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1509/2214] loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation
Date: Wed, 18 Nov 2026 15:53:05 +0100
Message-ID: <20261118150112.385827136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



