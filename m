Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623732;
	b=JfGveVxIjMt4Pr2UnicHbMnr/obD22hKpMYp1eaxkF+ZaTqH590tgJMoJeNeJONdpcD5
	 PL2Q7KNWnp5GB8TzHQtPH074qq+TcVEj+C+uobDc7mu1I1tz7BEv2c/qEFa674ZcEz3fX
	 /PUsUXY7TKuKbSSi9yHIrI/jTxkfWDBx1qj9NFJyZy/nAq8ZFFz3IdalmlqsYMZavhORe
	 auTZdUlYmc3oV3uZMO8jppba550XomjEUAUIzdMdUTWMSyClWbvuwK8Cc+D49Sn/T/98n
	 zyl8IghiQnwfeugnVxvhZaK5Rgyc6yqOreqKCmxeQoiryarnxVcvaNaFz3RHGO1VTBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+tQWMl0BYUFNDA/Bv932EqOfeC02inn0yqqG5y6U1rQ=;
	b=jWom1pJ9WzWI1vgi+HUsGANwObcBlIT7fRvJ720PvE+3wKpUhBnUkzF8mI24iyreS7KE
	 bhkzcRE1/aZdwDQwstiyJfZ2HGJQDnZ4DID/xT65+lG+qKGLAEbzi+HJw465K5qVTPIFJ
	 gaZqNKPraFOi3waLmfbS/jWYBiGDqmhYGkoreUR1ScUJNYiCeLPZdjbWxN9gC8VykGxts
	 Ov7zZkr2pa/dXiwkHtpFK7MbvFz1+IybLbbmQNSAG8IMLghZaTheJLHkdMeUlo5zpGHdN
	 jihWnmwaplaBPEBng4gUPujT81cm08YjPmXooUUxnxw1lmNSk4T7VHuLJM8YP1P4MFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QbEbexVp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C15606A326;
	Wed, 25 Nov 2026 16:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QbEbexVp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE741F000D2;
	Wed, 25 Nov 2026 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623731;
	bh=+tQWMl0BYUFNDA/Bv932EqOfeC02inn0yqqG5y6U1rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbEbexVprgBpgKfhqf6a4NV1NBDQoHz38xpZV+7kyqWy3GdTDxxC7/IWU7/aEaEIr
	 1XYZHsCMzrOgt+aAc3uMSNVhIXduh9/E7Fg0qBVeUAPdNq7qgu1DcDTnIdcqSh/wbM
	 vgM7k+Musb4m2QYyH7ta6MHJYtoJF9ypjzxzh3zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Semyon Maryasin <simeon@maryasin.name>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 953/990] iio: hid-sensors: fix fractional part for unit exponents -7 and -8
Date: Wed, 25 Nov 2026 15:38:40 +0100
Message-ID: <20261125143844.311591118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -99,9 +99,14 @@ static void simple_div(int dividend, int
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


