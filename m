Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043279;
	b=c+H08d9XnV0Figuo4x/cB3IpQuxy4zIrD8ByNuK4YBtCA5Gb9oY36FgViYOKc+Tzbg3y
	 t024k44NsLizDjTD+keXE6ZGjhDIENlcH5qJWIQh/pc9Av/3AE+emjNeDvZ5bQHp+ty72
	 aqELFKa3foJWB/2ikKLOMREcMYcNeU57+JJG5QTLX4T9k/N7aAUeBeBp5LwHJeBqDWXiA
	 GJUktoh7Hmv5iKbwSzyOMrr5g0lnEO/UHP9noCAnpOgCBQc9TjUc4yhznzEH18G7sEyo6
	 MgxKZQk3JsHc+dh9+aaznyOp5yJo6ytmNe5NXho/JAT385HQGNDH5Ky6KFnaAaxAm3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=207JTLOfT/hP3/bXMRo6nqvOauIL1GCo/5cklMqiKXw=;
	b=S1FOTNnCmti1FdII5utttaDXLuna9nsdm8gMQdRtF21zo+lXZhiCuC7MaFaBLbteKNHZ
	 O254sH6gnRE5X/F4bEvw13KVm8Y30ettcaS8dMB9yuQO4ReQ/cdgD1QRT8K3giZQHl9Hh
	 zE95+9h45QzuDciiYkiIEI2/CIHVa/iEWb5TABXXckTsgmFPwI2n+UvouPPaVPDnWHEGg
	 ERBuL0bok8/FLzlyQpQ/5eFrz6DnrrPhzzTEvczH7U3wHgGr2FoiIzXjb/U7BiWFrc0W+
	 c5LairPcy00lr9XwMqos4jJxEIRWh5eAB3KvI2OUFCjN3CWrGuZAzXbNZ2zrjU3BWFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2L2uE62;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C843606A320;
	Wed, 18 Nov 2026 23:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2L2uE62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E56A1F000C4;
	Wed, 18 Nov 2026 23:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043279;
	bh=207JTLOfT/hP3/bXMRo6nqvOauIL1GCo/5cklMqiKXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2L2uE62RSQXTl50xSOkeJxm49Ri+MqkSdzlPtkc1kRMRMHojT8fIJVrfmOcu2E6/
	 TPeWltSCDiYL4JFTD02nim5QEONXLCuc2eYJETgBHb3AU7sK/TkApYlvIN8Nk1/9+P
	 iXO/pDxeOFUtAHWPQBWOKDfEAZdj6HdP92Hqhvn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0103/2857] uio: sercos3: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:18:57 +0100
Message-ID: <20261118150204.968709070@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a432f68c51fc6761658445e80a798b8425fdb3dc ]

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152642.54769-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_sercos3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index b93a5f8f4cba2..20d8b5f9d0e97 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -212,6 +212,7 @@ static struct pci_device_id sercos3_pci_ids[] = {
 	},
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, sercos3_pci_ids);
 
 static struct pci_driver sercos3_pci_driver = {
 	.name = "sercos3",
-- 
2.53.0



