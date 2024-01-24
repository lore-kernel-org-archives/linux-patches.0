Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D06A004;
	Wed, 24 Jan 2024 19:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123834; cv=none; b=aYmzp7wt6GN7NJ9P4fYyR9RZfQLMr6CxgxKwSk98pB9/l83rg3yetCXpqmz1gK80o9qjugJosSd6M43/SWDsdfsBaT9d+bLmmKUfDLXEcMEx1AU6PcUuIUa/FScnJno0wf+LDMYofTYfVwsSmFTEx+4jH0BYT54GViJSQq201cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123834; c=relaxed/simple;
	bh=bg7wUFqsk+k5WbHc1jDP2DkdrtUqr4EBfv8qvjFurWw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=NPzCGX94di4uJZiT3l8ysZucD5fqRAwmUFV2G8dLi2i6XyKYU4+ipPjxPNOHE3cyA3VqD3la8pr42d8JxstimcxFR/oyZuCGuA5vAfoi3N3XPtAJND154lQz0ZgVDqjukhqoJCriF97S5QmZWc05Q7hpx2ZJp5m2YvqdUKMiik0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CvwkQ2mf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CvwkQ2mf"
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40OIiCmt014502;
	Wed, 24 Jan 2024 19:17:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=COQryiS/sEg0OSdfRKOL8KXB0EJx3OXUhJRJvyUgqOw=;
 b=CvwkQ2mfd/T9gu3gPPT3Rt1HONZu4WYqWpgy4Dzdnkx7X3q/zKQ6OwUQvQY+/1cdFFN2
 ns0f6FjhuH5hHW5hbXNUOcOAyp4xHFqH2Xu+DFaR4XPHfP1EP3WQo2/NNnpdEtu1+zbM
 07uR8KJzxe5zgmeNUMQs7tuD1niDcNOYMS8WyoCR1RlUNhqTfEkCY+Hja/zsAGqJWxdE
 TGvNz8KAmtC3RclW7SNABhplfFesTLunhztUiL8W+nUqCMjAqI/SKbGJYkyvRWURzQYJ
 07VrGWP4Q4lHjD5uHXOrIAaeIBsLzLRSk568IO+V3sb6qUU/oWZPu1IYDcc9yS0ihVkE yQ== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vu7uchkw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jan 2024 19:17:06 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40OHMN19022438;
	Wed, 24 Jan 2024 19:17:05 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vrt0m7p43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jan 2024 19:17:05 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40OJH4BK4850556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 19:17:04 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C5425805F;
	Wed, 24 Jan 2024 19:17:04 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 589245805A;
	Wed, 24 Jan 2024 19:17:03 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.watson.ibm.com (unknown [9.31.99.90])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Jan 2024 19:17:03 +0000 (GMT)
Message-ID: <53ff60d7a3691a8a2d3e15cdf9d5dd8bdec6a8e0.camel@linux.ibm.com>
Subject: Re: [PATCH 6.7 026/641] KEYS: encrypted: Add check for strsep
From: Mimi Zohar <zohar@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Chen Ni <nichen@iscas.ac.cn>,
        Sasha Levin
	 <sashal@kernel.org>
Date: Wed, 24 Jan 2024 14:17:02 -0500
In-Reply-To: <20240122235818.914706597@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
	 <20240122235818.914706597@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-22.el8) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dNylzflsCX3HJNx3y7jvajCAXYKMqecm
X-Proofpoint-ORIG-GUID: dNylzflsCX3HJNx3y7jvajCAXYKMqecm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-24_08,2024-01-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1011 priorityscore=1501 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401240139

Hi Greg,

On Mon, 2024-01-22 at 15:48 -0800, Greg Kroah-Hartman wrote:
> 6.7-stable review patch.  If anyone has any objections, please let me know.

The upstream patch needs to be reverted.  Please don't backport it.

Thanks,

Mimi

> 
> ------------------
> 
> From: Chen Ni <nichen@iscas.ac.cn>
> 
> [ Upstream commit b4af096b5df5dd131ab796c79cedc7069d8f4882 ]
> 
> Add check for strsep() in order to transfer the error.
> 
> Fixes: cd3bc044af48 ("KEYS: encrypted: Instantiate key with user-provided decrypted data")
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  security/keys/encrypted-keys/encrypted.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
> index 8af2136069d2..76f55dd13cb8 100644
> --- a/security/keys/encrypted-keys/encrypted.c
> +++ b/security/keys/encrypted-keys/encrypted.c
> @@ -237,6 +237,10 @@ static int datablob_parse(char *datablob, const char **format,
>  			break;
>  		}
>  		*decrypted_data = strsep(&datablob, " \t");
> +		if (!*decrypted_data) {
> +			pr_info("encrypted_key: decrypted_data is missing\n");
> +			break;
> +		}
>  		ret = 0;
>  		break;
>  	case Opt_load:

