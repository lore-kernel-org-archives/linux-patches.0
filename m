Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6DC28CF75
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750443251; cv=none; b=gc9PiaAiIOgv+onGEshFDhZH+FWMezKzAKw4mk1I93/FaKyyXfC4fH1hi6sFA5MqL2HDhjtcr0U8Ko8XYKGC+m/b8k9BPWDYTn1epycHewxUOk2TMAJKa1RNZw9SW05ei/PKKHHve2KlOVCxHg3sIG6YBAaT4WUKuSa9+yjWJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750443251; c=relaxed/simple;
	bh=wma8aBcQVPtFolGMnjfauIQiWhVZMbB2XEEP2UDVV9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFfUQejZFwRcJKE1GApxU1LkDFSLQVETyxwO/E69+k5ffEHXljA+SblsXyQn0h7tBV22DsfYQhLtpGvgi8KI4vSzxMBEqi9NdDWK2goXuxJqzf4/dPy+6H3D3gd9qEFnLMPR6R4wzgDsd6GaJhSET8nluTGcjJm1H+KJnkRfdqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VxP0bv8W; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VxP0bv8W"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55KFRRfl024226
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 18:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nO3sfnzlB67rNBuLuCNg6x8OnrGZzYrJhAxTg03f9r0=; b=VxP0bv8WbfY8U4LN
	fz3P3sNSRtv9aHUEX8uI5HVwpCbuTh2nh57emOwXMLWoqc3NtsQbiJVwXLHmyUuu
	Sp0abie7Q5dCp7+uBvKijNrod0gUZHqSlKtRskPQh1MvPAESaydqxXZHnOEZ1K4g
	GDlWzGI011dSdLeOUj52O14zj79MA0QDtRg+HjEk8LGx8c5pcqFG5CGwK0oBGu8y
	KPrUXZCB/79osM0o8OHQ7kxtPNO7BGRk2uVXDFJXF+l2lgJxsWIUb6i1B80deIyN
	StatHysBMFiY7KLKP/KuA5vUyf7UGJaEnoPrD5yn8+eK/syrV9560Gs0r9r5+qXL
	T2BsAQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47daa4rent-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 18:14:08 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c5bb68b386so580798385a.3
        for <patches@lists.linux.dev>; Fri, 20 Jun 2025 11:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750443248; x=1751048048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nO3sfnzlB67rNBuLuCNg6x8OnrGZzYrJhAxTg03f9r0=;
        b=fB5+G1CQ8k+gEaScbdPxHY3nIDBr4+aLyZ7wb5HRH/hDOHHL+QbvbH5FTcf+j8tgBo
         USnthotlqLcGFhWivXZtxKqEbscpLhYHmzZE17OcmQnt3DfXyJTB/nyQhXFKuEt+sklv
         MQT3kUrR5bmlWQeA7LYgjxxOhpT6AMsDFRuQ5CKJqA7cJBzHkPPMcAssvDbSYUeAPfAC
         74fS+xGQ9DpXTvpru021jaEI/P/fDffLIHgY0/nCyPzNC7P7kBhLbPSR0e/iKpD4JgWd
         IfmgnO6MfVJa3fmdEZomC0BbJEob71c6sG84DA3YAqL1MMNYHVAcAsyEYLUX4dFIF/ig
         VmJg==
X-Gm-Message-State: AOJu0YzIj/udk8MqTBBMwi61azMo2zYyYaWgVDcdaw+dvrZ2V5sRaOMl
	f6rspeMUKrXkVdKw93qjXXx465XlzUKnXs3cEmdBGzidj7cQn/PHA0vSvFHVBsMUO8vXCGWUKIZ
	V7QEcb+VBf5zMSdK8qlKvi1d8j3rjBEGpj6Eq1aYVTu6695SIkZivH09JOJ6N
X-Gm-Gg: ASbGncsrW/32yFpXdAa/AYT90glL3hLXl6FEdp9OHDJtXi2iadXVi3gZfHkx1e2J7IA
	uAvGZfodvQTIL6Tzwx3KY5bBoyvkqgphenGOu65/AByqOiBGkZWoM+dwxrkmAT5LmjCXCdsAuYr
	KL0PT8i6TCHLdVIrE1UE1C+Zlaycos14zjT8HPohE1ZsSc3ZGD4Q/ahGBAmOZ+zDjZnUqFK9wuv
	TF2z04pM3B+Izz/1iT2/HJwbSTbgTxMu9sg+jS6o9DTB+jk5J7BwrCGJ+uNnq7ZvcosvmZt2Ytu
	84WgXhbTi6RfjffW+qQOZyZz4oxZN+aVclz3aRjVVU86QYRJVT3Xofqpz88grezZggx1QPshICi
	B18BPm1dbNWr1XF25kJa0W/jIkTtNfcqTES4=
X-Received: by 2002:a05:620a:1b90:b0:7d3:8d16:cfb with SMTP id af79cd13be357-7d3f994652dmr464231985a.39.1750443247782;
        Fri, 20 Jun 2025 11:14:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE58pSYF6MxuiRzGS1LvzWtsB3m3BexOiTThz68ytr6Mc+HTEwb5RlSh9XRTP66yPct1Sc7bg==
X-Received: by 2002:a05:620a:1b90:b0:7d3:8d16:cfb with SMTP id af79cd13be357-7d3f994652dmr464229185a.39.1750443247411;
        Fri, 20 Jun 2025 11:14:07 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553e4144306sm363384e87.18.2025.06.20.11.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 11:14:06 -0700 (PDT)
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: dri-devel@lists.freedesktop.org, Randy Dunlap <rdunlap@infradead.org>
Cc: patches@lists.linux.dev, Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Rob Clark <robin.clark@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH] drm/msm/dp: add linux/io.h header to fix build errors
Date: Fri, 20 Jun 2025 21:13:55 +0300
Message-Id: <175044313807.2014621.18142017999140082135.b4-ty@oss.qualcomm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250617185611.2965223-1-rdunlap@infradead.org>
References: <20250617185611.2965223-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Fu3XmX06obdS9n3Yw6mtINc5iPfCr05q
X-Proofpoint-ORIG-GUID: Fu3XmX06obdS9n3Yw6mtINc5iPfCr05q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDEyNyBTYWx0ZWRfX/u/voFELrTiE
 x5/tFb1UrPnT/vXZcSypJCm6lzWWo6UGwqJ3Vemk9IEdhNnen3RDuVhXbbF33SYc9iSDSWUtk0b
 Ma/vmQW+9GIdGIDwhE9B9mBuHdqKKuHEtskviDcZWYSbFpuU1spLgrrEtkHXFKv36ptkYIWjvNK
 HEkVoQ8eEYrNmErRfoD43Uil+ZmHrHnG8zQjw24ROjCNdQYAglFazGFgi9p8ryQDKU3CB+AF48P
 6M4Cjo3fx8WR0H3vSwWWLVjSQAE2zGePQX9QjbHgU62EW8YdYvjQMlHBahIRDwCNRE54sL0rGuc
 vrshpT3mIo9FSyT89RyFe84ACbAsuss88DLbRDYg/4dR8FaGGxZ4STzwfQhCpiNHzi36Pj29eDq
 vZbXeOspQ+G8HhYsG1DoACFxR5dG6cPpvXfT3IeDyEha2UDm51eii1LfQRRX7FPaMO0zDdMm
X-Authority-Analysis: v=2.4 cv=KphN2XWN c=1 sm=1 tr=0 ts=6855a4f0 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6IFa9wvqVegA:10 a=e5mUnYsNAAAA:8 a=QBdSVzX5EUQIqSI3YyQA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=Vxmtnl_E_bksehYqCbjh:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_07,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=968 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506200127


On Tue, 17 Jun 2025 11:56:11 -0700, Randy Dunlap wrote:
> Add <linux/io.h> header to pull in readl/writel and friends.
> This eliminates the following build errors:
> 
> drivers/gpu/drm/msm/dp/dp_panel.c: In function 'msm_dp_read_link':
> drivers/gpu/drm/msm/dp/dp_panel.c:33:16: error: implicit declaration of function 'readl_relaxed' [-Wimplicit-function-declaration]
>    33 |         return readl_relaxed(panel->link_base + offset);
> drivers/gpu/drm/msm/dp/dp_panel.c: In function 'msm_dp_write_link':
> drivers/gpu/drm/msm/dp/dp_panel.c:43:9: error: implicit declaration of function 'writel' [-Wimplicit-function-declaration]
>    43 |         writel(data, panel->link_base + offset);
> 
> [...]

Applied, thanks!

[1/1] drm/msm/dp: add linux/io.h header to fix build errors
      https://gitlab.freedesktop.org/lumag/msm/-/commit/ee1c98ae63d1

Best regards,
-- 
With best wishes
Dmitry

