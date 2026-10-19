Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428893;
	b=3X68IsiPDu0Kt7tLeJLrkYGoL/iqFZDUAsppJ83p/BlpDKOu3CclT7L1bT5wF0zzooJT
	 Zz9Jd33uutwkkvY7rVcCtJ3SJJ+urZQ5SKsiJyElAFazRGAwJqE3gLPeVsaVs838dx9A9
	 rxsb01efBF4/qgN/aolNIDCCWGsLAVxBDRGWLw60phET3PhoMjTP0LUKxLYa+wWGKDNQo
	 NrD1A43JKu7UWSCQ1fiQNzToRXUNJIgihiVA8mSUfZb1izI5w2gljCF+nK2HOSF4k70nN
	 CaWg7xFaM86uvXlrt3gmy42xYHnCJa2VCdPBhmh7opNM3cmIRwe0wdJDdkQlCBQ3nyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=/vWn8vyFir5R6D0iFD0/omUM4kYSgdHlE4Y2WEwH1hQ=;
	b=NtUHQatUUZo9aBgTJptI6wKvwi54HwaL//eAbOt92pWjNk0b9K5aCjdltAgYnl67xzv3
	 YT+TVQiOaUiXYuxKTvUmayIoGdY44DuYPCr9fol+8qPSiNZte7NVwyMUOwRqxZWcr4fH1
	 VJoD5yO32UGhbAvRfoa2avVSCM7OtTSkZHDyclDfnicDeHT/OHfRMX+okJhrk/7QXsPEw
	 hbreJv1Qz4O6b4Rp/9LwClNIBz6SwFb1TrJne19kXIAcTGVzED+ny6EbgeVcuVoSJjzak
	 Z97ADsBoPzos7HIiPGWWlZQfEoJjeHYz1xH1yHEkpnSqLMK1mvNz6DD/RTl9/LJUT2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUsL7JXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A9D606A332;
	Mon, 19 Oct 2026 16:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUsL7JXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E85A1F000C6;
	Mon, 19 Oct 2026 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428893;
	bh=/vWn8vyFir5R6D0iFD0/omUM4kYSgdHlE4Y2WEwH1hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUsL7JXhSwWYZ8nngR0rJvFbPIbPuUPgYUWubdyMYHF4eoLJyI3GPuKsP7f7G8rnC
	 YYDmSApE7GztVlFDHQhUgLASXfJvmSd2tsC1ifWq0gcys516klEZFXYc6HuakPnyPx
	 ++OBMKyNuKdO4+DE/0jhrtcupIWhghHGybkyy4vg3yQCkorqtgwTm5LbjaEUTnwLxg
	 zEg0x4YlgkI++Gtvd/yezp73HGNFYy5ZrfyVle0R5X4YRaucJ/u2e+/DANiBZJdpJR
	 6wfnY6CXHld03m94Ofsa5AwQd+NGv0WpfL8dndNwj02Mob5eNXeoIl5byucqp0jPdx
	 xSE5HhT5yk0hA==
From: Sasha Levin <sashal@kernel.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	virtualization@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.6 1008/1674] vsock/virtio: fix potential unbounded skb queue
Date: Mon, 19 Oct 2026 12:54:32 -0400
Message-ID: <rc-reply-0004-be6cedb2b118@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atYgJz85081YBziv@sgarzare-redhat>
References: <20261017160431.119607952@linuxfoundation.org> <20261017160457.007728876@linuxfoundation.org> <atYgJz85081YBziv@sgarzare-redhat>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, Oct 19, 2026 at 03:51:21PM +0200, Stefano Garzarella wrote:
> Be careful with this patch, this caused data loss. It's fixed upstream
> by commits:
[...]
> So if you want to backport this patch, I strongly recommend that you
> include these others as well in the same backport.

Thanks. I dropped 059b7dbd20a6 ("vsock/virtio: fix potential unbounded
skb queue") from the 6.6 queue, together with its two prerequisites that
were queued only for it:

  - 0df7cd3c13e4 ("vsock/virtio/vhost: read data from non-linear skb")
  - 45ca7e9f0730 ("vsock/virtio: fix `rx_bytes` accounting for stream
    sockets")

It is dropped from 6.1 as well. If it comes back to 6.6, it will be with
the complete set of fixes.

-- 
Thanks,
Sasha
