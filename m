Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B8329C5D
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591667; cv=none; b=lRz8XYUwbRXInUsBa8qNtH7DXRhIMQSxlhRn5EBuRrz639AOziPCI+RuEc0iJiD4YhCXE1wLJKyTigUUHvXQR4u+paPMG6mDkMu5BGUzXxyu/1qkUS+PoEXdRYqK9itxznKDYwdbF/CCMBr1RD9WMQy3/WGzLrJ0lfiaBpFrUCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591667; c=relaxed/simple;
	bh=Mz7YuFINXQdC8PQ/VfexV55itQAo7KBzkvth7iSvNrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U0l1EkAxDINeQk66h2q3+lYKMEQXuTaoxWNEp/fnrF+93/Q6Qg2t02HR6kXVHQ7epNAy+Lp9n11ywHD40QZ9dz5jqx/KVe4jis2XuRj/8FdlOZdUOxkKikxl/V0/QL0f0n8qh8xLIoc6QF94dWq+a9PdQVTcjdHTe8Z/u8KhzbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BjzegyG6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BjzegyG6"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59RCTtrx2752236
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 19:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KmMsFA2jU2VzFA+RPyDjMpvUmFS+NJmtomscpMRHH4Y=; b=BjzegyG6B4d99ikO
	FG0IQn7Rz/gN3Qp/83Wt79hAbI1OvCMzNFnmW0d14ZzgtzcVTQWoZ6SPg8UuFYbP
	1k7umAqOHxuF04tYXikaTsuV1p9ReW+cXQeAgmtKPdwUZqERmxgpyQdSZ0UIMk5P
	ABbB0DjA1XGQGCVb8enB79lQZ3UqkIcntZGIt8wNLQz8UvqI60cObZs0MUVCS1pW
	9w4xm/pFgO0YegFK0JnXCAnSZxSVdXbBXy0r3bY9zlrKVxg7eo12gH+wC2799nkq
	MwnjZXna1gDCtUwsBr1birZ2HtJq0lqERyxP8b9HneH7GxWqZXBKliNvcj4+ovWJ
	DmPRbw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4a28swhaaq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 19:01:04 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-290e4fade70so40906215ad.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 12:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761591663; x=1762196463;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KmMsFA2jU2VzFA+RPyDjMpvUmFS+NJmtomscpMRHH4Y=;
        b=IMPLzXUxmOxNyOUyvIQCPKltA8i3d22sGb5ofRrd5uOnnyc3a3A5kM0IY37t0zgxpy
         2okR6m/MGYI+6AX6qULFvjOPnWOuLHDd0cOngrkXhmcKDqPKthr1csenHgDkuRXfDKpR
         A3mrucNkYtqMj0o2em3WFdSDIim6Qj3zSYx77N4U++bhXAZ8odkIW5R6dRbMICbRX9jZ
         bovZpGG389YhS3nEbi0LnzxXj5A6/XCeDjx1QSg1mxhQ6C3eYzk0Wd0rd2AA/IDoJ2+8
         sRSW/f5OR5385W7ZvJfJEHF5IS2Jmk/4P0HsSLLjwL06FJwZVqnNz1mxinPuhdd0+0Bu
         ILNg==
X-Gm-Message-State: AOJu0Yzk2Qui3DMTRJmkKR1XOfOutXfkYiZ3h55eHs86Rb0M4Nin6pB3
	K+YbHKqLwOiOU5BrXWWxtoSjCvzS50gytf4LhkW7Kp+mpyLODeV4fXFIJrofB9YR5t+iQey1Tuy
	5Em8mm3B/O62aG3yLgM5GfnzSxn/3J9/Gb/2jN+j98+IvPO58tIB+kqvqWkyw
X-Gm-Gg: ASbGncti0W+6rxWL5vsAE7O1lnrPVyvp9bd2noo1gQADlxBaxIyNJC9O34GdLPYmOPk
	cjTER6l8SgKCxDUckBaw0/78/RaQjBjXPHg6ejIQJcYtoefsy97qJESxpduBQg9V0sJHrnd75Vj
	RSYGr9uNZ+T3MAEYjjMV0EXqizrgL0Ht2sZYE5u52ZTKYFZjqliXxgnLXIoZkyyxXiZtGSJcjMf
	u9sISIHoeBGlpa0E71cliKi1CSjODhcdXhjvSURXpA/bRpoHC7Ak5Pkt6H/hImfZqzubhA3Rq8I
	eSbgtsVEAobM03CPA8nRnVkOdBmOfTyqUAJJg2wt7NC+D/smeWMi1cUxdwr4YnzE9LEWKkCMFkP
	MG+qgOYB4QM22cFXV4TVYcfcyLiysfe45x1hatGGfsmTQfFLsX1WyVHNyrXG2LqTGq8S69r8=
X-Received: by 2002:a17:902:d482:b0:290:6b30:fb3 with SMTP id d9443c01a7336-294cb3b2ab2mr9467565ad.16.1761591663070;
        Mon, 27 Oct 2025 12:01:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHa0PkB75QxFvEfsC7xYqy7x0qo8EfT8w0TreDLE2SS3cxu+kF6KGO6YQnwKLzSUX3UTKUvDA==
X-Received: by 2002:a17:902:d482:b0:290:6b30:fb3 with SMTP id d9443c01a7336-294cb3b2ab2mr9466685ad.16.1761591662097;
        Mon, 27 Oct 2025 12:01:02 -0700 (PDT)
Received: from [192.168.1.111] (c-73-202-227-126.hsd1.ca.comcast.net. [73.202.227.126])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf3381sm89694065ad.16.2025.10.27.12.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 12:01:01 -0700 (PDT)
Message-ID: <7f021277-2925-4fd1-a191-c7034d526e37@oss.qualcomm.com>
Date: Mon, 27 Oct 2025 12:01:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 067/332] wifi: ath10k: avoid unnecessary wait for
 service ready message
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Paul Menzel <pmenzel@molgen.mpg.de>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Sasha Levin <sashal@kernel.org>
References: <20251027183524.611456697@linuxfoundation.org>
 <20251027183526.385879492@linuxfoundation.org>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20251027183526.385879492@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: MujyKLzXZOb4pvmJDUbauSINkR4g9ZPx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE3NCBTYWx0ZWRfXxZySbBvZMvrV
 C6BV0jtZjc+r8fEDqHjNBEcWBxaJOowfwtBhGu//gp1SjJdkfsHY7s7kKXpJY43dawJxmciVdgC
 WXa05BUeQAFFbal32EdJLZBqStbF5qCTU44+nh9ICk5Kg6KwFRdF0dDn+7PvvR2k6qxdXJQ9SXc
 fXAamvGYWSMH/rSaCcWwKqk/cL0NOTY+qewXfldg6E6mc0/exseg0uHajTgNtB/mbGS6R4fXPap
 n7pBHX+ZwxkGSDWCVw+dHt9pmqAPdq+0xKIFJGKdn7tr4yFYw01HeyLpZIHWrZgqtgdtHkStwnk
 Z5svJ1j1wOsM8ueNLzoGdixYFcDZWJNEP4JF6PBY9oBsq9F8ie3jFs87JTEfB+35zqgMLiK1n1t
 FdSBtXm66lpMg/bYS9rLzEbr3MF13g==
X-Proofpoint-GUID: MujyKLzXZOb4pvmJDUbauSINkR4g9ZPx
X-Authority-Analysis: v=2.4 cv=fL40HJae c=1 sm=1 tr=0 ts=68ffc170 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=e70TP3dOR9hTogukJ0528Q==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=faGc5X2Oct-Rl-nflR4A:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510020000 definitions=main-2510270174

On 10/27/2025 11:32 AM, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.

Same comments as 5.4
Please do not propagate this. This had adverse effects on some platforms and a
revert is already in the pipeline:

https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=ath-current&id=2469bb6a6af944755a7d7daf66be90f3b8decbf9

The revert should hopefully land in v6.18-rc4.

/jeff

