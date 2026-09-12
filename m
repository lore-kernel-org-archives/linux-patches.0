Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5F43BB117;
	Sat, 12 Sep 2026 20:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243568; cv=none; b=jpkPvAfcZ1NHHD2KOvmF5VReuOf7KWw/m/A50ye8KVffQ9YUm9mEktQhdOFeht5lRXPohdxMJ04j9AdqNX1RV7RdHc8+KecBlUowJgcHdVZ2m7le/O4+om+0RKUEUmpb7KvS2d6r9AVbvLMrrxrxfC5Pb3oaqSVFQ0QDmO8AeH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243568; c=relaxed/simple;
	bh=AP7ugaevUUTyOk2b1iaedoR0GXHzZu2QnrdjY4BWH3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFUPWobhTj7I6rOZrOm0VRm5+7bM/v+YNKGugwvkv/KsIlmsHE0UIiiOY4vy43Yr586GLAvd1TncjD6aEt38iXIO45zSSYBBPS5FzCrZtbD8PVZ8kTNvbVEXnkd/HWTVJk+XR1XsjU6O5EuEgpj9LW11jJqkMCC89eyj60r2Hdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxC00IGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxC00IGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9541F000FF;
	Sat, 12 Sep 2026 20:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243563;
	bh=vh4DlVZUGj95NkYzIx1udRaJ2qyujE8BW4ssWL+msXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxC00IGOrBwGUJFZ3asOFKAOoEjjOZIc51rzrTKxu8fmKvHaKGNf1u9XSeMleZjBW
	 C0rFOkl1iudja53pSMS7x3Ub/aQqmdAqjHilVGvoQAW5LUTmy7khmuscnJY+5C/nQI
	 Ce0T1KTJbntyHVANmOYbccecS6KPUhvstsCZ5W5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Tang <tanghui20@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 789/798] crypto: testmgr - fix initialization of secret_size
Date: Sat, 12 Sep 2026 09:06:57 +0200
Message-ID: <20260912065535.147180514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 2d016672528a592ada5188e53ac746e1b8b7a978 ]

Actual data length of the 'secret' is not equal to the 'secret_size'.

Since the 'curve_id' has removed in the 'secret', the 'secret_size'
should subtract the length of the 'curve_id'.

Fixes: 6763f5ea2d9a ("crypto: ecdh - move curve_id of ECDH from ...")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d36f7e1a7bce0..37bcf7bd5b688 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2398,7 +2398,7 @@ static const struct kpp_testvec ecdh_p192_tv_template[] = {
 	"\xf4\x57\xcc\x4f\x1f\x4e\x31\xcc"
 	"\xe3\x40\x60\xc8\x06\x93\xc6\x2e"
 	"\x99\x80\x81\x28\xaf\xc5\x51\x74",
-	.secret_size = 32,
+	.secret_size = 30,
 	.b_public_size = 48,
 	.expected_a_public_size = 48,
 	.expected_ss_size = 24
@@ -2445,7 +2445,7 @@ static const struct kpp_testvec ecdh_p256_tv_template[] = {
 	"\x9f\x4a\x38\xcc\xc0\x2c\x49\x2f"
 	"\xb1\x32\xbb\xaf\x22\x61\xda\xcb"
 	"\x6f\xdb\xa9\xaa\xfc\x77\x81\xf3",
-	.secret_size = 40,
+	.secret_size = 38,
 	.b_public_size = 64,
 	.expected_a_public_size = 64,
 	.expected_ss_size = 32
@@ -2483,8 +2483,8 @@ static const struct kpp_testvec ecdh_p256_tv_template[] = {
 	"\x37\x08\xcc\x40\x5e\x7a\xfd\x6a"
 	"\x6a\x02\x6e\x41\x87\x68\x38\x77"
 	"\xfa\xa9\x44\x43\x2d\xef\x09\xdf",
-	.secret_size = 8,
-	.b_secret_size = 40,
+	.secret_size = 6,
+	.b_secret_size = 38,
 	.b_public_size = 64,
 	.expected_a_public_size = 64,
 	.expected_ss_size = 32,
-- 
2.53.0



