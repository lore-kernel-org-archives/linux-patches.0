Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239628;
	b=QffBoWTCL/xvpbVwmVhtWDqZx4Conno8mV26MwRBkPeYYme7xVpLSb+JOV7Ff5yroWU6
	 IVGvbkbfqYMS5hV+Dp8jRVX85kbZqmqb6tt+Yrs1Md6I2FpId2QfBbPR/ZYvojX5ubfSv
	 5CQUKW+pD9qy74cG/N02wiz0S+gcGo4PP+qhd3logNxypnXV9sSMM0+0ZWMD4bw2JI3Vo
	 7BaXoginqu8DfwO5pjFF0zZYvhcfJcLi9yS2aEo/sUFeQ7I4lK3TKVuU5HP9MkwZ21glv
	 sSSebTuyfrM3RxuXaVoykOEGTMpQ/UFyuxWei9lsnLtKz6eUkv21Uu4ARIXK2TjF6oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8a9edENjx0kV8wz3FD/Yi2KFgLhXa7lsMeP56SA3M1Y=;
	b=NFfvIgrs0lcMIWlPdJ/fwZFEQ/A2ZClOA9RdMqipTvleLHJwJBMlJqJvrCLORjqjZqCG
	 IY7reef9eIBpKUOMmxyE4dcUgtyZbisef6CH0CFmEk3LGAcIZgeNJyE7LsI3x+E27hidT
	 l/gXSENH2sBYUQLI9iBbrblpkaAF6Jh4tWyNLCgKI2dG3yY94kav8+3Nl6cnjkmR6niLJ
	 MJnLmJYpPRFsJBYy5kSJJ1ugWLRS9UBfJv9xFtrseJUN3HZ/EEyTb9ipBiYwhQVw5nwEE
	 ZYGi7V9vvtWd8qGQLZEqWPDM8Rz95hr/vAkP8Vrn6xnTB6WNAO5n0OL1/hkJmK8AJvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R8Kb2sFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235FB606A31C;
	Mon,  9 Nov 2026 15:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R8Kb2sFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360031F008A1;
	Mon,  9 Nov 2026 15:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794239628;
	bh=8a9edENjx0kV8wz3FD/Yi2KFgLhXa7lsMeP56SA3M1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8Kb2sFKKaZNy3SCsevhbz3yzQIOeXYjERM2Pklsp46gZTrT+YqDWBkKl6WwocYXf
	 yE7ce8qQcO1Sr3MYzpvTqc2eWuu1NJH9EpkPdqHi4gGViYS3I86UehexeU+q7G82yj
	 GRSYRe3JbNqGBOK0av5BTfc84gaCioMMraPf9s8rfpOm1z1gomWCpXzGdRROlD/3Kg
	 q2/hZ1CuatNxaefFowd8E030gibMiBhgtu7GHbHY9NR2aeANpgqxNF00WfYMrK/T1q
	 6mMJSoy5egLMZUqafVByeJQKf9/nydTj8wmNfUxb+FYWig73pTxTldW2YVke5EbZ+q
	 6yIrpcs4tzcYw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 7.3 0728/1257] spi: ljca: validate the response length before copying the data
Date: Mon,  9 Nov 2026 10:53:03 -0500
Message-ID: <2026-11-09-1-daily-reply-0021-spi-ljca-fix@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a602d227-fb3d-4087-9364-a0430958ec02@kernel.org>
References: <a602d227-fb3d-4087-9364-a0430958ec02@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 7.3 0728/1257] spi: ljca: validate the response length before copying the data

Queued the fix for 7.3, 6.18 and 6.12, so it rides with the patch it fixes. Thanks.

-- 
Thanks,
Sasha
