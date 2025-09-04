Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B86427F18F
	for <patches@lists.linux.dev>; Thu,  4 Sep 2025 20:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757017454; cv=none; b=fSNPu6oNW1xfgwrhHTbl6dAYILGgBnxmvNz9sVu1BNmpculKG22B2pO2O2VBL/4UmR0TJl3c1xihQ3laV3wL7K55Gt2EQi4C0RLUlvF5t2mSt62Zs4dXW+Ag15RO7ijmqP4Xk4WMnjfasy2R6BGrtnUC6p6F5Arg0tProIts4B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757017454; c=relaxed/simple;
	bh=0Z79+uzU9ubm+JTguJj556pChSKpqjy6iZCk/xKVJao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXH3Kr4lrcxGD3Q4j5Egbh4Hs+ZYTU5lC7EhWKMdcZZdVOog4J/s5TrNHx/FWglqllMCQ8Dmzezb/9xK046dMP90oX9OMz6JaKx8Q5oWP3zif+yG8tHTDCURR8tcSh6CH1E1Qhrx8VpSdt7LfmY6CWVRwaO3GmmTBADshs7DT+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BqHSy9Tw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BqHSy9Tw"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584I5GLB032238
	for <patches@lists.linux.dev>; Thu, 4 Sep 2025 20:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=eElUMenQajMKFKHmEfgJg4SM
	sc0hDo+dAtFtkPy6FKg=; b=BqHSy9TwmUNCS+2hyRbQjKWBBAcxa2ubVOWxnBWK
	7gZoHSE4hu1kNDYv8vSqmVAuE9uvfW8FN2phAzBrLQZwSijnaDeoEDsFPA2ZZvTd
	E5yj7RgFs90Px/bbyJCXRBPf1LIpYbjBLgubBoy894iE0FLkatBREyRMgDNijktO
	K5K3rGvwmrBe/ZlPHYn3A+L99jAb7enbznYqflBWukpo85QPYxwMvEWvCDs7SBWq
	5KbBHrNZOMeWZo7j96s600VmuUNlhSVecattxn4zCirDAUBjZ2hvNfXuj8aJ6Fcc
	OEgH7+GduPwKurE4A4lpx0QREynnMJkWiKrgQBht9ijeyg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48upnpgygm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 04 Sep 2025 20:24:11 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-7248ed9f932so13057456d6.3
        for <patches@lists.linux.dev>; Thu, 04 Sep 2025 13:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757017451; x=1757622251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eElUMenQajMKFKHmEfgJg4SMsc0hDo+dAtFtkPy6FKg=;
        b=SIukBpp3v3bpwZS8w183xJacZxqpWG3CpvK/lnnRi63cd7rvUxZ0kkItaidO/Hh/d/
         R2Yr3Q0df+0z/nn+7THMIFC238MRHft7lw/Lajl8fEI37rKmoSy47c29jCtAiamnf0GK
         ab94/Aro6TEvW9EE1BTf9woju3TYcSMuOD/BXIha77dwX7lxze9KDOWg9hVre1aJOqMU
         WFeVeOB8+oV4enHaKM3cjGBfI/Ic451vd5sL3ZqdkJjDiv2784HsdU/cuYVKdxtGgu6t
         KX+u6JfT0EVghXkwKoQb+Pah6h1vUrvQwPtT18Crf0NBz1dg7DS8YUNANUMYIr94uw+R
         v7Og==
X-Forwarded-Encrypted: i=1; AJvYcCU0BDUvgCb2AZG6zEWjtSW+ArX4MsxxuEY29pt4z3xf+mA+wQG3qpnqMnl2PffJvYowZGl0EM8g@lists.linux.dev
X-Gm-Message-State: AOJu0YxKZv6jDcQ7dNVgaPo9AHGOgdgc5ktBv4WVQtoqchUN8ZCbJmtt
	+vJzTcyFeEfnSi3TgnisLPvnne33o9rhKshkFvWUyoCHkaurborwTW/3Te/jEJvTBs9robd29TY
	qMaeXI9XpM+h2PVFTq4eGXi/jyhrq+dk5H5jQ4lOF9AbqXnq535aG7huNJmGQ
X-Gm-Gg: ASbGnct3QsxOm9vbuVR1cXGr1goAnY4I1XGaoYOAcwk9O1smDtJoPaftaDG1HTKQyPR
	w+Mi7OqkWap1gdHlqS8EYTvS4rc9mcai9OyEj3gnsiHXDKUmGlibd9AcfCW+qgLJ1d9hh2pPj9R
	V3bxXda7x+6U/ep5yXkrpRGlzncYG4Pjsm01bOHP2mEN1hByiTaD9MaIkevcNwhYVJBAxlCkPKj
	/xk6ka8NS3J9QkJA0f5deZ+d/M9qyyS+nyvMwxLpxDmWFtzpKwNyjfrDFVeg7RHbE6u8cgkBv73
	3CxFwNkd4mpnbTZ0RJ4NcH/JA9QVooxPP6LIu70Dm26KCjov0VDDTNmpIQrTov8mYNG2lNGPlNV
	wreg+0GTVA/3m8dFIee60wgBlhnLOMI1dfQcWlMj5EFuFMUtXoY4Y
X-Received: by 2002:a05:6214:400c:b0:70d:fd01:992d with SMTP id 6a1803df08f44-70fac73d452mr234244856d6.16.1757017450911;
        Thu, 04 Sep 2025 13:24:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEOYSlodY7ZwXlWkX917XlXU/4KfFSD9zZ55jDeSqB3xRKphER8n42jI5hC2HlLwTZYFa5kw==
X-Received: by 2002:a05:6214:400c:b0:70d:fd01:992d with SMTP id 6a1803df08f44-70fac73d452mr234244476d6.16.1757017450284;
        Thu, 04 Sep 2025 13:24:10 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5608ad121acsm1370936e87.118.2025.09.04.13.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 13:24:09 -0700 (PDT)
Date: Thu, 4 Sep 2025 23:24:08 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Devarsh Thakkar <devarsht@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Aradhya Bhatia <aradhya.bhatia@linux.dev>,
        dri-devel@lists.freedesktop.org, patches@lists.linux.dev
Subject: Re: [PATCH] drm/bridge: cdns-dsi: Select VIDEOMODE_HELPERS
Message-ID: <pbtpeuu2t6iwlhyszf4utsjg5jgx7aawoisuitszbeww2xb5hn@revzgv5mfhgr>
References: <20250821-cdns-videohelpers-v1-1-853e021908cf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821-cdns-videohelpers-v1-1-853e021908cf@kernel.org>
X-Proofpoint-GUID: dtxvQpaKr6TeOl1pNaPiRHINrXTEtckg
X-Authority-Analysis: v=2.4 cv=Jt/xrN4C c=1 sm=1 tr=0 ts=68b9f56b cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=GyFj89KpxmL9ovfeiVUA:9
 a=CjuIK1q_8ugA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-ORIG-GUID: dtxvQpaKr6TeOl1pNaPiRHINrXTEtckg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAwMSBTYWx0ZWRfX5xYH7/v8ThoP
 PJlmsORREMf2ZpjjMqXwL42mYffSjCfn9s0pDPDoQdp7EBkCyjX9fcyfK5WqAI2K9ji7Tdb/ZtG
 shoXmaDsd8fc+fg8XLz8AyrbZoQ7mnyBmZYkPSKg1jlBJ8zHVabHAg9YwrFU97Q2FW0Ixc1CuQj
 CNj5jZl8YQ5DAHT8RDxcKNmimF/FjelcD/LcDNnLmhP5MhdMcFbjdPwkQoNma6hENFIcaMiRTit
 g+4BnzIqGh3rftL86naqR+XT348L+mPKmhnePEXgnxd1Cvjfv1tMBGtpFtylODDphdQkyQtwQ6p
 Rb6Ni36yKpvDarltCbEds/AGwhjUwW+1xRAO8tBh9P4YHJXrWEakvN1+Ib/KIiviKaByrtw1ds4
 JUS3P6pU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 clxscore=1011 bulkscore=0 impostorscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300001

On Thu, Aug 21, 2025 at 01:52:12PM -0700, Nathan Chancellor wrote:
> When no other driver selects CONFIG_VIDEOMODE_HELPERS but
> CONFIG_DRM_CDNS_DSI is enabled, there is a linker or modpost error:
> 
>   ERROR: modpost: "drm_display_mode_to_videomode" [drivers/gpu/drm/bridge/cadence/cdns-dsi.ko] undefined!
> 
> Select VIDEOMODE_HELPERS to ensure that this helper function is
> available to the driver.
> 
> Fixes: ce4bc5ca7c1d ("drm/bridge: cdns-dsi: Use video mode and clean up cdns_dsi_mode2cfg()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/bridge/cadence/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
