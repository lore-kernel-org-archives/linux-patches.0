Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015867;
	b=v8OrNtW1K6L9n7RjNpmxHyCcWz9Qh4cPs0fWrhlL1TC/YtLLZsWc1vDY4TtCbyFFYwQh
	 1X1Dq/vd/LNopscz+LyaHH5KarmQnVZYZ22DUAOqh2E3L6wE4cgVndcSPqIflFEgXBSJi
	 tt78HAd8sdJARIJogaqwh9Vv017P3dTQMT2yPPSKs1MR3VGctB8rjG1i2Hn3oCpvI0/XH
	 9QUQqrN4Z1SHW8yUgWfnvPOKqhxt+Yt6Y7DD02figHAycjaeUFiMhWkf/I7Gj2IeHrkpj
	 wvaGj/NND+Kq3j6bMao1FsXAanv4iTVPW4wa2H8DOMYrZyn3EBfPNGluA8cNQ/hka6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BPH81m6bahB92n9VgeCarKhlCHKecp/pBmfXEgUFiZY=;
	b=mjdXe3Q87O7ZguHyGiqI7AK1E4tH/XG040F4iz+69gLg1P8g0MGgJKidLRe8CqAqSAEd
	 Uf39jDtK8YapoV5/eo4727SRGQD9PnZ6rsfWWcqH4vpupwrGbPWwmkvuFiox9/AFgyDsA
	 qktB4Ne0hOkUhfuz3dhmEoO+tU2Xxb3OzOoHUoBAnLbsbyMFaslX25dR4EFwy0KT4M2sB
	 gMuRIBO2mzBGsgV1aYu77PzTycnLAVcHXtRsmf6/88Gysq3GJOS+WFA+REtcRCFXhLLvo
	 1Hfg1+h9tSf2mOC9ULvdFTL92jOnMLbAw7dDf4mwFRHgYojK8cZI1CybFAp4NQFK5iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8qvsX3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD2C606A333;
	Wed, 18 Nov 2026 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y8qvsX3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEFA1F000C4;
	Wed, 18 Nov 2026 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015867;
	bh=BPH81m6bahB92n9VgeCarKhlCHKecp/pBmfXEgUFiZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8qvsX3HjD7VN5aaXXBl5LAqCZaCbBV+jdE5O/YC5rECoUos49zXEaIhSAx9LSgbE
	 OVCWFNW9XaK38+qnfquDYlyD7uKo1vpyj1GiSRlNj9hKvM5zulrStsO6sPhTzeRhy1
	 yW6mD7B36kaxRbYh6CkfjI4wg1xo0p/RjzJrf0Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0325/2651] power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document
Date: Wed, 18 Nov 2026 15:26:05 +0100
Message-ID: <20261118150259.564887632@linuxfoundation.org>
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

[ Upstream commit 1101833121a447999309a01f03d5b35bc1652e09 ]

drivers/power/supply/mp2629_charger.c creates the attribute with
DEVICE_ATTR_RW(batt_impedance_compensation). The ABI file documents it
under the truncated name batt_impedance_compen, which does not exist in
sysfs.

Use the full name.

Fixes: fe27f04e0cdc ("power: supply: mp2629: Add impedance compensation config")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260905101849.42830-1-kmehltretter@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-power-mp2629 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power-mp2629 b/Documentation/ABI/testing/sysfs-class-power-mp2629
index 914d67caac0d7..a85f926ce9c26 100644
--- a/Documentation/ABI/testing/sysfs-class-power-mp2629
+++ b/Documentation/ABI/testing/sysfs-class-power-mp2629
@@ -1,4 +1,4 @@
-What:		/sys/class/power_supply/mp2629_battery/batt_impedance_compen
+What:		/sys/class/power_supply/mp2629_battery/batt_impedance_compensation
 Date:		April 2020
 KernelVersion:	5.7
 Description:
-- 
2.53.0



