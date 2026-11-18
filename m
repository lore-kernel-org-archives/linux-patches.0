Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024353;
	b=i5hDkYRHcUX50tXSc9npBgkPEh3puxO70pVBfRXR1yihsTfDlLHLoppsDQO58zxzlEd/
	 nXrxt8NxiyD/8glLTrqAdVcfRVxrzPXVndjamUkk8H9JadVIHZ5ZtjviUemLjtYhsOxnp
	 G2EjEvfSYDpNmxf5C0u3jg6/yvJkv2NIGT6vYZ4sMksV8vrW9BNUh7jPgjN8JCUlBmH73
	 R+tSRRvDRXFPHnHqxFcnWFuzAMfXl7b2EF2UYk0e0ZkRQ8kwtCpAbt5fyUTxwq5PL3aKN
	 otoTmO4OFnlM09UCp3GKFtrVPfq+3efarRUCGMOKVNQhkEpbNITgzqy3ogGM41kRcgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tUFBsA2h6kq+f1C4lGAcdlkHZbrQhrsDz1sWWKybAWQ=;
	b=xpM0yZLHcQLrh9pItgPqkH40vwEqiBQ8H4sCD06fiTov5jHbdQQw1+xcDIILqd3I8EgA
	 nxBLH5xZ1k2qlHPDnErKxkHxGvsoulDMygN9zWm9w7GcLH5zmOToira99/Pe9aMQdArQz
	 xpticT606giRepZosrd8qwcYP0/1sw1NM1YXv9WFkLhozfkCIWrvVcSuvndIM61UmSoVX
	 +dJcNy5Zl6J0bCMxpeFiqtuQYmQn8DLMx1u1o7s0h8WPRTmMte76kzAe35cV3vx+My4Yj
	 UWStQ55zmavuETcMI5wnguIvv2n3w2hDDzD8tmPA8CNjOgOmnc90DGBtExXZi4J5k4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLRqiUrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E381C606A320;
	Wed, 18 Nov 2026 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLRqiUrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4976D1F000C4;
	Wed, 18 Nov 2026 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024352;
	bh=tUFBsA2h6kq+f1C4lGAcdlkHZbrQhrsDz1sWWKybAWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLRqiUrLJ9jXgxooneG9qgrJoApRrl4jl1mVO0xkU8Lng9Szikvgx6cK1BZnIECem
	 eKgVyFz4ohitRC6xtf1bN2F9aoH+LtV1WiIL0b0PY9kPRBlYu9i7o2JVou3n5pMJJv
	 meLBgeIKoU1FnvX4q8QTdZCgVtcu0wUQIPxb67uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Sinyavin <sinyavin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0654/2151] serial: msm: select PM_OPP
Date: Wed, 18 Nov 2026 15:39:49 +0100
Message-ID: <20261118150145.659678793@linuxfoundation.org>
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

From: Dmitry Sinyavin <sinyavin@gmail.com>

[ Upstream commit 6a8352bb4e4bfcf67fa23c49d2e0d14684ffe2e6 ]

Commit 173ebdedcd84 ("serial: msm: Use OPP table for DVFS support")
made the MSM serial driver unconditionally configure the core clock
through the OPP framework during probe.

When CONFIG_PM_OPP is disabled, devm_pm_opp_set_clkname() is a stub that
returns -EOPNOTSUPP, so every MSM serial port fails to probe. Select
PM_OPP to keep minimal configurations functional.

Fixes: 173ebdedcd84 ("serial: msm: Use OPP table for DVFS support")
Signed-off-by: Dmitry Sinyavin <sinyavin@gmail.com>
Link: https://patch.msgid.link/20260830085340.2542624-1-sinyavin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 2b9c8b39d68f5..b75c7b9157b16 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -905,6 +905,7 @@ config SERIAL_JSM
 config SERIAL_MSM
 	tristate "MSM on-chip serial port support"
 	depends on ARCH_QCOM || COMPILE_TEST
+	select PM_OPP
 	select SERIAL_CORE
 
 config SERIAL_MSM_CONSOLE
-- 
2.53.0



