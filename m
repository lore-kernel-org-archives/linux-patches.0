Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD0F53AB
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 16:09:02 +0000 (UTC)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FAOp9u015461;
	Wed, 15 Mar 2023 15:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=dja0bOkHmjy6ISthkFoE2r5UoTDyEgxRm/h8UPjEOjk=;
 b=E6MdsavxW84QXfZqJFourJr8d6HAVEpzL2pj500oKhpaDAnobvtGf8lb3ItrO3o3lerp
 rG5HSU2kK8p9UPzSiGYDESUtREuYe2DqW7BcRmN8hdXujvyl/eEvUxBN14pUZwn98XU3
 erfTZfiHKzNyF14vlXjIWJREU33C4UI3hFA6VotWSMNCM5nahSGf5mOCw3kZGvRjAmhY
 tI+zKVdtrO351lqhFZO7rQ/C/glreUMmBJuOAIUS8maTecx1mgl86uakEXtLmVDYcpVR
 9EIXerZ/1x7WUe0l9xLo0QOieGY7o4tJI2FSlhgJIdMrLpJXbY5n6dV4j3RYBDvRtAn6 Uw== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3pb2cr24j8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Mar 2023 15:51:23 +0000
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
	by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 32FFpM9q000768
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Mar 2023 15:51:22 GMT
Received: from [10.216.36.238] (10.80.80.8) by nasanex01c.na.qualcomm.com
 (10.45.79.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 15 Mar
 2023 08:51:19 -0700
Message-ID: <72de48c7-014d-80ac-51e9-ba22450f1d5b@quicinc.com>
Date: Wed, 15 Mar 2023 21:21:15 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] ring-buffer: remove obsolete comment for
 free_buffer_page()
Content-Language: en-US
To: Vlastimil Babka <vbabka@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@elte.hu>
CC: <linux-trace-kernel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <patches@lists.linux.dev>, Mike Rapoport <mike.rapoport@gmail.com>
References: <20230315142446.27040-1-vbabka@suse.cz>
From: Mukesh Ojha <quic_mojha@quicinc.com>
In-Reply-To: <20230315142446.27040-1-vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: dtx2zlEom7nRVxVvua37HfoQFfuJhBBq
X-Proofpoint-GUID: dtx2zlEom7nRVxVvua37HfoQFfuJhBBq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1011 lowpriorityscore=0
 spamscore=0 impostorscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150133



On 3/15/2023 7:54 PM, Vlastimil Babka wrote:
> The comment refers to mm/slob.o which is being removed. It comes from


> commit ed56829cb319 ("ring_buffer: reset buffer page when freeing") and
> according to Steven the borrowed code was a page mapcount and mapping
> reset, which was later removed by commit e4c2ce82ca27 ("ring_buffer:
> allocate buffer page pointer"). Thus the comment is not accurate anyway,
> remove it.
> 
> Reported-by: Mike Rapoport <mike.rapoport@gmail.com>
> Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>   kernel/trace/ring_buffer.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index af50d931b020..c6f47b6cfd5f 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -354,10 +354,6 @@ static void rb_init_page(struct buffer_data_page *bpage)
>   	local_set(&bpage->commit, 0);
>   }
>   
> -/*
> - * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
> - * this issue out.
> - */

Thanks for the clean up.

Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

-- Mukesh

>   static void free_buffer_page(struct buffer_page *bpage)
>   {
>   	free_page((unsigned long)bpage->page);
