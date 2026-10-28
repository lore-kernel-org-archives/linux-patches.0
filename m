Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215757;
	b=0pJTjASU7n8i8nxsU49vMaqsPGfhqe+agQoQmGqjVXm1l4xWas0yy+rbPVSdwVvINX1K
	 BcchsWrnyui5cXWQtjG3lJ9xZ5kSq4NsCA947GnTTQCtM36/m/ZliLZuaTWGHN/vzcQXc
	 /pUqA9HVZNuhlnN6DlrYRg6IT8RpODPJ2+FVl8BuvfEnJal+A2TVBVkQghbo3q40SIQmb
	 97wiQz6/nkpli8GogWH7KJc6YH/fGQcAX/qS/dc4UPSp9SpOGsyNGnO1wWGqt9JWw8L+f
	 sazevKWL4AfvCRNoQaVJbMcP02Xke1LO2sBYgYdzi7bhsTzhYLW3w1TgpTLvvgLscDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ExlK1Z0w08UB6FEJx5QQWXodvXchRNugHo7PxUaaJrc=;
	b=xO/GDhuh6o6Exd8vnS54ZOO5NoHm3kqEn7QIFzVgCLXMqNqVCrQrfDw900IlA4nlwShF
	 BhJ6FbFUjGmwHUNi/oHCSjy5hcPRrzQv3RtgAu+Z6iPqyPX3Xp+Dfo82NG13NntDCeIeZ
	 HEDUafU+3zZe01yTlhlErbcYR+bGiUkFKSuv2KBGcNGI1UAZZmSuKki6th0xMded3O9zX
	 ukDA2+mwuOVr4Lao+yiRmmmYR+3E+0dWPYZq8TEBnnAxc6l6nqBt9XFxKvy/f9O1ukT2d
	 TOJzjmC3uj1NE2iUmJ5eqEUmoSxP/wEtNGt8x+GcQtJioQ3KrEKz91s6olc9YhqsjFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvTGCCaf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD11606A31A;
	Wed, 28 Oct 2026 19:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvTGCCaf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8A21F01825;
	Wed, 28 Oct 2026 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215757;
	bh=ExlK1Z0w08UB6FEJx5QQWXodvXchRNugHo7PxUaaJrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvTGCCafWV19xWU8R7El1uYK5/ot9JPqez/5fZyJkVrzmrQ4TYQaOEckXRmaf7zpV
	 ge9Xkyk+bLadDe6jUbmHK8mYaZBisR1QkJJqAg3WIwpSgleATA0MngFgoKuqiuLK9Q
	 P1dvlmWF+b8r7X4GezmRtPhDXmaU9nmVbV6Wtoxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Finn Callies <fcallies@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1279/1887] s390/zcrypt: Close speculative mem read possibility
Date: Wed, 28 Oct 2026 17:56:15 +0100
Message-ID: <20261028170528.529384471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit e935cd525af4c6ed2e2c6404aa27ca19c7f39ddb ]

The domain value is extracted from a given CCA or EP11 ioctl struct
when a CPRB is about to be sent. Thus this is a user controlled value.
Under some special conditions (custom device node used, administrative
load) this value is used as an array index after bounds checking, but
without speculation barrier.

Add the missing array_index_nospec() call to prevent speculative
execution where this domain value is used.

Fixes: cfd68b33094e ("s390/zcrypt: Filter admin CPRBs on custom devices")
Cc: stable@vger.kernel.org
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Finn Callies <fcallies@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index d75affe6f4b67..d0e18a0806244 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -26,6 +26,7 @@
 #include <linux/cdev.h>
 #include <linux/ctype.h>
 #include <linux/capability.h>
+#include <linux/nospec.h>
 #include <asm/debug.h>
 
 #define CREATE_TRACE_POINTS
@@ -929,6 +930,7 @@ static long _zcrypt_send_cprb(bool userspace, struct ap_perms *perms,
 	tdom = *domain;
 	if (perms != &ap_perms && tdom < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
+			tdom = array_index_nospec(tdom, AP_DOMAINS);
 			if (!test_bit_inv(tdom, perms->adm)) {
 				rc = -ENODEV;
 				goto out;
@@ -1121,6 +1123,7 @@ static long _zcrypt_send_ep11_cprb(bool userspace, struct ap_perms *perms,
 
 	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
+			domain = array_index_nospec(domain, AP_DOMAINS);
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;
 				goto out_free;
-- 
2.53.0



