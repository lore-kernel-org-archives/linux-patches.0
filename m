Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7137EACF
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 11:11:22 +0000 (UTC)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37HB6xc7019956;
	Thu, 17 Aug 2023 11:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=bh8hKNOCunj0DLdC3UT5xxQR2j12wuA594/Ukqt1VGs=;
 b=qMpbIHCC/rTJNgAk3atsNYk63+5p4oTqn6UAjLI+KkELEigs/SqG7mW7+/oDDlO1QUo5
 GQbv58+tApbbXmB1xcjoSgeLUOTdTqNUJo5g2uNEk0Q5ctlsGLY6uKu8PfBqGtbWBQIY
 guaRTK5EL+5SLJMt5KlRC6lzF97HzPGb5bHttKCSKqfA7e4eDqoCSg1hiikCARfoq+CZ
 7luxW+mcTPhIu87IwGgknTbaHcSmgxyyyPcyWX9e6J8CH08+188uNzNBiOr85e++SAwi
 3dV9JO5M3p+PE/ba2Yc5YUR0kJXnq95k1B+dnr7s2FPtQU2QsQeRQLQIRseE9Sk5xF2V fA== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3shja306dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Aug 2023 11:11:05 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37H9DeQZ007832;
	Thu, 17 Aug 2023 11:11:04 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3senwkndqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Aug 2023 11:11:04 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37HBB32L64094470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Aug 2023 11:11:03 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 547ED5805A;
	Thu, 17 Aug 2023 11:11:03 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E916E58056;
	Thu, 17 Aug 2023 11:11:02 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.61.190.112])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 17 Aug 2023 11:11:02 +0000 (GMT)
Message-ID: <c785dca7d2c1c732fd47047e70396f11b7a3d2d3.camel@linux.ibm.com>
Subject: Re: [PATCH 6.1 063/591] evm: Complete description of
 evm_inode_setattr()
From: Mimi Zohar <zohar@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Roberto Sassu <roberto.sassu@huawei.com>,
        Stefan Berger <stefanb@linux.ibm.com>, Sasha Levin <sashal@kernel.org>
Date: Thu, 17 Aug 2023 07:11:02 -0400
In-Reply-To: <20230716194925.509794730@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
	 <20230716194925.509794730@linuxfoundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-22.el8) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _IxyUO4cvT41ofwkpqJmvGNZnjNsdq8u
X-Proofpoint-ORIG-GUID: _IxyUO4cvT41ofwkpqJmvGNZnjNsdq8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-17_03,2023-08-17_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2308170100

Hi Greg,

To clarify the kernel test robot report:

[stable:linux-6.1.y 7217/8698] security/integrity/evm/evm_main.c:788:
warning: Excess function parameter 'idmap' description in
'evm_inode_setattr'

Commit b1de86d4248b added two missing kernel-doc function arguments. 
Both changes should be backported to 6.3, but then only "* @attr: iattr
structure containing the new file attributes" should be backported.

thanks,

Mimi


On Sun, 2023-07-16 at 21:43 +0200, Greg Kroah-Hartman wrote:
> From: Roberto Sassu <roberto.sassu@huawei.com>
> 
> [ Upstream commit b1de86d4248b273cb12c4cd7d20c08d459519f7d ]
> 
> Add the description for missing parameters of evm_inode_setattr() to
> avoid the warning arising with W=n compile option.
> 
> Fixes: 817b54aa45db ("evm: add evm_inode_setattr to prevent updating an invalid security.evm") # v3.2+
> Fixes: c1632a0f1120 ("fs: port ->setattr() to pass mnt_idmap") # v6.3+
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  security/integrity/evm/evm_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
> index 23d484e05e6f2..f1a26d50c1d58 100644
> --- a/security/integrity/evm/evm_main.c
> +++ b/security/integrity/evm/evm_main.c
> @@ -776,7 +776,9 @@ static int evm_attr_change(struct user_namespace *mnt_userns,
>  
>  /**
>   * evm_inode_setattr - prevent updating an invalid EVM extended attribute
> + * @idmap: idmap of the mount
>   * @dentry: pointer to the affected dentry
> + * @attr: iattr structure containing the new file attributes
>   *
>   * Permit update of file attributes when files have a valid EVM signature,
>   * except in the case of them having an immutable portable signature.


