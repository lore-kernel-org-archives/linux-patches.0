Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE402469834
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547775; cv=none; b=cV/sUFHnQ73dhoKud/U3/YCJuR4Eh0KxQ9IKE1rsVy29cW6x3Zo2aI+pawwKgm/jMi4xgn7CmBb4a5ljxaofSi6H9v+fbFM9EUkw/R/ot5F0+YYWJfdZV52pWEJp95zO2DJrEpNugM2KcLV2fiegz6b4Auua3fPvPvKOHXQ0GhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547775; c=relaxed/simple;
	bh=sW8vNh4BJo9ETYFNlpOULWZ4MsxPcWARWmFE0T+Jghw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAJRXd4KiiAZqkr8OfG+z/tcKzcTyRrWwLnvB4aYPz8NvsDoXZg0qmSjc++5HQVdlWSC0gvO0gaVzgSX0B+ZMITAlXLtbVhPdVplISbyo2ot8OZTtinxqGJq7zFNY0g1w+yC3HTlxREIP/pl+1npMLmSPpd+/ZMXOAfZYQmUd9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=F4lKIE12; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iTxuYCFb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="F4lKIE12";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iTxuYCFb"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68G69eOW1163471
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=AsGoWkaP8lk0Cgyep59xCja8
	DVlh598m+OnWGJJVpAs=; b=F4lKIE12eCQwNhHAtphu+jlruG1tamiaJ/sGhzN8
	YSHN3aQkSOBGt/QVVz5MESFmT5dfBMNuRKgTwnIyNam2pK7vQUdxnYmHveMVX12W
	aGpPse+PSfom+z5bZ8gpr9Y5F02rhYscwT0Vb2JvwoFbYYsqUBztY7webzYIqLRk
	iyCb3nUaXlte6HDHQ7AbXzdiNY5WriXk1CbYeI5OBI9uoG9fYL81q8zkR+b1rHTk
	kymqEwt4WBmteaIL1L72teXf2lzNBkrJrFt27f7S9BZKPcDTGtfzCQvB7pK7xgO7
	RDmBjtRMHKQ8Ekxc3413PyvCYl4hl8mVPPtjJDkDeSvwhA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gq9n63nu7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:36:12 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39e1bbe2c30so987832a91.2
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 01:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789547772; x=1790152572; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AsGoWkaP8lk0Cgyep59xCja8DVlh598m+OnWGJJVpAs=;
        b=iTxuYCFbCfc8kiHftPcB2jLP+ONBsFaznGiMRdWQD2ky6p4qPpMfhFrOpaThiplbHA
         cLNDQFsUZtXh3rGEsq8p1z/lRC1L81epb/ps02T3vrvtic5iMXyE1b82ymmmdyCAN7f4
         O+Dfo+0hhrDko+/5Jhe5umHcddPyB+tveaFBi4KTt9ftN0+uZ94usHk8UG/5RrQhg5Q7
         rOwQ2ZmUpukIp0R9PE3zkbbPSqeOmhY+pRhkmYj2x+39lP1Z+ZhOwEtahbWLYbE9B4/L
         LX/UG5salppQ37eI5YkcmyxTzPHBtmG1BT0NX0a7Nvb5Os6wmA0jF1LQ8dfLTWdyY2Xe
         IMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547772; x=1790152572;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AsGoWkaP8lk0Cgyep59xCja8DVlh598m+OnWGJJVpAs=;
        b=MQ01JxgX8Xq/1Vg8aSasbEyZBswtfdhXOaXTGk3GVWkoZK5y1o/d1VlIIEWdrLcTly
         Ijn9Ejap/IrWMU2AU4fZYwUbOQ4/PZG+Vj7jkLZn9MFZHBA1CMJUg52jeQarWk40RSCM
         YKsglxwQy37c6zxuMUaebz6dqjxhfYmp2u1pKR4pzMPIyfbQCRIaVMWtziPjkNI6YrhO
         GeKg6ouAS/ajn5bHH2tfkSnmdKnkNDKnvBtM7CMDsaXxdz20U6K/pPSqLuKEgbRJzUsI
         ll14CUaNPwgXHMf+73qgA6HDjjvL14s3+b7zFKOnqpGmlZhVvZd4jfUOIt1M0yyTKm5J
         xHgw==
X-Forwarded-Encrypted: i=1; AKwUvBwLoOVNmMwQ7pUAKetm0nlzR10mpK6OztutMNKevZWDbREj9VHv9KPXT7dItjI8wVwwvd9lxJKp@lists.linux.dev
X-Gm-Message-State: AFuF++khckTCirD3PDI/wVsMlsM5P9uRtE/RG0vrkUT1KsOt+KtnbC4q
	uAHBuyrhQfGZGjdm5YxUtNjA4CaXeOsS4e3vvEXpHSVv/L/MRU3cSuj5nySnOVbwHiGaNNQbN+Q
	KcHjNbipoFLyiCQsdpPEUZJZmcEnJhp/wJx5wqVRW3glbaCuVfPdkd5Rq2k5f
X-Gm-Gg: AYBFou2QbmPdLb5NoN2N5rh2SN96dsL2r/9tBl9cD1NDNOdIfkqf3aF7LslqFp3xmXZ
	fRhQgBVXR6mkbNhUuKo3q+kN0mps7ew7mDKEOSTYswuBWydxQAPb+MR/I1l4hADapPicWcp5buQ
	l4DtC4vWhlF7qKmERWSMxUVVfBPk+AxA6qqVyndzDeZS32DN1OCU9ysCkpwrC4K74Z4Z37QEkOe
	jaN28rtLYbC+J/iP7yIUUusg/TRc9SGuEI3MLatc9xOblf7L2d2cHBUFIGqfjaYUfA0/5yGGHY/
	rMv7b1mouR60agkd0K1XIYh/wBi+8ay5rGfXPeY6uju4ADhTk4aMPDVmWXrFeZVk0UjNQ9I4dJr
	fD2PThJPEr2ZWXw==
X-Received: by 2002:a17:90b:5810:b0:398:9c39:520f with SMTP id 98e67ed59e1d1-39e1e4923f6mr4127392a91.15.1789547771875;
        Wed, 16 Sep 2026 01:36:11 -0700 (PDT)
X-Received: by 2002:a17:90b:5810:b0:398:9c39:520f with SMTP id 98e67ed59e1d1-39e1e4923f6mr4127321a91.15.1789547771391;
        Wed, 16 Sep 2026 01:36:11 -0700 (PDT)
Received: from oss.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5ad25bbsm5125623eec.19.2026.09.16.01.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:36:10 -0700 (PDT)
Date: Wed, 16 Sep 2026 14:06:05 +0530
From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 0951/1376] phy: qcom: sgmii-eth: vote for both
 voltage rails with correct current loads
Message-ID: <aqpU9epE2YS12PRu@oss.qualcomm.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065628.756028552@linuxfoundation.org>
 <a5153eb7-6047-4034-80a1-fb3c0b70c9ca@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5153eb7-6047-4034-80a1-fb3c0b70c9ca@oracle.com>
X-Authority-Analysis: v=2.4 cv=BdVNQbt2 c=1 sm=1 tr=0 ts=6aaa54fc cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=-HYML8Te7iaPLNSmSDEA:9 a=CjuIK1q_8ugA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMSBTYWx0ZWRfX3H7gqCrenx7y
 Z3F6ALEmEnifZU1iXbVdZZFhtIYmFJVN15dR532mVs71ER5z6K1M70Od415jStSejtti6yOEsTq
 QEZrqNxbYeHDP57c7kXyKc6IdRfoeXXJEeor40TDfwc3IQwLxmT13EgxHf1idpB5DDbROVlzwED
 QoHH9zd+hhrUaKRAm9D/IW7sDArM5H1op4qUv2Hcyc9afjiexOmEQjYvPpxGT9dkjVYrHlfOJkt
 pVoI8oc9svgf1Q1BH2d6QkhKBvFsagv/6Rley5S0qOspgoF6rGfcy8cz+HMPx6LR+SGDsUQ4M/E
 auDtjQTUM6b9yteEt6djCO02uOr17OD4WAik4UcGgxz74YqbeHPm5e/IigO2rdiaRs5GT4c52Sj
 ZT2rU4HWtLELzQQFu2dvSJt9xcxpFtFt05xFlmoDR2XUUYkSiRvjvP0kg3ZJaMvE2LZMTCv3Zmw
 kPmmLURIa/j40q0+ZaQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMSBTYWx0ZWRfXzwnxV04Zs25U
 z9xkCzi4pYiuoHSt69gRSsKqfOrN325DPgvlhPw8aH53hJO97agXxAreek81dp462RUtY8QLFt7
 eiUNmHc2HgpISF7Jt72Ofi+pu4OUNhc=
X-Proofpoint-GUID: pj2j9WU0z42wKgfXZ3YHK-CfAbFfDiUf
X-Proofpoint-ORIG-GUID: pj2j9WU0z42wKgfXZ3YHK-CfAbFfDiUf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1011
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160111

On Wed, Sep 16, 2026 at 01:38:54PM +0530, Harshit Mogalapalli wrote:
> 
> 
> On 12/09/26 12:26 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
> > 
> > [ Upstream commit 4f81684a1d1018d7d0e5579f08d95e7701279358 ]
<snip>
> >   #define QSERDES_COM_C_PLL_LOCKED			BIT(1)
> > +static const struct regulator_bulk_data qcom_dwmac_sgmii_phy_vregs[] = {
> > +	{ .supply = "vdda-0p9", .init_load_uA = 46000 },
> > +	{ .supply = "vdda-1p2", .init_load_uA = 15000 },
> 
> 
> Hi Greg/Sasha,
> 
> I ran an AI-assisted backport review, and I have verified the report. It
> looks valid to me.
> 
> Upstream driver code:
> 
>     { .supply = "vdda-0p9", .init_load_uA = 46000 },
>     { .supply = "vdda-1p2", .init_load_uA = 15000 },
> 
> Downstream 6.12.y board code:
> 
>     phy-supply = <&vreg_l5a>;
> 
> The downstream property matches neither required upstream supply name.
> 
> The driver now requires vdda-0p9 and vdda-1p2 supplies, but the enabled
> SA8775P SerDes nodes in 6.12 provide only phy-supply. Regulator lookup
> uses the exact named properties, so probe either fails or receives dummy
> supplies; it does not vote the physical rails which this fix requires.
> 
> Upstream companion 3719850f1b70dd adds that.
> 
> I suggest dropping the driver patch until that mapping is provided and
> validated. Thoughts?
> 
> thanks,
> Harshit> +};

Actually, phy-core.c already takes care of regulators described by
"phy-supply".

drivers/phy/phy-core.c
	/* phy-supply */
	phy->pwr = regulator_get_optional(&phy->dev, "phy");
	if (IS_ERR(phy->pwr)) {
		ret = PTR_ERR(phy->pwr);
		if (ret == -EPROBE_DEFER)
			goto put_dev;

		phy->pwr = NULL;
	}

This patch only adds support for two additional regulators
(vdda-0p9 and vdda-1p2). It does not remove or alter the existing
"phy-supply" path handled by phy-core.c.

As a result, boards that only describe "phy-supply" continue to work
as before. The new regulator lookups are optional and merely allow the
PHY driver to vote for the dedicated rails when they are available.

        Ayaan

