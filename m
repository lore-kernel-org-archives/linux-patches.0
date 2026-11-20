Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140566;
	b=YmvPLDHb7XeiAZT9cmWzoQqsFwnL1Sv7BjXf4cIydNVNV/YHnoh/88i9DEZnqch86btr
	 wRihC55sp/VK7HSo8LodhThMmbahLGE0jNrXAsl9QNL5HkYf2f73MwSG9We8yGSAkDdm+
	 GDXbH6C0LJo4aSJPaBjBrDFx9ZYy8hobwW85J2SMDgXJml938JIsQNu7pdtkLvXXetrIP
	 vivGPMrB8jN4Dgkfa+FdYOaVtvwitHH5k/L9mScl7GtF+wuUM62MUZ70U2Ibw9a3aG/pU
	 Q8jvypCkCIg6s+niVmnAhyeigxR9e/30a4KDwsQYFUlday5YgpyDbncdlm836jJV8HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bma9YZvNPM7Avyhxd7mziKiP7ijMLTNw7xHdBq2mZtA=;
	b=A7+Z5nEzg6q+NBYskRD8+27lJTtwBpEBwJx5HqU750NvFxbPvcHIyRX+87YIVDEIKVvq
	 Rkuk9ABmCK74Di9NuGROe0UdpIWrO7NZ09Z6iyLpM1XcgzsB3b1OAULZKioBqpGs9aT5b
	 mjkRvdhI/3Pw+baZqA6ydqfrWwgBwpM8EYdNZAl3EKeCG25qutuYhdxpTz1yzViszqx3o
	 v6PNPBQXd3XhyShruDonoSRGxJIvgoEgpZtap9HJyz3LAePXM3066b2kphVL53AyBVcFm
	 wZdNL5UbB7kjEsGEtyJvMtw2x6sAGSwjtJg0hGBUWm1sTmw4y+4BlV0vZc8zXr++rBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aemKCu6Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8B360A260B;
	Fri, 20 Nov 2026 02:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aemKCu6Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196D41F0089F;
	Fri, 20 Nov 2026 02:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140566;
	bh=bma9YZvNPM7Avyhxd7mziKiP7ijMLTNw7xHdBq2mZtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aemKCu6ZROQ2wYvgtiXzvAntRsQ1O96DcSMWzzvfpPzu0tJbQDEmo44H3WSjntb9v
	 DnQmdfTPirf9V360zKib730r3tT8nylqCIMmGcoQE5KQL1z1MIKElvmGcSYvxAfk6v
	 ZAiJnMhxspUuq+2DACQQmMzZ2bCl/DcmzIRdnJHxwCoikJsR98dovdaVmHTq9PywwF
	 luTGQRADuFCmEwoo5d1ht0Qjc0L3miB3EbmZ9uWTOJ3EU9JHg8sMyQ7NrGdpaKxlV/
	 G2Uc1w6eAt4zdDeoHZ6W5q5f3D9XdNu2estcxtHcjWbz8x+Zj7yjkOS9LnCPdec6Xa
	 CPvZTferh7dow==
From: Sasha Levin <sashal@kernel.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: Re: [PATCH 7.3 1870/2651] Bluetooth: L2CAP: take chan->lock for l2cap_chan_add/ready/del
Date: Thu, 19 Nov 2026 21:09:05 -0500
Message-ID: <20261120020908.2320910-8-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <42da5e9b-1db9-410e-9c72-9f9f4e9489f7@pobox.com>
References: <b5b8bc11-35bd-45f9-adac-648c1646ac32@pobox.com> <2026-11-19-1-daily-reply-0006@kernel.org> <42da5e9b-1db9-410e-9c72-9f9f4e9489f7@pobox.com>
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

On Thu, Nov 19, 2026 at 09:15:42AM -0800, Barry K. Nathan wrote:
> Now I get the following when building the current 7.3 stable-queue
> (commit 5252483124e6cf016c4a6f41fe1e44f5e1949648) with clang 23.1.6,

The remaining errors need 15ad901d92a2 ("Bluetooth: L2CAP: avoid
maybe-return-locked in l2cap_get_chan_by_scid/dcid"), which does not
apply cleanly to 7.3. I dropped these from the 7.3 queue:

  - 385c0829e09e ("Bluetooth: L2CAP: take chan->lock for
    l2cap_chan_add/ready/del")
  - 987935a58d28 ("Bluetooth: L2CAP: add locking annotations for
    l2cap_chan_lock/unlock")
  - 608e0b7a675b ("Bluetooth: L2CAP: add l2cap_chan_close_unlocked() and
    locking helpers")
  - 79ff49a72c06 ("Bluetooth: L2CAP: fix race condition in
    l2cap_sock_shutdown()")
  - a69dd52612ea ("Bluetooth: 6lowpan: use l2cap_chan_close_unlocked()")
  - df5175dfcf48 ("Bluetooth: 6lowpan: avoid concurrent peer_del() in
    bt_6lowpan_disconnect")
  - 32d86e048d8e ("Bluetooth: L2CAP: hold conn->lock for
    __l2cap_ecred_conn_rsp_defer")

They will be requeued together with 15ad901d92a2. 6.18, 6.12 and 6.6
keep 385c0829e09e.

-- 
Thanks,
Sasha
