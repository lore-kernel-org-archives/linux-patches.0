Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705752;
	b=E82EsXGjT8ApSH9HrIwVC0k6W4fJS3escmjc5En2SVZzVegOeAetmrYPl6JFIRCG//Mw
	 6eNZME3C4hxMeE1EG8FYUBuM0Ebi2EsvCMFxVYbfbZZMwq1cErrQzS5F2p5qZmhUqfpVg
	 OloBtI01VkZanwgmDLHtlEv8NqYx1i7oE0UQ6ROYPzDND4wnHyrKCSZw2Iz4boxeXq7Oy
	 Di5Ec53rwIXOswBYWEB3BNAnBWpv4UFvOAb5hs+ap2bC0Xp3aw8y8i9CtnWs1mTd6bwOm
	 2AU/FyX67KmQK1pJWeLxSp3xHpJ/c8oju/fOUpbjN0vdnx+Pts/G3BD1gxVTLy1Nx6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zeC+wDfBsq6L1quN0Vk1OwtnyZ7dhPTsEt6fM6F7PhU=;
	b=uj0Qlq3cnGnKJ9lZVS44lBgRYWnCpZ11ZYK5wBFxgDUvSmLtS4HsBTg/DrQydnAqorpN
	 RMdmADCFoFVCrM5iD3q//nYuD8eME2wPAHLoWdgsiAMmPcZwFIl7oG2VA0vhQM2fBkdd+
	 kh4M9nOs4whb/7xLz65SjgLw4U8eR3csdsj6QGdb+V0ZLCR7Z4OJSYWKcx6Y1Wu9tpwj+
	 9q8KH10ysmGMPkmQKWtqMxYhkCxLthyepUlnekZYufTOcbzSBkkEWuPOsWoZFXrCLpvuo
	 WXcrtCNEUVpiHudEvl3gEnNdTl9FIfeOrxBXxLQglUI97QfcSOSgHVnrprI64x8NOFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvNXmF9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A569C606A33C;
	Thu, 26 Nov 2026 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvNXmF9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B91C1F000C0;
	Thu, 26 Nov 2026 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705752;
	bh=zeC+wDfBsq6L1quN0Vk1OwtnyZ7dhPTsEt6fM6F7PhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvNXmF9ECH2JNJD+3lifqbOf8FGlZM8CMKQColTa/4yayh9AMffaq0+XPVBT+VP/G
	 LytNTslCynR/96GdCd0YzQBYtqM4qJIRpL4ANkQBSRg/ckkZBqeFGnD5DT9rzuwH/s
	 TduIzHVHEoBIgP1V9YPvMSfbKRtKyhUmG5jXWt2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Semyon Maryasin <simeon@maryasin.name>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 302/319] iio: hid-sensors: fix fractional part for unit exponents -7 and -8
Date: Thu, 26 Nov 2026 15:41:10 +0100
Message-ID: <20261126144013.575300504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 79c8dffd84e9784ec05bea68dbe5e71f7ec9941a upstream.

split_micro_fraction() scales the remainder to micro units by
multiplying it by 10^(6 - exp). The unit exponent of a HID field goes
down to -8, so exp can be 7 or 8 here. Then the argument of int_pow()
is negative, which the unsigned parameter turns into a huge power of
ten: 0 modulo 2^64. As a result, the fractional part of a value read
from the hysteresis attributes is always reported as 0.

Divide by 10^(exp - 6) in these two cases. This matches the reverse
conversion in convert_to_vtf_format().

Fixes: 73c6768b710a ("iio: hid-sensors: Common attribute and trigger")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Semyon Maryasin <simeon@maryasin.name>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -95,9 +95,14 @@ static void simple_div(int dividend, int
 static void split_micro_fraction(unsigned int no, int exp, int *val1, int *val2)
 {
 	int divisor = int_pow(10, exp);
+	unsigned int rem;
 
 	*val1 = no / divisor;
-	*val2 = no % divisor * int_pow(10, 6 - exp);
+	rem = no % divisor;
+	if (exp > 6)
+		*val2 = rem / (unsigned int)int_pow(10, exp - 6);
+	else
+		*val2 = rem * int_pow(10, 6 - exp);
 }
 
 /*


