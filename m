Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213056;
	b=ikw8TdpbpoV9D3S354T0rN3psSUW54WcWGcXHhYnsPj0K4Tzx2vPMtOj0AOdLNJikdSF
	 WCh11r9v3T1OEbKtx1PrOorzzT+2AZXLIq6Eu6HybxgcvQ8JZdzKp1J44eqdwJnt5764P
	 6Mv+06DCguftqVaY+DNCNuTnOui2VDLEmzW61cGtNbWKsxxWxpccDj9aobH8Mg2SHa76a
	 uv/RGlQ+scNXFmvA4c02jamTFd6p2GpEgmxjFUoE/bshkZb3BhKN2sNktlSbSihKLgQ1l
	 lRQHHIXnE9SVg0onMTuWOZoKnfCIPxwNWYA8gMw3Llh6kBToDDPRwMvW5qt7wvL28zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TbAHj/MeJntXMpis8dci+EtcP0dMJq2bKHrnkt2jl6k=;
	b=QR/YCye4RkRUUVh+SyVyk5E7YCcsvpQAxMargchtCCQWOllxjM7f9YMG95+fbgJVue/P
	 P+ddW694lwKxBmIZkdrcwG72zrll4xRhfzICjXT0w/vSjljFXDgSEbdJldDtqnZwtZMrX
	 i7iBSH+S2Uwc+CDmfxwpibK19DPvAVZHeznFCSESFyjFRS+BO4w8zQIw0iEHS72WIEfv9
	 qe/B63ZGw0lRqO5wMn3Y4UaRSziHYmjH8A6dKKDSC+YxV6gsCERTrugYXDHDp6nyqlKIx
	 Qu3ZhMJ2h9OcBpdvA+VqSxc7HfjsMiFjKyjyHMR7mwlwp5AzDwKIUgpgE8knJX8eSzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mm7OeeaQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA098606A31D;
	Wed, 28 Oct 2026 18:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mm7OeeaQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BAC1F01825;
	Wed, 28 Oct 2026 18:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213055;
	bh=TbAHj/MeJntXMpis8dci+EtcP0dMJq2bKHrnkt2jl6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mm7OeeaQcSBWUH7pR7ZmRytwEs52Ds/+CAWnnIvOnDptEoH2QsPjPUFC739H25xMP
	 0IVX3AQoveFT41PxgCYi+6EDC4VCrOqCqSzbXpku0DzFRbmbH3gc9qxdPf0eBH9Dux
	 tBnAmVeWOj6RigpO627/TDefIHP+xaEnNIcnd7nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0344/1887] iio: proximity: isl29501: Fix return type of isl29501_register_write
Date: Wed, 28 Oct 2026 17:40:40 +0100
Message-ID: <20261028170507.055588102@linuxfoundation.org>
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


