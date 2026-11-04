Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829621;
	b=TCmi4UVbdObObPLdl9oMswBY2sumqN0oN22OAi2skwza/KTV4YcpjliBoDiIrImiR7zf
	 1wyISCnDztauxf8aCdngYMX+wL/oJy8ImvwTkl/P+tH9RzgnJFATsZoF+fl3tXTl63s6H
	 UASB/pOGol8VXCWKJlsagcfhWYvqvGub9HrWL1aqmikk+Xhb7+7NWIzBLmirk/NcL4nRJ
	 mKfD5rz4B7I+itld6KyYq71gr1vrBAeKNBW23LjnDqyy8DCOftwCVKob5CV50naQTrNXA
	 4dE1DBcpQcOZVbAgwKBODgcxD2VQMU6kzTchTiNWo2Yjv+8M6lofb6BnLaR2g+6Oamw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kfCkbwyfAy2inqaLeQ2BqI3eu2qYcPQJVycoBpVtqqM=;
	b=ZubHEx4kSIyM/FmDrJxABAqlqOEJYTOwHm8kr6DvM28hP8OQ8n7P7OMZ8Sc3Cmfp3PsP
	 iOKNXkoEVYYPLPhwumcWzYWDPVg/UbIFvYXfusVvxzbAy2MUx+xp3Y6ViS8i8I7Xd5hy1
	 p9pJtoUnVeuTo6ngjMhCX41afmsahYZ1MToUqP6z84G602NHe4ArZhHRC5iKDaWdt5pgE
	 850ENLC9N4JIkPfN1m8GWoRMAtiB2MWdtxju6mi9W0qxXzCsNRnayQDUW3n0m/+hd5JYk
	 Ii/RSBCzwTEtcZYUj85jugl6od6B0E3En3CDAkjwmHpbbR8bjtkddyXIG2h0nnpt5fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLV4WfOf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41408606AC0D;
	Wed,  4 Nov 2026 22:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLV4WfOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C787F1F000C1;
	Wed,  4 Nov 2026 22:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829621;
	bh=kfCkbwyfAy2inqaLeQ2BqI3eu2qYcPQJVycoBpVtqqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLV4WfOfSinQDkA91xOqfD5iqamln6nbIquRj7lEA9Z9n7pmoyaGYjsCPwlCxBEiv
	 Q2SKwExhPGaWloGeLhxpydbLGOdAqA2ybSGyDret30xz0rkJJU92aAclj6FSBd1QAk
	 HtsPIemSrmnf3uQ044DfSbXJGdCBF2Meukcb4DMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0239/1005] soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:59:32 -0500
Message-ID: <20261104211050.545623506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 01479280fa5d4691013bcd64fdfd935117b69769 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Message-ID: <20260704121851.63805-1-pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ixp4xx/ixp4xx-qmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/ixp4xx/ixp4xx-qmgr.c b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
index 475e229039e30..e3ad0e0237a77 100644
--- a/drivers/soc/ixp4xx/ixp4xx-qmgr.c
+++ b/drivers/soc/ixp4xx/ixp4xx-qmgr.c
@@ -454,6 +454,7 @@ static const struct of_device_id ixp4xx_qmgr_of_match[] = {
         },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ixp4xx_qmgr_of_match);
 
 static struct platform_driver ixp4xx_qmgr_driver = {
 	.driver = {
-- 
2.53.0



