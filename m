Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2583F233735;
	Thu, 10 Jul 2025 08:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752136576; cv=none; b=HdXOuGidP/XE0HVhs2rcojYnGGHZzSsqvLcqZjZzm+AAwlLC5gocB6bR0v5/q8hgQmYfQL7GnQmtyxwWEmc3t13Wv2mwCyJsjDj7Br1ex2OUGshi5a67w2IRuAM1LAe6GvoNzM5NR1L+J/ca0BhTmBFiURhTWDFbSdovrsx6aIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752136576; c=relaxed/simple;
	bh=mRrb7U9h+wd/ixXq0sOvssEZNpJV79yjfLJ6q1P/s40=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r2SNi5S5u2smTpx2tFXdXb3FB1T5xtbtCONk5ZI35+jsdvgHdHhSnmAYrXdwnhhjRCCMbvqCoTeQpgtcebAMj/sfgfAsbPm6v5SLUOJNKD1yISavE9YgVVDYbWq7Dp+S6un+CIqfzk3H4LlHOVof0ojZNATdPmm/p5NNj/4OxkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NyOmZ62I; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NyOmZ62I"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56A1Waoc014142;
	Thu, 10 Jul 2025 08:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gzctx2
	cjNDSfw97ECZU1rLs5oO4DX279zNGEhW51iW0=; b=NyOmZ62IW0yVPtR5TR+yIF
	5CIHGgEme5WJMlIReXKsvBT8Z0+usW/1u6sh3ubfSUPbWPL1RwRdlXorBqMfFgrR
	+WIZVS0gByZT6HAACuD4+oPSBy8RQfBfnpFS0fYyv+p21T/WsmZ/8uuJYlJA2/Ct
	6iwIIa0cZEgd1w6/BU1sSdtzXPmAXVaE6NhGu4vprJbNo78xbp+acXrZqdXyrJhL
	adOz99UxiX9I1IacqKqpEHzOW9ieancDA4DXoj/UcPil8O1iGcUZIPRXaEcbEgCF
	AhE6yKRXrZFfUZGyTaUS1q8Z5TdDrNt2PWJ7V+zwqvnYMNGZraS+I/0ipdqG+8kw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47t3xd9qp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 08:36:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56A5ZQ6I010841;
	Thu, 10 Jul 2025 08:36:10 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47qes0cx51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 08:36:10 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56A8a8SJ16122590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Jul 2025 08:36:08 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B730358059;
	Thu, 10 Jul 2025 08:36:08 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1294258058;
	Thu, 10 Jul 2025 08:36:07 +0000 (GMT)
Received: from [9.111.81.29] (unknown [9.111.81.29])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Jul 2025 08:36:06 +0000 (GMT)
Message-ID: <23b7e8e20d7f660513dce9c70958af81057f0f46.camel@linux.ibm.com>
Subject: Re: [PATCH 6.6 108/132] s390/pci: Fix stale function handles in
 error handling
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Julian Ruess <julianr@linux.ibm.com>,
        Gerd
 Bayer	 <gbayer@linux.ibm.com>, Farhan Ali <alifm@linux.ibm.com>,
        Alexander
 Gordeev	 <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Date: Thu, 10 Jul 2025 10:36:06 +0200
In-Reply-To: <20250708162233.754242912@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
	 <20250708162233.754242912@linuxfoundation.org>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 59jT9K2GLUwbgAS_GcAQIIqRSowsTayt
X-Authority-Analysis: v=2.4 cv=MLRgmNZl c=1 sm=1 tr=0 ts=686f7b7b cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=_t13bW5AxIeavYlgejsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 59jT9K2GLUwbgAS_GcAQIIqRSowsTayt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDA3MCBTYWx0ZWRfX8WjsLTqb4wwT Ijak7TS1Ap/8t0qj1KTpcUbqsATk4J+Rd83ZAUEeTH0nJ7EXlb+Q/9EM5LdzwZjo7QoRR6xXC3v CILDskLikFG5EqyE4sHDc47Ul3OhZHtE8qVapDbIP1kQTkh3T8BWp2TmNhyXDCfl2hdF2t1cXTP
 m/6mOom0+OuMsfBqWFlyzUuo1fzjj13ifnmLNhZYQmYnVcDZBPybeAsm/RlT3jOTx9CbjlteegD sYlMsc+D0OQF4bUjSm4snFgdQAGF9z9m6v0z7LsWbWko9p9OXhcjZuiCk9PuLK/LYAB8ZJIZAeZ dZ1esTWzYym/6GLfr/7R9S9engykhMBiPCe5k/I+eyTo51p1BxBGuUBdcNGOO7jQyvnRatj9qME
 /OpubosYcXUWHLtYEYNpLPHwvTse5HxmKcjWoPS6eHJAcTsCHd4QfXI+7Kh3ByfgB9gXPrHI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-10_01,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507100070

On Tue, 2025-07-08 at 18:23 +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Niklas Schnelle <schnelle@linux.ibm.com>
>=20
> [ Upstream commit 45537926dd2aaa9190ac0fac5a0fbeefcadfea95 ]
>=20
> The error event information for PCI error events contains a function
> handle for the respective function. This handle is generally captured at
> the time the error event was recorded. Due to delays in processing or
> cascading issues, it may happen that during firmware recovery multiple
> events are generated. When processing these events in order Linux may
> already have recovered an affected function making the event information
> stale. Fix this by doing an unconditional CLP List PCI function
> retrieving the current function handle with the zdev->state_lock held
> and ignoring the event if its function handle is stale.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery")
> Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
> Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
> Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/s390/pci/pci_event.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
> index d969f36bf186f..fd83588f3c11d 100644
> --- a/arch/s390/pci/pci_event.c
> +++ b/arch/s390/pci/pci_event.c
> @@ -257,6 +257,8 @@ static void __zpci_event_error(struct zpci_ccdf_err *=
ccdf)
>  	struct zpci_dev *zdev =3D get_zdev_by_fid(ccdf->fid);
>  	struct pci_dev *pdev =3D NULL;
>  	pci_ers_result_t ers_res;
> +	u32 fh =3D 0;
> +	int rc;
> =20
>  	zpci_dbg(3, "err fid:%x, fh:%x, pec:%x\n",
>  		 ccdf->fid, ccdf->fh, ccdf->pec);
> @@ -264,6 +266,16 @@ static void __zpci_event_error(struct zpci_ccdf_err =
*ccdf)
>  	zpci_err_hex(ccdf, sizeof(*ccdf));
> =20
>  	if (zdev) {
> +		mutex_lock(&zdev->state_lock);

This won't compile this tree misses commit bcb5d6c76903 ("s390/pci:
introduce lock to synchronize state of zpci_dev's").

> +		rc =3D clp_refresh_fh(zdev->fid, &fh);
> +		if (rc)
> +			goto no_pdev;
> +		if (!fh || ccdf->fh !=3D fh) {
> +			/* Ignore events with stale handles */
> +			zpci_dbg(3, "err fid:%x, fh:%x (stale %x)\n",
> +				 ccdf->fid, fh, ccdf->fh);
> +			goto no_pdev;
> +		}
>  		zpci_update_fh(zdev, ccdf->fh);
>  		if (zdev->zbus->bus)
>  			pdev =3D pci_get_slot(zdev->zbus->bus, zdev->devfn);
> @@ -292,6 +304,8 @@ static void __zpci_event_error(struct zpci_ccdf_err *=
ccdf)
>  	}
>  	pci_dev_put(pdev);
>  no_pdev:
> +	if (zdev)
> +		mutex_unlock(&zdev->state_lock);

Curiously this patch was adjusted differently here vs for 6.1.y, this
one at least places the unlock in the same place as upstream.

>  	zpci_zdev_put(zdev);
>  }
> =20

Please drop this patch! Ten can we pull in commit bcb5d6c76903
("s390/pci: introduce lock to synchronize state of zpci_dev's")
as a prerequiste? This fix would still work for its specific issue
without the mutex i.e. just adjusting context but I'd prefer to have
both in stable.

Also, I wonder if it would be possible to have the subject of these
kind of mails indicate if the backport patch was adjusted more than
just line offsets or context? I think that would make it much easier to
spot where extra attention is required.

Thanks,
Niklas
