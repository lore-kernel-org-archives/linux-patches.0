Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D063203BB
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590789; cv=none; b=o1Rjdi7n4dB1MuOXgGJsw/oDlQ4MYj4PhNjCEXUwxzYzUO5r0/FG9Tjror2MqemZADN1V5M8Y5aJQ1dvXLfpiPNMWWMvOAkp+UChuMjXVDjPgFSZb/lWjaXImhdEygVQD1kSKAw6dHIU/JkEX211EzEfMIArTETJLPW7wLp9/G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590789; c=relaxed/simple;
	bh=eoAJ8PIVfLPdXpqlJmqfYLCFBxtKmPWeSYk7sZEFfzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ifYEkbl48DFqHiUQrzk+JJc3K2ec1t9ydNlrogZ5qQykKcXBKCz9EVAd5ioevaU7VxLSIN90L/8YQJegv2VmIjDR7SRf5CsG7T4RWe2Hy5CPOB2FWLl8ZX5qm50kk6+BIbcOePv+byuQ5g+gj31OYnB+ko6c2VFnASXOSWC3ff8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P+Xx0OQQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P+Xx0OQQ"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59RG3Aac3165415
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 18:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jL0+3GyKZ0RiY1kiMYGppf4ShPWCj6NZj4rXfhbQAl0=; b=P+Xx0OQQqFwSa2Wj
	0tOQVA0rqna4SwFcVpQNe3xnzss9wfJKUYx6/yiNuGEKeZL00E3t2RgiUSKMc/b/
	LruHKBNosaGhJtl2OcUynDMCnYd6ap/8I+V0umI/kVi+C53mPKz/BAL1Y8t5vjc3
	DS/GvtdxWn8wOqeUh4X8eR6GttSlsZ8ynUZazcC4Jb2CcwVsbpPyh8kRqN/y68De
	h/HgeMBEKSJaDH5zHo/RzK7mn8Tpo5Dex9T4Wr9894Uef8EMbAtKqGKjYEqxdDQL
	lyLsdjrrXe0LhS2xucpXb/PMKBNrgaAzcZc9bZNZtFviB49hN0Ykpv1/Z7uaQ3Fp
	ScqRCw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4a2bwx0fc9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 18:46:25 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-783c3400b5dso2891911b3a.1
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 11:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761590785; x=1762195585;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jL0+3GyKZ0RiY1kiMYGppf4ShPWCj6NZj4rXfhbQAl0=;
        b=Jlj+mQ91lp0iJx8uxXYQbIfsvzY7Vbzt71LtH2LHPKDvbl8VDpcAi2JqqoFQgZiJPA
         5oU0X7XRrVExiqHdY1BYWHmTAwhEUHNKROsWN2yIEN6pBlD3pPOEPCjnR953FRKnKbv/
         FhFxQWK/Pd77hCJ0RvhYKANeWu69d9sKG26cP/eDq0VPZx23Nz13LevhlEYta/UoHP6E
         EdWx4SNadb/ZC6SssTQ7V7Z46aW8FqY+OXlRWNh9uPBkOoysEjZMo5zxTBhlEYZ5HEEb
         pVjr0CE73Lif2J2PF9QzKO3I2UGQiuYKdwj+LYT1w9XH2Nj3GhjIIXjidVYF9/Ilwg6z
         vg1g==
X-Gm-Message-State: AOJu0Yxxbp9vLyiwjZgq2RKhWt9SeVbm5fRpw+2KQHAKVmBucKLL+Cxr
	YniWtPt5HxP82po0/ThEWtcHb2Dv6QgJTIsAWB7Rg7qZzUw1hR55xOU5gZdX9rnKNqpLVOefsY9
	n+R+3135XatlI0UbDhlgJ5Phb1C3ZZ+GKEUoDnsqFQ4DgkbyXBd30Z9JZZTpy
X-Gm-Gg: ASbGnctpGp8q7Do7hxmbFWu9K4cTdaTOOeczs+7+Wduwoc9/q/xUw+dxUfzedAwdhc6
	ke5LlSNYPUoz9WTP49zXauPEH6QBxhlmPe1LOGATC6LRXa6JO1zLFYnb25B8gUD/k7VGVNAEtJN
	Ugecym3k0hNrGyCl31w0GVvpmWzSHgVqnaPHCm92dfVPiQSLbxyR5CHuZDpaZkR9o2SiaXQPkFR
	ZM8oXtyb3dstErWCLHtZvtOE7hCwpZBBZQ3efTBq4QznYNUplunYXgxMjgy/t6zrFKrEL7smbOG
	VDkBVACRyWWq2W7D7HufO24hgf9YDEsW5Ek+MMAjRlVBREhMd6VDSOJVYCJMI4x7ipP7OyjpoYr
	46BxMnLhIlg/F2ok8VTM0Uo4sOn1WMXnt4B5gyxNqvumqnUriGMMvcYhIP8BPoU25JAVefC8=
X-Received: by 2002:a05:6a00:cd1:b0:77f:3149:3723 with SMTP id d2e1a72fcca58-7a441c3e2c5mr1046565b3a.29.1761590784844;
        Mon, 27 Oct 2025 11:46:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnL4UEkxsoHI6jYPW9XVOkmRIeY5om9N6SMAt+fJXI4HO3hkw0+YgMzaItJQas5rvbsr30Yg==
X-Received: by 2002:a05:6a00:cd1:b0:77f:3149:3723 with SMTP id d2e1a72fcca58-7a441c3e2c5mr1046536b3a.29.1761590784360;
        Mon, 27 Oct 2025 11:46:24 -0700 (PDT)
Received: from [192.168.1.111] (c-73-202-227-126.hsd1.ca.comcast.net. [73.202.227.126])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41409c703sm8923296b3a.70.2025.10.27.11.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 11:46:23 -0700 (PDT)
Message-ID: <98121cfc-0d01-4ef4-b8e3-4506034f79a1@oss.qualcomm.com>
Date: Mon, 27 Oct 2025 11:46:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 055/224] wifi: ath10k: avoid unnecessary wait for
 service ready message
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Paul Menzel <pmenzel@molgen.mpg.de>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Sasha Levin <sashal@kernel.org>
References: <20251027183508.963233542@linuxfoundation.org>
 <20251027183510.473050789@linuxfoundation.org>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20251027183510.473050789@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE3MiBTYWx0ZWRfXyP8UkSmLhl1s
 y0WsCvwLS1OMAHFEpG0iSdRfg360TWscFcXXNnQcXx3CRPsTfvXwEOEdcg8Kpq74JHt38+imi6Y
 mgyfRPltpslhtWmkeczAYoImDUshwI+IIJyZ0JFURUyebo2LCxhV2YT36rQ0teT8lK6WgNhbw7E
 d5i6571YIDwhoMLBTZxljd/jSd1/2b9H9LOVjmNfn5XX1zQEYXwA2O2qorXQQCOaxjMW7KNQwFh
 ciai8XUmNoT13X5q3T7JsMk+q7YRboUNKiKzS/ZVZxZoP5j9xJmUMJvu1q1T4gum1zfdxk3XE/+
 BfSftYWpyrWYAFUD1/ZSglLnehnnTHOXsgTft7uVtxliEL0LO993J6bU27dEypYbumM9Z9DEcy/
 jjEz2rkALCvAsyz9Rw7Dhvg+kbB3xg==
X-Proofpoint-ORIG-GUID: cUiV2ZH48-wn-8q8QjOtF1QrChTVednY
X-Authority-Analysis: v=2.4 cv=U9WfzOru c=1 sm=1 tr=0 ts=68ffbe01 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=e70TP3dOR9hTogukJ0528Q==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=0plzKGMI_zvm0rPhr3MA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: cUiV2ZH48-wn-8q8QjOtF1QrChTVednY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510020000 definitions=main-2510270172

On 10/27/2025 11:33 AM, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.

Please do not propagate this. This had adverse effects on some platforms and a
revert is already in the pipeline:

https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=ath-current&id=2469bb6a6af944755a7d7daf66be90f3b8decbf9

The revert should hopefully land in v6.18-rc4.

/jeff

