Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487C72E8B82
	for <patches@lists.linux.dev>; Sat, 16 May 2026 18:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778955107; cv=none; b=U0I6TQ1951b+pV5rWmbk4e2uYzi49y/EI5u/WZxE3G3+CB4AdwMIRvbb1MS0CYi8J9bq8AJq8JVa/sLWSsFLNewAV2OuyFfcxuy8S9vY8XyuioorKiFl1vnMNxVqemzYA9a/WK3Ytc70K+8Qve5yF56i/k4xusXviytbg0QySi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778955107; c=relaxed/simple;
	bh=PhObpNEhS0ZiJzgQRmVbLLCNQRddfTvS00Q0wi3M2Kw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJcA+XNsUS7VivyB8u4fUYSRrvmCO6bDmxSbg1CXqvTkJ1+NcXg42d+LfYGhQPnOFv0lu1137sBESlH0Z1WGksrtkN0UcC+tOfSGjs2jpc5hB7yM4Lm7qsbpkqUu/jUU20KExW7rudIMBK3MlCNSnBT0Xo/wQJcU6Y4UjSSxF8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Z4GhUM8C; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Z4GhUM8C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778955069;
	bh=ay4X99PYrhcKWpqwz/XJNqfa7qJBbCHbzSE/HguNIXE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=Z4GhUM8Cjofu7VgqH3dHQcpZMnvCA/G5CW3HQ8i5Rs41ACieL+m+Tu2Vqbw6a0JdB
	 yIL6pWaA5onqMf1TIOCksXGCF96FIZ7eydWaq98KeyDnhZTQ+o2nsCq0gOOetjlQXX
	 Yv77Dpuz+RIdUwenGDV2o+LNVVinLo4cJsrIdmy0=
X-QQ-mid: zesmtpip4t1778955063t5144ce51
X-QQ-Originating-IP: MkhxMI1W+wXBJzRfC6W0i8u4/qdFp17V6H78mJ7pmGU=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 17 May 2026 02:11:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17173971163173199362
EX-QQ-RecipientCnt: 22
From: Wentao Guan <guanwentao@uniontech.com>
To: pschneider1968@googlemail.com
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
	guanwentao@uniontech.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
Date: Sun, 17 May 2026 02:09:41 +0800
Message-Id: <20260516180941.704379-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <a56911f8-9c02-464e-b61c-0d565a5dbd43@googlemail.com>
References: <a56911f8-9c02-464e-b61c-0d565a5dbd43@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: NI2OMpepcF+sV3lX933JOwPntFy2mdA3O8SACWKVfK30ZS1DkGxllG5y
	qnyEerXEB9LOvXIKi3oycOZ6uhk9OQ55kyLbNpRZezMFh75XahWzhboiuh0Fn+aymH87RAb
	JoFgAUBtoVwG1UrVrX/J1RpqJPyzMsGWNsUWm2i6A4Pz7dA7g94vJu7mNroKCaOCTC5bCaa
	o7pNeJCBa3L590uLgUQ7Ac4CGmErrk0ofESvhXIjjqSIk3r4TVfiiQ8e4lAQjXh2Y5rLM+f
	fh0JL8D7atpSO+EPMsK/owsqXCDrGU6HsbOD5XwKjHCdjuEXkgjBidsA5FhDjtAn7nlQvfQ
	UfDRh/uLAVLbYY8Kt7/UeVXHpaEUw7ubFp5k2RxjsQHuS3Yc4sj7QzDR/0o/+eWeC5rF14t
	aTGC8GJSjOoup61flLkv/EFGtnre4tr7n6V38zWogcixpwrw1zkND0iZS6qFbTYeu6l/wX1
	t/lb36Lt6eQsksrft0teWgod0X2SPt6VZKkDisT2IVZkjsSejCYyF346mmuUx6yuiCe/kHx
	HtucusbjqprjcdlXOA5r8it+LuB5MygrbSd2JtZLmdnNwg+aEsKZtdNJp5uUuBOOFb0sLCL
	lYA5bzkkxV3MUJq7qZxMMYqX+9bf9dQHtLVON81rhuESrWv2Wt5OTpNeqy8KKpg03NhnWPf
	bKpkKDu7SKr5tgNo8NW+dHJeOFmeY4txtr+agYOsw+Mn5zX/rr/XcZUeiqPE32ySe5/6w1+
	XWup/+QkRGR8X9PdIj35T184g663x3B3jikNRwJf5gcfkkwkgM23KbZtuK5W3j4afUJqNok
	uNm/fHqHVz0Dod0JEaI8r95Q6O+pFFf6xKEB4QLH+U/JR5KIK/KOIa6A/HlRs6sSURQAoeS
	btxoVP/44qSf0M1TN5O2SC+WoWol5jdI/xzBs3Rq0g4ZZu84P3pfsbQAVHsK9IVE4jxRJmZ
	w1DDBTu6sSufWfCoUP97lQCzg6JzvtFPeK//WVLClpItXh5bwJz5kzh6rfa7HmhVDDlKDM6
	GI+69aa6h7zhdWDL1sUiLDnzF1NEtDnqs5iALf4lch9QESw5q+tykb6MBeq6kpJWZiRnHK7
	f7k9w2iuBm+TK8YF3qmjvoWc+0GYhN4PNfhPYuf5XSbe5sCkHRAG6ovWBaIrTLoMDdIwHVD
	sa0PmF7UMuRutFE=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

>Am 16.05.2026 um 12:09 schrieb Greg KH:
>> On Sat, May 16, 2026 at 03:07:14AM +0800, Wentao Guan wrote:
>>> Build failed, you can drop the commit to build ok, same as 6.18.30-rc1:
>>> git revert 14d9ce90cf4855d638ecbcdb0c208a144d6f991b..
>>> Revert "sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation"
>>>
>>> Tested-by: Wentao Guan <guanwentao@uniontech.com>
>>>
>>> BRs
>>> Wentao Guan
>>>
>>> defconfigs:
>>> https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9
>>>
>>> Log:
>>> In file included from kernel/sched/build_policy.c:63:
>>> kernel/sched/ext.c: In function ‘scx_ops_enable’:
>>> kernel/sched/ext.c:5524:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first use in this function); did you mean ‘HK_TYPE_DOMAIN’?
>>>   5524 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
>>>        |                                  ^~~~~~~~~~~~~~~~~~~
>>>        |                                  HK_TYPE_DOMAIN
>>>
>>> missed HK_TYPE_DOMAIN_BOOT is introduced in this commit:
>>>
>>> commit 4fca0e550d506e1c95504c2d9247bc92bf621bf6
>>> Author: Frederic Weisbecker <frederic@kernel.org>
>>> Date:   Mon May 26 13:06:21 2025 +0200
>>>
>>>      sched/isolation: Save boot defined domain flags
>>>
>>>      HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
>>>      but also cpuset isolated partitions.
>>>
>>>      Housekeeping still needs a way to record what was initially passed
>>>      to isolcpus= in order to keep these CPUs isolated after a cpuset
>>>      isolated partition is modified or destroyed while containing some of
>>>      them.
>>>
>>>      Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.
>>>
>>>      Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>>>      Reviewed-by: Phil Auld <pauld@redhat.com>
>>>      Reviewed-by: Waiman Long <longman@redhat.com>
>>>      Cc: Ingo Molnar <mingo@redhat.com>
>>>      Cc: Marco Crivellari <marco.crivellari@suse.com>
>>>      Cc: Michal Hocko <mhocko@suse.com>
>>>      Cc: Peter Zijlstra <peterz@infradead.org>
>>>      Cc: Tejun Heo <tj@kernel.org>
>>>      Cc: Thomas Gleixner <tglx@linutronix.de>
>>>      Cc: Vlastimil Babka <vbabka@suse.cz>
>>>      Cc: Waiman Long <longman@redhat.com>
>>>
>> 
>> Also dropped from here, thanks.  My fault, I should have only backported
>> this to 7.0.y as the commit itself said to.
>> 
>> greg k-h
>
>
>Now I really wonder why I didn't hit this build error with that patch included in 6.12.90-rc1...
>Because I hit it in 6.18.32-rc!
>
>Let me check my .config ...
>
>Beste Grüße,
>Peter Schneider

Hello,

I thought that 'CONFIG_SCHED_CLASS_EXT' is what you found,
and it is depends include 'DEBUG_INFO_BTF' which depend pahole (maybe missed).

BRs
Wentao Guan
