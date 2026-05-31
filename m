Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ADC3242B2;
	Sun, 31 May 2026 14:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780237929; cv=none; b=jCVjOJMQH7GDeEnMG8JqH6rg1xeNjH4RzJ1Y3zrGbx0VNl344YiP7hOIRsqoxh+LIXkR6CfKlbhudYzWzrWJyN4vlze/qeh7/rgxjpFos0se3ANAQxmcygGVslRjOb0LwO6cgZUn15j2vqd1UFK8vQjVSm7J/NkF8tGg2wD5MFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780237929; c=relaxed/simple;
	bh=o2bghsenNXobi081XOpbMzNDXWsR4DzLRzj+dbjqFOA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gnAKo8vd79LvlVRmH5Lkhi2A+/QANScLmDgW/6fic1LrHVB6/v/VXFhWDq2RYeU/N7hj0ol1t+2HUw4bLnVWcT59zDe5yVcqchOFNYu+QGCUfzSHZJWITN7XLcyEM/2SSmY7GpNLbaNa5mrAckvFMyG96yGdydMH3IdVgERPfzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wThCu-000OJL-23;
	Sun, 31 May 2026 14:32:04 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wThCt-0000000FGOt-0b4W;
	Sun, 31 May 2026 16:32:03 +0200
Message-ID: <70620d4eddfa13b0b5333e482bb76d7f4b323114.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 096/589] scsi: ufs: core: Improve SCSI abort
 handling
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Bean Huo <beanhuo@micron.com>, Stanley Chu	
 <stanley.chu@mediatek.com>, Bart Van Assche <bvanassche@acm.org>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Vasiliy Kovalev
 <kovalev@altlinux.org>, Sasha Levin	 <sashal@kernel.org>
Date: Sun, 31 May 2026 16:31:58 +0200
In-Reply-To: <20260530160227.218464986@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160227.218464986@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-M9kNx94o/cPq/cqSst5y"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-M9kNx94o/cPq/cqSst5y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 17:59 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Bart Van Assche <bvanassche@acm.org>
>=20
> commit 3ff1f6b6ba6f97f50862aa50e79959cc8ddc2566 upstream.

Since there are no patches to ufshcd in this series besides this and its
revert, it seems like you should drop both of them.

Ben.

> The following has been observed on a test setup:
>=20
> WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737 ufshcd_queueco=
mmand+0x468/0x65c
> Call trace:
>  ufshcd_queuecommand+0x468/0x65c
>  scsi_send_eh_cmnd+0x224/0x6a0
>  scsi_eh_test_devices+0x248/0x418
>  scsi_eh_ready_devs+0xc34/0xe58
>  scsi_error_handler+0x204/0x80c
>  kthread+0x150/0x1b4
>  ret_from_fork+0x10/0x30
>=20
> That warning is triggered by the following statement:
>=20
> 	WARN_ON(lrbp->cmd);
>=20
> Fix this warning by clearing lrbp->cmd from the abort handler.
>=20
> Link: https://lore.kernel.org/r/20211104181059.4129537-1-bvanassche@acm.o=
rg
> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> [ kovalev: bp to fix CVE-2021-47188; adapted placement of
>   lrbp->cmd =3D NULL for 5.10 function structure ]
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c7bf0e6bc303d..1b8072f47e7e8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6788,6 +6788,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		__ufshcd_transfer_req_compl(hba, (1UL << tag));
>  		spin_unlock_irqrestore(host->host_lock, flags);
>  out:
> +		lrbp->cmd =3D NULL;
>  		err =3D SUCCESS;
>  	} else {
>  		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.

--=-M9kNx94o/cPq/cqSst5y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmocRl4ACgkQ57/I7JWG
EQkU6A//QIhP8MUFpZh2gTGy7IfkiYvBX5qXmlyyHOgqGPXYfOQuilPRUsP456xB
ViyATSW5CK846XdNGm4VG6GpQYkp+8eL1Puj7AuLGhj09EerQY3y7v/KJ4EGP65B
dxOu0CBeQc3pOfbd3soYTsy3s1cxeFUSY8n9p2bBkQ/c7ZccZtGgBpXlDHbkBsrH
2uoJMj1833cSd14GnFtZbHNPcc76t2mSSM7I9n3vy++cyaAWuOobx/rVFGpQq1lT
eGIrr9m8l7UXN5TmB5yISuPRFjaZ0UE5epvIuv/2+LT9CR34ZjIkunNze6mPWQ58
NLI/pDcE/5akbhVf6a9YlN9FS86T6t8H8OIdu6Tf/SIG1zcHM52Z4M/BCOMhfZSn
C2gUMcgK9PrgGIBYsYChp1C4kSxB6yTRdkMAuQH75VX8H4Am54yTUWgkzljrhI8j
IEi4eWs5YhOg6/GWdTGgIMIscfv47YrcYsnXkmTrU9sSQfZhb7VlcZsBkPgHjX1G
e/l4BjIFVuDj1dsVNAlrs4r8ZpDf2PTQ5+RqybcxHDM8ZFqTQYxKJ5ZqAu9cvg20
Ixn2h1lJ4GylVRtUXdlmh04ZxzWEwGRKcMJCjnI5GP/rXqv6+YVMM/60sPeH+pRJ
RqeK1dkixP5XhPZWO6iJRdHYkxN2n45SBus+cvdflghM8Gny4oU=
=4oM5
-----END PGP SIGNATURE-----

--=-M9kNx94o/cPq/cqSst5y--
