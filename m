Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C190017E8
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 06:24:49 +0000 (UTC)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2bb99fbaebdso8319981fa.0
        for <patches@lists.linux.dev>; Thu, 24 Aug 2023 23:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692944687; x=1693549487;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uEHc+Bn9fVExj/Xm1/appuP/CTV5FQDNf/fQ5GlDY9k=;
        b=Qmg0yw1ib8mMBEqotOKleA6FwURO9sng03yw+9MYlavL0ZlVsDEq7uH1kDO0WfP8+Z
         m7qrQRZz6OWWTxb9FOJW7QBf3ezDj+0k0A1zB4YitThip3meDT6Xv0bifjNwsSPqjCTh
         36tFUDlYw+FHdO/z2XftXmRxZMENCJpOADF18f1+teqz+fI6107UD/PrSXBpX5ahf1m9
         e2cJz4VjQsR1U4zRn+Z+/zVNBSB2oUXQ0rRCCatYrQCX/Bb/UOlH205vr5drI7SvwKZQ
         rXXRkux7sSidO7fDBj167/Ka0lW/sEeL9VBF+YV9KyyQ7ON8jEzP+gI2k0HL9dL3zqkc
         19UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692944687; x=1693549487;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uEHc+Bn9fVExj/Xm1/appuP/CTV5FQDNf/fQ5GlDY9k=;
        b=jp3+BKXHtxDD7P/hR9tR+RykeGnJ/QSBgAz4UIxAqDBGYcC/RromZT/syLxIKKIxpB
         pV1cywNlyUpnH3Rsl6CTxmY+4WADfDyZA2nQaGu/mlh5mpg0lvCC1wuRKRrr6LHo7rLr
         jxKE92X7F8Fdr8zs2rw4R/ibLou1LaXsAmP5rzECpxTOigbZjrBUQlhkUr7HjEUtNpZM
         W+7ojUv+j3eTALd4/5Wy8aRMcB96THDbXoR8l7iuwb9TXNhGupZX34cs9bCckx3pbS+n
         3/b5Yjdo4TL1Imk7NtC0Un37iSzwZE9GH9i5LCW5sRcYAx4IOBZ3elaYASR7rgcGp3vy
         Y5UA==
X-Gm-Message-State: AOJu0YzPbOJRSV0T6xZwWxCD3pcMQp+Ba/vVuUJmckyXUFSsFywvrVC9
	56Obnq7ZgglxpvsTOIT3zXI=
X-Google-Smtp-Source: AGHT+IEeEg+wOHWE9+2JE6SBQOCKkhi7+hlHb7+7beGRLxugsfX/OUlKdP7BCUV3f2noAr4xPP7nWw==
X-Received: by 2002:a2e:9594:0:b0:2b6:d137:b61c with SMTP id w20-20020a2e9594000000b002b6d137b61cmr14112049ljh.39.1692944687281;
        Thu, 24 Aug 2023 23:24:47 -0700 (PDT)
Received: from [100.119.51.22] (95-24-151-207.broadband.corbina.ru. [95.24.151.207])
        by smtp.gmail.com with ESMTPSA id 8-20020a05651c00c800b002b9e501a6acsm196422ljr.3.2023.08.24.23.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 23:24:46 -0700 (PDT)
Message-ID: <739b18f9dc2ae6cde7b1060ee8071d7687b5d4e3.camel@gmail.com>
Subject: Re: [PATCH 5.10 066/135] net/ncsi: change from ndo_set_mac_address
 to dev_set_mac_address
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Paul Fertser <fercerpav@gmail.com>, Simon
 Horman <simon.horman@corigine.com>, "David S. Miller"
 <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>
Date: Fri, 25 Aug 2023 09:24:46 +0300
In-Reply-To: <20230824170620.057993946@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
	 <20230824170620.057993946@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2023-08-24 at 19:08 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.=C2=A0 If anyone has any objections, please let
> me know.
>=20
> ------------------
>=20
> From: Ivan Mikhaylov <fr0st61te@gmail.com>
>=20
> [ Upstream commit 790071347a0a1a89e618eedcd51c687ea783aeb3 ]
>=20
> Change ndo_set_mac_address to dev_set_mac_address because
> dev_set_mac_address provides a way to notify network layer about MAC
> change. In other case, services may not aware about MAC change and
> keep
> using old one which set from network adapter driver.
>=20
> As example, DHCP client from systemd do not update MAC address
> without
> notification from net subsystem which leads to the problem with
> acquiring
> the right address from DHCP server.
>=20
> Fixes: cb10c7c0dfd9e ("net/ncsi: Add NCSI Broadcom OEM command")
> Cc: stable@vger.kernel.org=C2=A0# v6.0+ 2f38e84 net/ncsi: make one oem_gm=
a
> function for all mfr id
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> =C2=A0net/ncsi/ncsi-rsp.c | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index 888ccc2d4e34b..47ffb790ff99f 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -616,7 +616,6 @@ static int ncsi_rsp_handler_oem_mlx_gma(struct
> ncsi_request *nr)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ncsi_dev_priv *ndp=
 =3D nr->ndp;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct net_device *ndev =
=3D ndp->ndev.dev;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const struct net_device_ops *o=
ps =3D ndev->netdev_ops;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ncsi_rsp_oem_pkt *=
rsp;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sockaddr saddr;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret =3D 0;
> @@ -630,7 +629,9 @@ static int ncsi_rsp_handler_oem_mlx_gma(struct
> ncsi_request *nr)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Set the flag for GMA c=
ommand which should only be called
> once */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ndp->gma_flag =3D 1;
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D ops->ndo_set_mac_addre=
ss(ndev, &saddr);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rtnl_lock();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D dev_set_mac_address(nd=
ev, &saddr, NULL);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rtnl_unlock();
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret < 0)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0netdev_warn(ndev, "NCSI: 'Writing mac address to
> device failed\n");
> =C2=A0

Greg, we had conversation in the past about this particular patchset
series:
https://www.spinics.net/lists/stable-commits/msg308587.html

Just one patch is not enough, I didn't test it either on linux kernel
version < 6.0 , also I saw the Sasha's commits about the same for 5.4,
5.10, 5.15 and answered to him about necessity of two patchsets instead
of one on 19 aug.

Thanks.
