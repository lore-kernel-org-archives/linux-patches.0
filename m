Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0D513AA2C
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 11:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006974; cv=none; b=WfxkYpNmn8xWDYIhpDr5XhustoVSgocaILL0zOIjMVFZgmluit+0fvUigpieNtZBfUnVy3x+NOTx4SQp/DZ/OQAW1yLgYOsAOdSg/TAC1HnKUvhHSrSq2bicA7GUyP9LagwMID1w/zSp/KHEYSGuqThgFaZRzEE/mZ0VwewZDmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006974; c=relaxed/simple;
	bh=K7qNNKCemwJNnX+1BcIXpnr6N/yn50dUXjm/HbTkLYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FiZpnN/whcYVxhAvnWof0wtPyjei8OD5DQrIJRvQ4NTN4nwtvd5NWm8W8Yx0Os5RsDUAgh6KezwwjLQ+9NXuHzvz9ejHbWh3FgjIJSG0LeQKS0RxJf9GkjvT12axQyxqWFq82l/8J+vYGIiPOq46aeaG8u9XCA5wJzbKmrGmUkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BqHOgmkE; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BqHOgmkE"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f480624d10so38871495ad.1
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 04:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720006973; x=1720611773; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ge1wWoFHDAtDCXZQGNb/dsW5tPLZbTcFYOX+qhqBchw=;
        b=BqHOgmkEA4stykKTFkJ0fr3L0iAyBbonFQCz77yPZWmmooQ2dlDQQFOHeaGFznGV0a
         8xs0CtCkOwTTjnVZPkj806N1Xzgjp7DcHF5+w1mas37+pf8Ydbk9uIOxw9MqnuXE7sDn
         e1zkTCRqXxG3JZ7IQTpXArHguwkwKjUSyzFNELqISLlAvPExC+yYj8qsNVXNb3coxXLt
         BAX3MDGNjieL+qdpgR2CpI0yvLxZEDTXybVbDrbSg269j9mVRjsOqFQIQRwXa8S4IkXl
         V8FmyliTNve9hBV5VVp4oEDaIi5EwYIaGb80OJCby7h56P1p6pT8FBZwI9K/obZ7RyQO
         6TKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720006973; x=1720611773;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ge1wWoFHDAtDCXZQGNb/dsW5tPLZbTcFYOX+qhqBchw=;
        b=dMVo8pshe6e0PYAaSydb0BV+1u/qLXpTYI7m1TDtdA+dU0af8KNmObfGN1m/HrR6EB
         j0ZksyCN4zOrnZ+DDcnS9bxFYqhl6zBSm7vUKg5397hGjngZ76OQmJz6CIiJLU5RFeAV
         MiYPxNwYP062KhUB7oKCgRkOYPe/5F2UjM76ZYZ3F8P2oHm75ghMWTOc1/XWTtsx7zMj
         nN/oRpc3bRT1sKeao4THSZLDyxmrf1/CGfDD4Ebkcb2u8t0gQkJpw9GFA0KDQxkW8ro8
         bFjRNrAZ81N1beAgW2CZuW62Va3E+Ipl+KPe5eZrT9z2nMfNaILrXY9AIEPpZc4yoPZ6
         75uA==
X-Gm-Message-State: AOJu0YyUEx1uoaJJEL0RNSHfeT7gG8Pr8ol047YF6lCdSBqZeBcehiNH
	T0dCqBnBOBTWhZfLgFbA7BtaEgMLQqpwwFb65yqgiCNgezlLEl3A
X-Google-Smtp-Source: AGHT+IFbmGqpCrPp2DHnF9f4E0obqrsea7nIt1awnOigtyr4ECVltV3vSLfaUTJvNYIpmMopU63g7A==
X-Received: by 2002:a17:902:cf01:b0:1fa:fc13:8bbc with SMTP id d9443c01a7336-1fafc138ddcmr33072075ad.57.1720006972724;
        Wed, 03 Jul 2024 04:42:52 -0700 (PDT)
Received: from [10.150.96.32] ([14.34.86.36])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fad58e84d7sm88502545ad.74.2024.07.03.04.42.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 04:42:52 -0700 (PDT)
Message-ID: <65a38070-cccf-45a0-af10-fd482eab64be@gmail.com>
Date: Wed, 3 Jul 2024 20:42:48 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 228/290] tracing/net_sched: NULL pointer dereference
 in perf_trace_qdisc_reset()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, netdev@vger.kernel.org,
 Yeoreum Yun <yeoreum.yun@arm.com>, Paolo Abeni <pabeni@redhat.com>,
 Sasha Levin <sashal@kernel.org>
References: <20240703102904.170852981@linuxfoundation.org>
 <20240703102912.767573728@linuxfoundation.org>
Content-Language: en-US
From: Yunseong Kim <yskelg@gmail.com>
In-Reply-To: <20240703102912.767573728@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Greg,

On 7/3/24 7:40 오후, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yunseong Kim <yskelg@gmail.com>
> 
> [ Upstream commit bab4923132feb3e439ae45962979c5d9d5c7c1f1 ]
> 
> In the TRACE_EVENT(qdisc_reset) NULL dereference occurred from
> 
>  qdisc->dev_queue->dev <NULL> ->name
> 
> This situation simulated from bunch of veths and Bluetooth disconnection
> and reconnection.
> 
> During qdisc initialization, qdisc was being set to noop_queue.
> In veth_init_queue, the initial tx_num was reduced back to one,
> causing the qdisc reset to be called with noop, which led to the kernel
> panic.


> Fixes: 51270d573a8d ("tracing/net_sched: Fix tracepoints that save qdisc_dev() as a string")
> Link: https://lore.kernel.org/lkml/20240229143432.273b4871@gandalf.local.home/t/
> Cc: netdev@vger.kernel.org
> Tested-by: Yunseong Kim <yskelg@gmail.com>
> Signed-off-by: Yunseong Kim <yskelg@gmail.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Link: https://lore.kernel.org/r/20240624173320.24945-4-yskelg@gmail.com
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/trace/events/qdisc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
> index a50df41634c58..f661d3d7c410a 100644
> --- a/include/trace/events/qdisc.h
> +++ b/include/trace/events/qdisc.h
> @@ -53,7 +53,7 @@ TRACE_EVENT(qdisc_reset,
>  	TP_ARGS(q),
>  
>  	TP_STRUCT__entry(
> -		__string(	dev,		qdisc_dev(q)->name	)
> +		__string(	dev,		qdisc_dev(q) ? qdisc_dev(q)->name : "(null)"	)
>  		__string(	kind,		q->ops->id		)
>  		__field(	u32,		parent			)
>  		__field(	u32,		handle			)

Since that code changed in +v5.10.213, +v5.15.152, +v6.1.82 +v6.6.22
+v6.7.10, +v6.8, +6.9 and the stable is in an intermediate state.

commit 2c92ca849fcc ("tracing/treewide: Remove second parameter of
__assign_str()")
Link:
https://lore.kernel.org/linux-trace-kernel/20240516133454.681ba6a0@rorschach.local.home/


I had to fix some other part for the stable branch backporting.


So, I submit another patch. Please check out.
Link:
https://lore.kernel.org/stable/20240702180146.5126-2-yskelg@gmail.com/T/#u

---
 include/trace/events/qdisc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 1f4258308b96..061fd4960303 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -81,14 +81,14 @@ TRACE_EVENT(qdisc_reset,
 	TP_ARGS(q),

 	TP_STRUCT__entry(
-		__string(	dev,		qdisc_dev(q)->name	)
+		__string(	dev,		qdisc_dev(q) ? qdisc_dev(q)->name : "(null)"	)
 		__string(	kind,		q->ops->id		)
 		__field(	u32,		parent			)
 		__field(	u32,		handle			)
 	),

 	TP_fast_assign(
-		__assign_str(dev, qdisc_dev(q)->name);
+		__assign_str(dev, qdisc_dev(q) ? qdisc_dev(q)->name : "(null)");
 		__assign_str(kind, q->ops->id);
 		__entry->parent = q->parent;
 		__entry->handle = q->handle;
-- 
