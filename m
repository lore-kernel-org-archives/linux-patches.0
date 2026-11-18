Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048378;
	b=oCvT/MXM6z0bjHoF/qg6K+7eFddQa4bJpiUxsnwC8hqG8tKvKp3na98yXHfiQ4os4BoZ
	 Slj9t60Xh1w83W5iNGRAuVx/oxGqDVpLGU9w44d4Z9AnIMOW8fc3PsgASVei5ZuEArp63
	 6kEBcp4WxQjmJsiiDrOBYsrVYuyeM8jvV6Quceyihyq+lyxuL9KRrmoWBTJDkEVjcX0c9
	 lFaXzvbbSZ4s448Mjm9vzGYtmMrRyplfgQmLhR6RaAomn17yGhkN3NNp3jDEezJq2Vwxs
	 jzW2Tm+83vVNpCiYg267emSj+su0CDAo8+4juOCm8gvDR2GvcOi9i//qKU6/DwtLz3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHHjI0Vd5FoC+YM98U6/HbY/jzDBrDSppFsk56LoF7Y=;
	b=uVEa2yVJ94R0j2jW1POLRD/djhoNpB0aMMmUmUvyyxSzc9b2XtlJmiwCJn8AgiyOzovj
	 vRMAYLMzag4J5WtoUjy3fwwP83v80V5C26RtD14n1IV4tLddAjGQp8Yj4pBmGBWBkAy2B
	 676/ROQZ558BcpzdyaylL9jiCrhwUf1WiuwjDs42JPZfE7Gpz96P4I43RiQHUiu4+zSpT
	 zzua98GUlMmcHvbonDR9JMfxQEc+PsnTQGgcYkKY+QcvwTwilo9M0LcogOHMgJ4hJ6SQK
	 BVJeIU9BIDfktJ/IiM/M5STvFZoPhMaR1t7kcPw/UGH0vLQPHG09o6Hm9/o0CKfqTAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpdTysSe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DC160A3801;
	Thu, 19 Nov 2026 00:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cpdTysSe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF0D1F000C4;
	Thu, 19 Nov 2026 00:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048378;
	bh=nHHjI0Vd5FoC+YM98U6/HbY/jzDBrDSppFsk56LoF7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpdTysSe1JUVrASFcyZxfCxHxFzaAS5nUjMCmt2XUSvB+FuS2h1sLXIsdUfTOnlzl
	 vTVRBbqhbmGuIf/VUQw5AXKZTBWpmVfNW5zAg8LVgPavtdH8jWTkR+bsjBfJ5qGFsP
	 jfcwX9+ZssdPnJoEJaMqO4h6ge5yhWd8Q29qKbj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1946/2857] loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation
Date: Wed, 18 Nov 2026 15:49:40 +0100
Message-ID: <20261118150311.340679294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



