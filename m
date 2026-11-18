Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032593;
	b=Nh2c/BDSIWoT46lSD/vr5HSdnlJb/qCmvEzYsFTcl09RZluUXGvC94GfdbiESVa5uVjw
	 9UoITP8GeRsnC2OVTV2NYwdtPaWwNFEIE0LptrExF2fr0swUvfWLlXxoCP70Wnu8devT8
	 UBMbEAn9oSJxiKG8mpTDgO4Qe+eP3KPHAPnqNYsw7ta4ozD6xTqGzpvOKJg6++koTUCAf
	 yRgq/R8C/Z8SdpPIWy2tUwjvMSv7/Kq73rTGVvy+5kZdkWFx9dA2Ucd1V4v9eXBzWK1Be
	 eqw9TCfNqV5SHPwvv9Zrm6spfJDkKm2uGtb+iAC1RGj7MlRmxBVN7QrO2Q5qEjB9wmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UizJ3ecOtc9maOfR2F63Saqefmr0SAx8TIF8ZdjDDnE=;
	b=jhT/7tsg4Z66YHHjN3Ubu/EtS7LIu3Sg266jjQwnRhFaJWdYvZg4tBpPVJ9e/F97+JYq
	 PDGLZ2pSw4jpYyh/PUy7YUqvc0D9USV4qG9tloQ9wTINXMOxBEADKhmHxQASefNN53+qg
	 NIFRg5Y7DOKRCxziTItHtpcAeUgUcHA9BXOdoZs9LQG6HwVnJheDpp4Qm8r6tHjvjeQF3
	 GGPHaMifL3976/nBHgBFvR4LfFYDguUjuNExKHEFff1IPQ1t/4Gb3Y9/EPbMxvPZl/VuM
	 o/0xuGg2Cttg9y3LYX9OrTEaEpZxatu8PYdLdndJJwIypvo82b96/Dvb/Pn/o73B4EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zT7NylZr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C069606A32F;
	Wed, 18 Nov 2026 20:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zT7NylZr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FCE1F000C5;
	Wed, 18 Nov 2026 20:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032593;
	bh=UizJ3ecOtc9maOfR2F63Saqefmr0SAx8TIF8ZdjDDnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zT7NylZrDMubNw9ws5GjOgAU/32gqPs8pADLyUVo6sfUj7foJl9BYqMoGyoWB3wXq
	 MS5zoZx0HPag9Xk30m47n5thX229/bJwW9GcC4Yu/fC0N/0RCQckJ4RdAJvscLoReD
	 02ehLLOOfKco6NgJ4QzDHjYP+n/CfFFcMIgdhW08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Fan Wu <wufan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1421/1756] ipe: fix invalid sgid value in audit event documentation
Date: Wed, 18 Nov 2026 15:59:08 +0100
Message-ID: <20261118150105.740891501@linuxfoundation.org>
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

From: Manuel Ebner <manuelebner@mailbox.org>

[ Upstream commit edf43c031902787117822b23324cf08ccc023bf6 ]

The audit event example in the IPE documentation contains 'sgid=)',
which is not a valid Set Group ID value. Fix it to use 'sgid=0'.

Fixes: ac6731870ed9 ("documentation: add IPE documentation")
Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/LSM/ipe.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admin-guide/LSM/ipe.rst
index f93a467db628d..d1f5cdd88e44f 100644
--- a/Documentation/admin-guide/LSM/ipe.rst
+++ b/Documentation/admin-guide/LSM/ipe.rst
@@ -458,11 +458,11 @@ Field descriptions:
 Event Examples::
 
    type=1404 audit(1653425689.008:55): enforcing=0 old_enforcing=1 auid=4294967295 ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
-   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=)
+   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
    type=1327 audit(1653425689.008:55): proctitle="-bash"
 
    type=1404 audit(1653425689.008:55): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
-   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=)
+   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
    type=1327 audit(1653425689.008:55): proctitle="-bash"
 
 This record will always be emitted in conjunction with a ``AUDITSYSCALL`` record for the ``write`` syscall.
-- 
2.53.0



