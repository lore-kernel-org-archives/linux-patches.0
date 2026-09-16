Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5330C3E1CFB;
	Wed, 16 Sep 2026 19:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586949; cv=none; b=se8WOv4Ph3mRshiZk61lyjh4UsiRk7zilym3yUv0RpsBPnDlO5Qpv3ZoskI4WV30fXeko6B0D/xp4M3zF4mvUhtj3XBidzt5qAb6Fi/Z6XinKIWrXouRUVruIRRMRH9aBWZ8Za6verzqZfFOLkBojOqM4As29wDCtpDHT6A/Ww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586949; c=relaxed/simple;
	bh=wHfLu9KpSSr0Oe8zXo0IpESM1mgtoPBv9G4qrkcMYJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJ9TdVoq4Njr/CuS70ZaJUu2gyu2tY733JstnJ8gMnxIKZCvVgqyJNkZue1i1EmE4EbCWCsKOCDiPci4BfFrduzt6dYBBLmupX32VwgysgMjCQBPrNi2Y0ttcuUjjoauH9PhZ00fSvD/JR9z3U20BPHHCZswC21O4XNTPnJlWW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9jjxlfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9jjxlfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF80F1F00898;
	Wed, 16 Sep 2026 19:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586933;
	bh=8Pa9kRL2OAnCyhlfcaF0kA/9WC02W89KHssK6RNERus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9jjxlfpeCI3uNuFMSpjxOQcEu30b6JEugE7MD1JYETKOZvFDPoVnUkYm9l1ZLUi/
	 4aUw3Y5QEauQCwIbqmDJmJROTCcJKJIGPQHfR1Sr3i8Y+SgGoYEdimq5BTav18+IFU
	 RE7GjEdUlKiSlW6MjgEVKSIlBK37YQTWbKfQTy5XmTLpZhPzpiLa2sae8MiVdjt7tD
	 oiVUfg4XcWeZHEdhXfL7w5NvXenRC/slrKVdVyB/QbzWXfCBNusmtFv+/hu8iUb44U
	 /cs73lRu54VSAFzdfOPWoPkjg4CN56WxD1MMoCdOi8tXL4ov2/VxzMPsDyAG4Yyw/b
	 +UfmqrSAaJ8DQ==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.12 1160/1376] hwmon: (emc1403) Rely on subsystem locking
Date: Wed, 16 Sep 2026 15:28:13 -0400
Message-ID: <daily-reply-20260916-0023-re-hwmon-watchdog-autosel@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <68500ad8-35da-479c-9b37-a5214add1c2c@roeck-us.net>
References: <68500ad8-35da-479c-9b37-a5214add1c2c@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I think we are at a point where the automatic backports are way too aggressive.
> Greg, please stop autoselecting hwmon and watchdog patches for backports, and
> only pick patches with explicit Cc: stable going forward.

Ack. I'll add it to my lists.

-- 
Thanks,
Sasha
