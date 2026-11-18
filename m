Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045810;
	b=YmvQzkKG8dajQsaUo5pR5mks4sAsRjceBhDhzOxqoluH9j9NgXU2QxFO3IgHVU3XfCzR
	 mZXltYuUOT895b7v3RZz68FPzqbsTxw2ohtH6vcXWC9KrJxxsodyuavhpbtFhPxqD9gty
	 86Gmxl3HBy2kLCkJT1oKBMKEx+t1fFdtcH8NWTBbf2Yplzg2oKCx38Nwy/DdguNn1FKuz
	 zu/cRZ+8r7DH5L6iAjw+dRyAdDvxR+j8UB+patA54A/kEcz/tm9Y7do9jNtK1xSFiHZYT
	 OZaQ5xweu9Gj5SHUG6tGfIamte2briTMD+/N/4BRH7FQtXs5DE/J6movpLk8cNv3FeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cGEEyalnlyz/Exf3W0F0op+EELQxf/v3sJ5oZjkIWFk=;
	b=ElylOGBnnmBzN4JT6QvMeZvNsnmmdchTpTZAZDvWOsdLcc13bQ7wERmQhX1hYX9jwBLB
	 ZNkpirMw6c7hVo2/SAp7FFtINE6oLV775KUwS3ZaPLnk61k97nRU3lL3ox59vCv5WITLG
	 Aya3ZtKmkkqaAoV8OBSd9dfmwskYJ5tap9QBRuxdeGnbkZ3WY0Cowx57tLh3c2jEQHHd2
	 j87ldmAuYAITx0L6fD2Bg9qna8KmxiMX2olvwvOFOdjHLJEKonk6L9Fcgc+qKbwaCS4O+
	 4wAXvwv6CsPNLynXKynO7IWrZGsWlceiFlY/9oCst5GFYiqsi2PMKBE5Vss5f2JRO3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3wdaEZD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EE6606A331;
	Wed, 18 Nov 2026 23:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3wdaEZD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB221F000C5;
	Wed, 18 Nov 2026 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045810;
	bh=cGEEyalnlyz/Exf3W0F0op+EELQxf/v3sJ5oZjkIWFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3wdaEZDkdJ3rZQxMeV6YxpPy2/NTAOvnUkUe+BbdmtGYqTBN3hVq/6fCy+cwMgQN
	 T9qbBCHskt4I+L3XT8dCYou2MocWHm3V5gB6aRF+JoHb9nUrUXQID73MVIPwZTsXml
	 Ls5MrzbdMzzvl3h05xg/5Lv1LDp9+XHXU/9TGTxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1056/2857] libceph: fix out-of-bounds reads from repeated CRUSH bucket entries
Date: Wed, 18 Nov 2026 15:34:50 +0100
Message-ID: <20261118150239.611464620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e812b30778d57..803514a1bc7ce 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -387,6 +387,8 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 				goto e_inval;
 
 			arg = &arg_map->args[bucket_index];
+			if (arg->ids || arg->weight_set)
+				goto e_inval;
 			ret = decode_choose_arg(p, end, arg);
 			if (ret)
 				goto fail;
-- 
2.53.0



