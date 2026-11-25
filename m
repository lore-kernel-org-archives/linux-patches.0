Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620614;
	b=YIuwQw4KFAeb4GqGQIV3r+Ysq36Ifz8Q8PHmSr/vzguGbKON69Rugkf1wLpXYyUIVgR2
	 C4VBemW1ksLL2JnF4K5EOE+uJO5Igx5cYD4xFG/UBq28gExckUPuaylZXfulYbwqFtnCG
	 dUkftGdTh/420b3Bor6jFl8yvZmflqwyenu9yODaiDuG21Hi/f0Am73/19LM2E8ZblBlb
	 CYNUa85vmcchPSTUeIv4HqylSuMa/0OFyj243fR2mEiGmjWBl2231ByCqoiY5bnEyArBQ
	 q0OYJDvob5gNy5rD2+dx6CaKSgJiVgAfQt+ntpCpugMqX2bop5rzA/av06Ct0BdgXVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g4BRbyjax9qdgBfHYiQKM305LDrNfbKD4zEdRzL8MUA=;
	b=Ijvl689zP0TK3AZJRfl2eh9TokQkp0eR8GgBQnOyGP4C81gSB46Nz4alrvU3vRspzNtY
	 l/RTz+CCl7L/+/LDHM6ogocFkejjh6veECcY+xCNAEHRPRo1iB45uW9nxMAs7s1e0I3L+
	 uwaZmCOwQBfE7JHpc2Mjkamhq69BA9UIeiueGLYjB65IMXHBkMa95+ADPnyzAmw/4r4Wd
	 gjojHufuJMomOtvfwqyyFVXrFW2eH/kEPMi/lzZujw9cmXWNHKSXpxXmuQ423CpNO0TaT
	 j/kyKdv5Ez0SC1uU71tLGP9FRD4h2THLOuGOp8hRDxc6bxojmjU0kPdwEwRdefLHeag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hDIRume;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023C3606A321;
	Wed, 25 Nov 2026 15:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hDIRume
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5647F1F000CA;
	Wed, 25 Nov 2026 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620613;
	bh=g4BRbyjax9qdgBfHYiQKM305LDrNfbKD4zEdRzL8MUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hDIRume7UPTu9Hcf0itRnvocYICwADF+mAa/dId/YbjSAGOwyEMRiyyk4naA8BIz
	 Ffdb2XjPYYLRZhZsQNJaWDE9Rh37FMTKbeXM62wi0fPVUTpXIHOjor34nLZy1Z1/tT
	 PE1CgE+N5dl6xUdW1SPD7foMj6opVqvaHws3WRAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Semyon Maryasin <simeon@maryasin.name>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0974/1005] iio: hid-sensors: fix fractional part for unit exponents -7 and -8
Date: Wed, 25 Nov 2026 15:38:32 +0100
Message-ID: <20261125143844.481579676@linuxfoundation.org>
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
@@ -98,9 +98,14 @@ static void simple_div(int dividend, int
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


