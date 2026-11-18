Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050571;
	b=RcrOZ/km0VWfEjbzni4G3I4za5aT91fGwhgALHJnaUDgNqKtYMci7B6SHx42k7rp8QSX
	 O95Vt9oRz54qlkQLYIUTFPcCadE6eECMHNirM7MCQLejpPs/eJwcfFVOi5P89mNsI7Xrq
	 lp0aG0os78TQMJP6otClC1bBlZ4s9a8g8p5RNXAkgwdkeLky8pyrJS+geLuhYUL4Px371
	 XsgXIa5TakMnfHKm3vHVZPeErsyeINRAv491M/2ns/e1UftITrxSLn5wscFNB/LIXUDNZ
	 dn9gnsWcasryRO8WNydYMdvLg6XSjLCs89t09r7pxGQKJxikRQX0A+kiy7Mkvpa/PWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pPu0ztuVuiZhGR8qAAq8ndQP7czRjt3Y6SY/BjKGIoM=;
	b=bP9J82zNLLsO7J2c+YtUrT40BldAMdXfSssqZ5OSfxRSEB3jHN0V/TLEbCs2rniBdxoJ
	 rUnO20qDZTF0i0ABGmW1EuLk3P0pXXyPA0t3EAb0yG7gNBiZq362KPVwMiPzBeJlCqOA0
	 djomi1OjbKza49ovM1I8liAGV072CzfE4fAL/9KN5eXHmwLv0b3Wu92cSeHhOLzp6+f35
	 pvnSr79IBkBn49UciXYJm2An+UOQrZChPIdEc8MerseuQUppMEnxR0NqvR0BhjKv6VoAy
	 QEGcnRmkwSk7cqExcy2W/t0wckpk3YNtCxuQ+aw9OKOqfNaBPhdlZR5QGu0e7CYLrOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCwJvJVH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2948606A320;
	Thu, 19 Nov 2026 01:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCwJvJVH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7021F000C4;
	Thu, 19 Nov 2026 01:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050570;
	bh=pPu0ztuVuiZhGR8qAAq8ndQP7czRjt3Y6SY/BjKGIoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCwJvJVHoa+3++OeTGgPZTR81HOhnetpIuTuBDLYpHaGmfuOLxfHiWtD7/zaAcsgD
	 V+cS4BwE5yquygYjKPGCmDcsHrMS+k/PEvM8y2LWh2TDbM7Yg26C+FK+BXAfgN9cKx
	 uwWIQ6wckirmo5PQh/QM7eOYa3p1S8gGo8byeu4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2714/2857] tls: add TLS_CIPHER_ARIA_GCM_* to tls_cipher_size_desc
Date: Wed, 18 Nov 2026 16:02:28 +0100
Message-ID: <20261118150339.335012848@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 200e23165109a173ffde3310dffa5ef5e502d97f ]

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/b2e0fb79e6d0a4478be9bf33781dc9c9281c9d56.1692977948.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c43c1c24f3cd ("tls: avoid field-spanning write when copying crypto info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 42c61cd1359c6..deb3085264311 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -73,6 +73,8 @@ const struct tls_cipher_size_desc tls_cipher_size_desc[] = {
 	CIPHER_SIZE_DESC(TLS_CIPHER_CHACHA20_POLY1305),
 	CIPHER_SIZE_DESC(TLS_CIPHER_SM4_GCM),
 	CIPHER_SIZE_DESC(TLS_CIPHER_SM4_CCM),
+	CIPHER_SIZE_DESC(TLS_CIPHER_ARIA_GCM_128),
+	CIPHER_SIZE_DESC(TLS_CIPHER_ARIA_GCM_256),
 };
 
 static const struct proto *saved_tcpv6_prot;
-- 
2.53.0



