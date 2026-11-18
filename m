Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039812;
	b=yjRF/M44IoJLV72VxBWK4fqD18USryDqgeVMMBgnSedfdLMcVLUmKl9th9aB4BEoO4yr
	 6f+FsYaGiJjKrDqWOtPGy9cRmhQU51CeoRxvPkRFMtljMIurWK6HuZM4ee2AMbeU2dFdq
	 fP4wSHIGIenLfXJEqPp5w1s/yqtRDKFQPdemqh1Ie/hk9GmDx93I5RfFqqU8n0dPosrEB
	 rJ+lsk3rWcG7ZXF+I4r9mL6xFgq03s1g3xPdfkNkTo3Lpf/9FszOvHF+VFSluEe+gcj/R
	 8ZSFlsMXlew9Q1DajLwD/ADNZ8kXW02EWI02YnbdkXcnoRXa3Qy+XvuyNgYJiC9F5bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvDguSSdGAhqRfkV7dxzfX6U//+IW5dOog2ZysF86j0=;
	b=iMXlx6SCdefVbmtvPQo8YJlS5CPE36Hap2DBA5UelVNLq/MMTxZh6/ouAffAZyUC/Hrf
	 yBCtr+5Ee6NrezoF7cMP4DNSnf4nT9fPYz8NIuNhsMFSr6R1x7DN3p2u/kyLjHfRn2OMe
	 mh7wLy5/YY0rjZcBeQC4MQWsk+EpraGK7vgo7yRAAJedgLw3emfKxq6AOsBBoVqLFBNl8
	 llFKcCdGiw/DTnYHoqzfjwYKJzgdF9QEilTwu4GOvQX6uUeS+jyrx1mvzXPgS+aGxmZJ2
	 a9z/NBOJkW8udcIhBDACjXEbOvpEFIsnYVZTv1csCXuz5SIeqFvEI6cymL1IAzpaUSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V25NzZm0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558C9606A320;
	Wed, 18 Nov 2026 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V25NzZm0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1551F000C4;
	Wed, 18 Nov 2026 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039812;
	bh=rvDguSSdGAhqRfkV7dxzfX6U//+IW5dOog2ZysF86j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V25NzZm0WlSRwQGcLCLkWFyB8yvx/HsYhLaDpURtEofxwFRE6iYDHg9Um7iMz+jFv
	 kHlyt2kt6/pDh3Z0pbuszPpTZC7oK8IKIgbq1r62bUaIiRHci0lWzIBOPDNu9HEk3D
	 WYbNY+mHRiiDF071B1El7/LL9AK9TMcrb8riikYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2227/3318] loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation
Date: Wed, 18 Nov 2026 15:47:29 +0100
Message-ID: <20261118150428.690106818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



