Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626273;
	b=BYU3Zt3/OxrmSZVo6+1KHhAl6XhhNFgid/WbSuAEahOk+6YML+lxr50sW6Av1ga+7zof
	 b8ch3IEgF3CBX3rfUz97kwXempve1YcgOxZeyqTcOz0OmWb5itLzdXFYoc9/y1bXophmy
	 z9ancf6eBYfaCjSX4koBu3eFp5DVvBcKKIMdoGJ9W2ZKu/48Ff5Uoeq6goaaW5BL2mCnO
	 w1mQsT8UGe0gYHoxSLLExj5v2AM19ai96Kae79LHlSCenBLs0+IgWxuAPOiggyw0dqNp3
	 88+teObfNGP0Kwa9xGZDSGsrX1cVZAZCmIzFkqOEBU7Jagv1GtzklWJ1mX38AP1qwNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UH8C9Ko5p090LfustC+D+zFI9mzeXaHS/humiCogzEU=;
	b=OmyVDbYCyl11ycqWQsvhySjgayntr+h56OJL3Q/jK9dXMZxSp64yOJEP8+JL9jWMc6ln
	 1/d0+E4PbD8jozGUTV6Cg+QnYSkiEzXLNGPhjQD5iSJKVCQcqjx4CN+7Wf3fOgEX7tvdI
	 /FfEqF1z6j4iAisb8EkmKcbaeKF8cJrqJU6nymlQWLxSvb15tkaVezmWGZHb1qRFrPc6T
	 QJRjYSvbm+29vO34Iyyo6i8SxZ5pOJK4oDU72F1WQA93eFAZ98iM4D8JZM80WPEMO7doa
	 zqisMEwhO56yjXBK8QPR2rJrmZzX7bwF7OR6tdd8IDrqeoWcOGnwGP0cGigFj8YspDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qEJUs72h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82EE606A323;
	Wed, 25 Nov 2026 17:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qEJUs72h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3321F000C6;
	Wed, 25 Nov 2026 17:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626272;
	bh=UH8C9Ko5p090LfustC+D+zFI9mzeXaHS/humiCogzEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEJUs72hst9f+qN9MhAq3GVkrAGYjzzBvvgFtix1sbWsbjSZfM2s1crTDEs47lhY9
	 Q2k0dEcrfCvPYd52sPYXqDESe0IY3Nkga9nzCeFTuL6lX8rXpRSyMD5nURkUhc2fa+
	 Bd6pH4JU5KbFdaF978/t3s+WWw2Lx2qTuHuurAuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Semyon Maryasin <simeon@maryasin.name>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 788/816] iio: hid-sensors: fix fractional part for unit exponents -7 and -8
Date: Wed, 25 Nov 2026 15:38:56 +0100
Message-ID: <20261125143907.413696045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


