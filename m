Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338343A254C;
	Fri, 22 May 2026 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779455564; cv=none; b=n9ieWH0NFvuU62x3lub/TDLwHcxG2Tn3pSlYGFHqsBi6coOOHe78FCmztPSn0TCmMSFsM5R/JB24Kl0lTj6cqxnHXRyrJjTVtiH1olYThh3iMUBRaioJcfDrq+0iLq/cKzofhYw7Ew2zhhpfSevAWzNBpYsnaGpg1Y5cR9yUA0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779455564; c=relaxed/simple;
	bh=CCJN0VEW1Dd5jDToCZqaNeqwVQTzWCt1li7aNKjLgc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJU2bMV/hgyK2VmWx+1A8MIoIMQ1QbBE6l/3v2CzKM4bZ70kaOqyv6JV8c7ccpMqSNxTGXh6oMxs9y1OTDYPgC/7TQNyRiSgVBnRu3hrZVyhyO8KycUo/gU71eSIEKabCq0+u+vekjBkhkiADshK6u67fDk7VahLAzT0rNoSARk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+UOA71J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+UOA71J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B564D1F00A3F;
	Fri, 22 May 2026 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779455563;
	bh=CCJN0VEW1Dd5jDToCZqaNeqwVQTzWCt1li7aNKjLgc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+UOA71JFrOJKw+UMbFXyqhd2DHke5PbYzwSz/kuKurppOPrSDTO+8wb7J+K4sv2X
	 c2VrbP7w95cRfVtsZM7IAlUUXRl3Yu89jPsDkhq9Me0a9fn5dxYHg8yqe66B2DVcQs
	 tR53EdfA+jYM9soKcEMtE72ZQP8PtoGEMJ5xNyeurOoVLBkhbVKgTeN2yROhT/PmLA
	 yvXq46HCJboFWYvLulf0jPrXDWuzHwGJvfWnAMpxFaBF1FgVRDYyqIpTA7nNu/cce3
	 UWVhgWUwSSyKGlbrrgJ2NN7tx7aaEbaxW6UigsiRlyiBJkEgN4Rm6Uil1q/jXKxqlt
	 8TI8O6UPxxD1g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jorge Marques <jorge.marques@analog.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 384/666] i3c: master: Fix error codes at send_ccc_cmd
Date: Fri, 22 May 2026 09:12:27 -0400
Message-ID: <20260522123641.rc-drop-ef8b5229348f@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a6d725bd-9ed4-4328-b2ba-078f658fd8b2@oracle.com>
References: <20260520162111.222830634@linuxfoundation.org> <20260520162119.576627180@linuxfoundation.org> <a6d725bd-9ed4-4328-b2ba-078f658fd8b2@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, May 22, 2026 at 03:56:21PM +0530, Harshit Mogalapalli wrote:
> The above mentioned prerequisites are not present in 6.12.91, so I think
> it is incorrect to backport this to 6.12.91.

Dropped from the 7.0, 6.18, 6.12, 6.6, 6.1, 5.15, and 5.10 queues — the
same prerequisite gap exists across all of them. Thanks for catching it.

--
Thanks,
Sasha
