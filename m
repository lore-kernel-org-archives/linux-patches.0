Received: from chinatelecom.cn (smtpnm6-08.21cn.com [182.42.159.130])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF3C44C9E
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 12:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=182.42.159.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719318640; cv=none; b=lalIMpDweNYAivgQzhYxXlB5ODmFs0WiKXtn9vr1CnjEOtCK6zFetaVDQOZ4PTDdncjPyD5kYhqMv2ZU8TCFAHJzBbvYd63/NEv76l2W3k47nXZxpZppBnm5Evzhx97/KVRHOFvIqd9EwjqixNv6D2jKvzyotfYj2DLE2t7jyBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719318640; c=relaxed/simple;
	bh=uB/uxdTqzATPTN8MOSeTrn4h6ketdBI4xYm8xT/dbhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QOf2J69Y3qzmIbk2PO1uMAGw0sla0pAoKNB+V5X/F38JF2ZmVM+qHHw9lnU/pXz/6JLZ/KH3IWtpycrUavF08mwfiUF/HOnjl53ApshwOIr6t0mc1gtJTKIENFoDHyU20Qt7T/2iHOmC8tcsYBoG0MaUXpPrEzhkBjKVc1Tsmg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn; spf=pass smtp.mailfrom=chinatelecom.cn; arc=none smtp.client-ip=182.42.159.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chinatelecom.cn
HMM_SOURCE_IP:192.168.139.44:0.633189758
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-27.148.194.72 (unknown [192.168.139.44])
	by chinatelecom.cn (HERMES) with SMTP id 655229063224;
	Tue, 25 Jun 2024 20:20:28 +0800 (CST)
X-189-SAVE-TO-SEND: wujianguo@chinatelecom.cn
Received: from  ([27.148.194.72])
	by gateway-ssl-dep-67bdc54df-cz88j with ESMTP id 6b4f06515cf14918b06bb6bc4419f65d for gregkh@linuxfoundation.org;
	Tue, 25 Jun 2024 20:20:33 CST
X-Transaction-ID: 6b4f06515cf14918b06bb6bc4419f65d
X-Real-From: wujianguo@chinatelecom.cn
X-Receive-IP: 27.148.194.72
X-MEDUSA-Status: 0
Sender: wujianguo@chinatelecom.cn
Message-ID: <563b0d0b-1f2d-4413-b3dc-ebd6d28851d1@chinatelecom.cn>
Date: Tue, 25 Jun 2024 20:20:28 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Ctyun AOneMail
Subject: Re: [PATCH 6.6 100/192] netfilter: move the sysctl nf_hooks_lwtunnel
 into the netfilter core
To: =?UTF-8?B?44CQ5aSW6YOo6LSm5Y+344CRIEdyZWcgS3JvYWgtSGFydG1hbg==?=
 <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Pablo Neira Ayuso <pablo@netfilter.org>, Sasha Levin <sashal@kernel.org>
References: <20240625085537.150087723@linuxfoundation.org>
 <2935400.2255.1719311647175.JavaMail.root@jt-retransmission-dep-5ccd6997dd-985ss>
 <740d9249-534a-477c-9740-1e4c3a099d51@chinatelecom.cn>
 <2024062537-entering-reprocess-3322@gregkh>
From: wujianguo <wujianguo@chinatelecom.cn>
In-Reply-To: <2024062537-entering-reprocess-3322@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2024/6/25 20:01,  Greg Kroah-Hartman 写道:
> On Tue, Jun 25, 2024 at 06:46:14PM +0800, wujianguo wrote:
>> Hi Greg,
>>
>>
>> This commit causes a compilation error when CONFIG_SYSFS is not enabled in
>> config
>>
>> I have sent a fix patch: https://lkml.org/lkml/2024/6/21/123
> Please use lore.kernel.org for links.

https://lore.kernel.org/lkml/24ac3144-c6bc-4fd9-b592-d1a88505e65a@163.com/

>
> Is this in Linus's tree yet?

Not yet.

>
> thanks,
>
> greg k-h
>
