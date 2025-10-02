Received: from e234-57.smtp-out.ap-northeast-1.amazonses.com (e234-57.smtp-out.ap-northeast-1.amazonses.com [23.251.234.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DF917A2FB
	for <patches@lists.linux.dev>; Thu,  2 Oct 2025 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759421198; cv=none; b=ezpXtHTMJN3oe+kF8cr/LQF7CXE4yaNZtsnmF6L9HoMX+5FlHe3I9Zil/n84qiutYSR1LQHBpylCOMCF1pYLJbbsAGmpTWL0duRoXohCr/JVxh879ce/7hLK3Y+6i26s6QiDwsdzIk/40wRX0k4eMMC2IQr7csW/c37tIYuBlOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759421198; c=relaxed/simple;
	bh=8gOOO9aLcgO8QiYiyH+kvBavcv2mamJigKNUyHAeKrY=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=oGtBS0R93pnwkXoHwiGkwzvJp9fTMS+47o1kBqq3MGBSyuTLosr2Ee/FMC5EzFWX0FNLLuvL3YUMGKzaEIQAhVBQ0Ibk5m9yuFeNzGS6VItlm7cFMb0escKa7i7+KCC45WvK+f/Lln7O0ASFzkc2ZBKCTUNYb0BYSog3yZt7Ga4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=eFJKLyWL; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=vyU/BMal; arc=none smtp.client-ip=23.251.234.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="eFJKLyWL";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="vyU/BMal"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1759421194;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=8gOOO9aLcgO8QiYiyH+kvBavcv2mamJigKNUyHAeKrY=;
	b=eFJKLyWLPRJIFTVA5V6z8tZG55eZnDpA07iJNRM09wmhR57Ensd77ZbLdQ3T5QxY
	Ntn064O5DSCCqIKqm1b/h6eaYRbn4KfkM26b54bTYNQV0ahg76s7f6VMa42pbM4WSxu
	VECnVphOHdqFKWRYZeR8dzB/jRemypsNYZtGv3zE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1759421194;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=8gOOO9aLcgO8QiYiyH+kvBavcv2mamJigKNUyHAeKrY=;
	b=vyU/BMalqqaHivD3bTcHBeM8hqMlumQt69eJ7RMKKpZjDHSe+vuD4tYPBIaK6GYv
	4lYFt0Qfp03gH/mOdDQIZvNQ8jEAKG2kcTW6r/3hauqUcDICovI0A70eQj0d8vTIiBp
	mvmuPfHMo6KgKfln09xc0/Gm5H1Qj971cbSzR1Fs=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <b21abadd-05ec-42d4-aefd-0493ddf54c56@kernel.org>
From: Kenta Akagi <k@mgml.me>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: patches@lists.linux.dev, martineau@kernel.org, geliang@kernel.org, 
	kuba@kernel.org, sashal@kernel.org, gregkh@linuxfoundation.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 6.1 54/61] selftests: mptcp: connect: catch IO errors
 on listen side
Message-ID: <01060199a5acdf5f-568aa6ab-e765-4a52-9400-1c235760a3f0-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: 7bit
Date: Thu, 2 Oct 2025 16:06:34 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.10.02-23.251.234.57

Hi,

Thank you for your detailed guide. I have sent a patch.

Thanks,
Akagi
