Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A620409275;
	Wed, 16 Sep 2026 19:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586943; cv=none; b=kIzCN2WHYDWQR1u/aKLMSLeLZdUNeBTSVQU/YbI1w708NcM2ASln3RqS1NH/BKzF9ZmflldFQ+0ignd1pCa4+Cili1StGZJz/LkZLS5oJf+aHBcZaZT/DsuUwm2QXIdyMINO/GIjio0g4c5gkkS8m/LQKaVRztLthzXf6YCyQuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586943; c=relaxed/simple;
	bh=D6J20OxNBky/g4Hzl5n/93hK+Zs52PvlWPa9atqu9sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZTCukPkxTRB+nBIbfrltuPKiUHA3fN4CPrQwUfZeaMOimtOS32AtOTfKoTvUTdNiXxaf3WI+C+PUGk3f5FQidwtfWiyfaqPtgiHPtFUZ2Inw3KlpqeiF1E2aRlj2pe4liXbeEHuAKqWyvn0TOVB6b3ZmHreAPKopAtnDb/Ffiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZyk3d04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZyk3d04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836021F0089A;
	Wed, 16 Sep 2026 19:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586910;
	bh=N1yOTVf0RbOearf6QC4HUrAEzuBKd/w9FLlUEHVTlfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZyk3d04/tzV80FQUJTd0NDYu36oZq0pcIbtGBjZRlLgxjZElVcOo2Q+k2QL0OOVm
	 1G/BmfO/WjQ/OfpSaPLbKeWnuRJYT3BVmn13GUci9dinfC2I1GelN5OGVLAN+noeei
	 WYtjBpE3xQv0AeZPPyDPv8brHIL9TW+Df+bLB0iCv/7yzSZkAFtCrPHT139EoRWMTK
	 oWeN1yBKYbtIa408OXLInikau/BRXEsSktkcBHhZfOuO98OVoI+hFN0LIyTj066MUm
	 FLFK9JAALLtRSJhc+LLZCcWGrPaJlMpSO8LHm8BKqKx6Bq9X8TbBVd7nhooVzlKhkx
	 nMk740jVW2P5g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <brgl@kernel.org>,
	Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
	Shivendra Pratap <shivendra.pratap@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0760/1376] firmware: qcom_scm: Support multiple waitq contexts
Date: Wed, 16 Sep 2026 15:27:55 -0400
Message-ID: <daily-reply-20260916-0005-re-qcom-scm-waitq@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aa1e8d13-214c-4b89-82f0-ffdf60267343@oracle.com>
References: <aa1e8d13-214c-4b89-82f0-ffdf60267343@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Upstream publishes __scm only after both the TZMem allocator and 
> waitqueue IRQ are ready, as established by bcd14791ba62d2 and 4e06c33aaa5ddc
>
> Maybe we should be applying those backports ? Thoughts?

That chain cannot land on 6.12 any more. The tree already released da9e6b1a96b1
("firmware: qcom_scm: Add API to get waitqueue IRQ info") and ccd207ec848e
("firmware: qcom_scm: Support multiple waitq contexts"), both mainline
descendants of 7ab36b51c6be ("firmware: qcom: scm: request the waitqueue irq
*after* initializing SCM"), backported ahead of it. Their waitq code now sits
inside the very window 7ab36b51c6be has to hoist, and no extra dependency
repairs that.

Tested backports would be more than welcome here.

-- 
Thanks,
Sasha
