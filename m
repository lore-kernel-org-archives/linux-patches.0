Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A20139D04
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 01:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727402141; cv=none; b=q+0TcGqrTdGfjWNoc1VdJMR4xuUSfOy7yHkVhDJol5TCpR+rSLQi8y4tFi+BEyMS7ytPS/6qXGhbFJwrY6mEUJugvUXnuCEY29ksAnHTts1ftqT8FwchG4CCUvk0jvA91p95XOO0iUUTYN7nR9/R5aBeoIdta254hmOBFCO9POw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727402141; c=relaxed/simple;
	bh=WEKM0tZRZyMJ4M2yhKVLV3egv5nh5cKgSsXJM8WYyro=;
	h=From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:
	 MIME-Version:Content-Type; b=IeipRaOaZnKl87twyMPh25KMVCPS6jvt9gEgEYwgrqBji44fAfEWFsEQrv+5V/RMVsunjfhKYsDkN2ukV/dpZXj7Dc0db7W0BSA1FJTAFRsYLc5KyTx51NUi8WF2YbbX0q4z9XOFiER/mnjrQSeiS/H+TO/e7GMwZ/YSwoKus90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-swift.com; spf=pass smtp.mailfrom=net-swift.com; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=net-swift.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=net-swift.com
X-QQ-mid:Yeas9t1727402078t874t41467
Received: from 73E00E8BC808433CB9DB281092DFBE6B (duanqiangwen@net-swift.com [60.186.242.192])
X-QQ-SSF:00400000000000F0FI4000000000000
From: duanqiangwen@net-swift.com
X-BIZMAIL-ID: 15219018867057488817
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
	<stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>,
	"'David S. Miller'" <davem@davemloft.net>,
	"'Sasha Levin'" <sashal@kernel.org>
References: <20240430103058.010791820@linuxfoundation.org> <20240430103059.311606449@linuxfoundation.org>
In-Reply-To: <20240430103059.311606449@linuxfoundation.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIDYuNiAwNDQvMTg2XSBuZXQ6IGxpYnd4OiBmaQ==?=
	=?gb2312?B?eCBhbGxvYyBtc2l4IHZlY3RvcnMgZmFpbGVk?=
Date: Fri, 27 Sep 2024 09:54:37 +0800
Message-ID: <029801db1080$35d213e0$a1763ba0$@net-swift.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQFOC2zPFGIL1BJCPg2TAnlAJkwjuwHfHi+Qs3XvmwA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:net-swift.com:qybglogicsvrgz:qybglogicsvrgz7a-0

> -----=D3=CA=BC=FE=D4=AD=BC=FE-----
> =B7=A2=BC=FE=C8=CB: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> =B7=A2=CB=CD=CA=B1=BC=E4: 2024=C4=EA4=D4=C230=C8=D5 18:38
> =CA=D5=BC=FE=C8=CB: stable@vger.kernel.org
> =B3=AD=CB=CD: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> patches@lists.linux.dev; Duanqiang Wen <duanqiangwen@net-swift.com>;
> David S. Miller <davem@davemloft.net>; Sasha Levin <sashal@kernel.org>
> =D6=F7=CC=E2: [PATCH 6.6 044/186] net: libwx: fix alloc msix vectors =
failed
>=20
> 6.6-stable review patch.  If anyone has any objections, please let me
know.
>=20
> ------------------
>=20
> From: Duanqiang Wen <duanqiangwen@net-swift.com>
>=20
> [ Upstream commit 69197dfc64007b5292cc960581548f41ccd44828 ]
>=20
> driver needs queue msix vectors and one misc irq vector, but only =
queue
vectors
> need irq affinity.
> when num_online_cpus is less than chip max msix vectors, driver will
acquire
> (num_online_cpus + 1) vecotrs, and call pci_alloc_irq_vectors_affinity
functions
> with affinity params without setting pre_vectors or post_vectors, it =
will
cause
> return error code -ENOSPC.
> Misc irq vector is vector 0, driver need to set affinity params
.pre_vectors =3D 1.
>=20
> Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
> Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> index e078f4071dc23..be434c833c69c 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
> @@ -1585,7 +1585,7 @@ static void wx_set_num_queues(struct wx *wx)
>   */
>  static int wx_acquire_msix_vectors(struct wx *wx)  {
> -	struct irq_affinity affd =3D {0, };
> +	struct irq_affinity affd =3D { .pre_vectors =3D 1 };
>  	int nvecs, i;
>=20
>  	nvecs =3D min_t(int, num_online_cpus(), wx->mac.max_msix_vectors);
> --
> 2.43.0
>=20
>=20
This patch in kernel-6.6 and kernel 6.7 will cause problems. In =
kernel-6.6
and kernel 6.7,
Wangxun txgbe & ngbe driver adjust misc irq to vector 0 not yet.  How to
revert it in=20
kernel-6.6 and kernel-6.7 stable?
>=20

