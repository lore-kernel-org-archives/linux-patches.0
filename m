Received: from mr85p00im-zteg06011601.me.com (mr85p00im-zteg06011601.me.com [17.58.23.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D163BB38
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.58.23.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706045721; cv=none; b=blxYKW7u/1P7aha6eJB8qnydvndmk/lJl0iO/28V6EY9Z2aTGV5T02SlFV//p2opOMuzHNXUx7R9iXv2VFY+6bn4UTTUWEXHGeEBes3Bjiddnj3Mt1EvZaHjbHrNOkbqcn5zTr7Kzx24oXV8H+oIykXsasE3dHXSGb9mQ61V7IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706045721; c=relaxed/simple;
	bh=gQ2YyM2P3cvihLm+KIRANnz0GaPOH2jQZpq2ccSqRk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLiqwRXpsLWr4SFrHtkeTo8O6d3lfHle8x8+RHUhLMmdKmZ5ClSe2T5IlNo7ohf5tQF4XXab4XuslvhT+lk5EkKk+cWBjQkb4b/mscqGSQ8Unbwb08EIxZ8Za+Jvv57/Vv9ETb3gV/ZJPFD5Q2Hr3OpyjmelQ3EUqeV0qsHvL0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net; spf=pass smtp.mailfrom=danm.net; dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b=dvXscf87; arc=none smtp.client-ip=17.58.23.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=danm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danm.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danm.net header.i=@danm.net header.b="dvXscf87"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danm.net; s=sig1;
	t=1706045719; bh=gQ2YyM2P3cvihLm+KIRANnz0GaPOH2jQZpq2ccSqRk0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=dvXscf87iAbgcLOohk3cbTfVyeH3J8KZgp1m3LAQ9OO5LZPU/l8ul/GfbbYxq3WvO
	 9OuaTM3L3Djiq+KhTzdm0FotKdGhujNjjIVScLWWEkJkPPdpLR+kqO84IxQ5XDK1C5
	 /8SvN2YpAvXkIS/LVPgS4qeSMb96dqGM3PC/6v80BrsCrAydLphytapooWEYY1fJ2m
	 CtdXo1qLZJcdGD2FvTatDQJ43g/H/3fDv6nj2PZlZkueyCqSk3fxAuybqaFl2qlteG
	 9m1caerPTLGafFpw8dMzaqnzRGxt7tHTtTmUzxPFMrSXquOKThOGPYGx9Q2+S2+MBf
	 8puxCAFNnSg9A==
Received: from hitch.danm.net (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
	by mr85p00im-zteg06011601.me.com (Postfix) with ESMTPSA id 92A281803DF;
	Tue, 23 Jan 2024 21:35:17 +0000 (UTC)
From: Dan Moulding <dan@danm.net>
To: gregkh@linuxfoundation.org
Cc: dan@danm.net,
	junxiao.bi@oracle.com,
	logang@deltatee.com,
	patches@lists.linux.dev,
	song@kernel.org,
	stable@vger.kernel.org,
	yukuai3@huawei.com
Subject: Re: [PATCH 6.7 438/641] md: bypass block throttle for superblock update
Date: Tue, 23 Jan 2024 14:35:15 -0700
Message-ID: <20240123213515.7535-1-dan@danm.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2024012320-coaster-ensnare-237c@gregkh>
References: <2024012320-coaster-ensnare-237c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 7Uzk1XBEh7q7f8jyF9H9RNSBALUdLf_0
X-Proofpoint-GUID: 7Uzk1XBEh7q7f8jyF9H9RNSBALUdLf_0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_13,2024-01-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 clxscore=1030 mlxlogscore=740 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2308100000 definitions=main-2401230160

> Or is the regression also in Linus's tree and both of these should be
> reverted/dropped in order to keep systems ok until the bug is fixed in
> Linus's tree?

The regression is in Linus' tree and appeared with commit
bed9e27baf52. I was operating under the assumption that the two
commits (bed9e27baf52 and d6e035aad6c0) are intended to exist as a
pair that should go together (the commit messages led me to believe
so).

The commit that caused the regression has already appeared in the
6.7.1 release (but without the second commit). Since I thought the two
commits are a pair and the regression needs to be reverted, that the
second commit should not be backported for 6.7.2 until the issue is
properly resolved in Linus' tree.

But it sounds like Song Liu is saying that the second commit
(d6e035aad6c0) should actually be fine to accept on its own even
though the other one needs to be reverted, and is not really dependent
on the one that caused the regression [1]. So maybe it's fine to pick
it up for 6.7.2.

I can say that I have tested 6.7.1 plus just commit d6e035aad6c0 and I
cannot reproduce the regression with it. But 6.7.1 plus both commits,
I can still reproduce the regression. So bed9e27baf52 definitely needs
to be reverted to eliminate the regression.

I hope that clears things up some.

-- Dan

[1] https://lore.kernel.org/regressions/CAPhsuW7-r=UAO8f7Ok08vCx2kdVx6mZADyZ-LknNE8csnX+L8g@mail.gmail.com/
