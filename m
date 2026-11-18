Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060601;
	b=d5AN+slmEAGnGtTgo5dypq7lbGrPLxm+2WVT5Cs3rarVdUoV62SAQT9uDLvXLB2XtFre
	 0OJpaTTvQvqq93CqvgT4Kb72w+tM0MMl3Q1tPfCls3n9fgIY5dmpq9UxxDQaUelDeOpuG
	 tNB5YCSx13RHts3JWKp3uBmMNlp1+nd8vVkAixQP2v9NOHtykS9Pknb7Pvbvcxsj97rdw
	 cSj7BFAACtX36ReoN17ox1xP604RT/M4PaXUZYrgiWU1W9Jd1T8/29+2pI6QlJIFlYycK
	 Q0TFNRAUZT4NGWNmnmXs6D+1InaOSzRDNGHvFYsaw86GUZTrhkRFh/04mKtcvY/a52w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2wXddr/O6pCjjSiFSyyLfY3IDysmPAPYVL4zO+3EbPY=;
	b=f8Sn+tRf2FjPmMXbyFJGLMT58FvAZVnLKhy5NvE8XYEbQFdMM3kkAuNb9PiosL6+zrK/
	 +Vl5/ME9RO+hy+ul7uaECiw0WZzC5dUoUIjPeFdvvxUnUMIQG0B4N52oJsbZ66cXa7bTh
	 9P1ncmDSEHSsljh8Fmcz7M0J9kiZT/Iq/dnLNsZOPvZu/vjErrcxPnGN7+zUHpnJ/6XpL
	 0W1A7Fmj4kcbq1zxk9UwR3QSAqYZJRX0OG7Y6dsk8+yjJeFSoodQWiw4E+TB3OLWMccs0
	 e9ojcMUOcmgTQZOcb+wIgMrHwrIyHGs/8gdFC60OBblD6D0WRxNTnLrmR5q3qAhOl6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOu9j4dP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7DF606A320;
	Thu, 19 Nov 2026 03:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOu9j4dP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372221F000C4;
	Thu, 19 Nov 2026 03:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060600;
	bh=2wXddr/O6pCjjSiFSyyLfY3IDysmPAPYVL4zO+3EbPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOu9j4dPAOXjjCht1QeVFmpdLSrEhjgi5HD+fL0LMxlLuvnOzmYjEMQ0QM5OX/HSL
	 /KBEjmLjv2OsRwIZsEcXOMrxKrKM8po6Vw5/pM7R5liE/0KHvNMS0r8unolFKi8Hl6
	 vV9yAoWz/3E3l+lxja0oCDYjyGtzTOzrAWCQZ4vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1258/1848] loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation
Date: Wed, 18 Nov 2026 15:54:56 +0100
Message-ID: <20261118150012.403234878@linuxfoundation.org>
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



