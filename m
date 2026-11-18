Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033666;
	b=PY0TTD/x22wUNT7fASHMZCEIXYoSG5OWvG8yEIrlpDGwULoDgq+tD0Vus/Qpr1Zu2qob
	 VZs+uoSvfUgoQ9Ks7N0oYOVuw0wKom5GrGUmUcdZOaHQ3riewH2xOVJ9OlschDlSveFAr
	 xewESRyiu0wYQzK6zzlBOdvX6sc6AEEWMMluPE3hb6wrnrVaHH0YX3jpWSgMPCEFvzBZU
	 NIhZ5VRCpOrpReLWq8vZll64Ctqg5HMKPAVrcOFaz69wa6m5qhjQ+gQnBX9a2dL2v7rnj
	 TJpAvB2T+uV6iEcErGuQJsaiWQ+5Dbd/3cwlklXSIP8hQCIQ/DoE8T68oivrXgTpnrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8FaLDUPGinJVvZNIReLe8srUdYUjhm/svWqsJn/DiZI=;
	b=K9pePz7xM6DZZTkRgauipWKfT2IsWpNRQemUEU+zeV/pmSnIxhTdxKe73agKWEsenLbA
	 sWanEA1YaA5JH8SSNcXEHnzYnCyV97DqVl2LnAMAvxOEu6POp/aJ010FM+DDlwLcsCaCh
	 DOuBhTEUYjI117OJwTQo7LadKHWGK3YcR8f1TD+IxDy8zGUIS/1AGaTW9efw48A3fLs4A
	 BAkBgEBP2KemLJNazsbr/RWt9BG+MeIbpg3CHmWXR6/Pn3p28rJsgqZrQlO4RQlJrhG1g
	 o6zkyGL1rBtGAXqHfBQh2fFDNbaSEHQ+5legb/6fAnUA1Se8fBmcx186vwD8vhY5EFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oHkFRjUA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EA8606A320;
	Wed, 18 Nov 2026 20:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oHkFRjUA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D811F000C4;
	Wed, 18 Nov 2026 20:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033666;
	bh=8FaLDUPGinJVvZNIReLe8srUdYUjhm/svWqsJn/DiZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHkFRjUA7wCkbsBr4oxcmKiAp1szOlqCuUMh/hlt60fE6Gq5CcTCKx+YnInHxGjHC
	 SUMJoXnqzkQAnGrYAWftJ9k+I0PbGOjRFjjy/vY3J5Jkb+u2fKIGJQBPuOrz6IpLER
	 Dt+p89el7L9dFAqLZ97Sgf/3MZKc15EpEMixqfqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0096/3318] crypto: keembay - add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:11:58 +0100
Message-ID: <20261118150317.063546893@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit b73b71df4cb4ca241165ad31218c82dfe489147c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index fb95deed9057a..4d020070e185c 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -989,6 +989,7 @@ static const struct of_device_id kmb_ocs_ecc_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_ecc_of_match);
 
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_ecc_driver = {
-- 
2.53.0



