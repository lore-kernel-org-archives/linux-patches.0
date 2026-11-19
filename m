Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104521;
	b=5Pcqh4vOiqZLOdrjt8uMPOQIRxvtPyT6vY7gBu3IGeQhzZY98zfCVMEuK8wnTIcJlPeL
	 2OD83jdFNpTsSPnWylX4mR4SlunW10XJNw3ybPXgdhlV07yQUwnGFdl9TtQ0kmJvp06Zr
	 FvlptZB+rivUUqDqL6F6KHWqbtdUNX0PoxZMOMWdTjFl3kVfWHlh/K/RMLNodtHEow6c5
	 fhfKFWQ0XZ4OSmUgcI9wY/AFmERse23znB+2Dugdr5ZC12NVv+iQy3tNs0uTahh/Qqsa4
	 booXr0/zVEEbAXqJSLOUdnTFveLah/nXzzsBkhJOuLga1h6Lh1zmdaN+l03I6wLL1Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fPfABin4zzIRr7ReQXMWWiy9FQlcsVTjrkEn4IKaZYo=;
	b=nQWHkSjZZiVVDnrQ4A+05DTQyv/Z4ETMvfpIb/0xefsnQzyd4vHAowY7EFWsxB85eCnd
	 LAm+E/XuqIAwHvuqiQOHshVziNiSbQsY7d+atUwWkrODLyb0JqTl4g0qdOTU5MgqTQBH5
	 0DPvJX1KHgUFPyjbnAuOQfFjrCmlWDaMc6zVbKb8+0Wadt1HLlJyWFC66OwTU4F1H6a7H
	 1jYmjuHd89e1cXbJi/5XYMK7ye2dLb3kXuhTKfftxb6kIoUyara1N44NLVIEbYO9s74j9
	 ys5QsyWLqsZ4yyQn/7eNGmcSGd02mnyJdJ1CtW9PRLErFhoXvoYTFHRbvZ86eFrf1AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ebM6nepB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D63560A261A;
	Thu, 19 Nov 2026 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ebM6nepB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A8E1F000C8;
	Thu, 19 Nov 2026 16:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104521;
	bh=fPfABin4zzIRr7ReQXMWWiy9FQlcsVTjrkEn4IKaZYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebM6nepBrDLUPYTBpVWop19Gk+w/PL+ZFDLSERRPmWWnMR1IbmJebBn5UqZ2NV00M
	 /1LeaG9L2lmqmJ2uEtgbID+DA5jRDqcNCOqB/nk3JfSeaHQu0jP5hzhZrGd2LjiMFM
	 9sAxYNdqUf8WViSu3F96301E8VG8D0syrGz82zgG2bfasEqhWzn3gDE2DKP60jJISz
	 sC7+bjVxllAK9MeqXyn9WfDxvSz+XKN6+gwLnqeYzupd/WqOlDDjgOEn9YqRCeTiPK
	 xqkUwBGPeAdX6FKkLIhq4VY8cytr8406OvMelNYw31j1OPmT8nF9JRFsPefNYgbkZt
	 eXTTnVSw5Akdw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	"Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 7.3 1870/2651] Bluetooth: L2CAP: take chan->lock for l2cap_chan_add/ready/del
Date: Thu, 19 Nov 2026 11:08:08 -0500
Message-ID: <2026-11-19-1-daily-reply-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b5b8bc11-35bd-45f9-adac-648c1646ac32@pobox.com>
References: <b5b8bc11-35bd-45f9-adac-648c1646ac32@pobox.com>
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

> This is breaking the build for me with clang 23.1.6 (also 23.1.5) for arm64, amd64 and i386:
>
> net/bluetooth/l2cap_core.c:708:2: error: calling function '__l2cap_chan_add' requires holding mutex 'chan->lock' exclusively

Queued the missing annotations patch for 7.3, thanks.

-- 
Thanks,
Sasha
