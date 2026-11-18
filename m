Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060509;
	b=RJsX5+dRJ4y9PHeWDyfGEsacuGeM1AsUysq1b72lOkB5EQH+w2Tb44IZpd/4txjJmzSa
	 fE4r4nfXRUHt/Nl8md1U/UtrSPXVAWgs/1tVJLIhQA0K0WrR35J+vr86wokTuwOk8AozT
	 pQ9HiFPj+RV4bVmjVzfTqqjkw0w7AemiVq8lJpFHUV//B5ua7vMxRbvr4cXi3l48WOico
	 ZF79yS0mHmTYnLiXZG6KlZ5funSIyPRt2cPMR6D2jF8X6knyN2pmZxn3E4dMd4Wvm89Og
	 gIhhA16Wr/rRPulsIxrOnbWBA/Xhp1ZFUbCuGU/qAkyb9Dol7Q98GX84szxOyAJDoCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sScUw/sNg40ZJVQA/4nz0+2bh5WOQnGX1gPmSIEr3aw=;
	b=X2qPZ9LjB70Lph0arrmAHCDUrOGC1LoH38lSVV/5RUkW0Fz89rzn9i8cW9JtXitHtOX9
	 XT/tQS8rlLqEWn6DfxGbTAH30jYaMm2uR6M/hlJ48QJKqmVxq3w4Tkwuzy2GwF5g5u9xb
	 ahs3mSu2YW4UjNa6b8tUxhGrpR0lF8aMHwDJ14Aelmrx84ENXr4Sj+4XMGBH0crTI5xhB
	 S2pLfoVXNsA3xi8SyQ21Vrqbr7h6OMGpTLfqP8JZHu16AWjrIzKeEb5zQhd+1MVmexkJb
	 G4Npyv6011eK9VLEC+iLOE12He2z63bRdMwUUtFMD3mfDoMo1B0OJM3jC0xO8iaCOuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jfzndjkl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A88606A325;
	Thu, 19 Nov 2026 03:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jfzndjkl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F60F1F000C4;
	Thu, 19 Nov 2026 03:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060509;
	bh=sScUw/sNg40ZJVQA/4nz0+2bh5WOQnGX1gPmSIEr3aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfzndjklKnuhZmOzqnjwFEuNfZQIU/BrF/TBMHS/p2RedbnuBF6quEmkKRL1s34Po
	 ys0Qjg6AKirqRxJmDlNvXpsVI4g0JrFL9FVw2ehY3xnSB9hY9MEyZVPwsXHPgVM3j7
	 7Y53bSJrngK4hPSn2Cyk5aNUqS0R7NRdAZ2aE+eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1197/1848] power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document
Date: Wed, 18 Nov 2026 15:53:55 +0100
Message-ID: <20261118150009.775237984@linuxfoundation.org>
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



