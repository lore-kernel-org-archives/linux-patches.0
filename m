Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384671DF748;
	Fri,  3 Jul 2026 13:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783084590; cv=none; b=e4CFbcl2jybfzMVdpPmiuQhUbQI61yQiiYOfraCgvz8bU6PHl7wyoG16jeqTPO9yjT1eh5t6qqtttoREtPjWPqAAyDv5P76pUFgRghRfxfYfb8n7BQTHLiPqu4d2493Yi9bay5vfhYt0g25kH4ZGnurMLwvrzeUH69xBvfO961w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783084590; c=relaxed/simple;
	bh=8mM0GBne9Ia/UoiXeaTjZ73jsUCsloQDBuSHy6LuEag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bH0BBRFRzjKlOP8Q3ckuZl022dorHRFdOVxaavk1H9D97dtR2d0jJKdPzmzp6WzJ+t26Dex8RZhDcM8RXX3uGY2cicuEAH6ndCczswmkmKIc76+igauIaIwjUSXfgRXCCvbHKSBvALUYsUml801yvG8o717UhPzXBghIOjepKEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4aNXIRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4aNXIRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146E01F000E9;
	Fri,  3 Jul 2026 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783084589;
	bh=bDbAaOtOt6pNm3+3iVgYUkzZwOLnLizjeFHc4qL4268=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4aNXIRwpWa1Zv9hp3p/4qhuMo0+vkIC8Qho9U+VNwhq8UqXlfVuw8Hlmp7T6H1mL
	 FdA1Aj45ioq8xM/9LELiz1UMKDlRJ2LRQLLc/iDl5dVIVpMN959RPwwFlb9RBUMpE7
	 XLg0yRIW0P8ip+4hMHILqK8ljqWD5Oe7xV0mGGBvC3hy8g9imePhwUhORt+zrO3uE4
	 olMMTzaw+9MerNVF3Yy6yXy+RqbGs9ZYZ4qe01rkiWVYBn6TYDk2NRrP2/p+5maMTP
	 u2fEYinf2S2xgm38FBarkuSPgDd6AlHtETj+LeCFiIKz+2CuOLILEJQ0bEc4Nh1ad8
	 WtBcjLJb97Xcg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH 6.1 095/129] LoongArch: Report dying CPU to RCU in stop_this_cpu()
Date: Fri,  3 Jul 2026 09:16:24 -0400
Message-ID: <202607030908.026132e831ea@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <329cd36.6ac7d.19f25f6d0e3.Coremail.chenhuacai@loongson.cn>
References: <20260702155112.163984240@linuxfoundation.org> <20260702155114.109325852@linuxfoundation.org> <329cd36.6ac7d.19f25f6d0e3.Coremail.chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> For 6.1 & 6.6 this should be "rcu_report_dead(smp_processor_id())". If
> you don't want to modify please just drop this patch, and I will send
> for them.

Dropped, thanks!

-- 
Thanks,
Sasha
