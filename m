Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207165;
	b=yOinJHCUHNXHsFalEj6QRJoVGEKRqP50V04eIDzMw6EiyVZNGPNl6UEq5VaU4WZaKfkL
	 ol4BotibVRMHgOSxAPdSCvn305dhnfOQcI7Z72wHRR8xirGYaOOxJ48ekdHPixDBFo4fO
	 rceHXw4pDASe0TDp/oOIHpWeEoFbGbajMxd+zlaejGNK7OLRf99wrYg6M0ytfrmDYF1cq
	 hmQYHmMpb3c4P4VAOw3RGkLHmc87xOt2o/Mksk1Own20zca4oOb6WjZDKiyJvGmho7xbs
	 sYiD6wnd8KD288NQnGI5KRP5GuBEyc+nolz40NYbz5h33Njp0fv6raY9LW50gA740Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VOTZX3W8QGbERFANsguYt9lGMzzmidy8ytieehfwkL0=;
	b=QAgHc5d0TMpDLCT0PfYUJCoY7QHNfi1ygfY4U8QHUmN0vLmTicWItoaJPHbMAnOC2i2N
	 QWr/ohW25B/z2+szhfR0LEJJKdXlVU5JFDzDAc2iGp1VIw7sNU5eTL0feZSpy2yBKpZaV
	 L4gVHJ4hkA2B6VsVQcgF7pp4rNuDg1/8ogEYre4UI8mN8UW7xgDXm2D2T42jwIYBBULUA
	 9ZrHL4drgpjdmOw1iksMkNXY1VHl0Pb2o/8f3N5Rt586j3w9SitsQexok9dq2g1AvPCfq
	 yInMk96wnBihV31BkaPAdwAcvEhTkdo7a/L5o56oOGebeOM6qPNrxgNJ2nlvAFJCELQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EJ8GOmXC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3C5606A6DF;
	Fri, 20 Nov 2026 20:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EJ8GOmXC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FC81F000D3;
	Fri, 20 Nov 2026 20:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207164;
	bh=VOTZX3W8QGbERFANsguYt9lGMzzmidy8ytieehfwkL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJ8GOmXCXI1P8xMBmyaHHGP5pYPS7BRfOcEpKWZAhdas2hjmUNichHhTLJo6ABbAO
	 TPGG7+KuzJB7kH80qLDDoHIe+c5ii+dXyY4xZQzwbb8nDRC+tFHmZOdroPaydpVlKm
	 /zZVwU6eo/gTfI7G749DCcAi9rscW/4+f3be4hDsp+6vNh4Hoq043uE2XUoIdJ9wO+
	 x/hpiHcZ9RS4aFaZS4E038Pxl/zeD5WrvbynBsd2TVfWKOTBC0FO9xPO6Rh9uPmvgQ
	 vnsrVtBlrbj+f8OWua1hCLA86+vr5OHzJr7lW4Rpz5KXLas31qOc/GelmZZY5yna4q
	 iDkj1c1ipnmGw==
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
Date: Fri, 20 Nov 2026 15:38:50 -0500
Message-ID: <2026-11-20-1-daily-reply-0001@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <42da5e9b-1db9-410e-9c72-9f9f4e9489f7@pobox.com>
References: <42da5e9b-1db9-410e-9c72-9f9f4e9489f7@pobox.com>
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

> Now I get the following when building the current 7.3 stable-queue
> (commit 5252483124e6cf016c4a6f41fe1e44f5e1949648) with clang 23.1.6,
> same config as before:
>
> net/bluetooth/l2cap_core.c:128:9: error: mutex
>        'l2cap_chan_hold_unless_zero(c).lock' is not held on every path through
>        here [-Werror,-Wthread-safety-analysis]

Requeued the L2CAP/6lowpan patches for 7.3 together with 15ad901d92a2
("Bluetooth: L2CAP: avoid maybe-return-locked in l2cap_get_chan_by_scid/dcid"),
thanks.

-- 
Thanks,
Sasha
