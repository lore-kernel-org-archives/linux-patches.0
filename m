Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620371;
	b=KKqDDUV6sf3dd8NX+A6J/iNsrzR2K9hOR96tw5XiisEL84PwiInMRQrbZMwoCMbZ6ttJ
	 Qxjir5pRcIXCsSazuP/oRXnJYNzzzKwgiEIMnHTx4LUaeN9N6Zx9y0Qxhe8rg6RfLTPRs
	 22JJJO2NV5ISmhtcSkaWsc1ruuVufggiO9wmSHU/5fUR3sd2iMDmIsVheDr22tBUUBWKe
	 Dn4nZ9AhPsTELY3Txi33HxIHTmzF9YmechDGYzXUSMte6I5+slYRtvKazm4+e5ZhMBm4y
	 aaNeFpQmpYrlTv/HrXGyn571bQFxnFFaXJo/dd9xRicXcz9JPeWRKyvpEMV4DAd/jQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdvGABdAfAVyJxhPzBHn81vcGuE9deNqOS52tf7OcdU=;
	b=molIJpxhYL3g1MIoF7q80cOmlpGjafglWFVRw4ZgPixLBNtTYV0NxkxUFMLgeNc5u6O2
	 Z3cLR354ojfi9YITNrvwPW8q2C0nknAl6IJniQbZm/DgxevN6K0NNu4ieWQBwHT+ZtJ1N
	 4V9EOAg0Raxtjn6Nv/7INhqcXdJHmVUpIQy4cllmE1VPWFvj5MEc/FR2BaUsJwDsGrKyN
	 0YvTmfnMHvbMn7SrVPrvMZECsQA0kenLhMDKFHUdgKtG5NUh7Zf07WPdox+wZyiPzTZ5C
	 iStYfKiVZilGa+C+oVIdYQ67ESZaBZ3xcLTWHCjq3fCUI+Uh4MMgXHKWJ8I6t4q8Y/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUzdNqrD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE84F606A326;
	Wed, 25 Nov 2026 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUzdNqrD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163EB1F000CA;
	Wed, 25 Nov 2026 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620371;
	bh=DdvGABdAfAVyJxhPzBHn81vcGuE9deNqOS52tf7OcdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUzdNqrD0I1tlJ9HKOtbO7xi0jRKy4OrHXFR9Ij9gF0ppCdVMcAOOn4NKHyp5ImKC
	 HgwgYkc/xoRyDJ4zYEfXhxfuaglckJMzVZumYVnhwAZoZCRqSvOOGojMNRDkV4D0YA
	 P9dAMXLm3NQ1Rdp6ZkklAJyBqbnoED5FnZagAF9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0896/1005] iio: hid-sensors: fix a division by zero
Date: Wed, 25 Nov 2026 15:37:14 +0100
Message-ID: <20261125143842.685625461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit fd4c92bbd3a64556e81042ff8d30545b15a3b93a upstream.

convert_to_vtf_format() divides the micro part of a value by
10^(6 + exp).  The unit exponent of a HID field is a nibble and goes
down to -8.  For -7 and -8 the argument of int_pow() is negative, which
the unsigned parameter turns into a huge power of ten: 0 modulo 2^64.
The division by it is a divide error.  The exponent comes from the report
descriptor of the sensor hub, the value from a write to the hysteresis
attribute of the IIO device.

Multiply by 10^(-exp - 6) in these two cases.

Fixes: 73c6768b710a ("iio: hid-sensors: Common attribute and trigger")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -140,7 +140,10 @@ static u32 convert_to_vtf_format(int siz
 	if (val1 < 0 || val2 < 0)
 		sign = -1;
 	exp = hid_sensor_convert_exponent(exp);
-	if (exp < 0) {
+	if (exp < -6) {
+		value = abs(val1) * int_pow(10, -exp);
+		value += abs(val2) * int_pow(10, -exp - 6);
+	} else if (exp < 0) {
 		divisor = int_pow(10, 6 + exp);
 		value = abs(val1) * int_pow(10, -exp);
 		value += abs(val2) / divisor;


