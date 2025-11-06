Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBF74315F
	for <patches@lists.linux.dev>; Fri,  7 Nov 2025 11:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762513657; cv=none; b=mETUHaNZRNgKF01DUY+YUe+WjnHMl3JB3AAs4LLgdQN6Un468OV+PCEh/mX/+WRDY+DzPl7avURWbvDn8wMPktOYwk4F8yYEptrC4yFjhD81dDLkkUDIM506Zwtxu6IbITvuIbKVlMixtjubNmJ4r7un8sDs4Eg06Xj8AsOZaCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762513657; c=relaxed/simple;
	bh=2tQXUr/PYkxW61kQejJm6zkf8UjDNUAFUBLRWFzkVR4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aUr1qiA65pDatTBc2fVd2R6SHqEbz1FyT7a63DdrpHAn6mZAZap+JIs5x8iS9VF8KZJJlZNfI70+qh6ghOMTPJx7dfX2/DkPNZuepifq3oJz2R54rOZLlhfGMD9e/qUuGhd0HVwENNWHK9Bw13wQRF4gdWu2y0gRESnWNSE6/T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=alien8.de; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uffY33Vf reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uffY33Vf"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3526A40E01A5
	for <patches@lists.linux.dev>; Fri,  7 Nov 2025 11:07:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id SwPhRxyxXwlW for <patches@lists.linux.dev>;
	Fri,  7 Nov 2025 11:07:15 +0000 (UTC)
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 47CDC40E015B
	for <patches@lists.linux.dev>; Fri,  7 Nov 2025 11:07:15 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Fri, 7 Nov 2025 12:07:07 +0100
Resent-Message-ID: <20251107110707.GAaQ3S200_9YA718V_@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>
Received: from mail.alien8.de
	by mad with LMTP
	id qIwlGCnpDGniOhgAc81XFw
	(envelope-from <superm1@kernel.org>)
	for <bp@alien8.de>; Thu, 06 Nov 2025 18:30:01 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 487A540E01CD
	for <bp@alien8.de>; Thu,  6 Nov 2025 18:30:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I1nluOM0yRHm for <bp@alien8.de>;
	Thu,  6 Nov 2025 18:29:51 +0000 (UTC)
Received: from tor.source.kernel.org (tor.source.kernel.org [IPv6:2600:3c04:e001:324:0:1991:8:25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256))
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id C73EA40E016E
	for <bp@alien8.de>; Thu,  6 Nov 2025 18:29:42 +0000 (UTC)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E6F86022D;
	Thu,  6 Nov 2025 18:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 50DA1C4CEFB; Thu,  6 Nov 2025 18:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD4BC116B1;
	Thu,  6 Nov 2025 18:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762453775;
	bh=KpOl/2oqnqK1rQInOzndCMZ1Xx7UxlBJ4IlPYa67kzo=;
	h=From:To:Cc:Subject:Date:From;
	b=uffY33VfnkeX8d+2AqFLcds1RsRGs2EmEgS7nsrSUvRsUkcFTFxH0Zrt5QN/0MTkM
	 PiiFhh8EvCeNqutHYtp/Mp3H9Bbb45quYQ93pkE8o50YoqqGbxvrkWE29grDEr/IH9
	 xrxJxUKcKFeSWoFv+eSLMSA2OAVwhJAzCMWHuUe0tjskkGZRxy70EccrXPHHsrkTmA
	 rzzlCAdC8VE8qjaqaFF+60ISDCexWmYXSQaiKu29ZGXcl4JW89pE/7w4+Oewxhzat/
	 UorCrhV8qoWi6sLpoTd3JqtWFiphxo4XIUSxKNKvwMHLGKsBHLd6qw3mOARRJ3gcik
	 CS+l854wz6kig==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: mario.limonciello@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH] x86/microcode/AMD: Add more known models to entry sign checking
Date: Thu,  6 Nov 2025 12:28:54 -0600
Message-ID: <20251106182904.4143757-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: C73EA40E016E
X-Spamd-Result: default: False [1.18 / 20.00];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:324::/64];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RBL_VIRUSFREE_UNKNOWN_FAIL(0.00)[2600:3c04:e001:324:0:1991:8:25:query timed out];
	 MAILSPIKE_FAIL(0.00)[2600:3c04:e001:324:0:1991:8:25:query timed out];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 RBL_SEM_IPV6_FAIL(0.00)[2600:3c04:e001:324:0:1991:8:25:query timed out];
	 DKIM_TRACE(0.00)[kernel.org:+];
	 DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 MID_CONTAINS_FROM(1.00)[];
	 NEURAL_HAM(-0.00)[-1.000];
	 BLOCKLISTDE_FAIL(0.00)[2600:3c04:e001:324:0:1991:8:25:query timed out,100.75.92.58:query timed out];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	 RCVD_COUNT_TWO(0.00)[2];
	 BAYES_HAM(-2.82)[99.23%]
X-Rspamd-Server: mad
Content-Transfer-Encoding: quoted-printable

Two Zen5 systems are missing from need_sha_check.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
 arch/x86/kernel/cpu/microcode/amd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/mi=
crocode/amd.c
index b7c797dc94f45..dc82153009dab 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -220,10 +220,12 @@ static bool need_sha_check(u32 cur_rev)
 	case 0xaa001: return cur_rev <=3D 0xaa00116; break;
 	case 0xaa002: return cur_rev <=3D 0xaa00218; break;
 	case 0xb0021: return cur_rev <=3D 0xb002146; break;
+	case 0xb0081: return cur_rev <=3D 0xb008111; break;
 	case 0xb1010: return cur_rev <=3D 0xb101046; break;
 	case 0xb2040: return cur_rev <=3D 0xb204031; break;
 	case 0xb4040: return cur_rev <=3D 0xb404031; break;
 	case 0xb6000: return cur_rev <=3D 0xb600031; break;
+	case 0xb6080: return cur_rev <=3D 0xb608031; break;
 	case 0xb7000: return cur_rev <=3D 0xb700031; break;
 	default: break;
 	}
--=20
2.43.0

