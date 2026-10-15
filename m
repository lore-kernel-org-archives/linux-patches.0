Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5A433993;
	Thu, 15 Oct 2026 00:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022937; cv=none; b=PZ9BEtylmK2mWlnKt45pVkO9NbStms2tkQ7bk0B742jqm9HeYEDun3a0r37/cQy45YRHqS5Ac8YWWDJfDOyPFmfmLRT1iv0BYD5s4mHB5dqV0SNeMQvp2/7atVhFMsroFB7qckJa9HAh8Fgyjla3AQiu65GeAqWC7mU7Y7/UdwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022937; c=relaxed/simple;
	bh=YRQ1aFAe5CzxH0i3qlIoh4036hzOyM5TaNZSABS0A50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvTkplxJ89DDpgrEQsnn9FIWQVIETRTKHF3sQyRr1/L6VH7kUKdIMPJXhsCW8cY551N6U007jr63xC4ntLk0amjLlwx46NFnAArO30rFtxZNOevkFlj3HIf6Hfkp9/mFNqb2JxGCvOIosTcEg4ausZyCMGDvyaw0Fs+bNLu5pao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnJ4nz3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnJ4nz3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049431F000C6;
	Thu, 15 Oct 2026 00:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022936;
	bh=rxdqFQJplNUCQaBPb+ujL1iD+/D6vNPMQzb45iE8Ey4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnJ4nz3mfgjjhs+VUk/GZX3OQi1tXztbdZefBInclSNN97G5/USQXnKrlsuF+V091
	 TBLJ0eXxDqnBj1WhArscel2VZNp3aCUKDkSkg6dkPFaKQSmB6hHhpiloTQYPcjQsVe
	 5BHr8rnmCkJW9pqT5GDheglCjBVZUrwsKAwsJK6l9TJhThsP862vdfvEHQs+xzq6wu
	 z5Tk8zq48LRAyQZsBOjFkQSqtAz7RUCUxxIV0dxpcl2WQ4egYpL/9FrXpZWoMdo6Vz
	 INiETx8KBO5SJGuieta8n0g/QW/ALw1X+51fS0fFzPN0BtSxzt0wap6B7rd6M+qsMK
	 uqmqdp9rhqAag==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Rodrigo Zaiden <rodrigoffzz@gmail.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH 6.12 459/497] tee: optee: fix kernel-doc warnings
Date: Wed, 14 Oct 2026 20:08:44 -0400
Message-ID: <6135ca77361546fca6cbfbf3@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <fafcf450-8f11-4898-bc36-23233831d4f1@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112918.776447090@linuxfoundation.org> <fafcf450-8f11-4898-bc36-23233831d4f1@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> the same parser. Maybe we should not worry about this but FYI. One 
> option is to get this fixed inplace in the patch.

Keeping this one as is. It leaves one cosmetic kernel-doc warning but removes
20, and it is a Stable-dep-of the large-page FF-A fix 3c0d2f1f431c ("tee:
optee: ffa: support shared memory offsets on large-page kernels").

-- 
Thanks,
Sasha
