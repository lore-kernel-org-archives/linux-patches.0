Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208906;
	b=3XA/lM5N1gOQW/nQj575/q7axQFji9IfSRHq1LikBG+EGNByI6G43n8FSEPHV9hNTJIK
	 u9/GBlc3/GE4fCsiaRojitAFwcMbGKS4jvO2zgqhN+aQ4mJ9CLO/FIqhzvJmjhdwOkVae
	 DaG7EF3iJ2YGd+nJ8/SYeX0cyrPE+ic2JBv3A4eLILpDxOY3MqhyrMcXHF2M7PRCPepUN
	 cKNWwFcbMJeFCg5KY/SCCV8q/H3Pj2DUosUn5eeZZ1H+jYBj8Cpx/9zC0JLWLIsm//veb
	 m1J+tE0IL+yoMqNTwqp8H7a6iy2FY9R9In9ucW9TX+LuibCLLesx7ISxYkbTiYuujtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xsm0rcMDb19Wh/32jKivkAtlSTcK9ckf11v6sZCMY0k=;
	b=XzFB4ZA9LozBnjh3N4gwOTFmI83DZmlg33MYw9kdY5hw/MYk8PRcXHR/wxlCI9i9CYfx
	 gVv6nFNcCUFMuaTqPXdpd4aiwW1IAQgz5OX6UsRx9v5nfm7fMHN4ZXzOvwQ1AuZi4fWo1
	 1oCO3zk3qGlw+rPx/1x1dU6xBOZMmwKkDh21NSWmw8HaV7PSwaGVnkvUW/5Y3AKS0d4JK
	 sOdvbWFukcVOleMcQcLVI1492pMUp+GtNyOV2t6bo+m9A8P/sHhf3NdHSvmqZRE9FfaUT
	 u2bBYbftd2JY/bcU08rpQRBpooXd2eMUD5ebX+rwkcz1qVRhqM0Qv7o1529023xcofA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngC7o2rZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F20D606A31A;
	Wed, 28 Oct 2026 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngC7o2rZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D591F01825;
	Wed, 28 Oct 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208906;
	bh=Xsm0rcMDb19Wh/32jKivkAtlSTcK9ckf11v6sZCMY0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngC7o2rZ0Jl1RM9lT7t0Ik4D6pRhZ6c9qn7fDbAlejXwgqLfElExhvuqUVJoo67Yw
	 FM+1uO4sTsoIY0QLd3ekMoVL6F48Kn6jR11g9dXd+uMrmEWi+MKQsQuJJDdU4rztD9
	 XGam8sAZjmn9PskDtMdJO5cr3BA7btUGPvHrJGI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 241/516] iio: proximity: isl29501: Fix return type of isl29501_register_write
Date: Wed, 28 Oct 2026 17:56:33 +0100
Message-ID: <20261028170009.210508322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit e8dd273d199f5bbe295a8e3d8b777c5505b6b2e1 upstream.

isl29501_register_write() was returning a u32 instead of an int.
Since the function returns negative error codes (such as -ERANGE or
return values from i2c_smbus_write_byte_data()), returning an unsigned
integer type prevents callers from correctly checking for negative error
conditions.

Fix this by changing the function return type from u32 to int.

This was found through manual code review.

Fixes: 1c28799257bc ("iio: light: isl29501: Add support for the ISL29501 ToF sensor.")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/isl29501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/isl29501.c
+++ b/drivers/iio/proximity/isl29501.c
@@ -227,7 +227,7 @@ err:
 	return ret;
 }
 
-static u32 isl29501_register_write(struct isl29501_private *isl29501,
+static int isl29501_register_write(struct isl29501_private *isl29501,
 				   enum isl29501_register_name name,
 				   u32 value)
 {


