Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052876;
	b=tSyMzFYVUx11YO/8L0mOfwl1u1DW41Ukd42wFIfkmgJIFkbSLNw2h+SrTHYymcQCSbO1
	 vQ5ordm5tnT7lUFFTCbKjCplixUlgJlkxocTRO5j26S+QePZobWVtK4SaDxHgO9WIofrs
	 jz3Bj/+AxpHOFYKfViobwhZfZpB5E/63f9EvHX/ZmpEsXogsaVju5IVDWJUZDjhWvOIxB
	 mm3zI8Hd7frr+MXow6d/d1Opu53EAfUNx3A7LMh0+H7ua+m+mR5o8zCWiLKX88NO0fMwa
	 k33QUNjZa0zEy5PgpO9B7KAqhh3iCSGaEMfHkgbQa0iL3fmyYX5bk4shy8lwBaEGIKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nZNWGrVMx/Nq17NbsYGzhzIC4ogicFR3Cf/KEdmen+A=;
	b=noKxNr2KyIw1T68mpdgolqy8fILy9NSLx/p2sgO8boQYIXBxrk+gTao/vG9uMrmIO30v
	 HD+OwdhxaUgohv9OSE8A5lEXtG7qPqDyhTkY8s6rNA7eyGrtdmhxT0tbCcHuU4uXIESxI
	 Jdy+SpLPqC+EphH38aTca7+A03XqSFD52uvs4E0mcD2y6cPvtZeoOEWxskQeQmwnX7EIL
	 kTphXoW1w0AsnRXtPfIWPsYbgh1rv9sWx7pWnwgxUxXJwM34N693ocavdVjZGxGmijLXQ
	 FZnaD1jTemAHFlXPAh33LbAQ8o/A0hISnq/j4AePJIWDZUeYa1yqL6lFUv7Yi42+YRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUOJD+Lh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB8606A32A;
	Thu, 19 Nov 2026 01:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUOJD+Lh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11F31F000C4;
	Thu, 19 Nov 2026 01:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052876;
	bh=nZNWGrVMx/Nq17NbsYGzhzIC4ogicFR3Cf/KEdmen+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUOJD+Lh95DkojcewO+tOClz3Nq8AIF0MQj27P+jypd24cJNwHaFuCW8mIKc+22JE
	 PIzNMLHHZ5SdDugZfVq9dh/hoJAfyGEUO7pRk+caYVdDFLb+4n23fCmx+Q9JmAbh8I
	 YMwNJNWN69qk6HafJoggIPBaPsUZHGG7OMfcV+Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0718/2214] libceph: fix out-of-bounds reads from repeated CRUSH bucket entries
Date: Wed, 18 Nov 2026 15:39:54 +0100
Message-ID: <20261118150040.514972605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 569a9bb1e5615c2b88b8d76f03a4ab82e65a673e ]

decode_choose_arg() assumes that its destination is zero-initialized.
Although decode_choose_args() zeroes the argument array, it does not reject
a repeated bucket_index and can decode into an already populated entry.

Repeating a bucket with weight_set_size=0 preserves its existing weight_set
pointer but clears the count. Placement then reads weight_set[-1].weights
and dereferences the resulting pointer.

A malformed monitor OSDMap triggers this during RBD placement:

  BUG: KASAN: slab-out-of-bounds in crush_bucket_choose+0xdd1/0xf90
  Read of size 8 at addr ffff88800290df70 by task init/75

Reject populated arguments before decoding another entry, so the error
path can free their original allocations.

Cc: stable@vger.kernel.org
Fixes: c7ed1a4bf4b4 ("crush: assume weight_set != null imples weight_set_size > 0")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 13d0ad66e3896..af8b6c01784ec 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -371,6 +371,8 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 				goto e_inval;
 
 			arg = &arg_map->args[bucket_index];
+			if (arg->ids || arg->weight_set)
+				goto e_inval;
 			ret = decode_choose_arg(p, end, arg);
 			if (ret)
 				goto fail;
-- 
2.53.0



