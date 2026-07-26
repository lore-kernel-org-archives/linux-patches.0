Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC1336493C;
	Sun, 26 Jul 2026 12:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067506; cv=none; b=MPJ1q+91K9bK8tGmdpRP4ihXm+QBHAr008ALBMNeah9pvhVDe1y7LFFKJcLA3jHhQgQfAEioxdT6PoL8TS1hhVZRjVkwEdaXdMftZjTbF5lyP92Ls5H14P5p3qanqnFtu92Hns4x+j3IrU8Ts9E2kA6A98rwKYYPngwinYn1uVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067506; c=relaxed/simple;
	bh=yKt++08J0DgDwfGT8U9V4XbnfI1UWtLm2W51f1uNhW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fv4bqz13Y/u6fiSwr75/3DioXH1/9myhUV5tDytyrEMySAjthfjPV2H7ka2aqjJ1wvGZLzSNv16i8w3H7uZdxb7GmWeMqL5Q1y57lYR787mll6A7Y91oat3BT9fJ6stLPQTo7qLtzuEisC3EIsoyO+Kvt1wK5ITmHdnd0hO8IjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUHAseI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUHAseI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED0F1F00A3A;
	Sun, 26 Jul 2026 12:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067505;
	bh=62ynwqXA5jbbd0AUhn7lN7btDkYb46WJQf7PC6BQiRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUHAseI9Z/Z/sVRtxExdi/gfGRxuWP0P41s9NMRKejBXLCSkDQlUw8/3E9vFLpnaZ
	 zXkpnb+OZvIBLXyYfJRarzTEPXvCrdsaRzzgqljxIM1a5A8/Hnyv5/306gqRXSrSbb
	 n0q3eDVS9q3rd6OxuzU/YnF1a7l+qX5uk0mWr1amKX7sGFBSA08HUpPhTr5DNCWUEr
	 dIFvy/s4Bbx0XuvGu+TTP9VmylfyktjfrUbFlVdAD4XPlGN++RafkLTSqZeR568kyO
	 SwwDk/vhW1A3Ey6QKUipf+KAANrAnF2HhQPqMLme1wwpBWXX43OPOkjrL0UaocfarI
	 UVDTa+7K2A5vQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1139/1276] iio: pressure: Remove redundant pm_runtime_mark_last_busy() calls
Date: Sun, 26 Jul 2026 08:04:47 -0400
Message-ID: <20260725192000.stable-0008@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ae4d5ec1-9e10-4230-85f7-88b99028ff17@oracle.com>
References: <ae4d5ec1-9e10-4230-85f7-88b99028ff17@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think 6.12.y misses commit b3db492e8335 ("PM: runtime: Mark last busy
> stamp in pm_runtime_put_autosuspend()"), so this backport probably is
> not be complete.
>
> Lets drop this from the queues [...]

Your analysis is correct: without b3db492e8335 the last-busy timestamp
is never updated on 6.12, so removing the explicit
pm_runtime_mark_last_busy() calls would cause premature autosuspend.
Since this cleanup was only pulled in as a stable-dep of the mpl115
runtime-PM-leak fix, I'll drop both from 6.12 for now and redo the pair
properly on top of b3db492e8335 later. Thanks.

-- 
Thanks,
Sasha
