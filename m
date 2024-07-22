Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBB51CABF
	for <patches@lists.linux.dev>; Mon, 22 Jul 2024 04:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721624140; cv=none; b=CIESLReYX8K42cMyRtH+0UqsVN3aB5znkKyTmSqpJgxzRM2vb9Ak3V8AqaBx2C0PnAl7dzBqNO9qte6dRx2OGdzJeK66n42keLV7sA4boo6uSegfhyIrfTxKhO72Hpi6Nq/Qdsa3dxFcu8k3EdjEIVqLIMycntRmgZu9Yfht/Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721624140; c=relaxed/simple;
	bh=0up8aCtWNsxAC4uhGA5lK93k/Cdyl3JxBMFq0lL7/1o=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Grwyrzfe5NYwcnZr/62z02gNxwRM8jI9Fq4NJa/jW4N8yRGYQ362Lz+j9O561tqhP6WE4a+WeFg01vVqseaMyUprIBnAZlM8XpZL4EF54799rpudDoAW+qIt89POdUcPLHdLhgpNXuJ/IW0rjEfwYQ72xjy2415e1GcQ2TCXS64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Ztf37u1G; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Ztf37u1G"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46LNuPUg005325;
	Mon, 22 Jul 2024 04:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=3nsbi7sFx1ra6m9fFn76vA3G
	Jnm1RAxiBUkonXtuWyQ=; b=Ztf37u1G+BFvYeot7+ZPTwDE2Uw1R+Oliyu/BQof
	sv7XMJJopnfA0iNDPNK7fw4+JDFfIgVdZiOVzXkxOfC4pcRqzyOAAwMacgipfjGj
	S6eQSiiAATsnJ+j6oQHtS2/7wy5Gcg/aVyXAmdllUcwXXqoqoa/fs88lZNUEMIC1
	3cUYaHiFlnlxWKWpJL3sYvOKSyUhVYPfqiHZEkgpuN5XmF4vGbXj2FbAJFGBZZBK
	uHu/HLOqVz1ih28aHksdCVqqJC62VaW9VBeSytJAA5Mfam9a3d7EwUN46fUsIiqk
	skYRlzIi+5YZVvkXLCwm6emKT6AiDKbLZSDX/tiMA+KoOg==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40g5aujm26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jul 2024 04:55:33 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46M4tVsi025737
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jul 2024 04:55:31 GMT
Received: from hu-pkondeti-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Sun, 21 Jul 2024 21:55:29 -0700
Date: Mon, 22 Jul 2024 10:25:26 +0530
From: Pavan Kondeti <quic_pkondeti@quicinc.com>
To: Stephen Boyd <swboyd@chromium.org>
CC: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH RESEND 1/2] soc: qcom: cmd-db: Mark device as having no
 PM support
Message-ID: <1cc3b5cb-a938-4768-a1eb-020e2d2f6ab8@quicinc.com>
References: <20221015004934.3930651-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221015004934.3930651-1-swboyd@chromium.org>
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: eUiWWsH8vtpaN96ZP57UuiMYzZlt90U3
X-Proofpoint-GUID: eUiWWsH8vtpaN96ZP57UuiMYzZlt90U3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_01,2024-07-18_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 clxscore=1011 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407220035

Hi Stephen,
On Fri, Oct 14, 2022 at 05:49:33PM -0700, Stephen Boyd wrote:
> This driver purely exposes information from memory to the kernel. Let's
> mark it as not having any device PM functionality, so that during
> suspend we skip even trying to call a suspend function on this device.
> This clears up suspend logs more than anything else, but it also shaves
> a few cycles off suspend.
> 
> Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> Resend to fix Bjorn's email.
> 
>  drivers/soc/qcom/cmd-db.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/soc/qcom/cmd-db.c b/drivers/soc/qcom/cmd-db.c
> index 629a7188b576..33856abd560c 100644
> --- a/drivers/soc/qcom/cmd-db.c
> +++ b/drivers/soc/qcom/cmd-db.c
> @@ -338,6 +338,8 @@ static int cmd_db_dev_probe(struct platform_device *pdev)
>  
>  	debugfs_create_file("cmd-db", 0400, NULL, NULL, &cmd_db_debugfs_ops);
>  
> +	device_set_pm_not_required(&pdev->dev);
> +
>  	return 0;
>  }
>  
> 

Sorry for asking this question here, thought it would be easy for you to
get the context.

I was recently reading this driver and learned about
device_set_pm_not_required() API. However, it is not clear how this is
working in practice? 

The driver is calling device_set_pm_not_required() in probe(), however
all the checks for device_pm_not_required() happen before probe() is
called. For ex: dpm_sysfs_add() and device_pm_add() both happens before
probe(). I was expecting not to see
/sys/bus/platform/devices/XXXXXX.aop-cmd-db/power directory but it is
still present.

Also, I believe once driver set this flag, the device clean up might not
remove sysfs entries as we have device_pm_not_required() checks active
by that time.

Would it make sense to add code after probe() and take some action if
device_pm_not_required() returns true?

Thanks,
Pavan
