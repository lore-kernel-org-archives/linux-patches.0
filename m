Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0365F17FA
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 08:38:05 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2bcb54226e7so8628381fa.1
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 01:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692952684; x=1693557484;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QT5lB6ELtp2Kj+OItj8lkNw3marf28CcZNitD0oxae4=;
        b=fHBPaZspft3eDNR1krp/yU67SM/sMHlaoFAQ8K+sV3YhB930ZvHHtjyM4/Xm7cDeHD
         cFf/Y1qlG6/9qyhsS9fvNcP7uj+gnQBidZRpwGJXqyRIhxAZD2vERtCVlmS7eR7RLUgV
         NAvuj2MukmD0YWeP/1EAtb8qm/5kxKQWfdeYXf2Fa7NsLQjzsQnHoCEY5dp05IRcVfKJ
         wL48tPb3fOP6w0hL8OBtwKSeKloWZLW/yasJUaMwepT1Kro0MaM3KYZ0kmnJZVZ0pp1K
         6gY8rPD3p8kNBcxRtYAnySPI263hmGRTNp450NGWcbcOHUBkK9D5omX4W07QBvItD8Tx
         tINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692952684; x=1693557484;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QT5lB6ELtp2Kj+OItj8lkNw3marf28CcZNitD0oxae4=;
        b=fLNfIb3DmBCrfJR+ivxSHe91ZAz+veJxYLlAtkzQ1O0sVBP+ywUPReBrgDsxQWCrgp
         TAtRESgaQ3kWLNTMRGK0xLS47hz5ElBKLK4xelC/CevVjCJvVQLZ5Eq/SReYX7ExwKs9
         bZiLooIwfFVb5NK/C1zh8YfgVfhYAYquaeMsqxIjZ9B71bkfAbDvbfzNttRVTB6GYVSt
         PhS/vmQJzXt7eVm4BZiAStZTO4zHsGs6syXhXfliO5yM3ZVmL0z9ddoAZdKwciNUi9VH
         yAk805CgwtJCfevmygZB+SSpNdbiW5QbcwTNOiSL0Ff/+bta3I5d7Lcea/YOO4Ewd01R
         T4Pw==
X-Gm-Message-State: AOJu0Yyi56p7AeiQnUGQANTwsaJo+YMaePWZMcgZYxU4X8nnQWrLVVir
	NJhLeA+KrXOpqj1SRrNmdNo=
X-Google-Smtp-Source: AGHT+IGOmN4g5i3o5oae/akXL0yQoPaUAUaWkgxO5MgazCDUPqE0YTdLnCr2Ujramb5WkqW0V1T2kA==
X-Received: by 2002:a2e:a4b2:0:b0:2b6:b30f:5bf with SMTP id g18-20020a2ea4b2000000b002b6b30f05bfmr7106277ljm.13.1692952683415;
        Fri, 25 Aug 2023 01:38:03 -0700 (PDT)
Received: from [100.119.51.22] (95-24-151-207.broadband.corbina.ru. [95.24.151.207])
        by smtp.gmail.com with ESMTPSA id j16-20020a2e6e10000000b002b9ef00b10csm240000ljc.2.2023.08.25.01.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 01:38:03 -0700 (PDT)
Message-ID: <e81e0014604bc8cf6f387c67875e43dc9a339815.camel@gmail.com>
Subject: Re: [PATCH 5.10 066/135] net/ncsi: change from ndo_set_mac_address
 to dev_set_mac_address
From: Ivan Mikhaylov <fr0st61te@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Paul Fertser
	 <fercerpav@gmail.com>, Simon Horman <simon.horman@corigine.com>, "David S.
	Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>
Date: Fri, 25 Aug 2023 11:38:02 +0300
In-Reply-To: <2023082507-breezy-eastward-da6d@gregkh>
References: <20230824170617.074557800@linuxfoundation.org>
	 <20230824170620.057993946@linuxfoundation.org>
	 <739b18f9dc2ae6cde7b1060ee8071d7687b5d4e3.camel@gmail.com>
	 <2023082507-breezy-eastward-da6d@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2023-08-25 at 09:16 +0200, Greg Kroah-Hartman wrote:
> On Fri, Aug 25, 2023 at 09:24:46AM +0300, Ivan Mikhaylov wrote:
> > On Thu, 2023-08-24 at 19:08 +0200, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.=C2=A0 If anyone has any objections, please
> > > let
> > > me know.
> > >=20
> > > ------------------
> > >=20
> > > From: Ivan Mikhaylov <fr0st61te@gmail.com>
> > >=20
> > > [ Upstream commit 790071347a0a1a89e618eedcd51c687ea783aeb3 ]
> > >=20
> > > Change ndo_set_mac_address to dev_set_mac_address because
> > > dev_set_mac_address provides a way to notify network layer about
> > > MAC
> > > change. In other case, services may not aware about MAC change
> > > and
> > > keep
> > > using old one which set from network adapter driver.
> > >=20
> > > As example, DHCP client from systemd do not update MAC address
> > > without
> > > notification from net subsystem which leads to the problem with
> > > acquiring
> > > the right address from DHCP server.
> > >=20
> > > Fixes: cb10c7c0dfd9e ("net/ncsi: Add NCSI Broadcom OEM command")
> > > Cc: stable@vger.kernel.org=C2=A0# v6.0+ 2f38e84 net/ncsi: make one
> > > oem_gma
> > > function for all mfr id
> > > Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> > > Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > > =C2=A0net/ncsi/ncsi-rsp.c | 5 +++--
> > > =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> > > index 888ccc2d4e34b..47ffb790ff99f 100644
> > > --- a/net/ncsi/ncsi-rsp.c
> > > +++ b/net/ncsi/ncsi-rsp.c
> > > @@ -616,7 +616,6 @@ static int
> > > ncsi_rsp_handler_oem_mlx_gma(struct
> > > ncsi_request *nr)
> > > =C2=A0{
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ncsi_dev_priv =
*ndp =3D nr->ndp;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct net_device *nd=
ev =3D ndp->ndev.dev;
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const struct net_device_op=
s *ops =3D ndev->netdev_ops;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ncsi_rsp_oem_p=
kt *rsp;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sockaddr saddr=
;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret =3D 0;
> > > @@ -630,7 +629,9 @@ static int
> > > ncsi_rsp_handler_oem_mlx_gma(struct
> > > ncsi_request *nr)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Set the flag for G=
MA command which should only be
> > > called
> > > once */
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ndp->gma_flag =3D 1;
> > > =C2=A0
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D ops->ndo_set_mac_a=
ddress(ndev, &saddr);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rtnl_lock();
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D dev_set_mac_addres=
s(ndev, &saddr, NULL);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0rtnl_unlock();
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret < 0)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0netdev_warn(ndev, "NCSI: 'Writing mac address to
> > > device failed\n");
> > > =C2=A0
> >=20
> > Greg, we had conversation in the past about this particular
> > patchset
> > series:
> > https://www.spinics.net/lists/stable-commits/msg308587.html
> >=20
> > Just one patch is not enough, I didn't test it either on linux
> > kernel
> > version < 6.0 , also I saw the Sasha's commits about the same for
> > 5.4,
> > 5.10, 5.15 and answered to him about necessity of two patchsets
> > instead
> > of one on 19 aug.
>=20
> Ah, so I should also include commit 74b449b98dcc ("net/ncsi: make one
> oem_gma function for all mfr id"), right?
>=20
> thanks,
>=20
> greg k-h

Greg, yes, that's right and I'm not sure if these two patches applies
well for 5.x stable releases.

Thanks.
