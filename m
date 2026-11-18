Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058706;
	b=KCpXj7Xd22BylSBTDWkQm5WN6BO8/I4g/WMZ1PmwfgG8spS3sq9yO/J6DTVuwMlGRruq
	 X1KkRMGIun38pZAnr5bqWXQS4IiKtNj0sWaAdfLNHd1T0X8C3SyiqtmxPtTlEekpPkDiB
	 +VrLBJX4KNouLWLKj3ObEX1RFeufd0rOTfA6wtZUV0Bq8FCXyU+7pLTbNlwqcODFme64x
	 hcfiDgY3NocA3xeTFiA8quUGCUlDB/g1Qk0kgJBLYIOm3t/KbVx/2UbbrdYYEYrlwWi3T
	 ljvv083ycGeBWfWtK6jmwcNLK9Ir4gX71eZScdf2vLbbJ+3D1E6eYa3gDRTVOB5GsoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YRfYvz72+GIU6ppM/WdosLmkLoLWBuInqTmnhRIx0H0=;
	b=g2S1tCIZji/8ubhcOf+HNjd8yOyCzaqM7I0cboAspIG1Um6F9zbCPwaBXjHbqVTlNvg4
	 agJ6sdXjjY7b8ojFnSCZc5CU7XgpufckQvlzPRp6u36bhXM3eUIrKhxhrmIyMES13flVs
	 Lew0XH15aEE+VOkv5M7WAA+iOlsWd/AFSfGkjZZVqRsjnveJpIARWRrZZeieJ3QpdhqvU
	 WiZqvwhMXncnAsHqYVQ/w91dSZzk879c9FB3FSD8UvVTTE/s4Oxznt9nJ2X7RgcicoSZJ
	 qtD3lep2tMiU/+FtfPc6BzDB0KCALi8291hjGgB3FxbIqxVhj7putYK1owlI227aQ7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UBXG/pB4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0F0606A31C;
	Thu, 19 Nov 2026 03:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBXG/pB4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707C81F000C4;
	Thu, 19 Nov 2026 03:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058706;
	bh=YRfYvz72+GIU6ppM/WdosLmkLoLWBuInqTmnhRIx0H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBXG/pB4mvQGXe/H9wacnRETS3i3SRJ6gLgTvbKjqlZqlidGdKheW0D6NInWsXuPi
	 9qUM4fLytSOPYURj8+VXqhtlnuQg/kaKF70QO4z31fUqucc5szAOgNmX22xCG2bLJc
	 rxIfLW/mUCjEcAZ0TZf1QrjCns/aB9H2tgIkd+SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0582/1848] libceph: fix out-of-bounds reads from repeated CRUSH bucket entries
Date: Wed, 18 Nov 2026 15:43:40 +0100
Message-ID: <20261118145939.683201025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b4ede3cbf18a5..2a3ab4ef39c28 100644
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



