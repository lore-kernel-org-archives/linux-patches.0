Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBACD2750F6
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 06:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745909204; cv=none; b=Dtqjz1EsD7+3wpqj2gm79T4yY4AEMvN6ENF807bibhBOMbGT6Clw9hoFn/Nh37nsBa/rBXsB9/0Y5fN9gGyU7/GoerdU+TmozfLZfKY23iLFEB/DaV80cjXK8fakazjzzHDmMAf1gqN4MGrzMO7yl7N7HGGQueloi8aoTXQcl8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745909204; c=relaxed/simple;
	bh=1pIprI0EO05HFaFO5ZwHNaOGBqkqOpeJf8DkIAD7OnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HGz+ydER1edqBGZoQ6RInnexQyzM4y3mqAo2dKIZl6gTsLZdH3v4IB0ZwRXIAK36UaGRfpaOUFBPhkYpSuKJnTKewIX/5Mdhl43QZq3eHZn63uvEjla6FPLJZHmSApjI8Gxw5YDio2zee5PIbEk8WJ886Qe0AjwbDSr+CTyGvc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N6XDVcY+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N6XDVcY+"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53SNqnFt001785
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 06:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=DZu3TV8trj7jEXy9C3oxl4Sy
	0FYWykPDbiLWiHrWJao=; b=N6XDVcY+mrQT+m461o4bwqUWem/L+QiXXwUoTQT0
	lyHKLGcln/unMyGQcwf3WRs2L8baOoyGPxiO8Fi/7QY863ItKpelgREWLF4Q56DY
	a2y4pMer6xyrT7r6p+TKDcBBG6Yyfj5B3/+xfPSX+CXgBLj+VrNHcsfk5JHYW6rG
	0bQA4qxj155NOjhDwrUTJwVwUNCzpyzqoR4s2q1rTWv5/UL0JWpMaFZnnCOodCbY
	8Sbji9o/STMdR9CM3wM6C16DPPrgryVadXWag3uF19gcNf8KURm4R2fLwomWVN46
	8XbEMtYYzl9uMe1NEUhr/iq9Bha0/5C7U3N1Xo83+s6ZJQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 468qv9kgpf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 06:46:40 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4768f9fea35so150891321cf.2
        for <patches@lists.linux.dev>; Mon, 28 Apr 2025 23:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745909200; x=1746514000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZu3TV8trj7jEXy9C3oxl4Sy0FYWykPDbiLWiHrWJao=;
        b=A46ga0dVkfwmQwSaw/FCX2wUrfrrfjkqpJKKN4Oki7lIYZsJFK6tOHpzvUs2Kc1g5q
         +SobYcPp5hx5rpLvwIEZyRv17CUG3UiNqHWUskcemN3vP9F3zlX7iLX8Kqzf+DNentH9
         PtaJD5h/nS5PaDkWajuAZC7oFQ5vDpMoRB8eoBdymfx1102jvln7XyLaU0kmEP4LdbcB
         c2jMdq3aSiUlGF9Mnq2mtSttGEeVl0Rplwc4Gh3edNmignj2lQNasQQdpw/bVwsx1nUK
         K1fQ/fA4HrYv00reSl/N2ONZA4RaagIfbI22s7i8iv8e0DSMLbDW71ioATCTOFuQasF+
         6ryQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHUnxOhTZRFX/UqSoYGbtGhTAuovC/PMTE95GG25bv1fosf2RPMdApK+4nGxEH6xLMq13VJ7oq@lists.linux.dev
X-Gm-Message-State: AOJu0Yyi/KyXyC9DMCX0qGvsRg9u99XabCSJcTF2RcmuMtNZKxtxVewd
	8b8y1s8vgQ1WDy+eXCW+5H9gljIJAkf/S5zEeVKc8rmW2+5LfbwVRVERMDxTvNntzU2gvRjBKfz
	pysdZrc+WVUMzJZcR43YLlFrmYPI+MkPP/TaHiZ42YHEh9DnVVHJ3FQU0
X-Gm-Gg: ASbGncsOw5uZE+eu1+fUqlaYtlqxQuNA55Pq8tfy0/m6N6rZfCg6pxY8Ddqais9x6Vq
	KTtvxvelizzVmj9i2nFT5htvp4/TqrUMURaWO/e6fizi9SO8FrVT7oT7ChNew9R+VYATKuh3REm
	exfTShGdHc2O8wcbW6aobSqUp+rOyO+qRUVnchLjkwqnMzu3ZXVAPKyaRarKCtO7TIshuEnlTK9
	1ml58y8aYi3FvqWFE4Xs1myg+6bc2h488dlDx5BQArH3bZjzvOZhGwVaSbFMLhrG1XxspttxaqO
	03H2S+c5MEVH1BJh9H9zh59/RGdKcqSF8VV3IXr+yWuBIM6S1nJ7qrWocJ1yohzCh3jLksU9OkA
	=
X-Received: by 2002:ac8:7f8e:0:b0:476:a967:b247 with SMTP id d75a77b69052e-48133562059mr203907701cf.47.1745909199811;
        Mon, 28 Apr 2025 23:46:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMg1rHdHs2/nbrDBu8fCMcRUEKSoFdhUgPQjOmgqhIt37Lk0kiYKjrtVvVlpe5Endpr+SpyQ==
X-Received: by 2002:ac8:7f8e:0:b0:476:a967:b247 with SMTP id d75a77b69052e-48133562059mr203907431cf.47.1745909199361;
        Mon, 28 Apr 2025 23:46:39 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-317d206b703sm22953181fa.114.2025.04.28.23.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 23:46:38 -0700 (PDT)
Date: Tue, 29 Apr 2025 09:46:36 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Conor Dooley <conor+dt@kernel.org>, Benson Leung <bleung@chromium.org>,
        chrome-platform@lists.linux.dev, Pin-yen Lin <treapking@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        =?utf-8?Q?=C5=81ukasz?= Bartosik <ukaszb@chromium.org>,
        Jameson Thies <jthies@google.com>,
        Andrei Kuchynski <akuchynski@chromium.org>
Subject: Re: [PATCH 1/7] platform/chrome: cros_ec_typec: No pending status
 means attention
Message-ID: <zjofw6fe5aznnqphtneccj426vqpbimm23kcpi3xts6p6zhftk@kjhrxvhanamm>
References: <20250416000208.3568635-1-swboyd@chromium.org>
 <20250416000208.3568635-2-swboyd@chromium.org>
 <6eeb7bca-6018-46de-a7db-7189d60c0942@oss.qualcomm.com>
 <CAE-0n53ypGBXAt3frrbfAsbJZEkxK4BCB0+3MWOFRxZ9E+6P9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n53ypGBXAt3frrbfAsbJZEkxK4BCB0+3MWOFRxZ9E+6P9Q@mail.gmail.com>
X-Authority-Analysis: v=2.4 cv=AO34vM+d c=1 sm=1 tr=0 ts=681075d0 cx=c_pps a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=EUspDBNiAAAA:8 a=yV4NexEFXbUgmP4BVSMA:9 a=CjuIK1q_8ugA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: 5TlMwG4lf2v-3EkWPoOcI6Kqr7sW7bs9
X-Proofpoint-ORIG-GUID: 5TlMwG4lf2v-3EkWPoOcI6Kqr7sW7bs9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDA1MCBTYWx0ZWRfX7BloLLUaCaN7 3f1beQUd3mgKcgO9rgR/Ji+zQofR3OdFUkJFouBdu6a/jpvlMqyRFTTBt+vhDaJRqKnaTuC9562 wT9/KPPN6WZZ33y4Rb3IcQbCNHFBcvYZfjNTwGXrmYNiI3UHcch2pIECOjEoeTtJuloapZplPLk
 /CyPkjX09BfEiVhK61RMw23LO9m54oS/4bzOvm5MaFhoJ6AHvd9tIBwysUb3fprqG/5VNQ0a4CN QfGeBkLRBO3GWOQHol7+r1CMmBkl0erfcsp6yOtK8DmBp8YbpARx+sxQCLKnny3ccGwfPePVFeb 8wx02b5vT6R0OBFsczx59xZwK3oUjhGa2C70hoQfunchbGqCh/3g5Huzjdm+ltOfKWm1tB6WSoX
 xmhwB3ldTxvtawXmBHQ/DjFgbv9QFA2InU/Tx7c2bg92nzLN0Oxdq+lm9BdrB/QCg7DNcI9n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_02,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1015 malwarescore=0 spamscore=0 suspectscore=0
 mlxlogscore=613 mlxscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504290050

On Mon, Apr 28, 2025 at 04:55:27PM -0700, Stephen Boyd wrote:
> Quoting Dmitry Baryshkov (2025-04-22 06:38:17)
> > On 16/04/2025 03:02, Stephen Boyd wrote:
> > > If we aren't expecting a status update when
> > > cros_typec_displayport_status_update() is called then we're handling an
> > > attention message, like HPD high/low or IRQ. Call
> > > typec_altmode_attention() in this case so that HPD signaling works in
> > > the DP altmode driver.
> >
> > Fixes?
> 
> I didn't put a fixes because it only matters to make the displayport
> altmode driver work with the typec port which isn't used so far on DT
> platforms. I view it as a new feature, not a fix for an existing
> feature, because we don't use the altmode driver.
> 
> It also seems like it was intentional on ACPI systems to only handle
> mode entry/exit and not HPD signaling per my reading of the mailing
> list.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

-- 
With best wishes
Dmitry
