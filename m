Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704800;
	b=HtyYGAvOvqjzo7VBVm4WtODRAeJQJtd6s0OjrsFZwYZiVieGl3eYcyMdiKGtB1XTry95
	 +Qvspc4t3bsT+xLX9IBb1dNrjYKjGpMWYDWEDPRiqndsL6nzhikWgeESfYs1SMJ7pAigi
	 yEUvhgneEdadnFm28Z4ml9yHFsBDwLeoehYwt+xgoyNh1M6HkOpYt2+TfVuG5YioynGpt
	 HJP5v8FPALHj4jkzEh5C/R0W0BZarLNsbceajbwGnhYwrABIRNZkLFv8ss+R1hg/7lQCq
	 4nFuoR5dyf6ov7m9sn5UINbcIWZXQY/dOrwj+YGp01qp8+M7nZmW5WMKA+JH+2qVCcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5nnomyh5dE277aBKxkaVsOGgYV1zkcTEqDd0eCOnzHk=;
	b=kvgS9HXB/XpjWT5QYYkDu5UlFeXl8vTVMBl1NJ8ZLm1jvraiqs4d8n8DBoE5HO+xGBaq
	 B1abUbAR6zA5ua5uxWxuCYhCmJ8QJIHnRRyIlKJF5Q6NcB4UcLcdXxrLVv5XoIUBR/SWK
	 aUD9B+2fFf6A2T6wf0f7bcGJAoYjn22dyS9BRUFMruded775+hqndATQERWQ0oHwJPK0I
	 phLJro7wo2sAQ76WfB7c38PzjJ76a5qeUf7qcLI/D1fh8eYLk5HjrOvwhreDnouQ9XbEO
	 WdXpM9Ej6xbI5LHKcGF/FQkMP3TTn6OeETQD4QavEDii8pvFznATHWU9YufEsh4hmng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kRuhNnFv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D6F606A336;
	Thu, 26 Nov 2026 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kRuhNnFv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39DC1F000EE;
	Thu, 26 Nov 2026 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704799;
	bh=5nnomyh5dE277aBKxkaVsOGgYV1zkcTEqDd0eCOnzHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRuhNnFvMe4mp/+SsDQggDkUxeYIt2E0NaK8EOi4uNA/6MYQCWMqKb1dKVznhNaoO
	 eaWzoZz7Yuj7RSOgHCZDZ4ns4OsCYK7DRQtJxQ9vHwbgMGQtpM+dlqtPlIEQ3fciT0
	 mIiYgRfIC91bac0E1zwSE/VAs9tfA+N1Pi+jE4wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Semyon Maryasin <simeon@maryasin.name>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 248/265] iio: hid-sensors: fix fractional part for unit exponents -7 and -8
Date: Thu, 26 Nov 2026 15:39:38 +0100
Message-ID: <20261126143622.593582922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -100,9 +100,14 @@ static void simple_div(int dividend, int
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


