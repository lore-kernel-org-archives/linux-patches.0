Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7F33208;
	Thu, 10 Jul 2025 08:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752135268; cv=none; b=RTthyYZL9NR3Ktvn5ljpp66luW4nDBhaNn3sVCY5pP9KUrHTNFjJK1Ibn0kivy/YNLw4mKScGTfwBu8+kj32ugssJ4w8/lT16an/IxBDEDIn/bedwJEV2S2Weujuf9MONsNgElKDDmDAbSBgLQHqjsKYbos2LC3NCConYY31psg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752135268; c=relaxed/simple;
	bh=WA3OFPfxvSq747KqaMSrkUwpYEKd0sSEJW17H/TST+E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IHDoAXjEk3hNob8qEVL+a6Vy5GmZ3WZRsrvfA3QbfxGLewhe7r8cROBE3z5AFYXg3Br2CXtEGo/GrVu98ORsHUFXaWyPp/wke7RNtGsqYHdl+THJxzFRdv4RvbVwXOU7q0TiMNNNnZSfkbp2FGrplUKwj2cKPbvZ0yTl/QmA1Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qpkSwdVe; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qpkSwdVe"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569LwaWN004705;
	Thu, 10 Jul 2025 08:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AsG/sv
	LIsZVI1j+a3Kfd1fICp/ISrPuoY1dGfKlmKFE=; b=qpkSwdVeMEBs+bMH0YtMH1
	nAygWgyISXekRem3tcIMZ3yof31ETqsbaFuyn2/HcLxx0Le+JbB0Jf3MUO26u4m3
	lDzDrKTx8tC02oiuJkaRPUyya0nnZDsyj2usk5PMgUMV+zZYUI7LY+JtX4Kw4MNB
	9FGC3Ry0ID6k7IRDm3LB6FN6A/Dbw9dG3tRgLf8zwTooV5dygiie6kR9RBF8dqr4
	uxfXWygdHtThvthAOM5s4fcjFE0ZiWUbqW3kRvtEnJh4WO0QiyKpOmIB9qM/AY3T
	NUuPc5dAfIQNVGQ+hMMft2pWIkLuDxXZ6/kDOk5mhPfXGOw1ZgU5enruT8jUQ7uA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47puqnjhmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 08:14:22 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56A5f42X021525;
	Thu, 10 Jul 2025 08:14:21 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 47qectvvjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 08:14:21 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56A8EKci27066964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Jul 2025 08:14:20 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4281A5805C;
	Thu, 10 Jul 2025 08:14:20 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D10558054;
	Thu, 10 Jul 2025 08:14:18 +0000 (GMT)
Received: from [9.111.81.29] (unknown [9.111.81.29])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Jul 2025 08:14:18 +0000 (GMT)
Message-ID: <6bca64221f8954adcdcfe6b5639e29c7fee4b03a.camel@linux.ibm.com>
Subject: Re: [PATCH 6.1 60/81] s390/pci: Fix stale function handles in error
 handling
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Julian Ruess <julianr@linux.ibm.com>,
        Gerd
 Bayer	 <gbayer@linux.ibm.com>, Farhan Ali <alifm@linux.ibm.com>,
        Alexander
 Gordeev	 <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Date: Thu, 10 Jul 2025 10:14:17 +0200
In-Reply-To: <20250708162226.893789793@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
	 <20250708162226.893789793@linuxfoundation.org>
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
X-Authority-Analysis: v=2.4 cv=FZ43xI+6 c=1 sm=1 tr=0 ts=686f765e cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=2IdWMj8hQMSgo3BdekcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: VtWGWgLaeUzhu8vni0A4MlFM-zDQRsKN
X-Proofpoint-ORIG-GUID: VtWGWgLaeUzhu8vni0A4MlFM-zDQRsKN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDA2NiBTYWx0ZWRfXx+IywV3C1lyN qdE4uYSk8pUuKF07axkikB4mSQ1cOciQX2TVAVazH80c1P6pYsVpmDIlClZ7bvqOQHu69Dj3WME RnzRePvDI+rY6AOPRT+J6vGdGgg9mfB5JR2xX3JFYxVEk3G7azI6t6DVndNJp3neGbFT9/5bQ6O
 n3aTKSHnG2dGddoe366Dm0jNmRCwt5GLmRiFsk030GBqOXqw//cT1vuXzAfi8blBqoocfXGsQFp 6vGn+VqXc+1NIgfQzXC9Ls15vhCWsjGZoMnFWvrbx5tphXi8Dfr65vfctYWY4NkKwLuiKxYSFNR M72ekVppJaEBxYJNrjBC2pVFlVGVkuSsEOLtdNmDgiUVNRwRE8pawnU4haMLXUQxffedW4M0cXj
 6ROM+DzheMZNZlbTF/RzKEaACaX4HoMJb99aes7hGBQnd9ErqwDEIpaTTgTpqnqPXaRrcZ3m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_05,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507100066

On Tue, 2025-07-08 at 18:23 +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
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
>  arch/s390/pci/pci_event.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
> index d969f36bf186f..dc512c8f82324 100644
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
> @@ -264,9 +266,23 @@ static void __zpci_event_error(struct zpci_ccdf_err =
*ccdf)
>  	zpci_err_hex(ccdf, sizeof(*ccdf));
> =20
>  	if (zdev) {
> +		mutex_lock(&zdev->state_lock);
> +		rc =3D clp_refresh_fh(zdev->fid, &fh);
> +		if (rc) {
> +			mutex_unlock(&zdev->state_lock);
> +			goto no_pdev;
> +		}
> +		if (!fh || ccdf->fh !=3D fh) {
> +			/* Ignore events with stale handles */
> +			zpci_dbg(3, "err fid:%x, fh:%x (stale %x)\n",
> +				 ccdf->fid, fh, ccdf->fh);
> +			mutex_unlock(&zdev->state_lock);
> +			goto no_pdev;
> +		}
>  		zpci_update_fh(zdev, ccdf->fh);
>  		if (zdev->zbus->bus)
>  			pdev =3D pci_get_slot(zdev->zbus->bus, zdev->devfn);
> +		mutex_unlock(&zdev->state_lock);
>  	}
> =20
>  	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",

Sorry I only noticed this due to a build error report but this backport
is NOT CORRECT. The mutex_lock(&zdev->state_lock) line that was context
in the original commit was part of commit bcb5d6c76903 ("s390/pci:
introduce lock to synchronize state of zpci_dev's") which also added
the mutex and isn't in this tree. So without pulling that in as a
prerequisite this won't compile.=C2=A0

Also and kind of worse the above puts the mutex_unlock() in the wrong
place! Please drop/revert this patch.=C2=A0

The original commit here should work for its specific problem even
without the backport of the mutex though I think it would be best to
get that into stable as well. Sorry for not marking it as a dependency.
That said, shouldn't there be a note that this backport deviates
significantly from the upstream commit?

Thanks,
Niklas
